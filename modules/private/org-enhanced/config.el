(use-package! ox-gfm
  :defer t)


(use-package! cdlatex
  :defer t
  :hook (org-mode . turn-on-org-cdlatex))


(use-package! org-pomodoro
  :defer t
  :init (when IS-MAC
          (setq org-pomodoro-audio-player "/usr/bin/afplay")))


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
  :after org
  ;;:load-path "~/.doom.d/extensions/org-pdftools"
  :init (setq org-pdftools-search-string-seperator "??")
  :config (setq org-pdftools-root-dir +my-org-dir)
  ;;with-eval-after-load 'org
  (org-link-set-parameters "pdftools"
                           :follow #'org-pdftools-open
                           :complete #'org-pdftools-complete-link
                           :store #'org-pdftools-store-link
                           :export #'org-pdftools-export)
  (add-hook 'org-store-link-functions 'org-pdftools-store-link)
  )


(use-package! org-noter
  :after org
  :config
  (setq org-noter-default-notes-file-names '("notes.org")
        org-noter-notes-search-path `(,(concat +my-org-dir "research"))
        org-noter-separate-notes-from-heading t))


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


(after! org

  ;; (remove-hook 'org-load-hook #'+org-init-agenda-h)
  ;; (remove-hook 'org-load-hook #'+org-init-capture-defaults-h)
  (setq org-directory +my-org-dir
        org-aganda-directory (concat +my-org-dir "agenda/")
        org-agenda-diary-file (concat  org-directory "diary.org")
        org-default-notes-file (concat org-directory "note.org")
        ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
        ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
        org-agenda-files `(,(concat org-aganda-directory "planning.org")
                           ,(concat org-aganda-directory "notes.org")
                           ,(concat org-aganda-directory "work.org")))
  (setq auto-coding-alist
        (append auto-coding-alist '(("\\.org\\'" . utf-8))))

  (setq org-agenda-span 'week
        org-agenda-start-on-weekday nil
        org-agenda-start-day nil)
  ;;:config
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
  (setq org-tags-column -77)
  ;; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)

  (setq org-hide-leading-stars nil)
  (setq org-cycle-separator-lines 0)
  (setq org-blank-before-new-entry '((heading)
                                     (plain-list-item . auto)))
  (setq org-insert-heading-respect-content nil)
  (setq org-startup-truncated nil)

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
           "* TODO %:annotation\n:PROPERTIES:\n:CATEGORY: link\n:END:\n%i\n"
           :immediate-finish t :kill-buffer t)
          ("p" "Phone/Email" entry
           (file+headline  "agenda/planning.org" "Reminder List")
           "* TODO %? \n:PROPERTIES:\n:CATEGORY: reminder\n:END:\n"
           :clock-in t :clock-resume t)
          ("h" "Habit" entry
           (file+headline  "agenda/notes.org" "Habit")
           "* ACTIVE %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: ACTIVE\n:END:\n")))

  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  ;; (setq org-refile-targets '((nil :maxlevel . 9)
  ;;                            (org-agenda-files :maxlevel . 9)))

  ;; Use full outline paths for refile targets - we file directly with IDO
  ;; (setq org-refile-use-outline-path t)

  ;; Targets complete directly with IDO
  ;; (setq org-outline-path-complete-in-steps nil)

  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  (setq org-refile-target-verify-function 'bh/verify-refile-target)

  (require 'org-expiry)
  ;; Configure it a bit to my liking
  (setq org-expiry-created-property-name "CREATED"
        org-expiry-inactive-timestamps t)

  (add-hook 'org-after-todo-state-change-hook
            (lambda ()
              (when (string= org-state "TODO")
                (save-excursion
                  (org-back-to-heading)
                  (org-expiry-insert-created)))))

  (setq org-enforce-todo-dependencies t)

  ;; Rebuild the reminders everytime the agenda is displayed
  (add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)

  ;; If we leave Emacs running overnight - reset the appointments one minute after midnight
  (run-at-time "24:01" nil 'bh/org-agenda-to-appt)

  (setq org-export-with-timestamps nil)

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

  (set-face-attribute 'org-table nil :family "Sarasa Mono SC")

  (setq org-global-properties
        '(("Effort_ALL" .
           "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))

  (setq org-publish-project-alist '())

  (setq-default system-time-locale "C")

  (if (featurep! +jekyll) (load! "+jekyll"))
  (if (featurep! +latex) (load! "+latex"))
  (if (featurep! +html) (load! "+html"))
  ;;(if (featurep! +dragndrop) (load! "~/.emacs.d/modules/lang/org/contrib/dragndrop"))
  ;;(if (featurep! +jupyter) (load! "~/.emacs.d/modules/lang/org/contrib/jupyter"))

  ;;(load! "+protocol")
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


(use-package! org-superstar
  :hook (org-mode . org-superstar-mode))


