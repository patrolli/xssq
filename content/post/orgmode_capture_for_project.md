+++
title = "orgmode capture for project"
author = ["Li Xunsong"]
date = 2021-04-27
lastmod = 2021-04-27T22:37:24+08:00
draft = false
+++

## Intro {#intro}

为每一个 project 设置一个 org file, 将这个 project 相关的内容，如 idea, 日志，笔记等都放在一起。为了层次化这个 project org file, 我想使用 org-capture 来将每次要添加的内容，如日志或者 idea 添加进这个 org 文件中。在 capture 的时候可以仿照 datetree 的形式，为每个记录添加一个时间戳，方便回顾，例如
![](/img/capture_2021_04_27_22_05_35.png)
如果存在多个项目，那么就会对应多个 org 文件，一般的 capture 模板都只能针对一个 org file 生效，那么这里我们需要在 capture 的时候，能够对应到多个文件，首先是弹出一个提示框，用于选择项目，然后打开对应的 org 文件，将内容添加到指定位置。在我这里是有两个一级标题，对应 Idea 和 Journal, 每次 capture 都会找到他们下面的 datetree, 然后再添加内容。为了实现在 capture 的时候能够对应到多个文件，就需要自己定义函数来确定 capture 时增添内容的位置。参考 org-capture 的源码，我写了一个函数：

```emacs-lisp
(defun lxs/org-find-project-journal-datetree ()
  ;; (interactive)
  (let* ((project (completing-read "Choose a project" '("compaction")))
	(m (org-find-olp (cons (org-capture-expand-file (concat lxs-home-dir "Documents/" "org/" "org-roam-files/" project ".org")) '("Journal")))))
    (set-buffer (marker-buffer m))
   ;; (org-capture-put-target-region-and-position)
   (widen)
   (goto-char m)
   (set-marker m nil)
   ;; (org-capture-put-target-region-and-position)
   (org-datetree-find-date-create (calendar-gregorian-from-absolute (org-today)) (when '("test") 'subtree-at-point))
   )
  )
(add-to-list 'org-capture-templates `("l" "lxs test" entry (function lxs/org-find-project-journal-datetree) "* %U - %^{heading}\n  %?"))
```

这里的目标文件是根据选择的 project name 来确定的，虽然在这里是硬编码实现，但至少可以对应多个文件，并在 capture 的时候选择一个相应的 project name, 然后将内容 capture 到这个 project name 对应的 org file 中。


## Outro {#outro}

这个功能还有许多可以改进的地方，例如在获取所有 project files 的时候，可以不用现在这样硬编码的方式，而是检索 org-roam-file 中所有标签带有 project 的文件，作为候选，这样就会更加灵活。索引 org-roam 中一个 tag 所对应的 files 需要用到 org-roam-db-query, 这方面没有看到什么参考，怎么去写 org-roam database 的 sql 语句，不过在网上搜到一个可以用的 gist:

```emacs-lisp
(setq lxs/org-roam (org-roam-db-query
		[:select file
		 :from tags
		 :where (like tags (quote "%\"Project\"%"))]))
```

这段代码会返回 tag 带有 Project 的所有 org-roam files, 借助它，可以得到所有 project file 的列表，作为 capture 时目标文件的候选。
