;; -*- no-byte-compile: t; -*-

(package! notdeft :recipe (:host github :repo "hasu/notdeft" :branch "xapian"))
(package! ox-gfm)
(package! ob-ipython :disable t)
(package! cdlatex)
;;(package! org-jekyll :ignore t)
(package! org-pomodoro)
(package! org-protocol-capture-html :disable t
  :recipe (:host github :repo "alphapapa/org-protocol-capture-html"))
;;(package! org-noter :recipe (:host github :repo "fuxialexander/org-noter" :branch "pdf-notes-booster"))
(package! org-noter)
(package! org-ref)
(package! ivy-bibtex)
(package! org-super-agenda)

(package! org-pdftools :recipe (:host github :repo "fuxialexander/org-pdftools" :no-byte-compile t))

(package! org-bullets :disable t)
(package! org-superstar :recipe (:host github :repo "integral-dw/org-superstar-mode"))
