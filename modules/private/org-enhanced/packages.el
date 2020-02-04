;; -*- no-byte-compile: t; -*-

;;(package! deft)
;;;; Prevent built-in Org from playing into the byte-compilation of
;; `org-plus-contrib'.
(when-let (orglib (locate-library "org" nil doom--initial-load-path))
  (setq load-path (delete (substring (file-name-directory orglib) 0 -1)
                          load-path)))

;; HACK A necessary hack because org requires a compilation step after being
;;      cloned, and during that compilation a org-version.el is generated with
;;      these two functions, which return the output of a 'git describe ...'
;;      call in the repo's root. Of course, this command won't work in a sparse
;;      clone, and more than that, initiating these compilation step is a
;;      hassle, so...
(add-hook! 'straight-use-package-pre-build-functions
  (defun +org-fix-package-h (package &rest _)
    (when (member package '("org" "org-plus-contrib"))
      (with-temp-file (expand-file-name "org-version.el" (straight--repos-dir "org"))
        (insert "(fset 'org-release (lambda () \"9.3\"))\n"
                "(fset 'org-git-version #'ignore)\n"
                "(provide 'org-version)\n")))))

(package! org-plus-contrib)
(package! notdeft :recipe (:host github :repo "hasu/notdeft" :branch "xapian"))
(package! ox-gfm)
(package! ob-ipython)
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

;;(package! org-pdftools :recipe (:host github :repo "fuxialexander/org-pdftools"))
