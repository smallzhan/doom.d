;;; config.el -*- lexical-binding: t; -*-

(load! "+bindings")
(load! "+ui")

;;======= org-directory ====
 (setq org-directory +my-org-dir
        org-aganda-directory (concat +my-org-dir "agenda/")
        org-agenda-diary-file (concat  org-directory "diary.org")
        org-default-notes-file (concat org-directory "note.org")
        ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
        ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
        org-agenda-files `(,(concat org-aganda-directory "planning.org")
                           ,(concat org-aganda-directory "notes.org")
                           ,(concat org-aganda-directory "work.org")))
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
      (setq projfile (ivy-read "Projs: " (directory-files rootdir nil "\.uvproj$")))

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

;; (when IS-MAC
;;   (setq ns-use-thin-smoothing t
;;         ns-use-fullscreen-animation nil
;;         ns-use-native-fullscreen nil
;;         frame-resize-pixelwise t)
;;   (add-hook 'window-setup-hook #'toggle-frame-maximized)
;;   ;; (run-at-time "5sec" nil

;;   ;;              (lambda ()
;;   ;;                (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
;;   ;;                  ;; If emacs has in fullscreen status, maximized window first, drag from Mac's single space.
;;   ;;                  ;;(when (memq fullscreen '(fullscreen fullboth))
;;   ;;                    (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;;   ;;                  ;; Manipulating a frame without waiting for the fullscreen
;;   ;;                  ;; animation to complete can cause a crash, or other unexpected
;;   ;;                  ;; behavior, on macOS (bug#28496).
;;   ;;                  (when (featurep 'cocoa)
;;   ;;                  ;; Call `toggle-frame-fullscreen' to fullscreen emacs.

;;   ;;                  (toggle-frame-fullscreen)))))

;;   ;; (run-at-time "5sec" nil
;;   ;;              (lambda ()
;;   ;;                (progn
;;   ;;                  (setq ns-use-native-fullscreen nil)
;;   ;;                  (toggle-frame-fullscreen))))
;;   )


;; (after! format-all
;;   (defun format-dos-2-unix (formatter status)
;;     (message "hookkkkkkk")
;;     (when IS-WINDOWS
;;       (save-excursion
;;         (+my/dos2unix))
;;       )
;;     )
;;   (add-hook 'format-all-after-format-functions #'format-dos-2-unix)
;;   )

(after! ivy
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-functions-alist
        '((counsel-irony . ivy-display-function-overlay)
          (ivy-completion-in-region . ivy-display-function-overlay))))

;; (after! ivy-posframe
;;   ;; (dolist (fn '(swiper counsel-ag counsel-grep counsel-git-grep))
;;   ;;   (setf (alist-get fn ivy-display-functions-alist) #'+ivy-display-at-frame-center-near-bottom))

;;   (setq ivy-posframe-display-functions-alist
;;         '((t . +ivy-display-at-frame-center-near-bottom)))
;;   )



;; (after! pdf-tools
;;   (setq pdf-view-use-scaling t)
;;   )




(use-package! snails
  ;;:load-path "~/.doom.d/extensions/snails"
  :init (setq snails-use-exec-path-from-shell nil)
  :commands snails)



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

  (remove-hook 'compilation-filter-hook #'doom-apply-ansi-color-to-compilation-buffer-h))

(after! elisp-mode
  (remove-hook 'emacs-lisp-mode-hook #'+emacs-lisp-extend-imenu-h))


(use-package! pretty-hydra)

(after! elfeed
  (pretty-hydra-define
    elfeed-hydra
    (:title "Elfeed"
     :color amaranth :quit-key "q")
    ("Search"
     (("c" elfeed-db-compact "compact db")
      ("g" elfeed-search-update--force "refresh")
      ("G" elfeed-search-fetch "update")
      ("y" elfeed-search-yank "copy URL")
      ("+" elfeed-search-tag-all "tag all")
      ("-" elfeed-search-untag-all "untag all"))
     "Filter"
     (("s" elfeed-search-live-filter "live filter")
      ("S" elfeed-search-set-filter "set filter")
      ("*" (elfeed-search-set-filter "@6-months-ago +star") "starred")
      ("A" (elfeed-search-set-filter "@6-months-ago" "all"))
      ("T" (elfeed-search-set-filter "@1-day-ago" "today")))
     "Article"
     (("b" elfeed-search-browse-url "browse")
      ("n" next-line "next")
      ("p" previous-line "previous")
      ("u" elfeed-search-tag-all-unread "mark unread")
      ("r" elfeed-search-untag-all-unread "mark read")
      ("RET" elfeed-search-show-entry "show"))))
  (map!
   :map elfeed-search-mode-map
   "?" #'elfeed-hydra/body
   :map elfeed-show-mode-map
   "o" #'ace-link
   "q" #'delete-window))


(put 'customize-face 'disabled nil)


(load custom-file t t t)
