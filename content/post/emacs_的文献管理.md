+++
title = "emacs 的文献管理"
author = ["Li Xunsong"]
date = 2021-11-29
lastmod = 2021-11-29T16:47:02+08:00
draft = false
+++

## 搜集 bib {#搜集-bib}

在 emacs 中，可以通过 `dblp-lookup` 输入论文标题名来得到 bibtex 信息，然后手动复制粘贴到自己的 .bib 文件中。如果查询不到，就直接从 Google scholar, arxiv 上面复制 bibtex 信息。

可以用 `bu-make-field-keywords` 对 bib 文件的 entry 添加 keyword 字段，给论文打标签，可以提供补全并填入多个，但这个标签是无层级的。


## 显示 {#显示}

`ivy-bibtex` / `helm-bibtex` 可以提取 bib 中每个 entry 的关键信息，得到 bib 中的论文列表，通过 mini-buffer/buffer 显示。这里显示的是整个 bib 文件的论文，提供补全搜索来定位特定论文 (可以搜索的内容包括论文题目，作者，keyword). 这里 `ivy-bibtex` 他们提供的更像是一个搜索界面，而不是用于浏览的界面，因为理想的浏览界面应该是分门别类，带有层级关系的。论文之间的相互关系在 [相互引用，建立连接](#相互引用-建立连接) 这里实现。


## 相互引用，建立连接 {#相互引用-建立连接}

目前的方式是，对不同的 topic (方向), 手动维护一个 `awesome-xx` 的 org 文件，通过 `org-roam` 来建立关联。通常，一篇加进来的论文，应该是包含一些 note 的，要么是简单的几句话，要么是一个单独的 org 文件。在 `org-roam` 的语境下，这些 note 都可以看作是 node, 要么是 headline node, 要么是 file node (对于 headline node, 它就应该是 `awesome-xx` 文件下的一个 headline）。

但无论如何，每篇论文 (也即 bib 文件中的每一个 entry), 都应该只对应一个 org roam node. 可以通过设置 `org-roam` 中的 `ROAM_REFS` 关键字为论文的 cite key, 来保证不会重复创建多个 note, 因为 cite key 是唯一的，只要 cite key 和 note node 对应上，就可以直接打开/跳转到 note node 所在的位置。

当需要在 org mode 的笔记中引用某一篇论文时，一种方式是使用 `org-ref` 来插入 cite key, 另一种方式是插入 org roam 的 node link. 结合这两种方式，在需要插入连接（引用）时，考虑两种情况：一是 node 已经存在，那就直接插入就可以了；二是 论文的 note node 不存在，那么需要在插入的时候提示是否需要创建 roam node (这里应该只能以 file noe 的形式来创建了), 如果不需要，那么就插入 `org-ref` 形式的引用。


## 操作论文 {#操作论文}

`ivy-bibtex` / `helm-bibtex` 除了用于显示、搜索论文外，还可以对搜索结果进行进一步操作。考虑以上的分析，对每个 entry (论文), 我们主要提供的操作应该有：

1.  打开 pdf
2.  创建、打开 note
3.  引用这篇论文。

我使用 `ivy-bibtex` 作为后端，在此基础上定制我们的需求。

**默认操作是打开论文 pdf/URL/DOI** (分优先级), 这个操作 `ivy-bibtex` 已经有了，所以只需要设置存放 pdf 的路径：

`(setq bibtex-completion-library-path '("/mnt/c/Users/lixun/Documents/bibliography/"))`

路径下的 pdf 文件命名应和 bib 文件的 cite key 一致，即 cite-key.pdf

**打开、创建 note**. 使用默认的 `ivy-bibtex-edit-notes`, 它最后实际调用的是 `orb-edit-notes`. 如果不存在，就创建 notes, 但只能以 file node 的形式来创建。后面应该弄成这种方式：node 不存在，提示创建 file node 还是 headline node, 如果是 headline node, 那么提供 `awesome-xx` 的列表，选择一个 aweomse 分类，然后创建一个 headline node 到这个文件下。

这样做可能会有一些烦琐，目前的话，只有在 aweome 文件里面引用这个 file node, 来达到分类的目的。

**引用**. 引用逻辑，打开 `ivy-bibtex`, 选择想要插入引用的论文，优先插入 org-roam note 的连接，如果不存在，那么就插入 cite: 形式的连接。
