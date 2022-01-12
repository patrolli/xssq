+++
title = "emacs hack helpful-mode"
author = ["Li Xunsong"]
date = 2021-12-30
lastmod = 2022-01-12T22:44:56+08:00
draft = false
+++

## 复用 helpful buffer 的 window {#复用-helpful-buffer-的-window}

当调用 helpful 连续查找多个函数/变量的时候，复用当前用于显示 helpful buffer 的窗口，这样不至于在多次调用后多增加很多窗口。

```emacs-lisp
(setq helpful-switch-buffer-function
	(lambda (buf) (if-let ((window (display-buffer-reuse-mode-window buf '((mode . helpful-mode)))))
			  ;; ensure the helpful window is selected for `helpful-update'.
			  (select-window window)
			;; line above returns nil if no available window is found
			(pop-to-buffer buf))))
```


## 快速弹出 helpful buffer {#快速弹出-helpful-buffer}

用 shakle 规定 helpful buffer 只显示在底端，然后按键 &lt;f3&gt; 就可以将已有的 helpful buffer 弹出在底端显示，再次按下便关闭窗口。这里主要涉及到窗口、buffer 相关的操作，如判断 buffer 是否可见，显示 buffer 等。

```emacs-lisp
(defun helpful--get-window()
  "Get the helpful window which is visible (active or inactive)."
  (cl-find-if #'(lambda(w)
		  (provided-mode-derived-p
		   (buffer-local-value 'major-mode (window-buffer w))
		   'helpful-mode))
	      (window-list)))

;; toggle helpful 的 buffer
(defun lxs-helpful-toggle ()
  (interactive)
  (let ((helpful-bufs (--filter (with-current-buffer it
				  (eq major-mode 'helpful-mode))
				(buffer-list)))
	(window (helpful--get-window)))
    (if window
	(delete-window window)
      (display-buffer (nth 0 helpful-bufs)))))

(global-set-key (kbd "<f3>") #'lxs-helpful-toggle)
```


## 循环显示查询历史 {#循环显示查询历史}

在当前浏览的 helpful buffer, 可以跳到之前的查找记录。维护当前的 helpful buffer list, 并需要清除掉 dead buffer. 然后获取当前 helpful buffer 在 list 中的索引，根据 offset 计算下一个显示的 buffer, 同时对溢出的索引进行处理。

```emacs-lisp
(defvar lxs-helpful-cur-bufs nil
  "记录当前有哪些 helpful buffers")

(defun lxs-helpful-cycle-buffer (buffer &optional offset)
  (interactive)
  (require 'dash)
  (let* ((buffers (buffer-list))
	 (helpful-bufs (--filter (with-current-buffer it
				   (eq major-mode 'helpful-mode))
				 buffers)))
    (dolist (buf helpful-bufs)
      (unless (member buf lxs-helpful-cur-bufs)
	(push buf lxs-helpful-cur-bufs)))
    ;; clean killed buffers
    (setq lxs-helpful-cur-bufs (--filter (buffer-live-p it) lxs-helpful-cur-bufs))
    (let ((idx (+ (or offset 0) (-elem-index buffer lxs-helpful-cur-bufs))))
      (cond ((< idx 0) (switch-to-buffer (nth (- (length lxs-helpful-cur-bufs) 1) lxs-helpful-cur-bufs)))
	    ((> (+ idx 1) (length lxs-helpful-cur-bufs))
	     (switch-to-buffer (nth 0 lxs-helpful-cur-bufs)))
	    (t (switch-to-buffer (nth idx lxs-helpful-cur-bufs)))))))

(defun lxs-helpful-prev ()
  (interactive)
  (lxs-helpful-cycle-buffer (current-buffer) -1))

(defun lxs-helpful-next ()
  (interactive)
  (lxs-helpful-cycle-buffer (current-buffer) 1))
```


## 插入前进、后退按钮 {#插入前进-后退按钮}

借助我们的 `lxs-helpful-next`, `lxs-helpful-prev`, 也可以在 helpful buffer 的顶端插入前进后退的按钮，便于鼠标操作：

{{< figure src="/img/emacs_hack_helpful_mode/2022-01-12_22-43-51_screenshot.png" >}}

```emacs-lisp
(defun moon-helpful@helpful-update (oldfunc)
  "Insert back/forward buttons."
  (funcall oldfunc)
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (insert-text-button "Back"
			'action (lambda (&rest _)
				  (interactive)
				  (lxs-helpful-prev)))
    (insert " / ")
    (insert-text-button "Forward"
			'action (lambda (&rest _)
				  (interactive)
				  (lxs-helpful-next)))
    (insert "\n\n")))

(advice-add #'helpful-update :around #'moon-helpful@helpful-update)
```