;; init.el -*- lexical-binding: t; -*-

;; 插件源, skip in straight.
(setq package-archives '(("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

;; 扩展
(defvar +my-ext-dir (expand-file-name "~/.doom.d/extensions"))

;; Org文件
(defvar +my-org-dir (expand-file-name "~/Dropbox/Notes/org/"))
;; (when IS-MAC
;;   (setq frame-resize-pixelwise t

;;         ns-use-native-fullscreen nil
;;         ns-use-fullscreen-animation nil)


;;   ;; (run-at-time "5sec" nil
;;   ;;              (lambda ()
;;   ;;                (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
;;   ;;                  ;; If emacs has in fullscreen status, maximized window first, drag from Mac's single space.
;;   ;;                  (when (memq fullscreen '(fullscreen fullboth))
;;   ;;                    (set-frame-parameter (selected-frame) 'fullscreen 'maximized))
;;   ;;                  ;; Manipulating a frame without waiting for the fullscreen
;;   ;;                  ;; animation to complete can cause a crash, or other unexpected
;;   ;;                  ;; behavior, on macOS (bug#28496).
;;   ;;                  (when (featurep 'cocoa) (sleep-for 0.5))
;;   ;;                  ;; Call `toggle-frame-fullscreen' to fullscreen emacs.
;;   ;;                  (toggle-frame-fullscreen))))
;;   )

(setq user-full-name "Guoqiang Jin"
      user-mail-address "ustczhan@gmail.com")


;;(setq custom-file (concat user-emacs-directory ".local/custom.el"))

(doom!
 :input
 ;;chinese

 :completion
 ;; (
 company         ; the ultimate code completion backend
 ;; +childframe)


 (ivy               ; a search engine for love and life
  +fuzzy
;;  +childframe     ;; macos 下面会有卡死的情况。不知道为什么。
  )

 :ui
 doom              ; what makes DOOM look the way it does
 doom-dashboard    ; a nifty splash screen for Emacs
 modeline     ; a snazzy Atom-inspired mode-line
 ;;doom-quit         ; DOOM quit-message prompts when you quit Emacs
 hl-todo           ; highlight TODO/FIXME/NOTE tags
 nav-flash         ; blink the current line after jumping
 ;;ophints      ; display visual hints when editing in evil
 (window-select    ; visually switch windows
  +ace-window)

 treemacs          ; a project drawer, like neotree but cooler
 (popup            ; tame sudden yet inevitable temporary windows
  +all
  +defaults)
 vc-gutter
 workspaces

 :editor
 ;;;evil
 ;;;(evil +everywhere)
 ;;;file-templates
 format            ; automated prettiness
 multiple-cursors  ; editing in many places at once
 fold
 snippets

 :emacs
 (dired             ; making dired pretty [functional]
  +icons)
 ;;eshell            ; a consistent, cross-platform shell (WIP)
 vc                ; version-control and Emacs, sitting in a tree
 electric

 :term
 ;;vterm

 :checkers
 (syntax
  +childframe
  )

 :tools
 eval
 magit
 (lookup
  +docsets)
 ;;editorconfig
 ;;lsp
 ;;pdf

 :lang
 (cc
 ;; +lsp
  )                ; C/C++/Obj-C madness
 data              ; config/data formats
 emacs-lisp        ; drown in parentheses
 common-lisp
 latex
 (org
  +jupyter)
 ;; (org              ; organize your plain life in plain text
 ;;  +attach          ; custom attachment system
 ;;  +babel
 ;;  +ipython                                      ; running code in org
 ;;  ;;+capture         ; org-capture in and outside of Emacs
 ;;  +export          ; Exporting org to whatever you want
 ;;  +protocol)
                                        ; Emacs for presentations
 (python            ; beautiful is better than ugly
  ;;+lsp
  )

 :app
 (rss
  +org)


 :config
 ;; The default module set reasonable defaults for Emacs. It also provides
 ;; a Spacemacs-inspired keybinding scheme, a custom yasnippet library,
 ;; and additional ex commands for evil-mode. Use it as a reference for
 ;; your own modules.
 (default
   +smartparens
   +bindings)

 :private
 ;; my-cc
 (org-enhanced
  +latex
  +jekyll)
 lsp
 edit-enhanced)

;;(load custom-file t t t)
