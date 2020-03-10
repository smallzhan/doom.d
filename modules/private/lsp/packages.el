;; -*- no-byte-compile: t; -*-
;; lsp/packages.el

(package! lsp-mode)

(package! lsp-ui)

(when (featurep! :completion company)
  (package! company-lsp))

(package! dap-mode)

;; (when (featurep! :lang cc)
;;   (package! ccls))

(package! lsp-python-ms)
(package! company-tabnine)
