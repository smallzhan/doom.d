;; -*- no-byte-compile: t; -*-
;;

(package! auto-save :recipe (:host github :repo "manateelazycat/auto-save"))
(package! lazy-search :recipe (:host github :repo "manateelazycat/lazy-search"))
(package! thing-edit :recipe (:host github :repo "manateelazycat/thing-edit"))
(package! color-rg :recipe (:host github :repo "smallzhan/color-rg" :branch "mac-issue"))
(package! awesome-pair :disable t :recipe (:host github :repo "manateelazycat/awesome-pair"))
;;(package! counsel-etags :recipe (:host github :repo "redguardtoo/counsel-etags"))
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;redguardtoo/counsel-etags
(package! counsel-etags)

;;(package! pdf-tools :recipe (:host github :repo "smallzhan/pdf-tools" :branch "retina-view"))
(package! pdf-tools :recipe (:host github :repo "politza/pdf-tools"))

(package! flywrap
  :recipe (:host github :repo "casouri/lunarymacs" :files ("site-lisp/flywrap.el"))
  :disable t)

(package! nov)

(package! shrface :recipe (:host github :repo "chenyanming/shrface") :disable t)

(package! shr-tag-pre-highlight :disable t)

(package! burly)
