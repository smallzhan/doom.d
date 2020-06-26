;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode
                   latex-preview-pane org-ref nose
                   anaconda-mode company-anaconda
                   company-auctex company-reftex fcitx
                   irony irony-doc flycheck-irony company-irony
                   rtags pyim bibtex-completion)

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

(package! pyim :recipe (:host github :repo "tumashu/pyim") :disable t)

;;(package! lsp-python-ms)

;;(package! company-tabnine )

(package! rg)
;;(package! pdf-tools :recipe (:host github :repo "smallzhan/pdf-tools" :branch "retina-view"))
;;(package! pdf-tools)
(package! ggtags :disable t)


(package! pretty-hydra)

;(package! alert :recipe (:no-byte-compile t))
;(package! org-pomodoro :recipe (:no-byte-compile t))
;(package! auctex :recipe (:no-byte-compile t))
