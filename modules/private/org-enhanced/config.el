(use-package! ox-gfm
  :defer t)


(use-package! cdlatex
  :defer t
  :hook (org-mode . turn-on-org-cdlatex))


;; (use-package! org-pomodoro
;;   :defer t
;;   :init (when IS-MAC
;;           (setq org-pomodoro-audio-player "/usr/bin/afplay")))


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
  :init (setq org-pdftools-link-prefix "pdftools")
  :defer t
  :hook (org-load . org-pdftools-setup-link))


(use-package! org-noter
  :after org
  :config
  (setq org-noter-default-notes-file-names '("notes.org")
        org-noter-notes-search-path `(,(concat +my-org-dir "research"))
        org-noter-separate-notes-from-heading t))


(use-package! org-noter-pdftools
  :after org-noter
  :config
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

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
                    "|" "CANCEL(c@/!)" "PHONE")))

  (setq org-todo-state-tags-triggers
        '(("CANCEL" ("CANCEL" . t))
          ("WAIT" ("WAIT" . t))
          ("HOLD" ("WAIT" . t) ("HOLD" . t))
          (done ("WAIT") ("HOLD"))
          ("TODO" ("WAIT") ("CANCEL") ("HOLD"))
          ("ACTIVE" ("WAIT") ("CANCEL") ("HOLD"))
          ("DONE" ("WAIT") ("CANCEL") ("HOLD"))))

  (setq org-columns-default-format "%70ITEM(Task) %10Effort(Effort){:} %20CLOCKSUM")
  (setq org-agenda-log-mode-items '(closed state))

  (setq org-tag-alist '((:startgroup)
                        ("@Work" . ?w)
                        ("@Self" . ?e)
                        ("@Home" . ?h)
                        ("@Outer" . ?o)
                        (:endgroup)
                        ("IDEA" . ?i)
                        ("NOTE" . ?n)
                        ("TIPS" . ?t)
                        ("READING" . ?r)
                        ("WRITE" . ?W)
                        ("PROG" . ?p)
                        ("MEETING" . ?m)
                        ("STUDY" . ?d)
                        ("OTHER" . ?o)
                        ("MARK" . ?M)
                        ("TEAM" . ?T)
                        ("LEARN" . ?l)
                        ("PROJ" . ?j)
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

  (add-hook! org-mode-hook (lambda () (yas-minor-mode -1)))
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

  (setq org-agenda-exporter-settings
        '((ps-number-of-columns 1)
          (ps-landscape-mode t)
          (htmlize-output-type 'css)))

  (defadvice org-kill-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (defadvice kill-whole-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (setq org-agenda-text-search-extra-files '(agenda-archives))

  ;;(set-face-attribute 'org-table nil :family "Sarasa Mono SC")

  (setq org-global-properties
        '(("Effort_ALL" .
           "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))

  (setq org-publish-project-alist '())

  (setq-default system-time-locale "C")

  (pretty-hydra-define
    org-hydra
    (:title "Org Templates"
     :color blue :quit-key "q")
    ("Basic"
     (("a" (hot-expand "<a") "ascii")
      ("c" (hot-expand "<c") "center")
      ("C" (hot-expand "<C") "comment")
      ("e" (hot-expand "<e") "example")
      ("E" (hot-expand "<E") "export")
      ("h" (hot-expand "<h") "html")
      ("l" (hot-expand "<l") "latex")
      ("n" (hot-expand "<n") "note")
      ("o" (hot-expand "<q") "quote")
      ("v" (hot-expand "<v") "verse"))
     "Head"
     (("i" (hot-expand "<i") "index")
      ("A" (hot-expand "<A") "ASCII")
      ("I" (hot-expand "<I") "INCLUDE")
      ("H" (hot-expand "<H") "HTML")
      ("L" (hot-expand "<L") "LaTeX"))
     "Source"
     (("s" (hot-expand "<s") "src")
      ("m" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
      ("y" (hot-expand "<s" "python :results output") "python")
      ("p" (hot-expand "<s" "perl") "perl")
      ("r" (hot-expand "<s" "ruby") "ruby")
      ("S" (hot-expand "<s" "sh") "sh")
      ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang"))
     "Misc"
     (("u" (hot-expand "<s" "plantuml :file CHANGE.png") "plantuml")
      ("Y" (hot-expand "<s" "jupyter-python :session python :exports both :results raw drawer\n$0") "jupyter")
      ("P" (progn
             (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
             (hot-expand "<s" "perl")) "Perl tangled")
      ("<" self-insert-command "ins"))))

  (map! :map org-mode-map
        "<"  #'(lambda ()
                 "Insert org template."
                 (interactive)
                 (if (or (region-active-p) (looking-back "^\s*" 1))
                     (org-hydra/body)
                   (self-insert-command 1))))

  (if (featurep! +jekyll) (load! "+jekyll"))
  (if (featurep! +latex) (load! "+latex"))
  (if (featurep! +html) (load! "+html"))
  ;;(if (featurep! +dragndrop) (load! "~/.emacs.d/modules/lang/org/contrib/dragndrop"))
  ;;(if (featurep! +jupyter) (load! "~/.emacs.d/modules/lang/org/contrib/jupyter"))

  ;;(load! "+protocol")
  (load! "next-spec-day")

  (bh/org-agenda-to-appt)
  (appt-activate t))


(after! org-clock
  (setq  org-clock-persist t
         ;; Resume when clocking into task with open clock
         org-clock-out-remove-zero-time-clocks t
         org-clock-in-switch-to-state "ACTIVE"
         org-clock-persist-query-resume nil
         org-clock-report-include-clocking-task t))


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
                 (:name "Issues"
                  :tag "Issue"
                  :order 12)
                 (:name "Projects"
                  :tag "PROJ"
                  :order 14)
                 (:name "Emacs"
                  :tag "Emacs"
                  :order 13)
                 (:name "Research"
                  :tag ("LEARN" "STUDY")
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


;; (use-package! org-superstar
;;   :hook (org-mode . org-superstar-mode))


(use-package! valign
                                        ;:load-path "~/.doom.d/extensions/valign"
                                        ;:init
                                        ;(require 'valign)
  :hook
  ('org-mode . #'valign-mode))

(use-package! org-clock-budget
  :commands (org-clock-budget-report)
  :init
  (defun my-buffer-face-mode-org-clock-budget ()
    "Sets a fixed width (monospace) font in current buffer"
    (interactive)
    (setq buffer-face-mode-face '(:family "Iosevka" :height 1.0))
    (buffer-face-mode)
    (setq-local line-spacing nil))
  :config
  (map! :map org-clock-budget-report-mode-map
        :nm "h" #'org-shifttab
        :nm "l" #'org-cycle
        :nm "e" #'org-clock-budget-report
        :nm "s" #'org-clock-budget-report-sort
        :nm "d" #'org-clock-budget-remove-budget
        :nm "q" #'quit-window)
  (add-hook! 'org-clock-budget-report-mode-hook
    (toggle-truncate-lines 1)
    (my-buffer-face-mode-org-clock-budget)))

(use-package! gkroam
  :hook (org-load . gkroam-mode)
  :init
  (setq gkroam-root-dir (expand-file-name "roam" +my-org-dir))
  (setq gkroam-prettify-p nil
        gkroam-show-brackets-p t
        gkroam-use-default-filename t
        gkroam-window-margin 4)

  :bind
  (:map gkroam-mode-map
   ("C-c k I" . gkroam-index)
   ("C-c k d" . gkroam-daily)
   ("C-c k D" . gkroam-delete)
   ("C-c k f" . gkroam-find)
   ("C-c k i" . gkroam-insert)
   ("C-c k n" . gkroam-dwim)
   ("C-c k c" . gkroam-capture)
   ("C-c k e" . gkroam-link-edit)
   ("C-c k u" . gkroam-show-unlinked)
   ("C-c k p" . gkroam-toggle-prettify)
   ("C-c k t" . gkroam-toggle-brackets)
   ("C-c k R" . gkroam-rebuild-caches)
   ("C-c k g" . gkroam-update)))


(use-package! org-roam
  ;;:hook (org-load . org-roam-setup)
  :after org
  :custom
  (org-roam-directory (file-truename (concat org-directory "roam")))
  :bind (("C-c o r b" . org-roam-buffer-toggle)
         ("C-c o r f" . org-roam-node-find)
         ("C-c o r g" . org-roam-graph)
         ("C-c o r i" . org-roam-node-insert)
         ("C-c o r c" . org-roam-capture)
         ;; Dailies
         ("C-c o r j" . org-roam-dailies-capture-today))
  :config
  (setq org-roam-v2-ack t)
  (org-roam-setup)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (add-to-list 'org-roam-capture-ref-templates
               '("a" "Annotation" plain (function org-roam-capture--get-point)
                 "%U ${body}\n"
                 :file-name "${slug}"
                 :head "#+title: ${title}\n#+roam_ref: ${ref}\n#+roam_aliases:\n"
                 :immediate-finish t
                 :unnarrowed t)))
