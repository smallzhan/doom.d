;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode smartparens)
(package! visual-regexp)
(package! visual-regexp-steroids)
(package! org-edit-latex)
(package! pyim)
(package! package-lint)

(package! company-english-helper :recipe (:fetcher github :repo "manateelazycat/company-english-helper"))

(package! yapfify)

