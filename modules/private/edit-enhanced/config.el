
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
  :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :init
  (after! pdf-annot
    (defun +pdf-cleanup-windows-h ()
      "Kill left-over annotation buffers when the document is killed."
      (when (buffer-live-p pdf-annot-list-document-buffer)
        (pdf-info-close pdf-annot-list-document-buffer))
      (when (buffer-live-p pdf-annot-list-buffer)
        (kill-buffer pdf-annot-list-buffer))
      (let ((contents-buffer (get-buffer "*Contents*")))
        (when (and contents-buffer (buffer-live-p contents-buffer))
          (kill-buffer contents-buffer))))
    (add-hook! 'pdf-view-mode-hook
      (add-hook 'kill-buffer-hook #'+pdf-cleanup-windows-h nil t)))

  :config
  (map! :map pdf-view-mode-map
        :gn "q" #'kill-current-buffer
        :gn "C-s" #'isearch-forward)

  (setq-default pdf-view-display-size 'fit-page
                pdf-view-use-scaling t
                pdf-view-use-imagemagick nil)

  ;; Turn off cua so copy works
  (add-hook! 'pdf-view-mode-hook (cua-mode 0))

  ;; Handle PDF-tools related popups better
  (set-popup-rules!
    '(("^\\*Outline*" :side right :size 40 :select nil)
      ("\\(?:^\\*Contents\\|'s annots\\*$\\)" :ignore t)))

  ;; The mode-line does serve any useful purpose is annotation windows
  (add-hook 'pdf-annot-list-mode-hook #'hide-mode-line-mode)

  ;; Sets up `pdf-tools-enable-minor-modes', `pdf-occur-global-minor-mode' and
  ;; `pdf-virtual-global-minor-mode'.
  (pdf-tools-install-noverify)
  )

(use-package! flywrap
  :hook
  ('text-mode . #'flywrap-mode))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :hook (nov-mode . my-nov-setup)
  :init
  (defun my-nov-setup ()
    "Setup `nov-mode' for better reading experience."
    (visual-line-mode 1)
    ;;(centaur-read-mode)
    (face-remap-add-relative 'variable-pitch :family "Times New Roman" :height 1.5))
  :config
  (with-no-warnings
    ;; FIXME: errors while opening `nov' files with Unicode characters
    ;; @see https://github.com/wasamasa/nov.el/issues/63
    (defun my-nov-content-unique-identifier (content)
      "Return the the unique identifier for CONTENT."
      (let* ((name (nov-content-unique-identifier-name content))
             (selector (format "package>metadata>identifier[id='%s']"
                               (regexp-quote name)))
             (id (car (esxml-node-children (esxml-query selector content)))))
        (and id (intern id))))
    (advice-add #'nov-content-unique-identifier :override #'my-nov-content-unique-identifier))

  ;; Fix encoding issue on Windows
  (when IS-WINDOWS
    (setq process-coding-system-alist
          (cons `(,nov-unzip-program . (gbk . gbk))
                process-coding-system-alist))))
