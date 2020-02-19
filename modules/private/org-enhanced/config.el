(use-package! ox-gfm
  :defer t)

(use-package! cdlatex
  :defer t
  :hook (org-mode . turn-on-org-cdlatex))

(use-package! org-pomodoro
  :defer t
  :init (when IS-MAC
          (setq org-pomodoro-audio-player "/usr/bin/afplay")))

;; (use-package! deft
;;   :config
;;   (setq deft-directory (concat +my-org-dir "deft/")
;;         deft-recursive t
;;         deft-auto-save-interval 10.0
;;         deft-file-naming-rules '((nospace . "-")
;;                                  (case-fn . downcase))))

(use-package! notdeft
  :config

  (setq notdeft-extension "org")
  ;;(setq notdeft-secondary-extensions '("md" "org" "muse"))
  (setq notdeft-directories `(,(concat +my-org-dir "research")
                              ,(concat +my-org-dir "deft")
                              ,(concat +my-org-dir "notes")
                              ,(expand-file-name (concat +my-org-dir "../blog/_posts"))
                              ;;,(expand-file-name (concat +my-org-dir "../source"))
                              ))
  (setq notdeft-sparse-directories `(("~" . (,(concat +my-org-dir "webclip.org")))))
  (setq notdeft-xapian-program (executable-find "notdeft-xapian"))
  :bind (:map notdeft-mode-map
          ("C-q" . notdeft-quit)
          ("C-r" . notdeft-refresh)))

(use-package! org-pdftools
  :defer t
  ;;:load-path "~/.doom.d/extensions/org-pdftools"
  :init (setq org-pdftools-search-string-seperator "??")
  :config (setq org-pdftools-root-dir +my-org-dir)
  )

(use-package! org-noter
  :after org
  :config
  (setq org-noter-default-notes-file-names '("notes.org")
        org-noter-notes-search-path `(,(concat +my-org-dir "research"))
        org-noter-separate-notes-from-heading t)
  )

(use-package! org-noter-pdftools
  :after org-noter
  ;;:load-path "~/.doom.d/extensions/org-pdftools"
  )

(use-package! org-ref
  :after org
  :init
  (setq org-ref-directory (concat +my-org-dir "bib/"))
  (setq reftex-default-bibliography `(,(concat org-ref-directory "ref.bib"))
        org-ref-bibliography-notes (concat org-ref-directory "notes.org")
        org-ref-default-bibliography `(,(concat org-ref-directory "ref.bib"))
        org-ref-pdf-directory (concat org-ref-directory "pdfs")))

(use-package! ivy-bibtex
  :after org-ref
  :config
  (setq bibtex-completion-bibliography
        `(,(concat org-ref-directory "ref.bib")))
  (setq bibtex-completion-library-path
        `(,(concat org-ref-directory "pdfs")))

  ;; using bibtex path reference to pdf file
  (setq bibtex-completion-pdf-field "File")

  (setq ivy-bibtex-default-action 'bibtex-completion-insert-citation))

(use-package! org
  :defer-incrementally
  calendar find-func format-spec org-macs org-compat org-faces org-entities
  org-list org-pcomplete org-src org-footnote org-macro ob org org-agenda
  org-capture
  :preface
  (setq org-directory +my-org-dir
        org-aganda-directory (concat +my-org-dir "agenda/")
        org-agenda-diary-file (concat org-directory "diary.org")
        org-default-notes-file (concat org-directory "note.org")
        ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
        ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
        org-agenda-files `(,(concat org-aganda-directory "planning.org")
                           ,(concat org-aganda-directory "notes.org")
                           ,(concat org-aganda-directory "work.org")))
  (setq auto-coding-alist
        (append auto-coding-alist '(("\\.org\\'" . utf-8))))
  :config
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

  ;; ;; org-capture
  ;; (defun org-capture-template-goto-link ()
  ;;   (org-capture-put :target (list 'file+headline
  ;;                                  (nth 1 (org-capture-get :target))
  ;;                                  (org-capture-get :annotation)))
  ;;   (org-capture-put-target-region-and-position)
  ;;   (widen)
  ;;   (let ((hd (nth 2 (org-capture-get :target))))
  ;;     (goto-char (point-min))
  ;;     (if (re-search-forward
  ;;          (format org-complex-heading-regexp-format (regexp-quote hd)) nil t)
  ;;         (org-end-of-subtree)
  ;;       (goto-char (point-max))
  ;;       (or (bolp) (insert "\n"))
  ;;      (insert "* " hd "\n"))))

  (setq org-capture-templates
        '(("s" "scheduled task" entry
           (file+headline "agenda/planning.org" "Task List")
           "* TODO %?\nSCHEDULED: %^t\n"
           :clock-in nil)
          ("t" "todo" entry
           (file+headline  "agenda/planning.org" "Task List")
           "* TODO %?\n:PROPERTIES:\n:CATEGORY: task\n:END:\n"
           :clock-in t :clock-resume t)
          ("r" "respond" entry
           (file  "notes.org")
           "* TODO Respond to %:from on %:subject\n:PROPERTIES:\n:CATEGORY: task\n:END:\n%a\n"
           :clock-in t :clock-resume t :immediate-finish t)
          ("n" "note" entry
           (file+headline  "agenda/notes.org" "Notes")
           "* TODO %? :NOTE:\n%a\n"
           :clock-in t :clock-resume t)
          ("j" "Journal" entry
           (file+olp+datetree  "diary.org")
           "* %?\n%U\n"
           :clock-in t :clock-resume t)
          ;; ("l" "org-protocol" plain ;;(file+function "notes.org" org-capture-template-goto-link)
          ;;  ;;"%?\n%i\n%U\n %:initial" :immediate-finish t)
          ;;  (file+function "notes.org" org-capture-template-goto-link)
          ;;  " %:initial\n%U\n"
          ;; :empty-lines 1)
          ("w" "Link" entry
           (file+headline "agenda/planning.org" "Idea List")
           "* TODO %:annotation\n:PROPERTIES:\n:CATEGORY: link\n:END:\n%i\n%U\n"
           :immediate-finish t :kill-buffer t)
          ("p" "Phone/Email" entry
           (file+headline  "agenda/planning.org" "Reminder List")
           "* TODO %? \n:PROPERTIES:\n:CATEGORY: reminder\n:END:\n"
           :clock-in t :clock-resume t)
          ("h" "Habit" entry
           (file+headline  "agenda/notes.org" "Habit")
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

  (setq org-refile-target-verify-function 'bh/verify-refile-target)

  (require 'org-expiry)
  ;; Configure it a bit to my liking
  (setq
   org-expiry-created-property-name "CREATED"
   ;; Name of property when an item is created
   org-expiry-inactive-timestamps t
   ;; Don't have everything in the agenda view
   )

 ;;; define mrb/insert-created-timestamp
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
  ;;; define mrb/add-tags-in-capture
  ;; Bind this to a reasonable key

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; CLOCK ;;;;;;;;;;;;;;;;
  ;;
  
  ;;
  ;; Show lot sof clocking history so it's easy to pick items off the C-F11 list
  ;; Separate drawers for clocking and logs
  ;;(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  
  ;; Clock out when moving task to a done state
  
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  
  ;; Do not prompt to resume an active clock
  ;; Include current clocking task in clock reports
  
  


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



  ;;(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)



  (setq org-enforce-todo-dependencies t)
  ;;(setq org-deadline-warning-days 30)

  ;; Erase all reminders and rebuilt reminders for today from the agenda


  ;; Rebuild the reminders everytime the agenda is displayed
  (add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)

  ;; This is at the end of my .emacs - so appointments are set up when Emacs starts
  ;;(bh/org-agenda-to-appt)

  ;; Activate appointments so we get notifications
  ;; (appt-activate t)

  ;; If we leave Emacs running overnight - reset the appointments one minute after midnight
  (run-at-time "24:01" nil 'bh/org-agenda-to-appt)

  (setq org-export-with-timestamps nil)
  ;;(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

  (require 'org-tempo)


  (setq org-agenda-exporter-settings
        '((ps-number-of-columns 1)
          (ps-landscape-mode t)
          (htmlize-output-type 'css)))





  (defadvice org-kill-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (defadvice kill-whole-line (after fix-cookies activate)
    (myorg-update-parent-cookie))





  (setq org-agenda-text-search-extra-files '(agenda-archives))

  ;; (defun zin/org-tag-match-context (&optional todo-only match)
  ;;   "Identical search to `org-match-sparse-tree', but shows the content of the matches"
  ;;   (interactive "P")
  ;;   (org-agenda-prepare-buffers (list (current-buffer)))
  ;;   (org-overview)
  ;;   (org-remove-occur-highlights)
  ;;   (org-scan-tags '(progn (org-show-entry)
  ;;                          (org-show-context))
  ;;                  (cdr (org-make-tags-matcher match)) todo-only)
  ;;   )

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
  (if (featurep! +dragndrop) (load! "~/.emacs.d/modules/lang/org/contrib/dragndrop"))
  (if (featurep! +jupyter) (load! "~/.emacs.d/modules/lang/org/contrib/jupyter"))

  (load! "+protocol")
  (load! "next-spec-day")

  (bh/org-agenda-to-appt)
  (appt-activate t)
  )

(use-package! org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1)
  (setq org-agenda-custom-commands
        '(("z" "Super agenda view"
           ((agenda
             ""
             ((org-agenda-span 'day)
              (org-super-agenda-groups
               '((:name "Today"
                        :time-grid t
                        :date today
                        :todo "TODAY"
                        :scheduled today
                        :order 1)
                 (:name "Planned"
                        :time-grid t
                        :todo t
                        :order 2)
                 ))))
            (alltodo
             ""
             ((org-agenda-overriding-header "")
              (org-super-agenda-groups
               '((:name "Next"
                        :and (:scheduled nil
                                         :deadline nil
                                         :category ("task" "link" "capture"))
                        :date today
                        :order 1
                        )
                 (:name "Important"
                        :tag "Important"
                        :priority "A"
                        :order 6)
                 (:name "Due Today"
                        :deadline today
                        :order 2)
                 (:name "Due Soon"
                        :deadline future
                        :order 8)
                 (:name "Overdue"
                        :deadline past
                        :order 7)
                 ;; (:name "Assignments"
                 ;;        :tag "Assignment"
                 ;;        :order 10)
                 (:name "Issues"
                        :tag "Issue"
                        :order 12)
                 (:name "Projects"
                        :tag "Project"
                        :order 14)
                 (:name "Emacs"
                        :tag "Emacs"
                        :order 13)
                 (:name "Research"
                        :tag "LEARN"
                        :order 15)
                 (:name "To read"
                        :and (:tag "READING"
                                   :not (:tag ("HOLD" "WAIT")))
                        :order 16)

                 (:name "SomeDay"
                        :priority<= "C"
                        :tag ("WAIT" "HOLD")
                        :todo ("SOMEDAY" )
                        :order 90))))))))))

(use-package! org-clock ; built-in
  :commands org-clock-save
  :init
  (setq org-clock-persist-file (concat doom-etc-dir "org-clock-save.el"))
  (defadvice! +org--clock-load-a (&rest _)
    "Lazy load org-clock until its commands are used."
    :before '(org-clock-in
              org-clock-out
              org-clock-in-last
              org-clock-goto
              org-clock-cancel)
    (org-clock-load))
  :config
  (setq org-clock-persist 'history
        ;; Resume when clocking into task with open clock
        org-clock-in-resume t
        org-clock-out-remove-zero-time-clocks t
        org-clock-in-switch-to-state 'bh/clock-in-to-next
        org-clock-report-include-clocking-task t)
  (add-hook 'kill-emacs-hook #'org-clock-save))


(use-package! org-crypt ; built-in
  :commands org-encrypt-entries
  :hook (org-reveal-start . org-decrypt-entry)
  :config
  (add-hook! 'org-mode-hook
    (add-hook 'before-save-hook 'org-encrypt-entries nil t))
  (add-to-list 'org-tags-exclude-from-inheritance "crypt")
  (setq org-crypt-key user-mail-address))


(use-package! org-bullets ; "prettier" bullets
  :hook (org-mode . org-bullets-mode))

(use-package! toc-org ; auto-table of contents
  :hook (org-mode . toc-org-enable)
  :config (setq toc-org-hrefify-default "gh"))
