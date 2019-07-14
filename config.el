;;; config/private/+ui.el -*- lexical-binding: t; -*-

(load! "+bindings")
(load! "+ui")

;; remove doom advice, I don't need deal with comments when newline
(advice-remove #'newline-and-indent #'doom*newline-indent-and-continue-comments)

(after! projectile
  (setq projectile-require-project-root t))

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
    ))

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
  (remove-hook 'compilation-filter-hook #'doom|apply-ansi-color-to-compilation-buffer))

(after! eshell
  (setq eshell-directory-name (expand-file-name "eshell" doom-etc-dir)))

(global-auto-revert-mode 0)

(def-package! visual-regexp
  :commands (vr/query-replace vr/replace))

(def-package! company-english-helper
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

  (setq pyim-page-length 5))

(def-package! yapfify
  :after python
  :defer t
  )

(def-package! aweshell)

(def-package! company-posframe
  :after company
  :config (company-posframe-mode 1)
  )

(when IS-MAC
  (setq ns-use-thin-smoothing t
        ns-use-fullscreen-animation nil
        ns-use-native-fullscreen nil
        frame-resize-pixelwise t)
  (add-hook 'window-setup-hook #'toggle-frame-maximized)
  ;; (run-at-time "5sec" nil

  ;;              (lambda ()
  ;;                (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
  ;;                  ;; If emacs has in fullscreen status, maximized window first, drag from Mac's single space.
  ;;                  ;;(when (memq fullscreen '(fullscreen fullboth))
  ;;                    (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  ;;                  ;; Manipulating a frame without waiting for the fullscreen
  ;;                  ;; animation to complete can cause a crash, or other unexpected
  ;;                  ;; behavior, on macOS (bug#28496).
  ;;                  (when (featurep 'cocoa)
  ;;                  ;; Call `toggle-frame-fullscreen' to fullscreen emacs.

  ;;                  (toggle-frame-fullscreen)))))

  ;; (run-at-time "5sec" nil
  ;;              (lambda ()
  ;;                (progn
  ;;                  (setq ns-use-native-fullscreen nil)
  ;;                  (toggle-frame-fullscreen))))
  )


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

(after! ivy-posframe
   ;; (dolist (fn '(swiper counsel-ag counsel-grep counsel-git-grep))
   ;;   (setf (alist-get fn ivy-display-functions-alist) #'+ivy-display-at-frame-center-near-bottom))

  (setq ivy-posframe-display-functions-alist
        '((t . +ivy-display-at-frame-center-near-bottom)))
  )


(def-package! lsp-python-ms
  :demand nil
  :config
  ;;(remhash 'pyls lsp-clients)
  (setq lsp-python-executable-cmd "python3")
  (defun find-vscode-mspyls-executable ()
    (let* ((wildcards ".vscode/extensions/ms-python.python-*/languageServer*/Microsoft.Python.LanguageServer")
           (dir-and-ext (if IS-WINDOWS
                            (cons (getenv "USERPROFILE") ".exe")
                          (cons (getenv "HOME") nil)))
           (cmd (concat (file-name-as-directory (car dir-and-ext))
                        wildcards (cdr dir-and-ext))))
      (file-expand-wildcards cmd t)))

  (setq lsp-python-ms-executable
        (car (find-vscode-mspyls-executable)))
  (setq lsp-python-ms-dir
        (file-name-directory lsp-python-ms-executable)))

(after! python
  (setq python-shell-interpreter "python3"))

(after! smartparens
  (add-hook 'prog-mode-hook #'turn-on-smartparens-strict-mode))

(after! pdf-tools
  (setq pdf-view-use-scaling t))
