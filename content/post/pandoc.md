+++
title = "pandoc"
author = ["Li Xunsong"]
lastmod = 2021-05-06T19:48:51+08:00
draft = false
+++

在将 org 文件导出成 word 的时候，文献的引用信息不能被导出，只好曲线救国，从 .tex 导出到 .docx. 命令如下：

```sh
pandoc -s foo.tex --bibliography=foo.bib --csl=ieee.csl -o foo.docx
```

这里需要指明 bib 文件的路径，另外需要单独[下载样式文件](https://tex.stackexchange.com/questions/268196/how-to-convert-latex-to-word-using-pandoc-and-keep-citations-as-numeral) （这里的 ieee.csl），并指明路径。

执行这个命令的时候，可能需要再安装 `pandoc-citeproc` 这个 package:

```sh
sudo apt install pandoc-citeproc
```

@Ref

-   [Pandoc - Demos](https://pandoc.org/demos.html)
