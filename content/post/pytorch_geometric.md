+++
title = "pytorch geometric"
author = ["Li Xunsong"]
lastmod = 2021-08-27T13:24:53+08:00
draft = false
+++

## Intro {#intro}

pytorch geometric 是基于 pytorch 的一个 GNN 框架库


## 安装 {#安装}

```sh
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.7.0+${CUDA}.html
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.7.0+${CUDA}.html
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.7.0+${CUDA}.html
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.7.0+${CUDA}.html
pip install torch-geometric
```

这里 `${CUDA}` 根据对应的 cuda 版本选择：`cpu`, `cu92`, `cu101`, `cu102`, `cu110`

实验室 aimax 上的 cuda 版本是 cu101, 所以把这几行弄成一个脚本 `install-pyg.sh`

```sh
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.7.0+cu101.html
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.7.0+cu101.html
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.7.0+cu101.html
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.7.0+cu101.html
pip install torch-geometric
```


## 定义一个图数据 {#定义一个图数据}

pyg 提供了一个类 `torch_geometric.data.Data` 来定义一个图，它包含了一个图的一些基本属性：

```python
from torch_geometric.data import Data
import torch
edge_index = torch.tensor([[0, 0, 0, 1, 2, 3],
			  [1, 2, 3, 0, 0, 0]], dtype=torch.long) # edge_index: (2, num_edges)
x = torch.randn((4, 256), dtype=torch.float) # x: (num_nodes, num_node_features)
data = Data(x=x, edge_index=edge_index)

print('num node features:', data.num_node_features)
print('num edges:', data.num_edges)
print('num nodes:', data.num_nodes)
print('num features:', data.num_features)
print('num edge features', data.num_edge_features)
```

这里我们给 Data 类传入了 x 和 edge\_index, 即所有的 node 和所有的 edge.


## Basic Message Passing Network {#basic-message-passing-network}

MessagePassing 类是所有图神经网络 layer 的 Base class. 各种不同的 message passing 方式都是从继承 MessagePassing 这个 base class 而来，然后再定制自己的 `message()`, `aggregate()`, `update()` 函数。在 forward 函数里调用 `propagate()` 函数，就会依次调用 `message()`, `aggregate()`, `update()` 这三个函数，完成 message passing 的过程。可以[参考](https://pytorch-geometric.readthedocs.io/en/latest/modules/nn.html) pyg `torch.geometric.nn` 中各种不同 graph layer 的实现，他们对应着不同的 message function.

`propagate()` 函数必须传入的是 edge\_index, 其余的参数根据 message() 和 update() 的需要来传递。

`propagate(edge_index: Union[torch.Tensor, torch_sparse.tensor.SparseTensor], size: Optional[Tuple[int, int]] = None, **kwargs)`:

在 \*\*kwargs 里面，可以传递任意的参数，这些参数会被 message, update 这些函数用到。例如下面这个代码，我在 propagate 中额外添加了 `lxs` 这个参数，它可以在后面的 message, update 函数中被用到。

```python
import torch.nn as nn
from torch_geometric.nn import MessagePassing
import numpy as np
from torch_geometric.utils import to_undirected
import torch

class MyMessagePassingLayer(MessagePassing):
    def __init__(self):
	super(MyMessagePassingLayer, self).__init__(aggr='add')

    def forward(self, x, edge_index):
	return self.propagate(edge_index, x=x, lxs=torch.randn((5, 4)))

    def message(self, x_i, x_j):
	print('x_i', x_i)
	print('x_j', x_j)
	return x_j

    def update(self, inputs, x_i):
	return inputs

x = torch.randn((8, 4))
net = MyMessagePassingLayer()
edge_index = torch.tensor([[1, 2, 3], [2, 4, 5]])
out = net(x, edge_index)
```

`message()` 可以接收 `propagate()` 中的任意参数，并且如果这些参数在变量名中加上 '\_i', '\_j', 那么这个参数将会被映射成 source\_node 和 target\_node 的形式。假如输入是表示结点的 x (N, d), 还传入 edge\_index (2, m), 那么在 message 中， x\_i 和 x\_j 的形状将变成 (m, d). 这个映射会根据 edge\_index 去进行索引，x\_i 是 edge\_index 中的 edge\_index[1] 对应的结点下标值，x\_j 是 edge\_index[0] 对应的结点下标值。

```python
import torch.nn as nn
from torch_geometric.nn import MessagePassing
import numpy as np
from torch_geometric.utils import to_undirected
import torch

class MyMessagePassingLayer(MessagePassing):
  def __init__(self):
      super(MyMessagePassingLayer, self).__init__(aggr='add')

  def forward(self, x, edge_index):
      print('x before message:\n', x)
      print('edge index:\n', edge_index)
      return self.propagate(edge_index, x=x, lxs=torch.randn((5, 4)))

  def message(self, x_i, x_j):
      print('x after enter message:\n', x)
      print('x_i:\n', x_i)
      print('x_j:\n', x_j)
      return x_j

  def update(self, inputs, x_i):
      print('x_i in update:\n', x_i)
      return inputs

x = torch.randn((4, 4))
net = MyMessagePassingLayer()
edge_index = torch.tensor([[0, 1, 2], [1, 2, 3]])
out = net(x, edge_index)
```

从这个结果还可以看到， x\_i, x\_j 在 update() 函数里面仍然可以使用。

`update()` 函数的原型是： `update(inputs: torch.Tensor) → torch.Tensor`, 它接受的第一个参数 `inputs` 是每个结点聚合后的 message, 其大小为 `(N, dim)`, N 是结点数目。另外还可以接受传给 `propagate()` 的任意参数，例如我们这里的 `edge_index`, `lxs`.


## pyg 官方库中的 Graph convolutional layer {#pyg-官方库中的-graph-convolutional-layer}

学习 pyg 官方库中对各种 graph layer 的实现


### [GraphSAGE]({{<relref "graphsage.md#" >}}) {#graphsage--graphsage-dot-md}


## <span class="org-todo todo TODO">TODO</span> 对于 bipartite graph 如何使用 {#对于-bipartite-graph-如何使用}

source 结点和 target 结点的参数要不一样
pyg 中不同 GNN layer 对具有不同属性的图的支持可以在[这里看到](https://pytorch-geometric.readthedocs.io/en/latest/notes/cheatsheet.html?highlight=bipartite#hypergraph-neural-network-operators)：
![](/img/capture_2021_08_27_11_48_29.png)


## Ref {#ref}
