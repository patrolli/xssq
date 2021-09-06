+++
title = "emacs 在 org-mode 中补全符号"
author = ["Li Xunsong"]
date = 2021-09-06
lastmod = 2021-09-06T22:53:29+08:00
draft = false
+++

## Intro {#intro}

在 abo-abo 的博客里翻倒一篇[博文](https://oremacs.com/2017/10/04/completion-at-point/)，将 `completion-at-point` 用到 org-mode 中，来补全引用内容 (即被 `==` 包围的内容). 这样，如果这个 symbol 在文档里面会重复多次，就不必每次都完整地输入 symbol, 例如这里再次输入 `completion-at-point`, 只需要键入 `=com`, 就能够提供补全了。

abo 原来博客里面的代码似乎不能直接使用了，需要做一些小的修改，如下：

```emacs-lisp
(defun org-completion-symbols ()
  (interactive)
  (when (looking-back "=[a-zA-Z\\-]+")
    (let (cands)
      (save-match-data
	(save-excursion
	  (goto-char (point-min))
	  (while (re-search-forward "=\\([a-zA-Z\\-]+\\)=" nil t)
	    (cl-pushnew
	     (match-string-no-properties 0) cands :test 'equal))
	  cands))
      (when cands
	(list (match-beginning 0) (match-end 0) cands :exclusive 'no)))))

(add-hook 'completion-at-point-functions
	  #'org-completion-symbols
	  'append)
```

这里的改动主要是在 `add-hook 'completion-at-point-functions` 这里，参考了[这篇文章](https://with-emacs.com/posts/tutorials/customize-completion-at-point/).


## Outro {#outro}

在 org-mode 中对这些重复的引用、符号进行补全是我之前就想过的，当时主要是想补全 `org-ref` 的 `cite:`, 不必重复为某一个 `cite:` 去按 `C-]`. 之后可以在这个基础上来扩展补全的类型。
