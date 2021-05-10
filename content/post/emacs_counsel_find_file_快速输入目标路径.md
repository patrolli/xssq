+++
title = "emacs counsel-find-file 快速输入目标路径"
author = ["Li Xunsong"]
date = 2021-05-10
lastmod = 2021-05-11T00:37:25+08:00
draft = false
+++

## Intro {#intro}

这个需求是最近用 `xah-new-empty-buffer` 来快速打开一个 buffer 记录一些草稿，然后保存文件，用它来代替 emacs 的 **scratch** buffer. 但一个问题是，在每次保存这些 untitled buffer 的时候 (c-x c-s), 默认打开的路径是 wsl 下的 home dir, 而我的文件通常放在 /mnt/c 这个目录下，这就意味着我要不停地按 backspace, 然后再输入目标路径，按 tab 在依次补全 file path. 但有些目标路径通常是固定的，例如，如果我想保存一个 org 文件，那么我的目标文件夹的路径就是 "/mnt/c/Users/lixun/Documents/org", 所以我希望能够快速地在 counsel-find-file 弹出的 mini-buffer 中输入这个路径。这里我使用 abbrev 来 pre-define 一些路径，例如：

```emacs-lisp
(define-abbrev global-abbrev-table "lorg" "mnt/c/Users/lixun/Documents/org/")
```

然后在 mini-buffer 中 enable abbrev mode:

```emacs-lisp
(add-hook
 'minibuffer-setup-hook
 (lambda ()
   (abbrev-mode 1)
   (setq local-abbrev-table global-abbrev-table)))
```

在保存文件或者 find-file 的时候，都会弹出 ivy 的 mini-buffer, 先按两下 /, 将起始的路径变成根目录，然后输入 abbrev 并展开（这里就是输入 "lorg", 然后按空格或者 `expand-abbrev`, 注意如果是空格展开，需要在展开后把后面的空格给去掉），这时 minibuffer 的输入栏就是我们的目标路径，然后按 Tab, 来激活 ivy （会发现这个路径的 text 被渲染了），就到了我们希望的目标路径上。
