;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode emacs-snippets latex-preview-pane org-ref nose)
(package! visual-regexp)
(package! visual-regexp-steroids)
(package! org-edit-latex)

(package! company-english-helper :recipe (:host github :repo "manateelazycat/company-english-helper"))
(package! aweshell :recipe (:host github :repo "manateelazycat/aweshell"))
(package! yapfify :disable t)

(package! company-posframe)

(package! company-box :recipe (:host github :repo "andersjohansson/company-box" :branch "customize-scrollbar"))

(package! lsp-python-ms)

(package! company-tabnine)

(package! rg)

(package! pdf-tools :recipe (:host github :repo "fuxialexander/pdf-tools" :branch "add-mac-retina"))
;;(package! snails)
