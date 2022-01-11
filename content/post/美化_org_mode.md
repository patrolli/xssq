+++
title = "美化 org-mode"
author = ["Li Xunsong"]
date = 2022-01-04
lastmod = 2022-01-12T00:06:01+08:00
draft = false
+++

<!--more-->


## 将 org list 变成一个圆点 {#将-org-list-变成一个圆点}

效果示意：

{{< figure src="/img/美化_org_mode/2022-01-05_15-47-23_screenshot.png" >}}

```emacs-lisp
(defvar xs-org-list-prettify nil
  "toggle org list prettify")

(defvar gkroam-org-list-re
  "^ *\\([0-9]+[).]\\|[*+-]\\) \\(\\[[ X-]\\] \\)?"
  "Org list bullet and checkbox regexp.")

(defun gkroam--fontify-org-checkbox (notation)
  "Highlight org checkbox with NOTATION."
  (add-text-properties
   (match-beginning 2) (1- (match-end 2)) `(display ,notation)))

(defun gkroam--fontify-org-list ()
  "Highlight org list, including bullet and checkbox."
  (with-silent-modifications
    (add-text-properties
     (match-beginning 1) (match-end 1)
     '(display "∙"))
    (when (match-beginning 2)
      (pcase (match-string-no-properties 2)
	("[-] " (gkroam--fontify-org-checkbox "□"))
	("[ ] " (gkroam--fontify-org-checkbox "□"))
	("[X] " (gkroam--fontify-org-checkbox "🗹"))))))

(defun gkroam-org-list-fontify (beg end)
  "Highlight org list bullet between BEG and END."
  (save-excursion
    (goto-char beg)
    (while (re-search-forward gkroam-org-list-re end t)
      (if (string= (match-string-no-properties 1) "*")
	  (unless (= (match-beginning 0) (match-beginning 1))
	    (gkroam--fontify-org-list))
	(gkroam--fontify-org-list)))))

(defun org-list-prettify ()
  (setq xs-org-list-prettify t)
  (jit-lock-register #'gkroam-org-list-fontify)
  (gkroam-org-list-fontify (point-min) (point-max)))

(defun toggle-org-list-prettify ()
  (interactive)
  (if xs-org-list-prettify
      (progn
	(setq xs-org-list-prettify nil)
	(jit-lock-unregister #'gkroam-org-list-fontify)
	(save-excursion
	  (goto-char (point-min))
	  (while (re-search-forward gkroam-org-list-re nil t)
	    (with-silent-modifications
	      (remove-text-properties (match-beginning 0) (match-end 0)
				      '(display nil))))))
    (org-list-prettify))
  (jit-lock-refontify))

(add-hook 'org-mode-hook #'org-list-prettify)
```


## ovlivetti-mode 居中显示 {#ovlivetti-mode-居中显示}

当 frame 中只有一个 buffer, 并且 buffer 是 org-mode 的时候，就开启 olivetti-mode 居中显示 org-buffer. 而当有多个窗口的时候，退出 olivetti-mode.

```emacs-lisp
(use-package olivetti
  :diminish
  :bind ("<f8>" . olivetti-mode)
  :init (setq olivetti-body-width 0.618)
  :config
  (defun xs-toggle-olivetti-for-org ()
    "if current buffer is org and only one visible buffer
  enable olivetti mode"
    (if (and (eq (length (window-list nil nil nil)) 1)
	     (eq (buffer-local-value 'major-mode (current-buffer)) 'org-mode))
	(olivetti-mode 1)
      (olivetti-mode 0)))
  (add-hook 'org-mode-hook #'xs-toggle-olivetti-for-org)
  (add-hook 'window-configuration-change-hook #'xs-toggle-olivetti-for-org))
```


## 使用 prettify-mode 美化 org-mode 中的一些符号 {#使用-prettify-mode-美化-org-mode-中的一些符号}

效果：

{{< figure src="/img/美化_org_mode/2022-01-05_10-15-47_screenshot.png" >}}

{{< figure src="/img/美化_org_mode/2022-01-05_15-55-11_screenshot.png" >}}

```emacs-lisp
(defcustom lxs-prettify-org-symbols-alist
  '(
    ("#+ARCHIVE:" . ?📦)
    ("#+AUTHOR:" . ?👤)
    ("#+CREATOR:" . ?💁)
    ("#+DATE:" . ?📆)
    ("#+DESCRIPTION:" . ?⸙)
    ("#+EMAIL:" . ?📧)
    ("#+OPTIONS:" . ?⛭)
    ("#+SETUPFILE:" . ?⛮)
    ("#+TAGS:" . ?🏷)
    ("#+TITLE:" . ?📓)
    ("#+BEGIN_SRC" . ?➤)
    ("#+begin_src" . ?➤)
    ("#+END_SRC" . ?➤)
    ("#+end_src" . ?➤)
    ("#+BEGIN_QUOTE" . ?«)
    ("#+END_QUOTE" . ?«)
    ("#+HEADERS" . ?☰)
    ("#+RESULTS:" . ?💻))
  "Alist of symbol prettifications for `org-mode'."
  :group 'lxs
  :type '(alist :key-type string :value-type (choice character sexp)))

(add-hook 'org-mode-hook #'(lambda ()
			       "Beautify org symbols."
			       (setq prettify-symbols-alist lxs-prettify-org-symbols-alist)
			       (unless prettify-symbols-mode
				 (prettify-symbols-mode 1))))
```