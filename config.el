;;; config/private/+ui.el -*- lexical-binding: t; -*-

(load! "+bindings")
(load! "+ui")

;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'doom*newline-indent-and-continue-comments)


(after! projectile
  (setq projectile-require-project-root t))


;; there is a wired bug in company-box, the scroll bar is very huge and cover the candicate list
;; see https://github.com/sebastiencs/company-box/issues/44
;; 
(after! company
  (setq company-tooltip-limit 12)
  )

(after! ws-butler
  (setq ws-butler-global-exempt-modes
        (append ws-butler-global-exempt-modes
                '(prog-mode org-mode))))

(after! tex
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
  (setq-hook! LaTeX-mode TeX-command-default "XeLaTex")

  (setq TeX-save-query nil))

(after! lsp
  (setq lsp-enable-snippet nil))


(after! eshell
  (setq eshell-directory-name (expand-file-name "eshell" doom-etc-dir)))

(global-auto-revert-mode 0)


(def-package! visual-regexp
  :commands (vr/query-replace vr/replace))

(def-package! company-english-helper
  :commands (toggle-company-english-helper))

(after! pyim
  (setq pyim-dicts
        '((:name "greatdict" :file "~/.doom.d/pyim/pyim-greatdict.pyim.gz")))         

  (setq-default pyim-english-input-switch-functions
                '(
                  pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  (setq pyim-page-tooltip 'posframe)

  (setq pyim-page-length 5))

(def-package! yapfify
  :after python
  :defer t
  )

(when IS-MAC
  (setq ns-use-thin-smoothing t)
  (add-hook 'window-setup-hook #'toggle-frame-maximized))



