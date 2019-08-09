(def-package! ox-gfm
  :defer t)

(def-package! cdlatex
  :defer t
  :hook (org-mode . turn-on-org-cdlatex))

(def-package! org-pomodoro
  :defer t
  :init (when IS-MAC
          (setq org-pomodoro-audio-player "/usr/bin/afplay")))

(def-package! deft
  :config
  (setq deft-directory (concat +my-org-dir "deft/")
        deft-recursive t
        deft-auto-save-interval 10.0
        deft-file-naming-rules '((nospace . "-")
                                 (case-fn . downcase))))

(def-package! org-noter
  :after org
  :config
  (setq org-noter-default-notes-file-names '("notes.org")
        org-noter-notes-search-path `(,(concat +my-org-dir "research"))
        org-noter-separate-notes-from-heading t))

(def-package! org-pdftools
  :load-path "~/.doom.d/extensions/org-pdftools")

(def-package! org-ref
  :after org
  :init
  (setq org-ref-directory (concat +my-org-dir "bib/"))
  (setq reftex-default-bibliography `(,(concat org-ref-directory "ref.bib"))
        org-ref-bibliography-notes (concat org-ref-directory "notes.org")
        org-ref-default-bibliography `(,(concat org-ref-directory "ref.bib"))
        org-ref-pdf-directory (concat org-ref-directory "pdfs")))

(def-package! ivy-bibtex
  :after org-ref
  :config
  (setq bibtex-completion-bibliography
        `(,(concat org-ref-directory "ref.bib")))
  (setq bibtex-completion-library-path
        `(,(concat org-ref-directory "pdfs")))

  ;; using bibtex path reference to pdf file
  (setq bibtex-completion-pdf-field "File")

  (setq ivy-bibtex-default-action 'bibtex-completion-insert-citation))

(after! org
  (setq org-directory +my-org-dir
        org-agenda-diary-file (concat org-directory "diary.org")
        org-default-notes-file (concat org-directory "refile.org")
        ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
        ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
        org-agenda-files `(,(concat org-directory "planning.org")
                           ,(concat org-directory "notes.org")
                           ,(concat org-directory "work.org")))
  (setq auto-coding-alist
        (append auto-coding-alist '(("\\.org\\'" . utf-8))))

  (setq org-log-done 'note
        org-log-redeadline 'note
        org-log-reschedule 'note
        org-log-into-drawer "LOGBOOK"
        org-deadline-warning-days 14 ;; two weeks enough
        org-agenda-compact-blocks t
        org-agenda-start-on-weekday nil
        org-agenda-insert-diary-extract-time t

        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-timestamp-if-done t
        org-agenda-skip-timestamp-if-deadline-is-shown t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown t)

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
                        ("@Ideas" . ?i)
                        (:endgroup)
                        ("PERSONAL" . ?P)
                        ("READING" . ?r)
                        ("PROG" . ?p)
                        ("SOFT" . ?s)
                        ("MEETING" . ?M)
                        ("OTHER" . ?o)
                        ("NOTE" . ?N)
                        ("TIPS" . ?t)
                        ("MARK" . ?m)
                        ("TEAM" . ?T)
                        ("OUTER" .?O)
                        ("LEARN" .?l)
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
  (defun org-capture-template-goto-link ()
  (org-capture-put :target (list 'file+headline
                                 (nth 1 (org-capture-get :target))
                                 (org-capture-get :annotation)))
  (org-capture-put-target-region-and-position)
  (widen)
  (let ((hd (nth 2 (org-capture-get :target))))
    (goto-char (point-min))
    (if (re-search-forward
         (format org-complex-heading-regexp-format (regexp-quote hd)) nil t)
        (org-end-of-subtree)
      (goto-char (point-max))
      (or (bolp) (insert "\n"))
      (insert "* " hd "\n"))))

  (setq org-capture-templates
        '(("t" "todo" entry (file  "refile.org")
           "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
          ("r" "respond" entry (file  "refile.org")
           "* TODO Respond to %:from on %:subject\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
          ("n" "note" entry (file  "refile.org")
           "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
          ("j" "Journal" entry (file+olp+datetree  "diary.org")
           "* %?\n%U\n" :clock-in t :clock-resume t)
          ("l" "org-protocol" plain ;;(file+function "notes.org" org-capture-template-goto-link)
           ;;"%?\n%i\n%U\n %:initial" :immediate-finish t)
           (file+function "notes.org" org-capture-template-goto-link)
           " %:initial\n%U\n" :empty-lines 1)
          ("w" "Link" entry (file+headline "notes.org" "Web Clip")
            "* %:annotation\n%i\n%U\n" :immediate-finish t :kill-buffer t)
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

  ;;   (defun bh/punch-in (arg)
  ;;     "Start continuous clocking and set the default task to the
  ;; selected task.  If no task is selected set the Organization task
  ;; as the default task."
  ;;     (interactive "p")
  ;;     (setq bh/keep-clock-running t)
  ;;     (if (equal major-mode 'org-agenda-mode)
  ;;         ;;
  ;;         ;; We're in the agenda
  ;;         ;;
  ;;         (let* ((marker (org-get-at-bol 'org-hd-marker))
  ;;                (tags (org-with-point-at marker (org-get-tags-at))))
  ;;           (if (and (eq arg 4) tags)
  ;;               (org-agenda-clock-in '(16)))))
  ;;     ;;
  ;;     ;; We are not in the agenda
  ;;     ;;
  ;;     (save-restriction
  ;;       (widen)
  ;;       ;; Find the tags on the current task
  ;;       (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
  ;;           (org-clock-in '(16)))))

  ;;   (defun bh/punch-out ()
  ;;     (interactive)
  ;;     (setq bh/keep-clock-running nil)
  ;;     (when (org-clock-is-active)
  ;;       (org-clock-out))
  ;;     (org-agenda-remove-restriction-lock))

  ;;   (defun bh/clock-in-default-task ()
  ;;     (save-excursion
  ;;       (org-with-point-at org-clock-default-task
  ;;         (org-clock-in))))

  ;;   (defun bh/clock-in-parent-task ()
  ;;     "Move point to the parent (project) task if any and clock in"
  ;;     (let ((parent-task))
  ;;       (save-excursion
  ;;         (save-restriction
  ;;           (widen)
  ;;           (while (and (not parent-task) (org-up-heading-safe))
  ;;             (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
  ;;               (setq parent-task (point))))
  ;;           (if parent-task
  ;;               (org-with-point-at parent-task
  ;;                 (org-clock-in))
  ;;             (when bh/keep-clock-running
  ;;              (bh/clock-in-default-task)))))))

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
  ;;(setq org-deadline-warning-days 30)

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


  (setq org-agenda-exporter-settings
        '((ps-number-of-columns 1)
          (ps-landscape-mode t)
          (htmlize-output-type 'css)))



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

  (defun org-time-today ()
  "Time in seconds today at 0:00.
Returns the float number of seconds since the beginning of the
epoch to the beginning of today (00:00)."
  (float-time (apply 'encode-time
                     (append '(0 0 0) (nthcdr 3 (decode-time))))))

  (defun filter-by-tags ()
    (let ((head-tags (org-get-tags-at)))
      (member current-tag head-tags)))

  (defun org-clock-sum-today-by-tags (timerange &optional tstart tend noinsert)
    (interactive "P")
    (let* ((timerange-numeric-value (prefix-numeric-value timerange))
           (files (org-add-archive-files (org-agenda-files)))
           (include-tags '("PROG" "READING" "NOTE" "OTHER" "@Work" "@Self" "MEETING"))
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


  (defun bh-archive-done-tasks ()
    (interactive)
    (dolist (tag (list
                  "/DONE"
                  "/CANCELLED"))
      (org-map-entries 'org-archive-subtree tag 'file))
    )

 (defun my-archive-done-tasks ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward
            (concat "\\* " (regexp-opt org-done-keywords) " ") nil t)
      (goto-char (line-beginning-position))
      (org-archive-subtree))))

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

  ;;(add-hook 'org-mode-hook 'turn-off-smartparens-mode)
  ;; (set-face-attribute
  ;;  'org-table nil
  ;;  :fontset (create-fontset-from-fontset-spec
  ;;            (concat "-*-*-*-*-*--*-*-*-*-*-*-fontset-orgtable"
  ;;                    ",han:Sarasa Mono SC"
  ;;                    ",cjk-misc:Sarasa Mono SC"))
  ;;  :family "Sarasa Mono SC")

  (set-face-attribute 'org-table nil :family "Sarasa Mono SC")

  (setq org-publish-project-alist '())

  (setq-default system-time-locale "C")

  (if (featurep! +jekyll) (load! "+jekyll"))
  (if (featurep! +latex) (load! "+latex"))
  (if (featurep! +html) (load! "+html"))
  (load! "next-spec-day")
  )

