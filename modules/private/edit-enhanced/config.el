;; -*- lexical-binding: t; -*-

(use-package! color-rg
  :commands (color-rg-search-symbol-in-project
             color-rg-search-input-in-project
             color-rg-search-input-in-current-file
             color-rg-search-symbol-in-current-file)
  :config
  (setq color-rg-kill-temp-buffer-p nil
        color-rg-mac-load-path-from-shell nil)
  (setq color-rg-ignore-dir-list '("node_modules" "dist" "__pycache__"))

  (setq rg-glob-fmt
        (if IS-WINDOWS
            "-g \"!%s\" "
          "-g '!%s' "))

  (setq color-rg-search-ignore-rules
        (mapconcat
         (lambda (x) (format rg-glob-fmt x)) color-rg-ignore-dir-list ""))
  (remove-hook 'compilation-filter-hook
               #'doom-apply-ansi-color-to-compilation-buffer-h))

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
         ("M-:" . awesome-pair-jump-out-pair-and-newline))
         
  :hook ((prog-mode ielm-mode minibuffer-inactive-mode sh-mode) . awesome-pair-mode))

(use-package! counsel-etags
  ;;:ensure t
  :bind (("M-]" . counsel-etags-find-tag-at-point))
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (dolist (dir '("build" ".ccls-cache" "Debug" "Release" "rime" ".local"))
    (push dir counsel-etags-ignore-directories))
  (dolist (ext '("*.bin" "*.hex" "*.pdb"))
    (push ext counsel-etags-ignore-filenames)))

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
  (pdf-tools-install-noverify))
  

(use-package! flywrap
  :hook
  ('text-mode . #'flywrap-mode))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  ;;:hook (nov-mode . my-nov-setup)
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


(use-package! shr-tag-pre-highlight
  :after shr
  :config
  (defun shrface-shr-tag-pre-highlight (pre)
    "Highlighting code in PRE."
    (let* ((shr-folding-mode 'none)
           (shr-current-font 'default)
           (code (with-temp-buffer
                   (shr-generic pre)
                   (setq-local fill-column 120)
                   (indent-rigidly (point-min) (point-max) 2)
                   ;; (fill-region (point-min) (point-max) nil nil nil)
                   (buffer-string)))
           (lang (or (shr-tag-pre-highlight-guess-language-attr pre)
                     (let ((sym (language-detection-string code)))
                       (and sym (symbol-name sym)))))
           (mode (and lang
                      (shr-tag-pre-highlight--get-lang-mode lang))))
      (shr-ensure-newline)
      (insert "  ") ; indentation
      (insert (propertize (concat "#+BEGIN_SRC" lang) 'face 'org-block-begin-line)) ; delete "lang" of this line, if you found the wrong detected langugage is annoying
      (shr-ensure-newline)
      (insert
       (or (and (fboundp mode)
                (with-demoted-errors "Error while fontifying: %S"
                  (shr-tag-pre-highlight-fontify code mode)))
           code))
      (shr-ensure-newline)
      (insert "  ") ; indentation
      (insert (propertize "#+END_SRC" 'face 'org-block-end-line))
      (shr-ensure-newline)))
  (add-to-list 'shr-external-rendering-functions
               '(pre . shrface-shr-tag-pre-highlight)))
  

(use-package! shrface
  :after shr
  :config
  (setq nov-shr-rendering-functions shr-external-rendering-functions)
  (setq shrface-paragraph-indentation 2)
  (setq shrface-paragraph-fill-column 120))
  

(use-package burly
  :bind (("C-c b b" . burly-bookmark-frames)
         ("C-c b o" . burly-open-bookmark)))


(use-package! sdcv
  :defer t
  :commands (sdcv-search-input sdcv-search-pointer+)
  :config
  (set-face-foreground 'sdcv-tooltip-face "#51afef")
  (setq sdcv-program (executable-find "sdcv"))
  (setq sdcv-dictionary-simple-list '("牛津现代英汉双解词典"))
  (setq sdcv-dictionary-complete-list '("牛津现代英汉双解词典"
                                        "CEDICT汉英辞典"
                                        "朗道汉英字典5.0"
                                        "21世纪双语科技词典"
                                        "朗道英汉字典5.0"))
  (setq sdcv-dictionary-data-dir (expand-file-name "~/.stardict/dic"))

  (defun sdcv-translate-result (word dictionary-list)
    "Call sdcv to search word in dictionary list, return filtered
string of results."
    (let ((command-string
           (format "%s -x -n %s %s --data-dir %s"
            sdcv-program
            (mapconcat (lambda (dict)
                         (concat "-u \"" dict "\""))
                       dictionary-list " ")
            (format "\"%s\"" word)
            sdcv-dictionary-data-dir)))
      ;; (message command-string)
      (sdcv-filter
        (shell-command-to-string command-string)))))
      ;; Set LANG environment variable, make sure `shell-command-to-string' can handle CJK character correctly.
      


(use-package! puni
  :defer t
  :hook ((prog-mode
          sgml-mode
          nxml-mode
          tex-mode
          eval-expression-minibuffer-setup) . puni-mode))



(use-package! citre
  ;;:load-path "~/.doom.d/extensions/citre"
  :defer t
  :init
  ;; This is needed in `:init' block for lazy load to work.
  (require 'citre-config)
  ;; Bind your frequently used commands.
  (global-set-key (kbd "C-c c j") #'citre-jump)
  (global-set-key (kbd "C-c c J") #'citre-jump-back)
  (global-set-key (kbd "C-c c p") #'citre-ace-peek)
  :config
  (setq
   ;; Set this if readtags is not in your path.
   ;; citre-readtags-program "/path/to/readtags"
   ;; Set this if you use project management plugin like projectile.  It's
   ;; only used to display paths relatively, and doesn't affect actual use.
   citre-project-root-function #'projectile-project-root))

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . meow-motion-origin-command)
   '("k" . meow-motion-origin-command)
   ;; Use SPC (0-9) for digit arguments.
   '("." . "M-.")
   '("," . "M-,")
   '(";" . comment-dwim)
   ;;'("k" . kill-this-buffer)
   '("p" . project-find-file)
   '("d" . dired)
   '("b" . switch-to-buffer)
   ;; '("r" . deadgrep)
   '("f" . find-file)
   '("i" . imenu)
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("C" . meow-change-save)
   '("d" . meow-C-d)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("F" . meow-find-expand)
   '("g" . meow-cancel)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("N" . meow-pop-search)
   '("o" . meow-block)
   '("O" . meow-block-expand)
   '("p" . meow-yank)
   '("P" . meow-yank-pop)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("T" . meow-till-expand)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("V" . meow-kmacro-matches)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-kmacro-lines)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("Z" . meow-pop-all-selection)
   '("&" . meow-query-replace)
   '("%" . meow-query-replace-regexp)
   '("'" . repeat)
   '("\\" . quoted-insert)
   '("<escape>" . meow-last-buffer)))

  

(use-package! meow
  ;;:demand t
  :init
  (meow-global-mode 1)
  :config
  ;; meow-setup 用于自定义按键绑定，可以直接使用下文中的示例
  (meow-setup)
  ;; 如果你需要在 NORMAL 下使用相对行号（基于 display-line-numbers-mode）
  ;;(meow-setup-line-number)
  ;; 如果你需要自动的 mode-line 设置（如果需要自定义见下文对 `meow-indicator' 说明）
  ;;(meow-setup-indicator))
  (setq meow-replace-state-name-list '((normal . "[N]")
                                       (motion . "[M]")
                                       (keypad . "[K]")
                                       (insert . "[I]")
                                       (bmacro . "[B]")))
  (add-to-list 'meow-mode-state-list '(color-rg-mode . motion))
  (add-to-list 'meow-mode-state-list '(elfeed-dashboard-mode . motion)))

