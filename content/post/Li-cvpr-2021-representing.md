+++
title = "Representing videos as discriminative sub-graphs for action recognition"
author = ["Li Xunsong"]
date = 2021-07-01
lastmod = 2021-07-09T17:34:01+08:00
draft = false
+++

## Motivation {#motivation}

首先，视频中出现的不同 object 和 subject 可以看成是图的关系，对于不同的 action category, 图的结点数目可能是不一致的，因为一个视频的动作，有一些物体可能是和动作无关的。

这篇文章将整个视频中的所有实体看成一个 graph, 希望找到不同动作中最具有判别性的 sub-graphs.


## Method {#method}


### spatio-temporal complete graph {#spatio-temporal-complete-graph}

-   要对视频采集多个 clip, 在每个 clip-level 得到 actor/object 的 tubelets. 这里的 temporal 的单位应该是 clip, 而不是传统的 frame.
-   **Graph node** 在每个 clip 中，定义 M 个 tubelets, 即关注当前 clip 中的 M 个实体。他们作为 graph 的结点，具体的表征是利用他们的 visual semantic feature (利用 bounding box 对 3D CNN 输出的 feature map 进行 ROI Align) 和 coordinates feature. 他们的 coordinates feature 是将所有帧的 coordinates 拼接到一起然后再送到 MLP 中表征。
-   **Graph edge** graph 中所有的结点是 dense connected 的。所以对于每两个结点，他们之间边的定义为结点之间语义的相似度，以及他们坐标的相对变化。


### Discriminative sub-graphs {#discriminative-sub-graphs}

-   基于一个 complete graph, 可以得到结点数量不同的 sub-graphs, 在如此多的 sub-graph 中，论文希望找到最具代表性的这些 sub-graph 的 prototype, 于是使用 GMM 来进行聚类，学习每一个动作类别的高斯混合分布的参数
-   虽然这里 formulate 出来了一个 graph, 但是并没有用到 graph 相关的方法，只是将每个 sub-graph 中所有结点和边简单地 concat 起来，作为这个 sub-graph 的表征，然后进行 GMM 的学习


## Comment {#comment}


## Ref {#ref}

-   Recurrent tubelet proposal and recognition networks for action detection
