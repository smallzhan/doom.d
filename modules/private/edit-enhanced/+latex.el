;;; latex-enhanced

(after! tex
  (setq-default TeX-engine 'xetex)

  (when (and IS-WINDOWS (featurep! :tools pdf)) ;; NOTE: doom-emacs add the list to macos, but not windows
    (add-to-list 'TeX-view-program-list '("PDF Tools" TeX-pdf-tools-sync-view)))

  (add-hook 'TeX-mode-hook 'turn-on-reftex)
  (setq reftex-section-levels
        '(("part" . 0) ("chapter" . 1) ("section" . 2) ("subsection" . 3)
          ("frametitle" . 4) ("subsubsection" . 4) ("paragraph" . 5)
          ("subparagraph" . 6) ("addchap" . -1) ("addsec" . -2)))

  (defvar beamer-frame-begin "^[ ]*\\\\begin{frame}"
    "Regular expression that matches the frame start")

  (defvar beamer-frame-end "^[ ]*\\\\end{frame}"
    "Regular expression that matches the frame start")


  (defun beamer-find-frame-begin ()
    "Move point to the \\begin of the current frame."
    (re-search-backward beamer-frame-begin))


  (defun beamer-find-frame-end ()
    "Move point to the \\end of the current environment."
    (re-search-forward beamer-frame-end))



  (defun beamer-mark-frame ()
    "Set mark to end of current frame and point to the matching begin.
The command will not work properly if there are unb(defun latex-enhanced/init-cdlatex()
  (use-package cdlatex
    :defer t
    :init
    (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)))alanced
begin-end pairs in comments and verbatim environments."
    (interactive)
    (let ((cur (point))
          beg end)
      (setq end (beamer-find-frame-end))
      (goto-char cur)
      (setq beg (beamer-find-frame-begin))
      (goto-char beg)
      (set-mark end)))

  ;; (defun beamer-mark-frame ()
  ;;   "beamer-mark-frame"
  ;;   (interactive)
  ;;   (let ((pos (point)))
  ;;     (when (re-search-backward "\\\\begin{frame}")
  ;;       (set-mark)
  ;;       (if (re-search-forward "\\\\end{frame}")
  ;; 		  (message "frame marked")
  ;; 		(message "not in frame")))))


  (defun beamer-indent-frame ()
    (interactive)
    (let ((pos (point))
          beg end)
      (setq beg (beamer-find-frame-begin))
      (goto-char pos)
      (setq end (beamer-find-frame-end))
      (indent-region beg end)
      (goto-char pos)))

  (defun beamer-narrow-to-frame ()
    (interactive)
    (let ((pos (point))
          beg end)
      (setq beg (beamer-find-frame-begin))
      (goto-char pos)
      (setq end (beamer-find-frame-end))
      (narrow-to-region beg end)
      (goto-char pos)))

  )
