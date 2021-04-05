+++
title = "hugo 博客搭建"
author = ["Li Xunsong"]
lastmod = 2021-04-05T18:01:11+08:00
tags = ["emacs", "blog"]
categories = ["emacs"]
draft = false
+++

## 基本安装与使用 {#基本安装与使用}


### Hugo 安装 {#hugo-安装}

直接在官网下载 Hugo 的安装包


### 本地创建 {#本地创建}

根据官网的 [quick start](https://gohugo.io/getting-started/quick-start/), 创建一个 site 只需如下几个命令

```shell
hugo server
```


### 部署到 github pages {#部署到-github-pages}

github pages 有两种形式，一种是针对用户的 pages: <username>.github.io，另一种是针对项目的 pages: <username>.github.io/projectxx. 无论如何，首先要在 github 上创建一个 <username>.github.io 的仓库。由于我之前将 hexo 的网站部署到了我的 patrolli.github.io 上，当时也没有写几篇博客，懒得再迁移，于是这次的 hugo 博客就放到项目的 github pages. patrolli.github.io 可以之后留做个人简历的入口。
根据 [Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/) 的 tutorial, 部署到 Github Pages project 有两种方式。第一种是直接以 master 分支的 /doc 文件夹发布，另一种是新建一个 gh-pages 分支，将 hugo 的发布文件夹 (publish) 放到这个分支下，然后选择以这个分支进行发布。第一种方法要简单一些，第二种我也还没研究明白。第一种方法的步骤如下：

-   在 github 创建一个仓库，不要添加 .gitignore 和 README.md
-   在仓库页面的 setting 中，找到 github pages 的设置，将发布的 source 设置为 master 分支的 docs 文件夹
    ![](/img/capture_2020_12_25_10_29_00.png)
    ![](/img/capture_2020_12_25_10_29_40.png)
-   将本地的 hugo site 的根目录 (demo) 与远程仓库关联
    -   `git remote add origin xxx`
-   修改 config.toml 文件（这一步很关键）

<!--listend-->

```toml
baseURL = "https://patrolli.github.io/xssq/"  # 设置为 github pages 发布的地址
publishDir = "docs"  # 将生成的静态页面文件夹设置到 docs 下，而不是 publish
```

-   将本地文件 push 到远程，这一步写在脚本里，在本地完成修改后一键部署到远程

<!--listend-->

```shell
#!/bin/bash

hugo

git add .
git commit -m "updates $(date)"
git push origin master
```


### Todo {#todo}

-   [X] 图片管理
-   主题美化完善
-   结合 emacs orgmode 的工作流


### issues {#issues}

-   hugo 图片显示问题：
    如果 hugo 的 basedir 包含了子文件夹，例如 'localhost:1313/foo/my-hugo/', 那么图片这些静态文件的路径将会是 'localhost:1313/foo/img.jpg', 而将那个子文件夹给忽略了。参考：[Best way to reference an image in \`/static\` directory when baseURL could contain a sub-directory? - support - HUGO](https://discourse.gohugo.io/t/best-way-to-reference-an-image-in-static-directory-when-baseurl-could-contain-a-sub-directory/15461). 这里我是在 config.toml 文件中设置 `canonifyURLs = true`, 然后能够正常显式图片了。


## Ref {#ref}

-   [official quick start](https://gohugo.io/getting-started/quick-start/)
-   [使用 Emacs + ox-hugo 来写博客](http://blog.jiayuanzhang.com/post/blog-with-ox-hugo/)
-   [博客写作流程之工具篇： emacs, orgmode, hugo & ox-hugo](https://www.xianmin.org/post/ox-hugo/)
-   [博客系统迁移：Hexo 到 Hugo](https://liujiacai.net/blog/2020/12/05/hexo-to-hugo/)
