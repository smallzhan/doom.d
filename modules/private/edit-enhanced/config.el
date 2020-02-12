
(use-package! color-rg
  :commands (color-rg-search-symbol-in-project
             color-rg-search-input-in-project
             color-rg-search-input-in-current-file
             color-rg-search-symbol-in-current-file))


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
