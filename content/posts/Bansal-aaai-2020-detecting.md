+++
title = "Detecting human-object interactions via functional generalization"
author = ["Li Xunsong"]
draft = false
+++

## Motivation {#motivation}

-   HOI 任务中，所有可能的 HOI 会随着 object 和 predicates 的数目增长而指数性地增长，但数据集中的训练样本并不能提供全部可能的 HOI, 这导致 HOI label 会有长尾分布的问题。
-   功能相似的物体，会出现在相近的 interaction 中。例如，eat <burger, hot dog, sandwitch, pizza>, 后面的这些物体都是可以说是功能相近，所以他们都可以出现在 eat 这个动作中。
-   这篇文章提出一种类似于数据增强的方式，找到很多“功能相似”的 object, 这些 object 可能不在数据集中出现，然后用这些 object 的信息去训练同一个类别的 HoI classifier. 在判定物体 "功能相似" 时，引入了一些先验知识 (common sense), 最后将功能相似定义为物体的 visual appearance 和 semantic representation 结合到一起来判定物体之间是否具有相似的功能。如果具有了相似的功能，那么物体就可能出现在同一个 HoI label 中。


## Method {#method}

-   框图：
    ![](/img/capture_2021_04_10_21_52_16.png)
-   generalization 模块：
    ![](/img/capture_2021_04_10_21_52_34.png)
    这里将相似的物体进行替换，替换的只是物体 word embedding 的输入部分，其他部分的输入保持不变，仍是从 HoI 图片样本中得到的。#+HUGO\_BASE\_DIR: /mnt/c/Users/lixun/Documents/xssq-blog


## Comment {#comment}

-   如何定义功能相似的 object?
-   如何做到 zero-shot?
-   提到了对 dataset bias 的定义 (<sup id="b7530f6aafec3df424a3304572e61591"><a href="#Zhao-emnlp-2017-men" title="Jieyu Zhao, Tianlu Wang, Mark Yatskar, , Vicente Ordonez \&amp; Kai-Wei Chang, Men Also Like Shopping: Reducing Gender Bias  Amplification using Corpus-level Constraints, 2979-2989, in in: {Proceedings of the 2017 Conference on Empirical
                      Methods in Natural Language Processing, {EMNLP}
                      2017, Copenhagen, Denmark, September 9-11, 2017}, edited by (2017)">Zhao-emnlp-2017-men</a></sup>)，构建了一个 bias dataset. 具体而言，考虑一个 <object, predicate> pairs 的集合，然后对每个 pair q\_i, 考虑两种情况：1. bias against the pair 2. bias towards the pair. 第一种情况，将数据集中全部包含 pair q\_i 的样本去掉（相当于从来没有看见过 q\_i），然后保留所有包含物体 o\_i 的样本（物体 o\_i 在其他的动作 (predicate) 之中）。第二种情况，去掉所有包含物体 o\_i 的样本，除了是 q\_i 这个 pair 的（相当于只见过物体 o\_i 出现在 q\_i 这个 pair 中）。


## Ref {#ref}

-   [Decaug: augmenting HOI detection via decomposition]({{< relref "Xie-aaai-2021-decaug" >}})
