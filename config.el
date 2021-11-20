;;; config.el -*- lexical-binding: t; -*-

(load! "+bindings")
(load! "+ui")

(when IS-MAC
  (setq frame-resize-pixelwise nil)

  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'initial-frame-alist '(fullscreen . maximized))

  (add-hook 'after-load-theme-hook
            (lambda ()
              (let ((bg (frame-parameter nil 'background-mode)))
                (set-frame-parameter nil 'ns-appearance bg)
                (setcdr (assq 'ns-appearance default-frame-alist) bg)))))

;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'+default--newline-indent-and-continue-comments-a)

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
      (setq projfile (completing-read "Projs: " (directory-files rootdir nil "\.uvprojx?$")))

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


(after! eshell
  (setq eshell-directory-name (expand-file-name "eshell" doom-etc-dir)))

(global-auto-revert-mode 0)


(use-package! company-english-helper
  :commands (toggle-company-english-helper))

(use-package! aweshell
  :commands (aweshell-new aweshell-toggle)
  :init
  (setq aweshell-use-exec-path-from-shell nil))

;; (after! consult
;;   (defvar mcfly-commands
;;     '(consult-line))

;;   (defvar mcfly-back-commands
;;     '(self-insert-command))

;;   (defun mcfly-back-to-present ()
;;     (remove-hook 'pre-command-hook 'mcfly-back-to-present t)
;;     (cond ((and (memq last-command mcfly-commands)
;;                 (equal (this-command-keys-vector) (kbd "M-p")))
;;            ;; repeat one time to get straight to the first history item
;;            (setq unread-command-events
;;                  (append unread-command-events
;;                          (listify-key-sequence (kbd "M-p")))))
;;           ((memq this-command mcfly-back-commands)
;;            (delete-region
;;             (progn (forward-visible-line 0) (point))
;;             (point-max)))))

;;   (defun mcfly-time-travel ()
;;     (when (memq this-command mcfly-commands)
;;       (insert (propertize
;;                (save-excursion
;;                  (set-buffer (window-buffer (minibuffer-selected-window)))
;;                  (or (seq-some (lambda (thing) (thing-at-point thing t))
;;                                '(region url symbol sexp))
;;                      "No thing at point"))
;;                'face 'shadow))
;;       (add-hook 'pre-command-hook 'mcfly-back-to-present nil t)
;;       (forward-visible-line 0)))

;;   ;; setup code
;;   (add-hook 'minibuffer-setup-hook #'mcfly-time-travel)


(after! elisp-mode
  (remove-hook 'emacs-lisp-mode-hook #'+emacs-lisp-extend-imenu-h))


(use-package! pretty-hydra)

(use-package! isearch-mb
  :init (isearch-mb-mode 1)
  :config
  (setq-default
   ;; Match count next to the minibuffer prompt
   isearch-lazy-count t
   ;; Don't be stingy with history; default is to keep just 16 entries
   search-ring-max 200
   regexp-search-ring-max 200
   isearch-regexp-lax-whitespace t
   search-whitespace-regexp ".*?")

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
  (bind-keys
   ("C-s" . isearch-forward-regexp)
   ("C-r" . isearch-backward-regexp)))

(after! eglot
  (setq eglot-ignored-server-capabilities '(:documentHighlightProvider
                                            :hoverProvider))
  (delq! 'eglot flycheck-checkers))
                                        ;(add-hook 'eglot--managed-mode-hook #'eldoc-box-hover-mode t))

;;(add-hook 'prog-mode-hook 'eglot-ensure)
(dolist (hook (list
               'js-mode-hook
               'rust-mode-hook
               'python-mode-hook
               'ruby-mode-hook
               'java-mode-hook
               'sh-mode-hook
               'php-mode-hook
               'c-mode-common-hook
               'c-mode-hook
               'c++-mode-hook
               'haskell-mode-hook))

  (add-hook hook #'eglot-ensure))


(use-package! awesome-tray
  ;; :load-path "~/.doom.d/extensions/awesome-tray"
  :config
  ;;(global-hide-mode-line-mode 1)
  (defvar modeline-backup-format nil)
  (defun enable-awesome-tray-mode()
    (interactive)
    (setq modeline-backup-format mode-line-format
          mode-line-format "")
    (setq awesome-tray-mode-line-active-color (face-attribute 'highlight :background))
    (awesome-tray-mode +1))
  (defun disable-awesome-tray-mode()
    (interactive)
    (setq mode-line-format modeline-backup-format
          modeline-backup-format nil)
    (awesome-tray-mode -1))
                                      
  (add-hook 'doom-load-theme-hook #'enable-awesome-tray-mode)

  (defun awesome-tray-module-datetime-info ()
    (let ((system-time-locale "C"))
      (format-time-string "[%H:%M] %a")))


  (add-to-list 'awesome-tray-module-alist
               '("datetime" . (awesome-tray-module-datetime-info awesome-tray-module-date-face)))
  (add-to-list 'awesome-tray-module-alist
               '("meow" . (meow-indicator awesome-tray-module-evil-face)))



  (setq awesome-tray-active-modules '("meow"
                                      "git"
                                      "location"
                                      "mode-name"
                                      "parent-dir"
                                      "buffer-name"
                                      "buffer-read-only"
                                      "datetime")))

(use-package! with-editor
  :defer t)

(use-package! magit
  :defer t
  :commands magit-status
  :init

  ;; Have magit-status go full screen and quit to previous
  ;; configuration.  Taken from
  ;; http://whattheemacsd.com/setup-magit.el-01.html#comment-748135498
  ;; and http://irreal.org/blog/?p=2253
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defadvice magit-quit-window (after magit-restore-screen activate)
    (jump-to-register :magit-fullscreen))
  :config
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent))
