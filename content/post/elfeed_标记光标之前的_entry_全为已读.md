+++
title = "elfeed 标记光标之前的 entry 全为已读"
author = ["Li Xunsong"]
date = 2021-12-18
lastmod = 2021-12-18T17:36:26+08:00
draft = false
+++

## Intro {#intro}

[elfeed]({{<relref "elfeed.md#" >}}) 只有在 entry 上有 action 的才会标记为已读 (例如按 Enter 打开 entry, 用 b 在浏览器打开 entry 等). 但我很多时候只有扫一眼 entry 标题，不感兴趣的也就不会进一步点开了。这些浏览过标题的 entry 并不会自动的标记为已读，又只有手动给每个 entry 标记，这样就很烦琐。于是写了一个函数，将当前光标之前的所有 entry 都标记为已读，这样就不必每个 entry 都产生一些 action 来使其变成已读。


## 实现 {#实现}

```emacs-lisp
;; 在阅读 elfeed 的时候，将当前光标之前的 entry 都标记为已读
;; 直接选择区域从当前光标到最开始的位置，然后调用 `elfeed-search-selected' 获得
;; 区域中所有的 entry, 然后标记为已读
(defun elfeed-mark-read-before-cursor ()
  (interactive)
  (save-excursion
    ;; select region
    (set-mark (point))
    (goto-char (point-min))
    (let ((entries (elfeed-search-selected))
	  (buffer (current-buffer)))
      (cl-loop for entry in entries
	       do (elfeed-untag entry 'unread)
	       )
      ;; update display buffer
      (with-current-buffer buffer
	(mapc #'elfeed-search-update-entry entries))))
  (forward-line)
  )
```


## elisp tips {#elisp-tips}

上面这段代码，注意如何用代码选择一个区域。