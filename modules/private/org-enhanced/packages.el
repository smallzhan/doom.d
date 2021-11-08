;; -*- no-byte-compile: t; -*-

(package! notdeft :recipe (:host github :repo "hasu/notdeft"))
(package! ox-gfm)
(package! ob-ipython :disable t)
(package! cdlatex)
;;(package! org-jekyll :ignore t)
;;(package! org-pomodoro :disable t)
(package! org-protocol-capture-html :disable t
  :recipe (:host github :repo "alphapapa/org-protocol-capture-html"))
;;(package! org-noter :recipe (:host github :repo "fuxialexander/org-noter" :branch "pdf-notes-booster"))
(package! org-noter :disable t)
(package! org-ref :disable t)
(package! ivy-bibtex :disable t)
(package! org-super-agenda)

(package! org-pdftools :disable t)
(package! org-noter-pdftools :disable t)

;;(package! org-bullets :disable t)
;;(package! org-superstar :recipe (:host github :repo "integral-dw/org-superstar-mode"))

(package! valign :recipe (:host github :repo "casouri/valign"))
(package! org-clock-budget :recipe (:host github :repo "Fuco1/org-clock-budget" :files ("*")))
(package! gkroam :recipe (:host github :repo "Kinneyzhang/gkroam" :branch "develop") :disable t)
(package! org-roam)
(package! org-roam-bibtex :recipe (:host github :repo "org-roam/org-roam-bibtex") :disable t)
(package! elfeed-dashboard :recipe (:host github :repo "Manoj321/elfeed-dashboard"))

;;(package! bibtex-actions)
(package! citeproc)
(package! ebib)
(package! citar :recipe (:host github :repo "bdarcus/citar"))
