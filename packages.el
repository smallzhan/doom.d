;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode emacs-snippets latex-preview-pane org-ref)
(package! visual-regexp)
(package! visual-regexp-steroids)
(package! org-edit-latex)

(package! company-english-helper :recipe (:fetcher github :repo "manateelazycat/company-english-helper"))
(package! aweshell :recipe (:fetcher github :repo "manateelazycat/aweshell"))
(package! yapfify :disable t)

(package! company-posframe :disable t)

(package! company-box :recipe (:fetcher github :repo "andersjohansson/company-box" :branch "customize-scrollbar"))

(package! lsp-python-ms)

(package! company-tabnine)


;;(package! snails)
