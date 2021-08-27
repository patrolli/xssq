+++
title = "GraphSAGE"
author = ["Li Xunsong"]
lastmod = 2021-08-27T11:50:05+08:00
draft = false
+++

## pyg 中的实现 {#pyg-中的实现}

-   message propagation 的公式：
    ![](/img/capture_2021_07_10_15_10_34.png)
-   实现

    ```python
    from typing import Union, Tuple
    from torch_geometric.typing import OptPairTensor, Adj, Size

    from torch import Tensor
    import torch
    from torch.nn import Linear
    import torch.nn.functional as F
    from torch_sparse import SparseTensor, matmul
    from torch_geometric.nn.conv import MessagePassing

    class SAGEConv(MessagePassing):
        def __init__(self, in_channels: Union[int, Tuple[int, int]],
    		 out_channels: int, normalize: bool = False,
    		 root_weight: bool = True,
    		 bias: bool = True, **kwargs):  # yapf: disable
    	kwargs.setdefault('aggr', 'mean')
    	super(SAGEConv, self).__init__(**kwargs)

    	self.in_channels = in_channels
    	self.out_channels = out_channels
    	self.normalize = normalize
    	self.root_weight = root_weight

    	if isinstance(in_channels, int):
    	    in_channels = (in_channels, in_channels)

    	self.lin_l = Linear(in_channels[0], out_channels, bias=bias)
    	if self.root_weight:
    	    self.lin_r = Linear(in_channels[1], out_channels, bias=False)

    	self.reset_parameters()

        def reset_parameters(self):
    	self.lin_l.reset_parameters()
    	if self.root_weight:
    	    self.lin_r.reset_parameters()

        def forward(self, x: Union[Tensor, OptPairTensor], edge_index: Adj,
    		size: Size = None) -> Tensor:
    	if isinstance(x, Tensor):
    	    x: OptPairTensor = (x, x) # x[0] 用于 message propagation 计算 message, x[1] 用于保留结点的输入特征

    	# propagate_type: (x: OptPairTensor)
    	out = self.propagate(edge_index, x=x, size=size)
    	print(f'out after propagate->:\n {out}')
    	out = self.lin_l(out)

    	x_r = x[1]
    	if self.root_weight and x_r is not None:
    	    out += self.lin_r(x_r)

    	if self.normalize:
    	    out = F.normalize(out, p=2., dim=-1)

    	return out

        def message(self, x_j: Tensor) -> Tensor:
    	print(f'x_j->\n{x_j}')
    	return x_j

        def message_and_aggregate(self, adj_t: SparseTensor,
    			      x: OptPairTensor) -> Tensor:
    	adj_t = adj_t.set_value(None, layout=None)
    	# print(f'adj_t: type->\n{type(adj_t)}, values->\n{ajd_t}')
    	return matmul(adj_t, x[0], reduce=self.aggr)

        def __repr__(self):
    	return '{}({}, {})'.format(self.__class__.__name__, self.in_channels,
    				   self.out_channels)

    x = Tensor([[1., 2., 3.], [4., 5., 6.], [7., 8., 9.]]) # x: (3, 3)
    edge_index = Tensor([[0, 0, 1, 2], [1, 2, 0, 0]]).long() # (2, 4)

    sage_nn = SAGEConv(3, 3)

    out = sage_nn(x=x, edge_index=edge_index)
    print(f'out->:\n{out}')
    ```

    -   实现里面有一些注意的地方：
        1.  `message_and_aggregate` 方法将 `message` 和 `aggragation` 放到一个函数中来执行，它的目的是为了节省时间和内存，但只有这个函数在子类中被实现，并且输入的 tensor x 是一个 SparseTensor 类型的时候，它才会被调用，目前不用管它

        2.  当把 x 变成一个 OptPairTensor 的时候 (即 x 扩展成元组 (x, x)), 在 propagate 时仍可以直接将 x 传进去，得到的 message 和传入 x: Tensor 的结果是一样的。这里之所以要将 x 从 Tensor 转换成 OptPairTensor, 是因为每次结点在计算更新的结点表示时，会将当前的结点特征和传入的 message 一并进行操作。


## GraphSAGE 中的 mini-batch 采样 {#graphsage-中的-mini-batch-采样}

<img src="/img/capture_2021_08_01_17_37_17.png" alt="capture_2021_08_01_17_37_17.png" width="800px" />
首先是前项传播的算法流程，聚合这里没有什么特别之处，和一般的 message passing 过程是一致的，主要理解这里的 K. K 在这里可以被认为是网络的 layer 数目，在每个 layer, aggragator function 的参数不一样，K 次迭代实际上是将结点的 K 阶邻居的信息聚合到一起。

{{< figure src="/img/capture_2021_08_01_17_41_51.png" width="800px" >}}

这是 graphsage mini-batch 采样的流程。1-6 行是得到所有采样的结点。注意这里 k 的循环方向和算法 1 的循环方向是相反的，原因是，假如我们想得到某个 batch B 的结点的表征，那么他们对应到算法 1, 应该是在最后第 K 次迭代输出得到的，所以这里需要反过来采样结点。那么对于每个 iteration k, 可以得到在这个 iteration 的 batch k. 采样完后，对应到 9-16 行，是算法 1 的过程，利用在每个 iteration 都构造好的 batch k, 来进行邻居结点的聚合。N\_k(u) 是一个 random 的邻居结点采样函数。
