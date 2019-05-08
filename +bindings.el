;;; +bindings.el --- description -*- lexical-binding: t; -*-

(map!

 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Defaults
 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 "M-s-<right>" 'other-frame
 "M-s-<left>"  'other-frame

 "s-<up>"    'windmove-up
 "s-<right>" 'windmove-right
 "s-<left>"  'windmove-left
 "s-<down>"  'windmove-down

 ;; ;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Doom
 ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (:leader

   (:prefix ("c" . "code")
     :desc "Compile"                     "c"   #'compile
     :desc "Jump to definition"          "d"   #'+lookup/definition
     :desc "Jump to references"          "D"   #'+lookup/references
     :desc "Evaluate buffer/region"      "e"   #'+eval/buffer-or-region
     :desc "Evaluate & replace region"   "E"   #'+eval:replace-region
     :desc "Format buffer/region"        "f"   #'+format/region-or-buffer
     :desc "Open REPL"                   "r"   #'+eval/open-repl-other-window
     :desc "Delete trailing whitespace"  "w"   #'delete-trailing-whitespace
     :desc "Delete trailing newlines"    "W"   #'doom/delete-trailing-newlines
     :desc "List errors"                 "x"   #'flycheck-list-errors

     (:prefix ("g" . "Go to")
       :desc "Implementation"            "i" #'lsp-goto-implementation
       :desc "Definition"                "d" #'lsp-goto-type-definition
       :desc "Find Definition"           "D" #'lsp-find-definition
       :desc "Find References"           "r" #'lsp-find-references)
     (:prefix ("p" . "Peek")
       :desc "Implementation"            "i" #'lsp-ui-peek-find-implementation
       :desc "Definition"                "d" #'lsp-ui-peek-find-definitions
       :desc "Reference"                 "r" #'lsp-ui-peek-find-references)
     (:prefix ("l" . "Lens")
       :desc "Show"                      "l" #'lsp-lens-show
       :desc "Hide"                      "q" #'lsp-lens-hide)
     (:prefix ("m" . "menu")
       :desc "Show"                      "m" #'lsp-ui-imenu
       :desc "Hide"                      "q" #'lsp-ui-imenu--kill)
     )

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
     :desc "iedit"                "e" #'iedit-mode
     :desc "Switch header/source" "s" #'ff-find-other-file
     :desc "Make header"          "m" #'make-header
     :desc "Make box comment"     "c" #'make-box-comment
     :desc "Make divider"         "d" #'make-divider
     :desc "Make revision"        "r" #'make-revision
     :desc "Update file header"   "g" #'update-file-header
     :desc "Duplicate line"       "l" #'+private/duplicate-line)

   (:prefix ("o". "org")
     :desc "Do what I mean"           "o"   #'+org/dwim-at-point
     :desc "Blog of github"           "B"   #'my-pages-start-post
     :desc "Deft"                     "d"   #'deft
     (:prefix ("e" . "org export")
       :desc "Export beamer to latex" "l b" #'org-beamer-export-to-latex
       :desc "Export beamer as latex" "l B" #'org-beamer-export-as-latex
       :desc "Export beamer as pdf"   "l P" #'org-beamer-export-to-pdf)
     (:prefix ("p" . "publish")
       :desc "Publish current file"    "f" #'org-publish-current-file
       :desc "Publish current project" "p" #'org-publish-current-project))

   "&" nil

   (:prefix ("s" . "snippets")
     :desc "New snippet"           "n" #'yas-new-snippet
     :desc "Insert snippet"        "i" #'yas-insert-snippet
     :desc "Find global snippet"   "v" #'yas-visit-snippet-file
     :desc "Reload snippets"       "r" #'yas-reload-all)
   
   
   (:prefix ("t" . "toggle")
     :desc "Flyspell"                     "s" #'flyspell-mode
     :desc "Flycheck"                     "f" #'flycheck-mode
     :desc "Line numbers"                 "l" #'doom/toggle-line-numbers
     :desc "Frame fullscreen"             "F" #'toggle-frame-fullscreen
     :desc "Indent guides"                "i" #'highlight-indent-guides-mode
     :desc "Impatient mode"               "h" #'+impatient-mode/toggle
     :desc "Big mode"                     "b" #'doom-big-font-mode
     :desc "org-tree-slide mode"          "p" #'+org-present/start
     :desc "cycle-themes"                 "t" #'+my/toggle-cycle-theme)
   
   (:prefix ("/" . "search")
     :desc "Search buffer"                 "b" #'swiper
     :desc "Search current directory"      "d" #'+default/search-from-cwd
     :desc "Jump to symbol"                "i" #'imenu
     :desc "Jump to symbol across buffers" "I" #'imenu-anywhere
     :desc "Jump to link"                  "l" #'ace-link
     :desc "Look up online"                "o" #'+lookup/online-select
     :desc "search with color-rg"          "r" #'color-rg-search-input-in-project
     :desc "search symbol with color-rg"   "s" #'color-rg-search-symbol-in-project
     :desc "Search project"                "p" #'+default/search-project
     :desc "Lazy search"                   "z" #'lazy-search)
   )
 
 
 )


