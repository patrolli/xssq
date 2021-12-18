+++
title = "hugo 博客文件缺失"
author = ["Li Xunsong"]
date = 2021-09-07
lastmod = 2021-12-18T23:52:27+08:00
draft = false
+++

## Intro {#intro}

在发布 hugo 博客的时候遇到一个问题，当文件导出到 `post` 目录，部署到 `github pages` 后，网页没有把新的文章刷新出来。之前大概等 10 几秒就能够刷新。在 github 仓库的提交历史中能看到这篇文章被 commit 了。后面查了一下，可能是时区设置的问题，导致 hugo 认为这篇文章是要在未来某个时刻才发布。解决方法是在 deploy 的脚本中，添加 `hugo --buildFuture`.

Update: Sat Dec 18

文章渲染缺失的问题，可能是因为 github pages 部署没有成功导致的。今天又遇到了类似文章被 commit 了上去，但没有加载显示出来的问题。然后在博客仓库的 Action 里面看到了每次部署的具体情况：

{{< figure src="/img/Intro/2021-12-18_23-47-06_screenshot.png" >}}

点开失败的 git action, 可以看到具体构建失败的原因。今天下午遇到的原因其实是没有将 themes/ 这个文件夹下的所有主题写到 .gitmodules 文件中。虽然之前没有写也没出错。问题在于，themes 文件夹下面有几个主题，就要把这几个主题写到 .gitmodules 里面，例如：

```text
[submodule "themes/ananke"]
        path = themes/ananke
        url = https://github.com/budparr/gohugo-theme-ananke.git
[submodule "themes/maupassant"]
        path = themes/maupassant
        url = git@github.com:flysnow-org/maupassant-hugo.git
[submodule "themes/even"]
        path = themes/even
        url = https://github.com/olOwOlo/hugo-theme-even.git
[submodule "themes/hugo-onyx-theme"]
        path = themes/hugo-onyx-theme
        url = https://github.com/kaushalmodi/hugo-onyx-theme.git
```

而其实这个报错的信息就是通过 git action 里面看到的：

{{< figure src="/img/Intro/2021-12-18_23-50-36_screenshot.png" >}}

所以当博客部署了但没有刷出新文章的时候，应该就查看一下 github 的 action 的报错信息。


## Ref {#ref}

-   [Hugo Post Missing (Hugo 博客文章缺失问题) - jdhao's blog](https://jdhao.github.io/2020/01/11/hugo%5Fpost%5Fmissing/)
-   [Issue with generating site - missing posts - support - HUGO](https://discourse.gohugo.io/t/issue-with-generating-site-missing-posts/12149/7)
-   [GitHub pages are not updating - Stack Overflow](https://stackoverflow.com/questions/20422279/github-pages-are-not-updating/35388975#35388975)