+++
title = "org 整理 paper_index"
author = ["Li Xunsong"]
lastmod = 2021-04-20T00:21:19+08:00
tags = ["emacs", "orgmode", "elisp"]
draft = false
+++

## Intro {#intro}

花了一些时间用 elisp 写了一个函数，将 [paper-index]({{< relref "paper_index" >}}) 中维护的论文索引按照他们的 tag 来进行分组。之前我是对每篇论文用一个一级 headline 进行维护，然后插入对应的 tag, 但这样做有一些弊端，首先是一篇论文可能会有多个 tag, 一一加上后整行就会显得很长，窗口小了的话就会折行，看着就不舒服了；二是不方便检索，如果知道论文题目，可以直接搜索，但有时候会忘记论文的题目，需要浏览来查找，虽然可以通过 tag 来过滤 (`org-tags-views`), 但每次都需要输入命令，而且会将 filter 的结果放在一个新的 buffer 中，也不太方便。所以我想对此进行一些改进，目标是能够将每个论文的 headline （或者在这里说索引）按照其 tag 复制到对应的以 tag 命名的一级标题下（论文的索引就变成二级标题）。在一开始添加论文的时候，可以先放在一个 `Un-archieve` 的标题下，然后执行命令去根据它的 tag 来移动到对应的分组下，同时删去他在 `Un-archieve` 的索引。另外，之后也昆虫为某个论文索引再添加 tag, 然后再次执行命令，又可以将这个索引复制到对应的 tag headline 下。如果在 `Un-archieve` 中的论文索引的 tag 已经被复制到 tag 的 headline 下，那么这个 tag 就被移除，如果 `Un-archieve` 中的论文索引没有 tag, 那么执行命令就会删除掉这个索引（只在 `Un-archieve` 下面有效）。代码如下：

```emacs-lisp
(defun lxs/org-refile-headline-by-tag ()
  (interactive)
  (save-excursion
  (let ((tags (org-get-tags nil t))
	(headline  (nth 4 (org-heading-components)))
	remove-flag)
    ;; if the headline has no tag and being under "Un-archieve"
    (when (and (eq 0 (length tags))  (progn
				       (save-excursion
				       (outline-up-heading 1)
				       (string-equal "Un-archieve" (nth 4 (org-heading-components))))))
      (org-cut-subtree))
    ;; process each tag
    (while tags
	(let* ((tag (nth 0 tags))
	      (remove-flag nil))
	  (save-excursion
	    ;; if exist the level-1 headline of this tag
	    ;;;; narrow region to search the title under this tag headline
	    ;;;;;; if title exist
	    ;;;;;;;; prepare for remove the tag of current entry (set remove-flag)
	    ;;;;;; else
	    ;;;;;;;; insert this title under the tag headline
	    ;; else
	    ;;;; insert this new tag headline
	    ;;;; insert title under this new headline
	    ;; if remove-tag
	    ;;;; remove tag for current entry
	  (if (org-ql-select (buffer-name)
		`(and (level 1) (heading ,tag)))
	      (progn
		(let ((start (re-search-forward (concat "^* " tag "\n") nil t))
		      (end (re-search-forward "^* .*\n" nil t)))
		  (save-restriction
		    (setq start (if start start 1))
		    (setq end (if end end (point-max)))
		    (narrow-to-region start end)
		    (goto-char (point-min))
		    (if (re-search-forward (format "^** %s" (regexp-quote headline)) nil t) ;; no such titles under this tag headline
			;; remove the tag of current entry headline
			(progn
			  (setq remove-flag t)
			  )
		      (progn
			(goto-char (point-max))
			(forward-line -1)
			(insert (format "** %s\n" headline)))
		      )
		    )
		  ))
	    (progn
	      (end-of-buffer)
	      (forward-line)
	      (insert (format "* %s\n" tag))
	      (forward-line 2)
	      (insert (format "** %s\n" headline))
	      )
	    )
	  )
	  (if remove-flag
	      (org-toggle-tag tag 'off))
	)
	(setq tags (cdr tags))
	)
    )))
```


## Outro {#outro}

为了写这个函数花费了许多功夫，主要还是自己对 elisp 不太熟悉，以及 org-mode 的 api, 在网上用关键词查找自己想要的功能，很难找到有效的答案，后面发现 org mode 的源码里面每个函数的实现其实就很具有参考价值，之后可以多看源码来熟悉对 org mode 的 hack. 另外，在搜索和处理文本时，正则表达式也是威力巨大的武器，我也还不太会用，还需要花一些功夫去深入地学习。
