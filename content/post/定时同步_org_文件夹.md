+++
title = "定时同步 org 文件夹"
author = ["Li Xunsong"]
date = 2021-12-11
lastmod = 2021-12-18T17:58:31+08:00
draft = false
+++

## 步骤 {#步骤}

1.  在 emacs 配置里面设置：`(run-at-time "00:59" 3600 'org-save-all-org-buffers)`. 每一个小时将所有打开的 org mode buffer 保存一次
2.  用一个脚本来 commit org 的仓库：

    ```sh
    #!/bin/sh
    # Add org file changes to the repository
    REPOS="org"

    for REPO in $REPOS
    do
        echo "Repository: $REPO"
        cd ~/Documents/$REPO
        # Remove deleted files
        git ls-files --deleted -z | xargs -0 git rm >/dev/null 2>&1
        # Add new files
        git add . >/dev/null 2>&1
        git commit -m "$(date)"
    done
    ```

3.  另外一个脚本用于将 org repo push 的远程 github:

    ```sh
    #!/bin/sh
    # push org repo into github
    cd ~/Documents/org/
    git push -v origin refs/heads/master\:refs/heads/master
    ```

4.  使用 [crontab]({{<relref "crontab.md#" >}}) 来定时执行脚本:

    ```text
    0 * * * * ~/scripts/org-git-sync.sh >/dev/null
    0 3 * * * ~/scripts/org-git-push.sh >/dev/null
    ```

    我们小时 commit 一次，然后每天一次将 repo push 到远程


## 参考 {#参考}

-   [Cron (简体中文) - ArchWiki](https://wiki.archlinux.org/title/Cron%5F(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
-   [一文精通 crontab从入门到出坑 - 知乎](https://zhuanlan.zhihu.com/p/58719487)
-   [Org Mode - Organize Your Life In Plain Text!](http://doc.norang.ca/org-mode.html#GitSync)