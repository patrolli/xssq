+++
title = "pytorch ddp"
author = ["Li Xunsong"]
date = 2021-09-20
lastmod = 2021-12-20T00:32:15+08:00
tags = ["pytorch"]
draft = false
+++

## 一些基本术语 {#一些基本术语}

假设有两台机器，每台机器 8 张显卡，那么我们共有 16 张显卡，可以启动 16 个进程。

-   world\_size: 全局的并行数，这里就是 16
-   rank: 表示当前进程的序号，对于 world\_size=16 的情况，就是 0,1,2,...,15. rank=0 的进程是 master 进程
-   local\_rank: 在每台机器上的进程序号。机器一上有 0,...,8, 机器二上也有 0,...,8.

CUDA\_VISIBLE\_DEVICES=4,5 python -m torch.distributed.launch --nproc\_per\_node 2  --master\_port=$RANDOM ddp\_demo.py


## 有哪些改动？ {#有哪些改动}


### 导入 {#导入}

```python
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
```


### DDP backend 初始化 {#ddp-backend-初始化}

```python
torch.cuda.set_device(local_rank)  # 指定使用哪块 GPU
dist.init_process_group(backend='nccl')  # 默认
```


### 将模型放到 GPU 上 {#将模型放到-gpu-上}

```python
device = torch.device("cuda", local_rank)
model = nn.Linear(10, 10).to(device)
```


### 定义模型 {#定义模型}

`model = DDP(model, device_ids=[local_rank], output_device=local_rank)`

`local_rank` 需要我们手动传入，每份程序都应该接收 `local_rank` 的命令行参数，因此需要将 `local_rank` 作为 argparse 中的一个参数，保证在启动程序的时候能够接收这个参数。然后将模型包装一下就可以了。


### 定义数据 loader {#定义数据-loader}

在 `Dataparallel` 中，只有一个进程，所以是先切分好数据，然后分配到每张卡上。但在 `DDP` 中，每个进程会复制一份代码执行，也就是每个进程都会用同一份数据。如果一个 epoch 有一万个数据，那么过一遍 epoch 实际上过了 16 万个数据。因此需要单独设计 `sampler`, 来保证各个进程的数据不相同，并且保证一个 epoch 还是一万个数据。`DDP` 中提供了这样一个 `sampler`.

```python
my_trainset = torchvision.datasets.CIFAR10(root='./data', train=True)
# 新增1：使用DistributedSampler，DDP帮我们把细节都封装起来了。用，就完事儿！
train_sampler = torch.utils.data.distributed.DistributedSampler(my_trainset)
# 需要注意的是，这里的batch_size指的是每个进程下的batch_size。也就是说，总batch_size是这里的batch_size再乘以并行数(world_size)。
trainloader = torch.utils.data.DataLoader(my_trainset, batch_size=batch_size, sampler=train_sampler)

for epoch in range(num_epochs):
    # 新增2：设置sampler的epoch，DistributedSampler需要这个来维持各个进程之间的相同随机数种子
    trainloader.sampler.set_epoch(epoch)
    # 后面这部分，则与原来完全一致了。
    for data, label in trainloader:
	prediction = model(data)
	loss = loss_fn(prediction, label)
	loss.backward()
	optimizer = optim.SGD(ddp_model.parameters(), lr=0.001)
	optimizer.step()
```

两个注意点：1. batch\_size 的大小。总的 batch size 是进程数\*每个进程的 batch size. 2. 每个 epoch 需要调用 `.sampler.set_epoch()`


### 打印 {#打印}

`DDP` 在梯度反传的时候和单卡的梯度反传是一样的，直接在代码里面 `loss.backward()` 就可以了。但在打印的时候，我们可能需要汇总一下所有进程的 loss, 不然打印的是在每个进程上算出来的 loss. 另外，可以把 io 这些事情都交给 master 进程，因此，在执行打印等 io 操作时，可以先判断进程的 rank, 然后执行操作：

```python
def reduce_mean(tensor, nprocs):
    rt = tensor.clone()
    dist.all_reduce(rt, op=dist.ReduceOp.SUM)
    rt /= nprocs
    return rt

# 这个 reduced_loss 只用来计数，不会 backward
reduced_loss = reduce_mean(loss, args.nprocs)
losses.update(reduced_loss.item(), global_img_tensors.size(0))

# 保存模型的时候，也可以只在 master 进程进行
if dist.get_rank() == 0:
    torch.save(model.module, "saved_model.ckpt")
```


### 调用方式 {#调用方式}

-   使用 `torch.distributed.launch` 来启动训练
-   一些参数：
    -   nnodes: 有多少台机器
    -   node\_rank: 当前是哪台机器
    -   nproc\_per\_node: 每台机器上多少的进程

`torch.distirbuted.launch` 会启动 n 个进程，并且给每个进程一个 `--local_rank=i` 的参数。


#### 单机多卡的启动 {#单机多卡的启动}

```sh
# 假设我们只用4,5,6,7号卡
CUDA_VISIBLE_DEVICES="4,5,6,7" python -m torch.distributed.launch --nproc_per_node 4 main.py
# 假如我们还有另外一个实验要跑，也就是同时跑两个不同实验。
#    这时，为避免master_port冲突，我们需要指定一个新的。这里我随便敲了一个。
CUDA_VISIBLE_DEVICES="4,5,6,7" python -m torch.distributed.launch --nproc_per_node 4 \
    --master_port 53453 main.py
```

Note: 如果要在一台机器上跑多个实验，这里的 `master_port` 参数需要单独指定，不然端口会冲突。一个方式是在这里设置一个随机数，每次实验就随机指定一个端口。


## torch.distributed.barrier() {#torch-dot-distributed-dot-barrier}

这个函数用于处理多个进程之间的同步。

场景一：在读取和处理数据时，我们希望只在一个进程上进行处理，然后其他进程去共享缓存的处理数据。这时，其他进程就需要和这个处理数据的进程保持同步，要等到处理数据的进程将数据处理完毕后，再去进行读取的操作。写法是：

```python
if args.local_rank not in [-1, 0] and not evaluate:
    torch.distributed.barrier()  # Make sure only the first process in distributed training process the dataset, and the others will use the cache

    # ... (preprocesses the data and save the preprocessed data)

if args.local_rank == 0 and not evaluate:
    torch.distributed.barrier()
```

这一过程要通过 `barrier` 来实现。当一个进程遇到 `barrier` 时，会被阻塞，那么这里就只有 rank=0 的进程会继续执行代码 (不进入 if 语句). 当 rank=0 的进程处理完数据后，它通过 `if` 语句也遇到了 `barrier`, 此时所有进程都遇到 `barrier`, 而这个阻塞就会被释放，其他进程也会开始执行数据处理的代码。

场景二：汇总所有进程的 loss 和 acc. 我们希望只在一个进程中打印 acc 和 loss, 那么需要等到所有进程都算出 loss 和 acc 后，再汇总计算。

```python
# ...
torch.distributed.barrier()
reduced_loss = reduce_mean(loss, args.nprocs)
if dist.get_rank() == 0:
    print(reduced_loss)
```


## Ref {#ref}

-   [[原创][深度][PyTorch] DDP系列第一篇：入门教程 - 知乎](https://zhuanlan.zhihu.com/p/178402798)