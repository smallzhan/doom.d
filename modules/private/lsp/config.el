;;; private/lsp/config.el -*- lexical-binding: t; -*-

;;(def-package! spinner)

;; https://github.com/emacs-lsp/lsp-mode#supported-languages
(use-package! lsp-mode
  :defines (lsp-clients-python-library-directories lsp-rust-rls-server-command)
  :commands (lsp-enable-which-key-integration )
  :diminish
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode)
                          (lsp-deferred))))
         (lsp-mode . (lambda ()
                       ;; Integrate `which-key'
                       (lsp-enable-which-key-integration)
                       
                       ;; Format and organize imports
                       )))
  :bind (:map lsp-mode-map
          ("C-c C-d" . lsp-describe-thing-at-point)
          ([remap xref-find-definitions] . lsp-find-definition)
          ([remap xref-find-references] . lsp-find-references))
  :init
  ;; @see https://github.com/emacs-lsp/lsp-mode#performance
  (setq read-process-output-max (* 1024 1024)) ;; 1MB
  
  (setq lsp-auto-guess-root nil      ; Detect project root
        lsp-keep-workspace-alive nil ; Auto-kill LSP server
           lsp-enable-indentation nil
           lsp-enable-on-type-formatting nil
           lsp-keymap-prefix "C-c l")

     ;; For `lsp-clients'
     (setq lsp-clients-python-library-directories '("/usr/local/" "/usr/"))
     (unless (executable-find "rls")
       (setq lsp-rust-rls-server-command '("rustup" "run" "stable" "rls"))))


;;  (use-package! company-lsp
;;      :init (setq company-lsp-cache-candidates 'auto)
;;      :config
;;      (with-no-warnings
;;        ;; WORKAROUND: Fix tons of unrelated completion candidates shown
;;        ;; when a candidate is fulfilled
;;        ;; @see https://github.com/emacs-lsp/lsp-python-ms/issues/79
;;        (add-to-list 'company-lsp-filter-candidates '(mspyls))

;;        (defun my-company-lsp--on-completion (response prefix)
;;          "Handle completion RESPONSE.

;; PREFIX is a string of the prefix when the completion is requested.

;; Return a list of strings as the completion candidates."
;;          (let* ((incomplete (and (hash-table-p response) (gethash "isIncomplete" response)))
;;                 (items (cond ((hash-table-p response) (gethash "items" response))
;;                              ((sequencep response) response)))
;;                 (candidates (mapcar (lambda (item)
;;                                       (company-lsp--make-candidate item prefix))
;;                                     (lsp--sort-completions items)))
;;                 (server-id (lsp--client-server-id (lsp--workspace-client lsp--cur-workspace)))
;;                 (should-filter (or (eq company-lsp-cache-candidates 'auto)
;;                                    (and (null company-lsp-cache-candidates)
;;                                         (company-lsp--get-config company-lsp-filter-candidates server-id)))))
;;            (when (null company-lsp--completion-cache)
;;              (add-hook 'company-completion-cancelled-hook #'company-lsp--cleanup-cache nil t)
;;              (add-hook 'company-completion-finished-hook #'company-lsp--cleanup-cache nil t))
;;            (when (eq company-lsp-cache-candidates 'auto)
;;              ;; Only cache candidates on auto mode. If it's t company caches the
;;              ;; candidates for us.
;;              (company-lsp--cache-put prefix (company-lsp--cache-item-new candidates incomplete)))
;;            (if should-filter
;;                (company-lsp--filter-candidates candidates prefix)
;;              candidates)))
;;        (advice-add #'company-lsp--on-completion :override #'my-company-lsp--on-completion)))

;; (def-package! company-lsp
;;   :after lsp-mode
;;   :init
;;   (setq company-transformers nil 
;;         company-lsp-cache-candidates 'auto)
;;   :config
;;   (set-company-backend! 'lsp-mode 'company-lsp)
;;   )

(use-package! lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (set-lookup-handlers! 'lsp-ui-mode
    :definition #'lsp-ui-peek-find-definitions
    :references #'lsp-ui-peek-find-references)
  (setq
   lsp-ui-doc-use-webkit nil
   lsp-ui-doc-use-childframe t
   lsp-ui-doc-max-height 20
   lsp-ui-doc-max-width 50
   lsp-ui-sideline-enable nil
   lsp-ui-peek-always-show t)
  (map!
   :map lsp-ui-peek-mode-map
   "h" #'lsp-ui-peek--select-prev-file
   "j" #'lsp-ui-peek--select-next
   "k" #'lsp-ui-peek--select-prev
   "l" #'lsp-ui-peek--select-next-file))


 (def-package! dap-mode
       ;; :functions dap-hydra/nil
       :diminish
       :bind (:map lsp-mode-map
              ("<f5>" . dap-debug)
              ("M-<f5>" . dap-hydra))
       :hook ((after-init . dap-mode)
              (dap-mode . dap-ui-mode)
         ;;     (dap-session-created . (lambda (_args) (dap-hydra)))
           ;;   (dap-stopped . (lambda (_args) (dap-hydra)))
            ;;  (dap-terminated . (lambda (_args) (dap-hydra/nil)))

              (python-mode . (lambda () (require 'dap-python)))
              (ruby-mode . (lambda () (require 'dap-ruby)))
              (go-mode . (lambda () (require 'dap-go)))
              (java-mode . (lambda () (require 'dap-java)))
              ((c-mode c++-mode objc-mode swift-mode) . (lambda () (require 'dap-lldb)))
              (php-mode . (lambda () (require 'dap-php)))
              (elixir-mode . (lambda () (require 'dap-elixir)))
              ((js-mode js2-mode) . (lambda () (require 'dap-chrome)))
              (powershell-mode . (lambda () (require 'dap-pwsh)))))


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
                         (setq-local flycheck-checker 'python-flake8))))

(after! python
  (setq python-shell-interpreter "python3"))

(use-package! lsp-ivy
     :after lsp-mode
     :bind (:map lsp-mode-map
            ([remap xref-find-apropos] . lsp-ivy-workspace-symbol)
            ("C-s-." . lsp-ivy-global-workspace-symbol)))
;; lsp client config

;; (def-package! ccls
;;   :init
;;   (add-hook! (c-mode c++-mode cuda-mode) #'lsp)
;;   :config

;;  (setq ccls-initialization-options `(:cacheDirectory ,(expand-file-name "~/Code/ccls_cache")))

;;   (evil-set-initial-state 'ccls-tree-mode 'emacs)

;;   (after! projectile
;;     (setq projectile-project-root-files-top-down-recurring
;;           (append '("compile_commands.json")
;;                   projectile-project-root-files-top-down-recurring))
;;     (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")
;;     (add-to-list 'projectile-globally-ignored-directories "build")
;;     )
;;   )


;; (def-package! dap-lldb
;;   :after (ccls)
;;   :config
;;   (setq dap-lldb-debugged-program-function 'cp-project-debug)
;;   )
(use-package! company-tabnine
  :after company
  :config
  ;;(add-to-list 'company-backends #'company-tabnine)
  (push '(company-capf :with company-tabnine :separate) company-backends))
