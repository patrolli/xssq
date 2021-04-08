+++
title = "ubuntu 安装 iosevka 字体"
author = ["Li Xunsong"]
lastmod = 2021-04-08T17:55:41+08:00
tags = ["linux"]
draft = false
+++

-   从 [github](https://github.com/be5invis/Iosevka/releases) 的代码仓库中下载 zip 文件，放到一个临时目录中 ("~/temp/")
-   解压文件

    ```sh
    unzip -u ttf-iosevka-5.2.1.zip -d iosevka
    ```
-   放到系统的字体目录：

    ```sh
    sudo cp -r ~/temp/iosevka /usr/share/fonts/
    ```
-   重新刷新字体缓存

    ```sh
    fc-cache -fv
    ```

-   Ref:
    -   [Linux notes | Shreyas Ragavan](https://shreyas.ragavan.co/docs/linux-notes/)
