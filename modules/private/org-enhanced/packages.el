;; -*- no-byte-compile: t; -*-

(package! deft)
(package! ox-gfm)
(package! ob-ipython)
(package! cdlatex)
;;(package! org-jekyll :ignore t)
(package! org-pomodoro)
(package! org-protocol-capture-html :disable t
  :recipe (:host github :repo "alphapapa/org-protocol-capture-html"))
(package! org-noter :recipe (:host github :repo "fuxialexander/org-noter" :branch "pdf-notes-booster"))
(package! org-ref)
(package! ivy-bibtex)

;;(package! org-pdftools :recipe (:host github :repo "fuxialexander/org-pdftools"))
