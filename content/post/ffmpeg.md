+++
title = "ffmpeg"
author = ["Li Xunsong"]
lastmod = 2021-04-09T19:46:57+08:00
tags = ["ffmpeg", "linux"]
draft = false
+++

-   使用 ffmpeg 将一系列帧图片转换成 .gif 和 .avi

<!--listend-->

```shell
ffmpeg -f image2 -i frame%4d.jpg video.avi
ffmpeg -i video.avi -t 5 out.gif
```

-   将视频转换成图片

    ```sh
    ffmpeg -i ./video.webm ./video/image%d.jpg
    ```
