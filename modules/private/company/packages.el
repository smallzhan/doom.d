;; -*- no-byte-compile: t; -*-
;;; completion/company/packages.el

(package! company )
(package! company-dict)
(when (featurep! +childframe)
  (package! company-box))
(package! company-prescient)
