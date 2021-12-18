+++
title = "Evidential deep learning"
author = ["Li Xunsong"]
date = 2021-08-19
lastmod = 2021-12-18T18:23:02+08:00
draft = false
+++

对于一个 K 类的分类任务，EDL 将输入 x 看作一个命题，然后给出 K-维领域的主观意见 {1,...,K}. 每一个主观意见被表示为一个三元组：(b, u, a). b 表示 belief mass, u 表示 uncertainty, a 表示 base rate distribution. 对于 k &isin; {1, 2, ..., K}, probability mass 表示为：

{{< figure src="/mnt/c/Users/lixun/Documents/org/static/img/capture_2021_08_19_21_10_29.png" >}}

为了让 p\_k 具有概率意义 (所有 p\_k 之和为 1)，a\_k 通常被设置为 1/K, 剩下的 u 和 b\_k 满足约束：

{{< figure src="/mnt/c/Users/lixun/Documents/org/static/img/capture_2021_08_19_21_11_44.png" >}}

同时，probability mass p = [p1, p2, ..., pk] 要满足 [dirichlet dsitribution]({{<relref "dirichlet_dsitribution.md#" >}}),

{{< figure src="/mnt/c/Users/lixun/Documents/org/static/img/capture_2021_08_19_21_13_06.png" >}}

这个分布受到向量 a=[a1, ..., ak] 的控制。