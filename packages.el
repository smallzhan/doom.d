;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode latex-preview-pane org-ref nose anaconda-mode)

(package! company-english-helper
  :recipe (:host github :repo "manateelazycat/company-english-helper")
  :disable t)
(package! aweshell
  :recipe (:host github :repo "manateelazycat/aweshell"))
(package! snails
  :recipe (:host github :repo "manateelazycat/snails" :no-byte-compile t))
(package! yapfify
  :disable t)

(package! company-posframe)

(package! company-box
  :recipe (:host github :repo "andersjohansson/company-box" :branch "customize-scrollbar")
  :disable t)

(package! lsp-python-ms)

(package! company-tabnine )

(package! rg)
;;(package! pdf-tools :recipe (:host github :repo "fuxialexander/pdf-tools" :branch "add-mac-retina"))
;;(package! pdf-tools)
(package! ggtags :disable t)


