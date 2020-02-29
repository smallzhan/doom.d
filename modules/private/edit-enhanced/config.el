
(use-package! color-rg
  :commands (color-rg-search-symbol-in-project
             color-rg-search-input-in-project
             color-rg-search-input-in-current-file
             color-rg-search-symbol-in-current-file)
  :config
  (setq color-rg-kill-temp-buffer-p nil))


                                        ;(use-package! aweshell
                                        ;  :init (setq aweshell-use-exec-path-from-shell nil))


(use-package! auto-save
  :init
  (setq auto-save-silent t)
  :config
  (auto-save-enable))

(use-package! lazy-search
  :commands lazy-search)


(use-package! thing-edit)

(use-package! awesome-pair
  :bind (:map awesome-pair-mode-map
          ("(" . awesome-pair-open-round)
          ("[" . awesome-pair-open-bracket)
          ("{" . awesome-pair-open-curly)
          (")" . awesome-pair-close-round)
          ("]" . awesome-pair-close-bracket)
          ("}" . awesome-pair-close-curly)
          ("=" . awesome-pair-equal)

          ("%" . awesome-pair-match-paren)
          ("\"" . awesome-pair-double-quote)
          ("SPC" . awesome-pair-space)

          ("M-o" . awesome-pair-backward-delete)
          ("C-d" . awesome-pair-forward-delete)
          ("C-k" . awesome-pair-kill)

          ("M-\"" . awesome-pair-wrap-double-quote)
          ("M-[" . awesome-pair-wrap-bracket)
          ("M-{" . awesome-pair-wrap-curly)
          ("M-(" . awesome-pair-wrap-round)
          ("M-)" . awesome-pair-unwrap)
          ("M-p" . awesome-pair-jump-right)
          ("M-n" . awesome-pair-jump-left)
          ("M-:" . awesome-pair-jump-out-pair-and-newline)
          )
  :hook ((prog-mode ielm-mode minibuffer-inactive-mode sh-mode) . awesome-pair-mode))

(use-package counsel-etags
  ;;:ensure t
  :bind (("M-]" . counsel-etags-find-tag-at-point))
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (push "build" counsel-etags-ignore-directories))

(load! "+latex")

(use-package! pdf-tools
  ;;:load-path "~/.doom.d/extensions/pdf-tools/lisp"
  :diminish (pdf-view-midnight-minor-mode pdf-view-printer-minor-mode)
  :defines pdf-annot-activate-created-annotations
  :functions (my-pdf-view-set-midnight-colors my-pdf-view-set-dark-theme)
  :commands pdf-view-midnight-minor-mode
  :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :init (setq pdf-annot-activate-created-annotations t)
  :config
  (map! :map pdf-view-mode-map
        "C-s" #'isearch-forward
        "q" #'kill-current-buffer)
  (when IS-MAC
    (setenv "PKG_CONFIG_PATH"
            "/usr/local/lib/pkgconfig:/usr/local/opt/libffi/lib/pkgconfig"))
  (pdf-tools-install t nil t nil)

  ;; Set dark theme
  (defun my-pdf-view-set-midnight-colors ()
    "Set pdf-view midnight colors."
    (setq pdf-view-midnight-colors
          `(,(face-foreground 'default) . ,(face-background 'default))))

  (defun my-pdf-view-set-dark-theme ()
    "Set pdf-view midnight theme as color theme."
    (my-pdf-view-set-midnight-colors)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (eq major-mode 'pdf-view-mode)
          (pdf-view-midnight-minor-mode (if pdf-view-midnight-minor-mode 1 -1))))))

  (my-pdf-view-set-midnight-colors)
  (add-hook 'after-load-theme-hook #'my-pdf-view-set-dark-theme)

  (setq-default pdf-view-display-size 'fit-page
                pdf-view-use-scaling t
                pdf-view-use-imagemagick nil)
  (set-popup-rules!
    '(("^\\*Outline*" :side right :size 40 :select nil)
      ("\\(?:^\\*Contents\\|'s annots\\*$\\)" :ignore t)))
  ;; Recover last viewed position
  ;; (when emacs/>=26p
  ;;   (use-package pdf-view-restore
  ;;     :hook (pdf-view-mode . pdf-view-restore-mode)
  ;;     :init (setq pdf-view-restore-filename
  ;;                 (locate-user-emacs-file ".pdf-view-restore"))))
  )
