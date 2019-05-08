
(def-package! ox-gfm
  :defer t
  )

(def-package! cdlatex
  :defer t
  :hook (org-mode . turn-on-org-cdlatex))

(def-package! ob-ipython
  :defer t
  :config
  (setq org-confirm-babel-evaluate nil)
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append))

(def-package! deft
  :config
  (setq deft-directory (concat +my-org-dir "deft/")
        deft-recursive t
        deft-auto-save-interval 10.0
        deft-file-naming-rules '((nospace . "-")
                                 (case-fn . downcase))))

(def-package! org-jekyll
  :load-path +my-ext-dir
  :after org
  :commands my-pages-start-post
  )

(after! org
  (setq org-directory +my-org-dir
        org-agenda-diary-file (concat org-directory "diary.org")
        org-default-notes-file (concat org-directory "refile.org")
        ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
        ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
        org-agenda-files `(,(concat org-directory "planning.org")
                           ,(concat org-directory "notes.org")))
  (setq auto-coding-alist
        (append auto-coding-alist '(("\\.org\\'" . utf-8))))
  
  (setq org-log-done 'time
        org-log-into-drawer "LOGBOOK"
        org-deadline-warning-days 2
        org-agenda-start-on-weekday nil
        org-agenda-insert-diary-extract-time t)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "ACTIVE(a)" "|" "DONE(d!/!)")
          (sequence "WAIT(w@/!)" "HOLD(h@/!)"
                    "|" "CANCELLED(c@/!)" "PHONE")))

  (setq org-todo-state-tags-triggers
        '(("CANCELLED" ("CANCELLED" . t))
          ("WAIT" ("WAIT" . t))
          ("HOLD" ("WAIT" . t) ("HOLD" . t))
          (done ("WAIT") ("HOLD"))
          ("TODO" ("WAIT") ("CANCELLED") ("HOLD"))
          ("ACTIVE" ("WAIT") ("CANCELLED") ("HOLD"))
          ("DONE" ("WAIT") ("CANCELLED") ("HOLD"))))

  (setq org-columns-default-format "%70ITEM(Task) %10Effort(Effort){:} %20CLOCKSUM")
  (setq org-agenda-log-mode-items '(closed state))

  (setq org-tag-alist '((:startgroup)
                        ("@News" . ?n)
                        ("@Work" . ?w)
                        ("@Funny" . ?f)
                        ("@Self" . ?e)
                        (:endgroup)
                        ("PHONE" . ?m)
                        ("PERSONAL" . ?P)
                        ("PROG" . ?p)
                        ("SOFT" . ?s)
                        ("IDEA" . ?I)
                        ("EXP" . ?E)
                        ("ROBOT" . ?R)
                        ("OTHER" . ?O)
                        ("NOTE" . ?N)
                        ("TIPS" . ?T)
                        ("WAITING" . ?W)
                        ("MARK" . ?M)
                        ("HOLD" . ?H)
                        ("CANCELLED" . ?c)
                        ("READING" . ?a)
                        ))
  (setq org-emphasis-regexp-components
        '(
          "：，。、  \t('\"{"            ;pre
          "- ：，。、 \t.,:!?;'\")}\\"   ;post
          " \t\r\n,\"'"                  ;border *forbidden*
          "."                            ;body-regexp
          1                              ; newline
          ))

  ;; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key 'expert)

  ;; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)

  ;; (defun bh/remove-empty-drawer-on-clock-out ()
  ;;   (interactive)
  ;;   (save-excursion
  ;;     (beginning-of-line 0)
  ;;     (org-remove-empty-drawer-at "LOGBOOK" (point))))

  ;;(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

  (setq org-hide-leading-stars nil)
  (setq org-cycle-separator-lines 0)
  (setq org-blank-before-new-entry '((heading)
                                     (plain-list-item . auto)))
  (setq org-insert-heading-respect-content nil)
  (setq org-startup-truncated nil)

  ;; org-capture
  (setq org-capture-templates
        '(("t" "todo" entry (file  "refile.org")
           "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
          ("r" "respond" entry (file  "refile.org")
           "* TODO Respond to %:from on %:subject\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
          ("n" "note" entry (file  "refile.org")
           "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
          ("j" "Journal" entry (file+olp+datetree  "diary.org")
           "* %?\n%U\n" :clock-in t :clock-resume t)
          ("w" "org-protocol" entry (file "refile.org")
           "* TODO Review %c\n%U\n" :immediate-finish t)
          ("p" "Phone call" entry (file  "refile.org")
           "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
          ("h" "Habit" entry (file  "refile.org")
           "* ACTIVE %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: ACTIVE\n:END:\n")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; REFILE Settings ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9)))

  ;; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

  ;; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  ;; Use IDO for both buffer and file completion and ido-everywhere to t
  ;; (setq org-completion-use-ido t)
  ;; (setq ido-everywhere t)
  ;; (setq ido-max-directory-size 100000)
  ;; (ido-mode (quote both))

  ;; Refile settings
  ;; Exclude DONE state tasks from refile targets
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setq org-refile-target-verify-function 'bh/verify-refile-target)

  ;;(require 'org-expiry)
  ;; Configure it a bit to my liking
  (setq
   org-expiry-created-property-name "CREATED"
   ;; Name of property when an item is created
   org-expiry-inactive-timestamps t
   ;; Don't have everything in the agenda view
   )

  (defun mrb/insert-created-timestamp()
    "Insert a CREATED property using org-expiry.el for TODO entries"
    (org-expiry-insert-created)
    (org-back-to-heading)
    (org-end-of-line)
    (insert " ")
    )
  ;; Whenever a TODO entry is created, I want a timestamp
  ;; Advice org-insert-todo-heading to insert a created timestamp using org-expiry
  (defadvice org-insert-todo-heading (after mrb/created-timestamp-advice activate)
    "Insert a CREATED property using org-expiry.el for TODO entries"
    (mrb/insert-created-timestamp)
    )
  ;; Make it active
  (ad-activate 'org-insert-todo-heading)
  (require 'org-capture)
  (defadvice org-capture (after mrb/created-timestamp-advice activate)
    "Insert a CREATED property using org-expiry.el for TODO entries"
    ;; Test if the captured entry is a TODO, if so insert the created
    ;; timestamp property, otherwise ignore
    (when (member (org-get-todo-state) org-todo-keywords-1)
      (mrb/insert-created-timestamp)))
  (ad-activate 'org-capture)
  ;; Add feature to allow easy adding of tags in a capture window
  (defun mrb/add-tags-in-capture()
    (interactive)
    "Insert tags in a capture window without losing the point"
    (save-excursion
      (org-back-to-heading)
      (org-set-tags)))
  ;; Bind this to a reasonable key

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; CLOCK ;;;;;;;;;;;;;;;;
  ;;
  ;; Resume clocking task when emacs is restarted
  (org-clock-persistence-insinuate)
  ;;
  ;; Show lot sof clocking history so it's easy to pick items off the C-F11 list
  (setq org-clock-history-length 36)
  ;; Resume clocking task on clock-in if the clock is open
  (setq org-clock-in-resume t)
  ;; Change tasks to ACTIVE when clocking in
  (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; Enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; Include current clocking task in clock reports
  (setq org-clock-report-include-clocking-task t)

  (setq bh/keep-clock-running nil)

  (defun bh/clock-in-to-next (kw)
    "Switch a task from TODO to ACTIVE when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from ACTIVE back to TODO"
    (when (not (and (boundp 'org-capture-mode) org-capture-mode))
      (cond
       ((and (member (org-get-todo-state) (list "TODO"))
             (bh/is-task-p))
        "ACTIVE")
       ((and (member (org-get-todo-state) (list "ACTIVE"))
             (bh/is-project-p))
        "TODO"))))

  (defun bh/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task has-subtask))))

  (defun bh/is-project-subtree-p ()
    "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
    (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                                (point))))
      (save-excursion
        (bh/find-project-task)
        (if (equal (point) task)
            nil
          t))))

  (defun bh/is-task-p ()
    "Any task with a todo keyword and no subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task (not has-subtask)))))

  (defun bh/find-project-task ()
    "Move point to the parent (project) task if any"
    (save-restriction
      (widen)
      (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
        (while (org-up-heading-safe)
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (goto-char parent-task)
        parent-task)))

  (defun bh/punch-in (arg)
    "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
    (interactive "p")
    (setq bh/keep-clock-running t)
    (if (equal major-mode 'org-agenda-mode)
        ;;
        ;; We're in the agenda
        ;;
        (let* ((marker (org-get-at-bol 'org-hd-marker))
               (tags (org-with-point-at marker (org-get-tags-at))))
          (if (and (eq arg 4) tags)
              (org-agenda-clock-in '(16)))))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ;; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16)))))

  (defun bh/punch-out ()
    (interactive)
    (setq bh/keep-clock-running nil)
    (when (org-clock-is-active)
      (org-clock-out))
    (org-agenda-remove-restriction-lock))

  (defun bh/clock-in-default-task ()
    (save-excursion
      (org-with-point-at org-clock-default-task
        (org-clock-in))))

  (defun bh/clock-in-parent-task ()
    "Move point to the parent (project) task if any and clock in"
    (let ((parent-task))
      (save-excursion
        (save-restriction
          (widen)
          (while (and (not parent-task) (org-up-heading-safe))
            (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
              (setq parent-task (point))))
          (if parent-task
              (org-with-point-at parent-task
                (org-clock-in))
            (when bh/keep-clock-running
              (bh/clock-in-default-task)))))))

  ;; (defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

  ;; (defun bh/clock-in-organization-task-as-default ()
  ;;   (interactive)
  ;;   (org-with-point-at (org-id-find bh/organization-task-id 'marker)
  ;;     (org-clock-in '(16))))

  (defun bh/clock-out-maybe ()
    (when (and bh/keep-clock-running
               (not org-clock-clocking-in)
               (marker-buffer org-clock-default-task)
               (not org-clock-resolving-clocks-due-to-idleness))
      (bh/clock-in-parent-task)))

  (add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)


  (defun bh/insert-inactive-timestamp ()
    (interactive)
    (org-insert-time-stamp nil t t nil nil nil))

  (defun bh/insert-heading-inactive-timestamp ()
    (save-excursion
      (org-return)
      (org-cycle)
      (bh/insert-inactive-timestamp)))

  (setq org-enforce-todo-dependencies t)
  (setq org-deadline-warning-days 30)

  ;; Erase all reminders and rebuilt reminders for today from the agenda
  (defun bh/org-agenda-to-appt ()
    (interactive)
    (setq appt-time-msg-list nil)
    (org-agenda-to-appt))

  ;; Rebuild the reminders everytime the agenda is displayed
  (add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)

  ;; This is at the end of my .emacs - so appointments are set up when Emacs starts
  (bh/org-agenda-to-appt)

  ;; Activate appointments so we get notifications
  (appt-activate t)

  ;; If we leave Emacs running overnight - reset the appointments one minute after midnight
  (run-at-time "24:01" nil 'bh/org-agenda-to-appt)

  (setq org-export-with-timestamps nil)
  ;;(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

  (require 'org-tempo)

  (setq org-latex-listings t)
  (setq org-latex-compiler "xelatex")
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-highlight-latex-and-related '(latex))
  (require 'ox-latex)
  (add-to-list 'org-latex-classes
               `("my-beamer"
                 ,(concat
                   "\\documentclass[presentation]{beamer}"
                   "\n\\usepackage[UTF8]{ctex}"
                   "\n\\mode<presentation> {"
                   "\n\\setbeamercovered{transparent}"
                   "\n\\setbeamertemplate{theorems}[numbered]"
                   "\n\\usefonttheme[onlymath]{serif}"
                   "\n}"
                   "\n\\usepackage{amsmath, amssymb}"
                   "\n\\usepackage{hyperref}"
                   "\n\\usepackage[english]{babel}"
                   "\n\\usepackage{tikz}"
                   "\n\\setbeamerfont{smallfont}{size=\\small}"
                   "\n[NO-DEFAULT-PACKAGES]"
                   "\n[NO-PACKAGES]"
                   "\n[EXTRA]")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ))

  (add-to-list 'org-latex-classes
               `("my-article"
                 ,(concat
                   "\\documentclass{ctexart}"
                   "\n\\usepackage{hyperref}"
                   "\n[NO-DEFAULT-PACKAGES]"
                   "\n[PACKAGES]"
                   "\n[EXTRA]")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))



  (setq org-agenda-exporter-settings
        '((ps-number-of-columns 1)
          (ps-landscape-mode t)
          (htmlize-output-type 'css)))

  (setq org-html-head-include-default-style nil)
  (setq org-html-postamble t)
  (setq org-html-postamble-format
        '(("en" "<hr /> <p class=\"postamble\">[<b>Last Updated:</b> %T | <b>Created by</b> %c]</p>")))
  (setq org-html-footnote-format " [%s]")

  (setq org-publish-project-alist
        `(("orgfiles" ;; see the backquote ` not ' and the comma before the variable
           ;;:base-directory "~/Notes/org/" ; FIXME: can't be a variable.
           :base-directory , org-directory
           :base-extension "org"
           :publishing-directory , (concat org-directory "../public_html")
           :publishing-function org-html-publish-to-html
           :exclude "PrivatePage.org" ;; regexp
           :language: utf-8
           :headline-levels 3
           :section-numbers nil
           :table-of-contents nil
           :html-head: "<link rel=\"stylesheet\" href=\"org.css\" type=\"text/css\">"
           :footnotes t
           :language "utf-8"
           ;;:html-postamble: '(("en" "<hr />[<p class=\"author\">Author: %a (%e)</p> | <p class=\"date\">Last Update: %T</p> | <p class=\"creator\">%c</p> | <p class=\"xhtml-validation\">%v</p>]"))
           :auto-index t)

          ("homepage"
           :base-directory , (expand-file-name (concat org-directory "../homepage"))
           :base-extension "org"
           :publishing-directory , (expand-file-name (concat org-directory "../public_html"))
           :publishing-function org-html-publish-to-html
           :headline-levels 3
           :section-numbers nil
           :table-of-contents nil
           :footnotes t
           :style-include-default nil
           :language "utf-8"
           :html-head "<link rel=\"stylesheet\" href=\"theme/style.css\"  type=\"text/css\" />
<link rel=\"stylesheet\" href=\"theme/facebox.css\"  type=\"text/css\" />"
                                        ;:style "<link rel=\"stylesheet\" href=\"org.css\" type=\"text/css\">"
           :auto-preamble t
           :auto-postamble nil
           :auto-index nil)

          ("notes" :components ("orgfiles"))
          ("webpage" :components ("homepage"))))


  (defun myorg-update-parent-cookie ()
    (when (equal major-mode 'org-mode)
      (save-excursion
        (ignore-errors
          (org-back-to-heading)
          (org-update-parent-todo-statistics)))))

  (defadvice org-kill-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (defadvice kill-whole-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (defun filter-by-tags ()
    (let ((head-tags (org-get-tags-at)))
      (member current-tag head-tags)))

  (defun org-clock-sum-today-by-tags (timerange &optional tstart tend noinsert)
    (interactive "P")
    (let* ((timerange-numeric-value (prefix-numeric-value timerange))
           (files (org-add-archive-files (org-agenda-files)))
           (include-tags '("PROG" "READING" "NOTE" "OTHER" "IDEA" "@Work" "@Self"))
           ;;                         "LEARNING" "OUTPUT" "OTHER"))
           (tags-time-alist (mapcar (lambda (tag) `(,tag . 0)) include-tags))
           (output-string "")
           (tstart (or tstart
                       (and timerange (equal timerange-numeric-value 4)
                            (- (org-time-today) 86400))
                       (and timerange (equal timerange-numeric-value 16)
                            (org-read-date nil nil nil "Start Date/Time:"))
                       (org-time-today)))
           (tend (or tend
                     (and timerange (equal timerange-numeric-value 16)
                          (org-read-date nil nil nil "End Date/Time:"))
                     (+ tstart 86400)))
           h m file item prompt donesomething)
      (while (setq file (pop files))
        (setq org-agenda-buffer (if (file-exists-p file)
                                    (org-get-agenda-file-buffer file)
                                  (error "No such file %s" file)))
        (with-current-buffer org-agenda-buffer
          (dolist (current-tag include-tags)
            (org-clock-sum tstart tend 'filter-by-tags)
            (setcdr (assoc current-tag tags-time-alist)
                    (+ org-clock-file-total-minutes (cdr (assoc current-tag tags-time-alist)))))))
      (while (setq item (pop tags-time-alist))
        (unless (equal (cdr item) 0)
          (setq donesomething t)
          (setq h (/ (cdr item) 60)
                m (- (cdr item) (* 60 h)))
          (setq output-string (concat output-string (format "[-%s-] %.2d:%.2d\n" (car item) h m)))))
      (unless donesomething
        (setq output-string (concat output-string "[-Nothing-] Done nothing!!!\n")))
      (unless noinsert
        (insert output-string))
      output-string))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (R . t)
     (perl . t)
     (ruby . t)
     (python . t)
     (haskell . t)
     (dot . t)
     (ditaa . t)
     (C . nil)
     (latex . t)
     (ipython . t)
     ))

  (defun my-org-archive-done-tasks ()
    (interactive)
    (dolist (tag (list
                  "/DONE"
                  "/CANCELLED"))
      (org-map-entries 'org-archive-subtree tag 'file))
    )
  (setq org-agenda-text-search-extra-files '(agenda-archives))

  (defun zin/org-tag-match-context (&optional todo-only match)
    "Identical search to `org-match-sparse-tree', but shows the content of the matches"
    (interactive "P")
    (org-agenda-prepare-buffers (list (current-buffer)))
    (org-overview)
    (org-remove-occur-highlights)
    (org-scan-tags '(progn (org-show-entry)
                           (org-show-context))
                   (cdr (org-make-tags-matcher match)) todo-only)
    )

  ;; (add-hook 'org-mode-hook
  ;;            (lambda ()
  ;;              (set (make-local-variable 'system-time-locale) "C")))
  
  (set-face-attribute
   'org-table nil
   :fontset (create-fontset-from-fontset-spec
             (concat "-*-*-*-*-*--*-*-*-*-*-*-fontset-orgtable"
                     ",han:Noto Sans Mono CJK SC"
                     ",cjk-misc:Noto Sans Mono CJK SC"))
   :family "Inconsolata" :height (if IS-WINDOWS 1.0 1.1))
  )
