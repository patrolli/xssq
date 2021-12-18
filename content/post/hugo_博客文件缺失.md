+++
title = "hugo 博客文件缺失"
author = ["Li Xunsong"]
date = 2021-09-07
lastmod = 2021-12-18T17:56:41+08:00
draft = false
+++

## Intro {#intro}

在发布 hugo 博客的时候遇到一个问题，当文件导出到 `post` 目录，部署到 `github pages` 后，网页没有把新的文章刷新出来。之前大概等 10 几秒就能够刷新。在 github 仓库的提交历史中能看到这篇文章被 commit 了。后面查了一下，可能是时区设置的问题，导致 hugo 认为这篇文章是要在未来某个时刻才发布。解决方法是在 deploy 的脚本中，添加 `hugo --buildFuture`.


## Ref {#ref}

-   [Hugo Post Missing (Hugo 博客文章缺失问题) - jdhao's blog](https://jdhao.github.io/2020/01/11/hugo%5Fpost%5Fmissing/)
-   [Issue with generating site - missing posts - support - HUGO](https://discourse.gohugo.io/t/issue-with-generating-site-missing-posts/12149/7)
-   [GitHub pages are not updating - Stack Overflow](https://stackoverflow.com/questions/20422279/github-pages-are-not-updating/35388975#35388975)