;; -*- no-byte-compile: t; -*-
;; lsp/packages.el

(package! lsp-mode :disable t)

(package! lsp-ui :disable t)

(package! dap-mode :disable t)

(package! lsp-python-ms :disable t)
(package! company-tabnine :disable t)

(package! lsp-ivy :disable t)

(package! nox :recipe (:host github :repo "manateelazycat/nox"))

(package! eglot :disable t)
