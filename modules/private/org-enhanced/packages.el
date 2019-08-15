;; -*- no-byte-compile: t; -*-

(package! deft)
(package! ox-gfm)
(package! ob-ipython)
(package! cdlatex)
;;(package! org-jekyll :ignore t)
(package! org-pomodoro)
(package! org-protocol-capture-html :disable t
  :recipe (:fetcher github :repo "alphapapa/org-protocol-capture-html"))
(package! org-noter :recipe (:fetcher github :repo "fuxialexander/org-noter" :branch "pdf-notes-booster"))
(package! org-ref)
(package! ivy-bibtex)

;;(package! org-pdftools :recipe (:fetcher github :repo "fuxialexander/org-pdftools"))
