+++
title = "hugo&org-mode&ox-hugo 的博客工作流"
author = ["patrolli"]
publishDate = 2021-02-11T17:51:00+08:00
lastmod = 2021-02-11T17:53:27+08:00
tags = ["orgmode", "emacs", "hugo"]
categories = ["computer"]
draft = false
+++

## 两种工作流 {#两种工作流}

ox-hugo 有两种 work-flow: 一种是 one-post-per-subtree, 另一种是 one-post-per-file. ox-hugo 起到的作用实际是将我们写的 org 文件导出成 md, 并且生成 hugo 需要的 md 头文件信息，例如：

```txt
+++
title = "hugo&org-mode&ox-hugo 的博客工作流"
author = ["LAPTOP-4COO4EVU"]
categories = ["computer"]
draft = false
+++
```

这两种 workflow 的主要区别在于，如果是使用 headline, 我们不需要重复地设置 org 文件的 hearder 部分，并且可以利用 headline 的 todo state, tags, property 来设置导出的 markdown 元信息。

所以，使用 ox-hugo 的关键点在于理解如何在 org 文件中设置这些元信息，以及他们代表的含义。


## 文件元信息设置 {#文件元信息设置}

在 hugo 的 markdown 元信息配置中，通常需要涉及：

-   title
-   tag
-   author
-   created time
-   last modified time
-   categories
-   draft

将 org 通过 ox-hugo 导出到 markdown，需要在 org 文件里设置：

HUGO\_SECTION
: section 的定义可以参考 [Content Sections | Hugo](https://gohugo.io/content-management/sections/). 在 "/content" 目录下的一级目录，以及目录中含有 "\_index.md" 的文件夹都被视作 section. 我的理解是 section 可以对博文进行一些分组，便于我们管理。

HUGO\_BASE\_DIR
: Hugo site 的 root dir. 指定了这个路径后，在导出时，ox-hugo 就会找到这个目录下的 "/content" 文件夹，将导出的 md 文件放到对应位置。（如果是将 headline 导出，那么需要为这个 headline 设置 `EXPORT_FILE_NAME` 的 property.）
