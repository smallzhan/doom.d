;;; config/private/+ui.el -*- lexical-binding: t; -*-

(load! "+bindings")
(load! "+ui")

;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'doom*newline-indent-and-continue-comments)

(after! projectile
  (setq projectile-require-project-root t)
  (if IS-WINDOWS
      (setq projectile-git-submodule-command
            "git submodule --quiet foreach \"echo $sm_path\" | tr '\\n' '\\0'"))
  (add-to-list 'projectile-project-root-files-bottom-up ".projectile"))

(after! company
  (setq company-tooltip-limit 12)
  (after! pyim
    (defun eh-company-dabbrev--prefix (orig-fun)
      "取消中文补全"
      (let ((string (pyim-char-before-to-string 0)))
        (if (pyim-string-match-p "\\cc" string)
            nil
          (funcall orig-fun))))

    (advice-add 'company-dabbrev--prefix
                :around #'eh-company-dabbrev--prefix)
    (setq company-lsp-cache-candidates 'auto)
    )
  )

;; there is a wired bug in company-box, the scroll bar is very huge and cover the candicate list
;; see https://github.com/sebastiencs/company-box/issues/44 , it is not resolved, now i hack the
;; company-box.el and remove the scrollbar display
(after! company-box
  ;; Support `company-common' in company-box
  ;; stolen from centaur emacs config
  (setq company-box-scrollbar nil)

  ;;   (defun my-company-box--make-line (candidate)
  ;;     (-let* (((candidate annotation len-c len-a backend) candidate)
  ;;             (color (company-box--get-color backend))
  ;;             ((c-color a-color i-color s-color) (company-box--resolve-colors color))
  ;;             (icon-string (and company-box--with-icons-p (company-box--add-icon candidate)))
  ;;             (candidate-string (concat (propertize company-common 'face 'company-tooltip-common)
  ;;                                       (substring (propertize candidate 'face 'company-box-candidate) (length company-common) nil)))
  ;;             (align-string (when annotation
  ;;                             (concat " " (and company-tooltip-align-annotations
  ;;                                              (propertize " " 'display `(space :align-to (- right-fringe ,(or len-a 0) 1)))))))
  ;;             (space company-box--space)
  ;;             (icon-p company-box-enable-icon)
  ;;             (annotation-string (and annotation (propertize annotation 'face 'company-box-annotation)))
  ;;             (line (concat (unless (or (and (= space 2) icon-p) (= space 0))
  ;;                             (propertize " " 'display `(space :width ,(if (or (= space 1) (not icon-p)) 1 0.75))))
  ;;                           (company-box--apply-color icon-string i-color)
  ;;                           (company-box--apply-color candidate-string c-color)
  ;;                           align-string
  ;;                           (company-box--apply-color annotation-string a-color)))
  ;;             (len (length line)))
  ;;       (add-text-properties 0 len (list 'company-box--len (+ len-c len-a)
  ;;                                        'company-box--color s-color)
  ;;                            line)
  ;;       line))
  ;;   (advice-add #'company-box--make-line :override #'my-company-box--make-line)
  )

(after! ws-butler
  (setq ws-butler-global-exempt-modes
        (append ws-butler-global-exempt-modes
                '(prog-mode org-mode))))

;; (after! tex
;;   (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
;;   (setq-hook! LaTeX-mode TeX-command-default "XeLaTex")

;;   (setq TeX-save-query nil))

;; (after! lsp
;;   (setq lsp-enable-snippet nil))

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
  (setq pyim-dicts
        '((:name "greatdict" :file "~/.doom.d/pyim/pyim-bigdict.pyim.gz")))

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

  (setq pyim-page-length 9)
  (when IS-MAC
    (add-to-list 'load-path "~/.doom.d/extensions")
    (require 'liberime)
    (liberime-start "/Library/Input Methods/Squirrel.app/Contents/SharedSupport" (file-truename "~/.emacs.d/.local/pyim/rime/"))
    (liberime-select-schema "luna_pinyin_simp")
    (setq pyim-default-scheme 'rime-quanpin)))


(use-package! yapfify
  :after python
  :defer t
  )

(use-package! aweshell
  :commands (aweshell-new aweshell-toggle)
  :init
  (setq aweshell-use-exec-path-from-shell nil))

(use-package! company-posframe
  :after company
  :config (company-posframe-mode 1)
  )

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
          (ivy-completion-in-region . ivy-display-function-overlay)))
  )

;; (after! ivy-posframe
;;   ;; (dolist (fn '(swiper counsel-ag counsel-grep counsel-git-grep))
;;   ;;   (setf (alist-get fn ivy-display-functions-alist) #'+ivy-display-at-frame-center-near-bottom))

;;   (setq ivy-posframe-display-functions-alist
;;         '((t . +ivy-display-at-frame-center-near-bottom)))
;;   )


(use-package! lsp-python-ms
  :defer t
  :defines (flycheck-disabled-checkers flycheck-checker)
  :init
  (when (executable-find "python3")
    (setq lsp-python-ms-python-executable-cmd "python3")  )
  :config
  (defun find-vscode-mspyls-executable ()
    (let* ((wildcards ".vscode/extensions/ms-python.python-*/languageServer*/Microsoft.Python.LanguageServer")
           (dir-and-ext (if IS-WINDOWS
                            (cons (getenv "USERPROFILE") ".exe")
                          (cons (getenv "HOME") nil)))
           (cmd (concat (file-name-as-directory (car dir-and-ext))
                        wildcards (cdr dir-and-ext)))
           ;; need to copy a fallback path.
           (fallback (concat "~/.doom.d/mspyls/Microsoft.Python.LanguageServer" (cdr dir-and-ext)))
           (exe (file-expand-wildcards cmd t)))
      (if exe
          exe
        (file-expand-wildcards fallback t))))

  (setq lsp-python-ms-executable
        (car (find-vscode-mspyls-executable)))
  (if lsp-python-ms-executable
      (setq lsp-python-ms-dir
            (file-name-directory lsp-python-ms-executable)))
  ;;(setq lsp-python-ms-dir "~/.doom.d/mspyls/")
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (setq-local flycheck-disabled-checkers '(lsp-ui))
                         (setq-local flycheck-checker 'python-flake8)))
  )

(after! python
  (setq python-shell-interpreter "python3"))

(after! smartparens
  (add-hook 'prog-mode-hook #'turn-on-smartparens-strict-mode))

;; (after! pdf-tools
;;   (setq pdf-view-use-scaling t)
;;   )


(use-package! company-tabnine
  :after company
  :config
  (add-to-list 'company-backends #'company-tabnine)
  )

(use-package! snails
  :load-path "~/.doom.d/extensions/snails"
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
  ;; (remove-hook 'pre-command-hook 'my-ivy-fly-back-to-present t)
  (cond ((and (memq last-command my-ivy-fly-commands)
              (equal (this-command-keys-vector) (kbd "M-p")))
         ;; repeat one time to get straight to the first history item
         (setq unread-command-events
               (append unread-command-events
                       (listify-key-sequence (kbd "M-p")))))
        ((or (memq this-command '(self-insert-command
                                  yank
                                  ivy-yank-word
                                  counsel-yank-pop))
             (equal (this-command-keys-vector) (kbd "M-n")))
         (delete-region (point)
                        (point-max)))))

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

  (remove-hook 'compilation-filter-hook #'doom-apply-ansi-color-to-compilation-buffer-h)
  )

(after! elisp-mode
  (remove-hook 'emacs-lisp-mode-hook #'+emacs-lisp-extend-imenu-h))
