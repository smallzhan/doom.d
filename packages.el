;; -*- no-byte-compile: t; -*-
;;; config/private/packages.el

(disable-packages! glsl-mode cuda-mode opencl-mode)
(package! visual-regexp)
(package! visual-regexp-steroids)
(package! org-edit-latex)

(package! company-english-helper :recipe (:fetcher github :repo "manateelazycat/company-english-helper"))

(package! yapfify)

