;;; config.el -*- lexical-binding: t; -*-

(load! "+bindings")
(load! "+ui")

;;======= org-directory ====
(setq org-directory +my-org-dir
      org-agenda-directory (concat +my-org-dir "agenda/")
      org-agenda-diary-file (concat  org-directory "diary.org")
      org-default-notes-file (concat org-directory "note.org")
      org-roam-directory (file-truename (concat org-directory "roam"))
      ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
      ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
      org-agenda-files `(,(concat org-agenda-directory "planning.org")
                         ,(concat org-agenda-directory "notes.org")
                         ,(concat org-agenda-directory "work.org")))
;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'doom*newline-indent-and-continue-comments)

(after! projectile
  (setq projectile-require-project-root t)
  (when IS-WINDOWS
    (setq projectile-git-submodule-command
          "git submodule --quiet foreach \"echo $sm_path\" | tr '\\n' '\\0'")
    (defun build-keil-project()
      (interactive)
      (setq rootdir (projectile-project-root)
            logfile (concat (projectile-project-root) "build.txt"))
      (if (file-exists-p logfile)
          (delete-file logfile))
      (setq projfile (completing-read "Projs: " (directory-files rootdir nil "\.uvproj$")))

      (make-process
       :name "build"
       :command `("D:\\Keil_v5\\UV4\\UV4.exe"
                  "-cr"
                  ,(concat rootdir projfile)
                  "-j0"
                  "-o"
                  ,logfile)
       :connection-type 'pipe)

      (find-file-other-window logfile)
      (auto-save-mode -1)
      (auto-revert-mode 1)
      (compilation-mode 1)))

  (add-to-list 'projectile-project-root-files-bottom-up ".projectile"))

(after! company
  (setq company-tooltip-limit 12)
  ;; remove doom company mode settings...
  (setq +company-backend-alist nil)

  (after! pyim
    (defun eh-company-dabbrev--prefix (orig-fun)
      "取消中文补全"
      (let ((string (pyim-char-before-to-string 0)))
        (if (pyim-string-match-p "\\cc" string)
            nil
          (funcall orig-fun))))

    (advice-add 'company-dabbrev--prefix
                :around #'eh-company-dabbrev--prefix))

  (defun my-company-yasnippet ()
    "Hide the current completions and show snippets."
    (interactive)
    (company-abort)
    (call-interactively 'company-yasnippet))

  (bind-keys
   :map company-mode-map
   ("<backtab>" . company-yasnippet)
   :map company-active-map
   ("<backtab>" . my-company-yasnippet)))


(after! ws-butler
  (setq ws-butler-global-exempt-modes
        (append ws-butler-global-exempt-modes
                '(prog-mode org-mode))))

(after! color-rg
  ;; solve the issue that color-rg buffer color is messed
  ;; see https://github.com/manateelazycat/color-rg/issues/33
  (remove-hook 'compilation-filter-hook #'doom-apply-ansi-color-to-compilation-buffer-h))

(after! eshell
  (setq eshell-directory-name (expand-file-name "eshell" doom-etc-dir)))

(global-auto-revert-mode 0)

(use-package! visual-regexp
  :commands (vr/query-replace vr/replace))

(use-package! company-english-helper
  :commands (toggle-company-english-helper))

(after! pyim
  ;;(setq pyim-dicts
  ;;      '((:name "greatdict" :file "~/.doom.d/pyim/pyim-bigdict.pyim.gz")))

  (setq-default pyim-english-input-switch-functions
                '(
                  pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;;(pyim-isearch-mode 1)
  (setq pyim-page-tooltip 'posframe)

  (setq pyim-page-length 9)
                                        ;(if IS-MAC
                                        ;    (setq rime-shared-path "/Library/Input Methods/Squirrel.app/Contents/SharedSupport"
                                        ;          rime-user-path "~/Library/Rime/")
                                        ;  (setq rime-shared-path "~/.doom.d/extensions/rime/data"
                                        ;        rime-user-path "~/.rime/"))
  (add-to-list 'load-path "~/.doom.d/extensions/rime")
  (require 'liberime)
  ;;(liberime-start rime-shared-path (file-truename rime-user-path))
  (liberime-select-schema "luna_pinyin_simp")
  (setq pyim-default-scheme 'rime-quanpin)

  ;;; pinyin search for ivy
  (defun eh-ivy-cregexp (str)
    (let ((x (ivy--regex-plus str))
          (case-fold-search nil))
      (if (listp x)
          (mapcar (lambda (y)
                    ((if t) (cdr y)
                     y
                     (list (pyim-cregexp-build (car y))))
                    x))
        (pyim-cregexp-build x))))

  (setq ivy-re-builders-alist
        '((t . eh-ivy-cregexp)))
  )


(use-package! yapfify
  :after python
  :defer t)

(use-package! aweshell
  :commands (aweshell-new aweshell-toggle)
  :init
  (setq aweshell-use-exec-path-from-shell nil))

(use-package! company-posframe
  :after company
  :config
  (company-posframe-mode 1)
  (setq company-posframe-quickhelp-delay nil))

(after! ivy
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-functions-alist
        '((counsel-irony . ivy-display-function-overlay)
          (ivy-completion-in-region . ivy-display-function-overlay)))





  (defvar my-ivy-fly-commands '(query-replace-regexp
                                flush-lines
                                keep-lines
                                ivy-read
                                swiper
                                swiper-backward
                                swiper-all
                                swiper-isearch
                                swiper-isearch-backward
                                counsel-grep-or-swiper
                                counsel-grep-or-swiper-backward
                                counsel-grep
                                counsel-ack
                                counsel-ag
                                counsel-rg
                                counsel-pt))

  (defun my-ivy-fly-back-to-present ()
    (cond ((and (memq last-command my-ivy-fly-commands)
                (equal (this-command-keys-vector) (kbd "M-p")))
           ;; repeat one time to get straight to the first history item
           (setq unread-command-events
                 (append unread-command-events
                         (listify-key-sequence (kbd "M-p")))))
          ((or (memq this-command '(self-insert-command
                                    ivy-forward-char
                                    ivy-delete-char delete-forward-char
                                    end-of-line mwim-end-of-line
                                    mwim-end-of-code-or-line mwim-end-of-line-or-code
                                    yank ivy-yank-word counsel-yank-pop))
               (equal (this-command-keys-vector) (kbd "M-n")))
           (unless my-ivy-fly--travel
             (delete-region (point) (point-max))
             (when (memq this-command '(ivy-forward-char
                                        ivy-delete-char delete-forward-char
                                        end-of-line mwim-end-of-line
                                        mwim-end-of-code-or-line
                                        mwim-end-of-line-or-code))
               (insert (ivy-cleanup-string ivy-text))
               (when (memq this-command '(ivy-delete-char delete-forward-char))
                 (beginning-of-line)))
             (setq my-ivy-fly--travel t)))))

  (defun my-ivy-fly-time-travel ()
    (when (memq this-command my-ivy-fly-commands)
      (let* ((kbd (kbd "M-n"))
             (cmd (key-binding kbd))
             (future (and cmd
                          (with-temp-buffer
                            (when (ignore-errors
                                    (call-interactively cmd) t)
                              (buffer-string))))))
        (when future
          (save-excursion
            (insert (propertize (replace-regexp-in-string
                                 "\\\\_<" ""
                                 (replace-regexp-in-string
                                  "\\\\_>" ""
                                  future))
                                'face 'shadow)))
          (add-hook 'pre-command-hook 'my-ivy-fly-back-to-present nil t)))))

  (add-hook 'minibuffer-setup-hook #'my-ivy-fly-time-travel)
  (add-hook 'minibuffer-exit-hook
            (lambda ()
              (remove-hook 'pre-command-hook 'my-ivy-fly-back-to-present t)))

  ;; Improve search experience of `swiper'
  ;; @see https://emacs-china.org/t/swiper-swiper-isearch/9007/12
  (defun my-swiper-toggle-counsel-rg ()
    "Toggle `counsel-rg' with current swiper input."
    (interactive)
    (let ((text (replace-regexp-in-string
                 "\n" ""
                 (replace-regexp-in-string
                  "\\\\_<" ""
                  (replace-regexp-in-string
                   "\\\\_>" ""
                   (replace-regexp-in-string "^.*Swiper: " ""
                                             (thing-at-point 'line t)))))))
      (ivy-quit-and-run
       (counsel-rg text default-directory))))
  ;;(bind-key "<C-return>" #'my-swiper-toggle-counsel-rg swiper-map)
  )

(use-package! snails
  ;;:load-path "~/.doom.d/extensions/snails"
  :init (setq snails-use-exec-path-from-shell nil)
  :commands snails)


(after! consult
  (defvar mcfly-commands
    '(consult-line))

  (defvar mcfly-back-commands
    '(self-insert-command))

  (defun mcfly-back-to-present ()
    (remove-hook 'pre-command-hook 'mcfly-back-to-present t)
    (cond ((and (memq last-command mcfly-commands)
                (equal (this-command-keys-vector) (kbd "M-p")))
           ;; repeat one time to get straight to the first history item
           (setq unread-command-events
                 (append unread-command-events
                         (listify-key-sequence (kbd "M-p")))))
          ((memq this-command mcfly-back-commands)
           (delete-region
            (progn (forward-visible-line 0) (point))
            (point-max)))))

  (defun mcfly-time-travel ()
    (when (memq this-command mcfly-commands)
      (insert (propertize
               (save-excursion
                 (set-buffer (window-buffer (minibuffer-selected-window)))
                 (or (seq-some (lambda (thing) (thing-at-point thing t))
                               '(region url symbol sexp))
                     "No thing at point"))
               'face 'shadow))
      (add-hook 'pre-command-hook 'mcfly-back-to-present nil t)
      (forward-visible-line 0)))

  ;; setup code
  (add-hook 'minibuffer-setup-hook #'mcfly-time-travel)

  (defun consult-line-symbol-at-point ()
    (interactive)
    (consult-line (thing-at-point 'symbol)))

  (defun my-isearch-or-consult (use-consult)
    (interactive "p")
    (cond ((eq use-consult 1)
           (call-interactively 'isearch-forward))
          ((eq use-consult 4)
           (call-interactively 'consult-line-symbol-at-point))
          ((eq use-consult 16)
           (call-interactively 'consult-line)))))


(use-package! rg
  :defines projectile-command-map
  ;;:hook (after-init . rg-enable-default-bindings)
  :config
  (rg-enable-default-bindings "\C-cr")
  (setq rg-group-result t
        rg-show-columns t)

  (cl-pushnew '("tmpl" . "*.tmpl") rg-custom-type-aliases)

  (with-eval-after-load 'projectile
    (defalias 'projectile-ripgrep 'rg-project)
    (bind-key "s R" #'rg-project projectile-command-map))

  (with-eval-after-load 'counsel
    (bind-keys
     :map rg-global-map
     ("c r" . counsel-rg)
     ("c s" . counsel-ag)
     ("c p" . counsel-pt)
     ("c f" . counsel-fzf)))

  (defun my-swiper-toggle-rg-dwim ()
    "Toggle `rg-dwim' with current swiper input."
    (interactive)
    (ivy-quit-and-run (rg-dwim default-directory)))
  ;;(bind-key "<M-return>" #'my-swiper-toggle-rg-dwim swiper-map)
  ;;(bind-key "<M-return>" #'my-swiper-toggle-rg-dwim ivy-minibuffer-map)
  )

(after! elisp-mode
  (remove-hook 'emacs-lisp-mode-hook #'+emacs-lisp-extend-imenu-h))


(use-package! pretty-hydra)

(use-package! isearch-mb
  :init (isearch-mb-mode 1)
  :config
  (add-to-list 'isearch-mb--with-buffer #'consult-isearch)
  (define-key isearch-mb-minibuffer-map (kbd "M-r") #'consult-isearch)
  (add-to-list 'isearch-mb--after-exit #'consult-line)
  (define-key isearch-mb-minibuffer-map (kbd "M-s") 'consult-line)

  (defun move-end-of-line-maybe-ending-isearch (arg)
    "End search and move to end of line, but only if already at the end of the minibuffer."
    (interactive "p")
    (if (eobp)
        (isearch-mb--after-exit
         (lambda ()
           (move-end-of-line arg)
           (isearch-done)))
      (move-end-of-line arg)))

  (define-key isearch-mb-minibuffer-map (kbd "C-e") 'move-end-of-line-maybe-ending-isearch)
  )

;; (after! elfeed
;;   (pretty-hydra-define
;;     elfeed-hydra
;;     (:title "Elfeed"
;;      :color amaranth :quit-key "q")
;;     ("Search"
;;      (("c" elfeed-db-compact "compact db")
;;       ("g" elfeed-search-update--force "refresh")
;;       ("G" elfeed-search-fetch "update")
;;       ("y" elfeed-search-yank "copy URL")
;;       ("+" elfeed-search-tag-all "tag all")
;;       ("-" elfeed-search-untag-all "untag all"))
;;      "Filter"
;;      (("s" elfeed-search-live-filter "live filter")
;;       ("S" elfeed-search-set-filter "set filter")
;;       ("*" (elfeed-search-set-filter "@6-months-ago +star") "starred")
;;       ("A" (elfeed-search-set-filter "@6-months-ago" "all"))
;;       ("T" (elfeed-search-set-filter "@1-day-ago" "today")))
;;      "Article"
;;      (("b" elfeed-search-browse-url "browse")
;;       ("n" next-line "next")
;;       ("p" previous-line "previous")
;;       ("u" elfeed-search-tag-all-unread "mark unread")
;;       ("r" elfeed-search-untag-all-unread "mark read")
;;       ("RET" elfeed-search-show-entry "show"))))
;;   (map!
;;    :map elfeed-search-mode-map
;;    "?" #'elfeed-hydra/body
;;    :map elfeed-show-mode-map
;;    "o" #'ace-link
;;    "q" #'delete-window))


(put 'customize-face 'disabled nil)


(load custom-file t t t)
