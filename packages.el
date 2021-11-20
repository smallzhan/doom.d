;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode
                   latex-preview-pane nose
                   anaconda-mode company-anaconda
                   company-auctex company-reftex fcitx
                   irony irony-doc flycheck-irony company-irony
                   rtags pyim bibtex-completion
                   ivy-rtags irony-mode irony-eldoc
                   solaire-mode)

(package! company-english-helper
  :recipe (:host github :repo "manateelazycat/company-english-helper")
  :disable t)
(package! aweshell
  :recipe (:host github :repo "manateelazycat/aweshell"))
(package! snails
  :recipe (:host github :repo "manateelazycat/snails" :build (:not compile)) :disable t)


(package! pretty-hydra)

(package! isearch-mb)
(package! awesome-tray :recipe (:host github :repo "manateelazycat/awesome-tray"))

(package! magit)
(package! with-editor)
