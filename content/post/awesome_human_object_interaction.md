+++
title = "awesome human object interaction"
author = ["Li Xunsong"]
lastmod = 2022-01-10T17:22:59+08:00
draft = false
+++

## Intro {#intro}

HoI 是 visual relation 的一个子任务，它对 human body 和 object understanding 的依赖性很强


## 相关工作 {#相关工作}


### Transformer based {#transformer-based}


#### QPIC: query-based pairwise human-object interaction detection with image-wide contextual information {#qpic-query-based-pairwise-human-object-interaction-detection-with-image-wide-contextual-information}

-   这篇是基于 [DETR]({{<relref "Carion-eccv-2020-end.md#" >}}) 做的, 它有什么改进或区别吗？
-   推理是什么做的？


#### [Mining the benefits of two-stage and one-stage HOI detection]({{<relref "Zhang-nips-2021-mining.md#" >}}) {#mining-the-benefits-of-two-stage-and-one-stage-hoi-detection--zhang-nips-2021-mining-dot-md}


#### [HOTR: end-to-end human-object interaction detection with transformers]({{<relref "Kim-cvpr-2021-hotr.md#" >}}) {#hotr-end-to-end-human-object-interaction-detection-with-transformers--kim-cvpr-2021-hotr-dot-md}


### One-stage {#one-stage}


#### Glance and Gaze: Inferring Action-aware Points for One-Stage Human-Object Interaction Detection {#glance-and-gaze-inferring-action-aware-points-for-one-stage-human-object-interaction-detection}


#### {PPDM:} Parallel Point Detection and Matching for Real-Time Human-Object Interaction Detection {#ppdm-parallel-point-detection-and-matching-for-real-time-human-object-interaction-detection}

将 human/object/interaction 的中心点进行预测，学习的时候将 point 的预测转换成 key-point heatmap 的预测。检测到 point 后，对于每个 interaction point, 匹配其对应的 human/object point, 做法是，对 ground truth 中的每个 interaction point, 学习它相对于 human 和 object point 的位移。这样对于预测的 interaction point, 也能够得到它相对于 human 和 object 的偏移，这样再根据这个偏移，找到与之最接近的 human 和 object point.


#### Mining the Benefits of Two-stage and One-stage {HOI} Detection {#mining-the-benefits-of-two-stage-and-one-stage-hoi-detection}


### Graph {#graph}

图的方法，为什么要考虑用图？


#### [Learning Human-Object Interactions by Graph Parsing Neural Networks]({{<relref "Qi-eccv-2018-learning.md#" >}}) {#learning-human-object-interactions-by-graph-parsing-neural-networks--qi-eccv-2018-learning-dot-md}


#### Relation Parsing Neural Network for Human-Object Interaction Detection {#relation-parsing-neural-network-for-human-object-interaction-detection}


#### ConsNet: Learning Consistency Graph for Zero-Shot Human-Object Interaction Detection {#consnet-learning-consistency-graph-for-zero-shot-human-object-interaction-detection}

图建模标签依赖关系

-   这篇的 motivation 和 [Learning graph embeddings for compositional zero-shot learning]({{<relref "Ferjad-arxiv-2021-learning.md#" >}}) 有点像。对于这种带有组合性质的标签，标签之间的依赖是一个有用的信息。将标签的语义（包括 word embedding 和 visual semantic）放到图里进行传播，将 seen 或者 head category 的 label 信息传递到 unseen/tail category 上。不过他们这个图要复杂一些，除了对结点用 word embedding, 还用了视觉的语义信息。那篇文章的方法能不能用这篇文章的来增强呢？


#### [Learning to Detect Human-Object Interactions With Knowledge]({{<relref "Xu-cvpr-2019-learning.md#" >}}) {#learning-to-detect-human-object-interactions-with-knowledge--xu-cvpr-2019-learning-dot-md}

主要针对 HOI 中的长尾问题，这里认为 HOI 中的 verb 存在长尾分布问题，因此将 verb 和 object 的类别放到一个图中，利用已有的 HOI 标注，建立 verb/object 之间的依赖关系，然后通过消息传播，将 head verb 类别的信息传递到 tail verb 类别中。


#### Spatially Conditioned Graphs for Detecting Human-Object Interactions {#spatially-conditioned-graphs-for-detecting-human-object-interactions}

这篇沿着 [GPNN]({{<relref "Qi-eccv-2018-learning.md#" >}}) 来做的，我的理解是在图的结点和边的表示中加入了位置信息，感觉创新性上不是很高，但他们的效果调得很好。


### Zero-shot/Composition {#zero-shot-composition}


#### [Interaction compass: multi-label zero-shot learning of human-object interactions via spatial relations]({{<relref "interaction_compass_multi_label_zero_shot_learning_of_human_object_interactions_via_spatial_relations.md#" >}}) {#interaction-compass-multi-label-zero-shot-learning-of-human-object-interactions-via-spatial-relations--interaction-compass-multi-label-zero-shot-learning-of-human-object-interactions-via-spatial-relations-dot-md}


#### [Scaling Human-Object Interaction Recognition Through Zero-Shot Learning]({{<relref "Shen-wacv-2018-scaling.md#" >}}) {#scaling-human-object-interaction-recognition-through-zero-shot-learning--shen-wacv-2018-scaling-dot-md}


## Scene graph related {#scene-graph-related}

Scene graph 的工作和 Hoi 比较相近，暂时也将他们放到这里


### [Bipartite Graph Network with Adaptive Message Passing for Unbiased Scene Graph Generation]({{<relref "Li-cvpr-2021-bipartite.md#" >}}) {#bipartite-graph-network-with-adaptive-message-passing-for-unbiased-scene-graph-generation--li-cvpr-2021-bipartite-dot-md}


## Evaluation {#evaluation}

在这个 setting 下面的各种 evaluation 指标

1.  HICO-DET 数据集