+++
title = "Decaug: augmenting HOI detection via decomposition"
author = ["Li Xunsong"]
lastmod = 2021-04-05T16:40:05+08:00
tags = ["PaperReading"]
categories = ["Academic"]
draft = false
+++

<sup id="8ee52d5562c7b98dc31141ab8959c0fc"><a href="#Xie-aaai-2021-decaug" title="Yichen Xie, Haoshu Fang, Dian Shao, Yonglu, Li \&amp; Cewu Lu, DecAug: Augmenting {HOI} Detection via  Decomposition, {CoRR}, v(), (2020).">Xie-aaai-2021-decaug</a></sup>


## Motivation {#motivation}

-   设计一种数据增强的方法 (pixel-level)，来增加 interaction 的 diversity, 以此缓解 HOI 中存在的长尾分布问题。通过贴图组合的方式来增加每种 HOI 的训练样本，论文是将同一个类别的物体相互替换，并且通过人体的 pose, 建模了每种 HOI 下物体可能出现的位置，对物体可能出现的位置也进行了增强。


## Method {#method}

-   首先将 HOI 分解成 background I, human state h （appearance, pose, parsing, shape, gaze 等信息）, object state o （category, 6D pose, occlusion, functionality 等），spatial relationship s:
    ![](/img/capture_2021_04_03_19_25_13.png)
    论文主要是通过 object state 和 spatial relationship 进行样本增强
-   论文指出在 HOI detection 中， object state 比其 texture pattern 更加重要。例如， holding a mug, “the standing pose and the occlusion with hands are more important than the mug’s color and texture". （在论文中，主要是用什么信息描述 object state?）
-   这里贴物体的要求：1. 保持物体的 state 2. 增强后的图片要 realistic
-   首先判断图中的物体是否可以替换。这里考虑如果一个物体和其他物体的遮挡交错 (interlock) 较为严重时，就不进行替换。论文设计了一个名为 "instance interlocking ratio" 的指标来进行判断。公式为：

![](/img/capture_2021_04_03_19_34_48.png)
![](/img/capture_2021_04_03_19_34_57.png)
其中 C\_i 是 instance i 的边界，M\_i 是 instance i 的 mask, 如果两个物体的边界相交很长，就认为他们的 interlock 很高，因此这两个物体都不可以被替换 (数据集中可以被替换的物体比例？)。如图：
![](/img/capture_2021_04_03_19_36_34.png)

-   在决定一个物体是否可以替换后，需要找到具有相似 state 的物体来进行替换。这里的 state 包括 shape variance, occlusion variance, pose variance 等。不同的 HOI 决定这些 object state 是不一样的。论文将 instance mask 作为 object state 的表征，他们认为这个 mask 包含了物体 6D pose 形状，6D pose 的投影，并且遮挡情况也可以通过临近的 instance mask 来量化。给出物体的一个 bounding box, 将 object mask 部分的像素点记为 1, background 部分的像素点记为 0, 将相邻的 object mask 的像素点记为 -1. 将这个 object state matrix 作为物体 pose, 6D pose, occulusion 的 descriptor. 基于这个 descriptor, object state distance 两个物体 state matrix 的 L1 距离。在找到可以相互替换的 object pair 后，就可以相互拼图替换，这里还涉及到一些算法，来使拼过去的图片更加 realistic. 如图：

{{< figure src="/img/capture_2021_04_03_20_03_32.png" >}}

-   目前的替换仍是在被替换的物体原来的位置上进行，也就是只对物体的 appearance 进行了增强，这里还需要对物体在这个 HOI 中可能出现的位置进行增强，将物体贴到可能的位置上去。论文提出 pose-guided probability 的方法来找到物体 feasible 的位置。首先生成 human 的 pose, 得到 17 个 keypoints 坐标。然后计算物体中心和 human body 的中心之间的位移矢量，作为 relative spatial position vector, 将物体出现的位置 L 建模为 human pose 的条件概率，用一个混合高斯分布来建模，对于每个 HOI label h, 去学习这个条件概率分布。

![](/img/capture_2021_04_03_20_17_52.png)
这里 N\_G 是指数据集中 atomic poses 的数目，这里设置为 42. 这个[混合高斯分布]({{< relref "混合高斯分布" >}})的参数通过 [EM 算法]({{< relref "em算法" >}})来求解。


## Comment {#comment}

-   实际上替换的还是物体的 appearance
-   在建模了物体可能出现的位置后，取得的提升是多少？从实验结果来看，对物体位置建模取得的提升要更大一些，但二者加在一起仍有提升。


## Ref {#ref}
