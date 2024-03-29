+++
title = "awesome action recognition"
author = ["Li Xunsong"]
date = 2021-10-18
lastmod = 2022-01-07T14:40:35+08:00
tags = ["tmp", "awesome", "ce shi"]
draft = false
+++

## Egocentric {#egocentric}


### Interactive Prototype Learning for Egocentric Action Recognition {#interactive-prototype-learning-for-egocentric-action-recognition}

Epic-Kitchen 的数据集，将识别动作分解成识别 verb 和 noun. 文章首先得到 verb 的 prototype (verb classifier 权重的 l2 normalization), 然后用这个 prototype 去和 3D feature map 的所有 grid (TxHxW) vector 计算响应，来得到与动作相关的 noun feature, 抑制无关的 noun feature.

思想是利用 verb 去得到 action-centric object feature, 提高对物体的分类准确率，进而提高对 action 的识别。

![](/mnt/c/Users/lixun/Documents/org/static/img/capture_2021_10_18_20_24_37.png)
![](C:\Users\lixun\Documents\org\static\img\capture_2021_10_18_20_24_37.png)


## Self-supervised {#self-supervised}


### Motion-Augmented Self-Training for Video Recognition at Smaller Scale {#motion-augmented-self-training-for-video-recognition-at-smaller-scale}

从小规模的视频数据集，例如 HMDB51, UCF101 上面得到提取光流作为 motion 信息，然后训练一个以光流为输入的 model, 用这个训好的 motion model, 在更大的 source dataset (Kinetics) 上面通过聚类的方式得到视频的伪标签，然后去训练以 RGB 为输入的 model. 这一步的训练就不需要 source dataset 的监督信息。最后把这个训练好的 RGB model 用到下游的任务 (target dataset).

![](/mnt/c/Users/lixun/Documents/org/static/img/capture_2021_10_25_19_51_46.png)
![](C:\Users\lixun\Documents\org\static\img\capture_2021_10_25_19_51_46.png)


## Zero-shot {#zero-shot}

数据集和结果：

1.  UCF-101

    |                                            | Top-1 | Top-5 |
    |--------------------------------------------|-------|-------|
    | PS-ZSAR <Kerrigan-nips-2021-reformulating> | 40.1  | 66.3  |
    |                                            |       |       |
2.  HMDB

    |                                            | Top-1 | Top-5 |
    |--------------------------------------------|-------|-------|
    | PS-ZSAR <Kerrigan-nips-2021-reformulating> | 27.3  | 55.7  |
    |                                            |       |       |
3.  RareAct

    |                                            | Top-1 | Top-5 |
    |--------------------------------------------|-------|-------|
    | PS-ZSAR <Kerrigan-nips-2021-reformulating> | 11.5  | 32.8  |
    |                                            |       |       |


### Rethinking Zero-Shot Video Classification: End-to-End Training for Realistic Applications {#rethinking-zero-shot-video-classification-end-to-end-training-for-realistic-applications}

主要贡献: 1. 在 ZSAR 中首次提出 end-to-end 的模型，把 3D-CNN 也拿来训练，而之前的方法都是固定它 2. 标准化了 ZSAR 的评估 setting. 更现实的场景是，在 kinetic 上面训练模型，然后在其他数据集 (HMDB, UCF) 上面测试，并且将有 overlap 的类别从训练集中剔出掉。


### Reformulating Zero-shot Action Recognition for Multi-label Actions {#reformulating-zero-shot-action-recognition-for-multi-label-actions}

在 zero-shot 的时候，能够预测一个 video 的多个 action 标签。两个创新点，1. 将分类的函数从找与 video 最近邻的 label word embedding 换成学习一个 score function, 将 video 和每个 label word embedding 送到 function 中进行打分；2. 不固定 text embedding, 在学习的时候 refine 标签的语义嵌入。

这篇主要是 follow [Rethinking Zero-Shot Video Classification: End-to-End Training for Realistic Applications](#rethinking-zero-shot-video-classification-end-to-end-training-for-realistic-applications), 改进的地方似乎就是把 text embedding 这里也变成了一个可学习的，而不是固定住。

网络：

![](/mnt/c/Users/lixun/Documents/org/static/img/capture_2021_11_23_14_00_19.png)
![](C:\Users\lixun\Documents\org\static\img\capture_2021_11_23_14_00_19.png)


## Conventional {#conventional}


### TDN: temporal difference networks for efficient action recognition {#tdn-temporal-difference-networks-for-efficient-action-recognition}


## Transformers {#transformers}


### [Object-Region Video Transformers]({{<relref "Herzig-iclr-2021-object.md#" >}}) {#object-region-video-transformers--herzig-iclr-2021-object-dot-md}


### [Multiscale Vision Transformers]({{<relref "Fan-arxiv-2021-multiscale.md#" >}}) {#multiscale-vision-transformers--fan-arxiv-2021-multiscale-dot-md}