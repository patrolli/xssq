+++
title = "目录下 org 文件自动导出成 hugo md 文件"
author = ["Li Xunsong"]
lastmod = 2021-04-09T19:46:59+08:00
tags = ["emacs", "elisp"]
draft = false
+++

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
