
(use-package! eaf
  :init
  (when IS-MAC
    (setq ns-use-native-fullscreen nil
          ns-use-fullscreen-animation nil))
  :load-path "~/.doom.d/extensions/emacs-application-framework" ; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  :defer t
  :commands (eaf-open eaf-open-browser)
  :custom
  (eaf-browser-continue-where-left-off t)
  :config
  (eaf-setq eaf-browser-enable-adblocker "true")
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding)
  (eaf-bind-key nil "M-q" eaf-browser-keybinding)
  (add-to-list 'eaf-interleave-org-notes-dir-list (concat org-directory "research"))
  )

(use-package! epc :defer t)
(use-package! ctable :defer t)
(use-package! deferred :defer t)


