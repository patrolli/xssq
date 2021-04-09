+++
title = "目录下 org 文件自动导出成 hugo md 文件"
author = ["Li Xunsong"]
lastmod = 2021-04-10T00:35:25+08:00
tags = ["emacs", "elisp"]
draft = false
+++

## Intro {#intro}

目前在从 org 使用 ox-hugo 导出成 hugo 的 blog 时，只能手动的执行 `C-c C-e`, 然后选择导出成 Hugo 形式的 markdown. 如果原始的 org 文件进行了修改，就需要每次自己手动去进行导出，有一些不方便，所以我想写一个函数，来直接将指定目录下，所有已经导出过 hugo blog 的 org 文件，全部重新导出，这样只要定期执行这个命令，就可以保证文件在修改后能够被更新地导出到 hugo blogs. 目前的实现代码如下：

```emacs-lisp
;; 检测文件是否已经被导出 hugo
(defun lxs-org-is-hugo-file-p (fPath)
  "Predict if the org file has been converted into hugo"
  (with-temp-buffer
    (let ((keyline "#+HUGO_DRAFT: false\n"))
	  (insert-file-contents fPath)
	  (and (search-forward keyline nil t) t)
	  )
    ))
(defun lxs-list-org-in-directory (dPath)
  "list org files under a directory path"
  (directory-files-recursively dPath "\.org$")
  )
(defun my--export-to-hugo (dPath)
  "Convert org files under a directory path into hugo .md files"
  (mapc
   (lambda (file-name)
     (progn
       (if (lxs-org-is-hugo-file-p file-name)
	   (with-current-buffer (find-file-noselect file-name)
	     (org-hugo-export-wim-to-md)
	     ))
       ))
   (lxs-list-org-in-directory dPath)
   )
  (message "export to hugo md file end!"))
(defun my--choose-directory ()
  "Return a directory chosen by the user.  The user will be prompted
to choose a directory"
  (let* ((ivy-read-prompt "Choose directory: ")
	 (counsel--find-file-predicate #'file-directory-p)
	 (selected-directory
	  (ivy-read
	   ivy-read-prompt
	   #'read-file-name-internal
	   :matcher #'counsel--find-file-matcher)))
    selected-directory))
(defun lxs-export-org-to-hugo ()
  (interactive)
  (let ((directory (my--choose-directory)))
    (my--export-to-hugo directory)))
```


## Outro {#outro}

-   如果只针对单个 org 文件，也可以不用 `C-c C-e` 命令来选择导出成什么形式，直接执行 `org-hugo-export-wim-to-md` 即可
-   TODO: [ ] 自动加入 Hugo 的 header lines, 一旦希望这个 org 文件被导出成 hugo blogs, 就插入 hugo 的头文件信息到 org 文件中
-   TODO: [ ] 自动部署到 github pages 上，现在还需要手动再执行部署的脚本，这一步也可以集成到一起，实现从一个 org 文件到网页 blog 的流程
