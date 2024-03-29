;; init.el -*- lexical-binding: t; -*-

;; 插件源, skip in straight.
(setq package-archives '(("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

;; 扩展
(defvar +my-ext-dir (expand-file-name "~/.doom.d/extensions"))

;; Org文件
(defvar +my-org-dir (file-truename (expand-file-name "~/Nutstore/Notes/org/")))

(setq user-full-name "Guoqiang Jin"
      user-mail-address "ustczhan@gmail.com")


(setq custom-file (concat user-emacs-directory ".local/custom.el"))

(doom!
 :input
 ;;chinese

 :completion
 ;; (company         ; the ultimate code completion backend
 ;; +childframe)


 ;;(ivy               ; a search engine for love and life
 ;; +fuzzy
  ;;+childframe     ;; macos 下面会有卡死的情况。不知道为什么。
  ;;)

 vertico

 :ui
 doom              ; what makes DOOM look the way it does
 doom-dashboard    ; a nifty splash screen for Emacs
 ;;modeline     ; a snazzy Atom-inspired mode-line
 ;;doom-quit         ; DOOM quit-message prompts when you quit Emacs
 hl-todo           ; highlight TODO/FIXME/NOTE tags
 nav-flash         ; blink the current line after jumping
 ;;ophints      ; display visual hints when editing in evil
 ;;(window-select    ; visually switch windows
 ;; +switch-window

 treemacs          ; a project drawer, like neotree but cooler
 (popup            ; tame sudden yet inevitable temporary windows
  ;;+all
  +defaults)
 vc-gutter
 workspaces

 :editor
 ;;;evil
 ;;;(evil +everywhere)
 ;;;file-templates
 format            ; automated prettiness
 ;;multiple-cursors  ; editing in many places at once
 fold
 snippets
 parinfer

 :emacs
 (dired             ; making dired pretty [functional]
  +icons)
 ;;eshell            ; a consistent, cross-platform shell (WIP)
 vc                ; version-control and Emacs, sitting in a tree
 electric
 undo

 :term
 ;;vterm

 :checkers
 (syntax
  +childframe)
  

 :tools
 ;;eval
 ;; magit
 (lookup
  +docsets)
 ;;editorconfig
 ;; (lsp
 ;;  +eglot)
 ;;pdf

 :lang
 (cc)
  ;; +lsp
                  ; C/C++/Obj-C madness
 data              ; config/data formats
 emacs-lisp        ; drown in parentheses
 common-lisp
 (latex
  +cdlatex)

 ;; (org
 ;;  +dragndrop
 ;;  +pomodoro
 ;;  ;;+jupyter
 ;;  ;;+roam2
 ;;  +pretty)
  
 php
 ;; (org              ; organize your plain life in plain text
 ;;  +attach          ; custom attachment system
 ;;  +babel
 ;;  +ipython                                      ; running code in org
 ;;  ;;+capture         ; org-capture in and outside of Emacs
 ;;  +export          ; Exporting org to whatever you want
 ;;  +protocol)
                                        ; Emacs for presentations
 (python)            ; beautiful is better than ugly
  ;;+pyright)

 (rust
  +lsp)
 :app
 (rss
  +org)
 :email
 ;;wanderlust

 :config
 ;; The default module set reasonable defaults for Emacs. It also provides
 ;; a Spacemacs-inspired keybinding scheme, a custom yasnippet library,
 ;; and additional ex commands for evil-mode. Use it as a reference for
 ;; your own modules.
 (default
   ;;+smartparens
   +bindings)

 :private
 ;; my-cc
 (company                               
  +childframe)
 ;; corfu
 chinese
 (org-enhanced
  +jekyll
  +latex)
 tree-sitter

 lsp
 rust
 eaf
 edit-enhanced)

(load custom-file t t t)
