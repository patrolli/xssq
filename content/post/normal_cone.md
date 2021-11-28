+++
title = "cones"
author = ["Li Xunsong"]
date = 2021-11-28
lastmod = 2021-11-28T12:03:19+08:00
draft = false
+++

## Cone 锥 {#cone-锥}

{{< figure src="/img/capture_2021_11_28_11_32_42.png" >}}


## Convex cone 凸锥 {#convex-cone-凸锥}

{{< figure src="/img/capture_2021_11_28_11_33_02.png" >}}


## Polar cone {#polar-cone}

定义:
![](/img/capture_2021_11_28_11_37_16.png)

从下面这个图可以看到，polar cone 类似于对集合 C 取反了 (这里需要 C 满足什么性质吗？如 convex set?)。
![](/img/capture_2021_11_28_11_37_36.png)


## Tanget cone {#tanget-cone}

{{< figure src="/img/capture_2021_11_28_11_45_40.png" >}}

对于给出的集合，Tanget cone 定义为:

1.  如果点在集合内部，那么它的 Tanget cone 是任意的 (整个空间)
2.  如果点在集合的包络面上，那么 Tanget cone 是半平面
3.  如果是在 x3 那个点，那么 Tanget cone 是集合的边界

问题：

-   给出的这个集合要是一个 cone 吗？
-   Tanget cone 也是一个 cone? 如何验证它满足 cone 的定义呢？


## Normal cone {#normal-cone}

{{< figure src="/img/capture_2021_11_28_11_51_23.png" >}}

-   Normal cone 是 Tanget cone 的 [polar cone](#polar-cone).
-   如果点在内部，那么为 0
-   如果在包络面上，那么就是垂直切线的方向
-   如果在 x3 这个点上，就是图中红线画的区域

一个更加正式的定义：
![](/img/capture_2021_11_28_12_01_12.png)
