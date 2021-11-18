;;; +bindings.el --- description -*- lexical-binding: t; -*-

(map!

 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Defaults
 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 "M-s-<right>" #'other-frame
 "M-s-<left>"  #'other-frame

 "s-<up>"    #'windmove-up
 "s-<right>" #'windmove-right
 "s-<left>"  #'windmove-left
 "s-<down>"  #'windmove-down

 ;;"C-s"       #'my-isearch-or-consult
 ;;"C-r"       #'consult-isearch-backward
 "C-S-s"     #'isearch-forward
 "C-x k"     #'ido-kill-buffer
 "C-x K"     #'doom/kill-this-buffer-in-all-windows
 "C-x b"     #'switch-to-buffer
 "C-x B"     #'persp-switch-to-buffer

 ;;"M-l"       #'pyim-convert-string-at-point
 ;;"C-;"       #'pyim-delete-word-from-personal-buffer

 "C-c C-y"   #'company-yasnippet

 

 ;; ;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Doom
 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (:leader

   ;; (:prefix ("a" . "application")
   ;;   :desc "Snails"            "s" #'snails
   ;;   :desc "Elfeed Rss Reader" "r" #'elfeed
   ;;   :desc "Org Noter"         "n" #'org-noter)
   

   (:prefix ("c" . "code")
     
     (:prefix ("g" . "Go to")
       :desc "Implementation"            "i" #'eglot-find-implementation
       ;;:desc "Definition"                "d" #'lsp-goto-type-definition
       :desc "Definition"                "d" #'xref-find-definitions
       ;;:desc "Find Definition"           "D" #'lsp-find-definition
       :desc "Find Definition"           "D" #'eglot-find-typeDefinition
       
       :desc "Find References"           "r" #'xref-find-references))
   

   (:prefix ("d" . "doom")
     :desc "Dashboard"                   "d" #'+doom-dashboard/open
     :desc "Recent files"                "f" #'recentf-open-files
     (:when (featurep! :ui neotree)
       :desc "Open neotree"              "n" #'+neotree/open
       :desc "File in neotree"           "N" #'neotree/find-this-file)
     (:when (featurep! :ui treemacs)
       :desc "Toggle treemacs"           "n" #'+treemacs/toggle
       :desc "File in treemacs"          "N" #'+treemacs/find-file)
     :desc "Popup other"                 "o" #'+popup/other
     :desc "Popup toggle"                "t" #'+popup/toggle
     :desc "Popup close"                 "c" #'+popup/close
     :desc "Popup close all"             "C" #'+popup/close-all
     :desc "Popup raise"                 "r" #'+popup/raise
     :desc "Popup restore"               "R" #'+popup/restore
     :desc "Scratch buffer"              "s" #'doom/open-scratch-buffer
     :desc "Switch to scratch buffer"    "S" #'doom/switch-to-scratch-buffer
     :desc "Sudo this file"              "u" #'doom/sudo-this-file
     :desc "Sudo find file"              "U" #'doom/sudo-find-file
     ;; :desc "Terminal open popup"         "l" #'+private/term-open-popup
     ;; :desc "Terminal open"               "L" #'+private/term-open
     :desc "Terminal open popup"         "l" #'multi-term-dedicated-toggle
     :desc "Terminal open"               "L" #'multi-term
     :desc "Reload Private Config"       "R" #'doom/reload
     :desc "Open Lsip REPL"              ";" #'+eval/open-repl
     :desc "Toggle frame fullscreen"     "F" #'toggle-frame-fullscreen
     :desc "Toggle modal edition mode"   "m" #'modalka-global-mode
     :desc "Switch compilation database" "b" #'+private/switch-compilation-database)

   "e" nil
   (:prefix ("e" . "editor")
     :desc "Switch header/source" "s" #'ff-find-other-file
     :desc "Make header"          "m" #'make-header
     :desc "Make box comment"     "b" #'make-box-comment
     :desc "Make divider"         "d" #'make-divider
     :desc "Make revision"        "r" #'make-revision
     :desc "Update file header"   "g" #'update-file-header
     :desc "Sdcv input"           "i" #'sdcv-search-input
     :desc "Sdcv point+"          "p" #'sdcv-search-pointer+
     (:after thing-edit
       (:prefix ("c" . "Thing Edit Copy")
         :desc "thing-copy-defun"    "d" #'thing-copy-defun
         :desc "thing-copy-line"     "l" #'thing-copy-line
         :desc "thing-copy-sexp"     "s" #'thing-copy-sexp
         :desc "thing-copy-word"     "w" #'thing-copy-word
         :desc "thing-copy-symbol"   "b" #'thing-copy-symbol
         :desc "thing-copy-filename" "f" #'thing-copy-filename
         :desc "thing-copy-list"     "t" #'thing-copy-list
         :desc "thing-copy-sentence" "c" #'thing-copy-sentence
         :desc "thing-copy-paragrah" "p" #'thing-copy-paragraph
         :desc "thing-copy-page"     "g" #'thing-copy-page
         :desc "thing-copy-url"      "u" #'thing-copy-url
         :desc "thing-copy-email"    "e" #'thing-copy-email
         :desc "thing-copy-comment"  ";" #'thing-copy-comment
         :desc "thing-copy-number"   "n" #'thing-copy-number)
       (:prefix ("x" . "Thing Edit Cut")
         :desc "thing-cut-defun"    "d" #'thing-cut-defun
         :desc "thing-cut-line"     "l" #'thing-cut-line
         :desc "thing-cut-sexp"     "s" #'thing-cut-sexp
         :desc "thing-cut-word"     "w" #'thing-cut-word
         :desc "thing-cut-symbol"   "b" #'thing-cut-symbol
         :desc "thing-cut-filename" "f" #'thing-cut-filename
         :desc "thing-cut-list"     "t" #'thing-cut-list
         :desc "thing-cut-sentence" "c" #'thing-cut-sentence
         :desc "thing-cut-paragrah" "p" #'thing-cut-paragraph
         :desc "thing-cut-page"     "g" #'thing-cut-page
         :desc "thing-cut-url"      "u" #'thing-cut-url
         :desc "thing-cut-email"    "e" #'thing-cut-email
         :desc "thing-cut-comment"  ";" #'thing-cut-comment
         :desc "thing-cut-number"   "n" #'thing-cut-number)
       (:prefix ("a" . "Thing Edit Replace")
        :desc "thing-replace-defun"    "d" #'thing-replace-defun
        :desc "thing-replace-line"     "l" #'thing-replace-line
        :desc "thing-replace-sexp"     "s" #'thing-replace-sexp
        :desc "thing-replace-word"     "w" #'thing-replace-word
        :desc "thing-replace-symbol"   "b" #'thing-replace-symbol
        :desc "thing-replace-filename" "f" #'thing-replace-filename
        :desc "thing-replace-list"     "t" #'thing-replace-list
        :desc "thing-replace-sentence" "c" #'thing-replace-sentence
        :desc "thing-replace-paragrah" "p" #'thing-replace-paragraph
        :desc "thing-replace-page"     "g" #'thing-replace-page
        :desc "thing-replace-url"      "u" #'thing-replace-url
        :desc "thing-replace-email"    "e" #'thing-replace-email
        :desc "thing-replace-comment"  ";" #'thing-replace-comment
        :desc "thing-replace-number"   "n" #'thing-replace-number)))
   (:prefix ("f" . "file")
     :desc "Find git file"        "g" #'consult-git-grep)

   "g" nil
   (:after eglot
     (:prefix ("g" . "Goto")
       :desc "Implementation"            "i" #'eglot-find-implementation
       ;;:desc "Definition"                "d" #'lsp-goto-type-definition
       :desc "Definition"                "d" #'xref-find-definitions
       ;;:desc "Find Definition"           "D" #'lsp-find-definition
       :desc "Find Definition"           "D" #'eglot-find-typeDefinition
       
       :desc "Find References"           "r" #'xref-find-references))
       

   "o" nil ;; default keybinding for org agenda is too complicated
   (:prefix ("o". "org")
     :desc "Search notes for symbol"  "." #'+default/search-notes-for-symbol-at-point
     :desc "Do what I mean"           "w" #'+org/dwim-at-point
     :desc "Blog of github"           "B" #'my-pages-start-post
     ;; :desc "NotDeft"                  "d" #'notdeft
     :desc "Clock in"                 "i" #'org-clock-in
     :desc "Clock in recent"          "I" #'my/org-clock-in
     :desc "Clock out"                "o" #'org-clock-out
     :desc "Pomodoro"                 "m" #'org-pomodoro
     :desc "Agenda"                   "a" #'org-agenda
     :desc "Todo List"                "t" #'org-todo-list
     :desc "Tags view"                "g" #'org-tags-view
     :desc "View Search"              "v" #'org-search-view
     :desc "Browse notes"             "f" #'+default/browse-notes
     :desc "Search org-directory"     "s" #'+default/org-notes-search
     :desc "Switch org buffers"       "b" #'org-switchb
     :desc "Capture"                  "c" #'org-capture
     :desc "Goto capture"             "C" #'org-capture-goto-target
     :desc "Link store"               "l" #'org-store-link
     :desc "Sync org caldav"          "S" #'org-caldav-sync
     :desc "Mark default task"        "T" #'org-clock-mark-default-task
     
     (:prefix ("e" . "org export")
       :desc "Export beamer to latex" "l b" #'org-beamer-export-to-latex
       :desc "Export beamer as latex" "l B" #'org-beamer-export-as-latex
       :desc "Export beamer as pdf"   "l P" #'org-beamer-export-to-pdf)
     (:prefix ("P" . "publish")
       :desc "Publish current file"     "f" #'org-publish-current-file
       :desc "Publish current project"  "p" #'org-publish-current-project)
     (:prefix ("p" . "clock punch")
       :desc "Punch In"                 "i" #'bh/punch-in
       :desc "Punch Out"                "o" #'bh/punch-out)
     (:prefix ("r" . "roam")
         :desc "Open random node"           "a" #'org-roam-node-random
         :desc "Find node"                  "f" #'org-roam-node-find
         :desc "Find ref"                   "F" #'org-roam-ref-find
         :desc "Show graph"                 "g" #'org-roam-graph
         :desc "Insert node"                "i" #'org-roam-node-insert
         :desc "Capture to node"            "n" #'org-roam-capture
         :desc "Toggle roam buffer"         "r" #'org-roam-buffer-toggle
         :desc "Launch roam buffer"         "R" #'org-roam-buffer-display-dedicated
         :desc "Sync database"              "s" #'org-roam-db-sync
         (:prefix ("d" . "by date")
          :desc "Goto previous note"        "b" #'org-roam-dailies-goto-previous-note
          :desc "Goto date"                 "d" #'org-roam-dailies-goto-date
          :desc "Capture date"              "D" #'org-roam-dailies-capture-date
          :desc "Goto next note"            "f" #'org-roam-dailies-goto-next-note
          :desc "Goto tomorrow"             "m" #'org-roam-dailies-goto-tomorrow
          :desc "Capture tomorrow"          "M" #'org-roam-dailies-capture-tomorrow
          :desc "Capture today"             "n" #'org-roam-dailies-capture-today
          :desc "Goto today"                "t" #'org-roam-dailies-goto-today
          :desc "Capture today"             "T" #'org-roam-dailies-capture-today
          :desc "Goto yesterday"            "y" #'org-roam-dailies-goto-yesterday
          :desc "Capture yesterday"         "Y" #'org-roam-dailies-capture-yesterday
          :desc "Find directory"            "-" #'org-roam-dailies-find-directory)))

   ;;"&" nil

   ;; (:prefix ("s" . "snippets")
   ;;   :desc "New snippet"           "n" #'yas-new-snippet
   ;;   :desc "Insert snippet"        "i" #'yas-insert-snippet
   ;;   :desc "Find global snippet"   "v" #'yas-visit-snippet-file
   ;;   :desc "Reload snippets"       "r" #'yas-reload-all)

   (:prefix ("t" . "toggle")
     :desc "Flyspell"                      "s" #'flyspell-mode
     :desc "Flycheck"                      "f" #'flycheck-mode
     :desc "Line numbers"                  "l" #'doom/toggle-line-numbers
     :desc "Frame fullscreen"              "F" #'toggle-frame-fullscreen
     :desc "Indent guides"                 "i" #'highlight-indent-guides-mode
     :desc "Impatient mode"                "m" #'+impatient-mode/toggle
     :desc "Big mode"                      "b" #'doom-big-font-mode
     :desc "org-tree-slide mode"           "p" #'+org-present/start
     :desc "company-english-helper"        "e" #'toggle-company-english-helper
     :desc "Visual Lines"                  "v" #'visual-line-mode
     :desc "Highlights Lines"              "h" #'hl-line-mode
     :desc "Truncate Lines"                "c" #'toggle-truncate-lines
     :desc "Theme"                         "t" #'counsel-load-theme)

   
   (:prefix ("s" . "search")
     :desc "Search with color-rg"          "r" #'color-rg-search-input-in-project
     :desc "Search symbol with color-rg"   "s" #'color-rg-search-symbol-in-project
     :desc "Search input in current file"  "f" #'color-rg-search-input-in-current-file
     :desc "Search symbol in current file" "e" #'color-rg-search-symbol-in-current-file
     :desc "Search project"                "p" #'+default/search-project
     :desc "Search in git"                 "g" #'consult-git-grep
     :desc "Search with consult-rg"        "c" #'consult-ripgrep
     :desc "Search with dash"              "t" #'consult-dash
     :desc "Keep lines in current file"    "k" #'consult-keep-lines
     :desc "Lazy search"                   "z" #'lazy-search
     :desc "Nil"                           "B" nil 
     :desc "Search buffer "                "b" #'consult-line)) 

 (:after smartparens
   :map smartparens-mode-map
   "M-("   #'sp-wrap-round
   "M-["   #'sp-wrap-square
   "M-{"   #'sp-wrap-curly
   "M-)"   #'sp-unwrap-sexp
   "C-<"   #'sp-backward-slurp-sexp
   "C->"   #'sp-forward-slurp-sexp
   "M-p"   #'sp-backward-up-sexp
   "M-n"   #'sp-up-sexp
   "C-,"   #'sp-backward-barf-sexp
   "C-."   #'sp-forward-barf-sexp
   "C-<right>" nil
   "M-<right>" nil
   "C-<left>"  nil
   "M-<left>"  nil)
 


 (:after counsel
   :map counse-mode-map
   [remap swiper]  #'counsel-grep-or-swiper
   [remap dired]  #'counsel-dired
   :map swiper-map
   "C-<return>" #'my-swiper-toggle-counsel-rg)
   ;; "C-x C-r"  #'counsel-recentf
   ;; "C-x j"  #'counsel-mark-ring
   ;; "C-h F"  #'counsel-describe-face

   ;; "C-c L"  #'counsel-load-library
   ;; "C-c P"  #'counsel-package
   ;; "C-c f"  #'counsel-find-library
   ;; "C-c g"  #'counsel-grep
   ;; "C-c h"  #'counsel-command-history
   ;; "C-c i"  #'counsel-git
   ;; "C-c j"  #'counsel-git-grep
   ;; "C-c l"  #'counsel-locate
   ;; "C-c r"  #'counsel-rg
   ;; "C-c z"  #'counsel-fzf

   ;; "C-c c F"  #'counsel-faces
   ;; "C-c c L"  #'counsel-load-library
   ;; "C-c c P"  #'counsel-package
   ;; "C-c c a"  #'counsel-apropos
   ;; "C-c c e"  #'counsel-colors-emacs
   ;; "C-c c f"  #'counsel-find-library
   ;; "C-c c g"  #'counsel-grep
   ;; "C-c c h"  #'counsel-command-history
   ;; "C-c c i"  #'counsel-git
   ;; "C-c c j"  #'counsel-git-grep
   ;; "C-c c l"  #'counsel-locate
   ;; "C-c c m"  #'counsel-minibuffer-history
   ;; "C-c c o"  #'counsel-outline
   ;; "C-c c p"  #'counsel-pt
   ;; "C-c c r"  #'counsel-rg
   ;; "C-c c s"  #'counsel-ag
   ;; "C-c c t"  #'counsel-load-theme
   ;; "C-c c u"  #'counsel-unicode-char
   ;; "C-c c w"  #'counsel-colors-web
   ;; "C-c c z"  #'counsel-fzf
   
 (:after swiper
   (:after rg
     :map swiper-map
     "M-<return>" #'my-swiper-toggle-rg-dwim
     :map ivy-minibuffer-map
     "M-<return>" #'my-swiper-toggle-rg-dwim))

 ;; (:after pdf-tools
 ;;   :map pdf-view-mode-map
 ;;   "C-s" #'isearch-forward
 ;;   "q" #'kill-current-buffer)
 (:after pyim
   "M-l"       #'pyim-convert-string-at-point
   "C-;"       #'pyim-delete-word-from-personal-buffer))
 


