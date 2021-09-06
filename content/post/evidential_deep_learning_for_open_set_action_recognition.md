+++
title = "Evidential deep learning for open set action recognition"
author = ["Li Xunsong"]
date = 2021-08-19
lastmod = 2021-09-06T23:09:40+08:00
draft = false
+++

## Motivation {#motivation}

-   open-set action recognition 的挑战是什么？ static bias 带来的影响，将具有相同 static bias, 但不同 dynamic 的 unknown class 看作了 known class 去预测。


## Method {#method}

-   为什么用狄利克雷分布来描述？
-   主要内容：
    -   使用 [EDL]({{<relref "evidential_deep_learning.md#" >}}) 的 objective function, 学习给出一个样本 x, 预测它的类别概率和属于这个类别的不确定度
        ![](/img/capture_2021_08_26_16_35_36.png)
        ![](/img/capture_2021_08_26_16_36_53.png)
        这里相当于：给一个样本 x, 通过 DNN 计算它的 evidence e, 这个 e 又和狄利克雷分布的 &alpha; 有等式关系，再通过这个 &alpha; 来得到每个类别的概率和总体的不确定度（&alpha; 就相当于后验分布的参数，这个后验分布是关于每个 class 的）。
    -   对于 evidential uncertainty 的校准
        论文说提出这个校准是为了消除 OSAR 任务的 static bias, 一个校准模型需要对正确的预测给出高的 uncertainty, 而对于不正确的预测，要同时给出 uncertainty 的结果。校准就是考虑模型预测的 accuracy 和 uncertainty 之间的关系。（EDL 和 传统的 negative log-likelihood loss 都不能考虑到？）

        这里就是用了一个 loss 去约束预测的类别概率和 uncertainty 之间的关系。
        ![](/img/capture_2021_08_26_16_44_46.png)
    -   Contrastive evidence debiasing
        同样是为了消除 static bias, 引入了对比学习的方法

        {{< figure src="/img/capture_2021_08_26_16_46_19.png" >}}

        中间支路是用 3D 卷积网络提取的视频特征，而上面支路是打乱了帧序列再过 3D 卷积，下面支路是用 2D 卷积提取特征。这里引入了 HSIC, 它是度量两个连续随机变量之间的独立性的，当 HSIC(x,y)=0, 表示随机变量 x 和 y 是相互独立的。这里的对比是一个 minmax 的优化，对于中间特征 f, 需要它尽可能和上下两支路的特征独立，而上下两支路的特征需要尽量和中间支路相似。这样优化的目标是，让 f 尽可能不含有上下两支路中 bias 的特征。


## Summary {#summary}


## Comment {#comment}


## Ref {#ref}

-   [Evidential deep learning]({{<relref "evidential_deep_learning.md#" >}})
-   Open set recognition

multinomial subjective opinion: 多项主观意见
belief mass
