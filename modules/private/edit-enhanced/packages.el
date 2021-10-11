;; -*- no-byte-compile: t; -*-
;;

(package! auto-save :recipe (:host github :repo "manateelazycat/auto-save"))
(package! lazy-search :recipe (:host github :repo "manateelazycat/lazy-search"))
(package! thing-edit :recipe (:host github :repo "manateelazycat/thing-edit"))
;;(package! color-rg :recipe (:host github :repo "smallzhan/color-rg" :branch "mac-issue"))
(package! color-rg :recipe (:host github :repo "manateelazycat/color-rg"))
(package! awesome-pair :disable t :recipe (:host github :repo "manateelazycat/awesome-pair"))
;;(package! counsel-etags :recipe (:host github :repo "redguardtoo/counsel-etags"))
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;redguardtoo/counsel-etags
(package! counsel-etags :disable t)

;;(package! pdf-tools :recipe (:host github :repo "smallzhan/pdf-tools" :branch "retina-view"))
;;(package! pdf-tools :recipe (:host github :repo "politza/pdf-tools"))

(package! pdf-tools :disable t)
(package! flywrap
  :recipe (:host github :repo "casouri/lunarymacs" :files ("site-lisp/flywrap.el"))
  :disable t)

(package! nov)

(package! shrface :recipe (:host github :repo "chenyanming/shrface") :disable t)

(package! shr-tag-pre-highlight :disable t)

(package! burly)

(package! sdcv :recipe (:host github :repo "manateelazycat/sdcv"))

(package! puni :recipe (:host github :repo "Amaikinono/puni") :disable t)

(package! citre :recipe (:host github :repo "universal-ctags/citre"))
