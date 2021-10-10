;;; -*- lexical-binding: t; -*-
(use-package! rime
                                        ;:load-path "~/.doom.d/extensions/emacs-rime"
  :init
  (if IS-MAC
      (setq rime-librime-root "~/Projects/librime/dist")
    (setq rime-librime-root "E:/Projects/librime/dist"))
  :config
  ;;; Code:

  ;; (if IS-WINDOWS
  ;;     (setq rime-share-data-dir "~/.doom.d/extensions/emacs-rime/data"))
  (setq rime-user-data-dir "~/.emacs.d/rime")
  (setq rime-posframe-properties
        (list :background-color "#333333"
              :foreground-color "#dcdccc"
              ;;:font "SF Mono-14"
              :internal-border-width 10))

  (setq default-input-method "rime"
        rime-show-preedit 'inline
        rime-preedit-face '(t (:underline t))
        rime-show-candidate 'posframe
        rime-inline-ascii-holder ?a
        rime-cursor "|"
        window-min-height 1
        rime-title "")

  ;;(setq rime-preedit-face '(:underline t))

;;   (defun +rime--posframe-display-content-a (args)
;;     "给 `rime--posframe-display-content' 传入的字符串加一个全角空
;; 格，以解决 `posframe' 偶尔吃字的问题。"
;;     (cl-destructuring-bind (content) args
;;       (let ((newresult (if (string-blank-p content)
;;                            content
;;                          (concat content "　"))))
;;         (list newresult))))

;;   (if (fboundp 'rime--posframe-display-content)
;;       (advice-add 'rime--posframe-display-content
;;                   :filter-args
;;                   #'+rime--posframe-display-content-a)
;;     (error "Function `rime--posframe-display-content' is not available."))


  (defun +rime-force-enable ()
    "[ENHANCED] Force into Chinese input state.
If current input method is not `rime', active it first. If it is
currently in the `evil' non-editable state, then switch to
`evil-insert-state'."
    (interactive)
    (let ((input-method "rime"))
      (unless (string= current-input-method input-method)
        (activate-input-method input-method))
      (when (rime-predicate-evil-mode-p)
        (if (= (1+ (point)) (line-end-position))
            (evil-append 1)
          (evil-insert 1)))
      (rime-force-enable)))

  (defun +rime-convert-string-at-point ()
    "Convert the string at point to Chinese using the current input scheme.
First call `+rime-force-enable' to active the input method, and
then search back from the current cursor for available string (if
a string is selected, use it) as the input code, call the current
input scheme to convert to Chinese."
    (interactive)
    (+rime-force-enable)
    (let ((string (if mark-active
                      (buffer-substring-no-properties
                       (region-beginning) (region-end))
                    (buffer-substring-no-properties
                     (point) (max (line-beginning-position) (- (point) 80)))))
          code
          length)
      (cond ((string-match "\\([a-z]+\\|[[:punct:]]\\)[[:blank:]]*$" string)
             (setq code (replace-regexp-in-string
                         "^[-']" ""
                         (match-string 0 string)))
             (setq length (length code))
             (setq code (replace-regexp-in-string " +" "" code))
             (if mark-active
                 (delete-region (region-beginning) (region-end))
               (when (> length 0)
                 (delete-char (- 0 length))))
             (when (> length 0)
               (setq unread-command-events
                     (append (listify-key-sequence code)
                             unread-command-events))))
            (t (message "`+rime-convert-string-at-point' did nothing.")))))

  (defun +rime-predicate-button-at-point-p ()
    "Determines whether the point is a button.
\"Button\" means that positon is not editable.
Can be used in `rime-disable-predicates' and `rime-inline-predicates'."
    (button-at (point)))


  (defun +translate-symbol-to-rime ()
    (interactive)
    (let* ((input (thing-at-point 'symbol))
           (beg (car (bounds-of-thing-at-point 'symbol)))
           (end (point)))
      (delete-region beg end)
      (toggle-input-method)
      (dolist (c (string-to-list input))
        (rime-lib-process-key c 0))
      (rime--redisplay)))

  (setq-default rime-disable-predicates
                '(+rime-predicate-button-at-point-p
                  rime-predicate-prog-in-code-p
                  rime-predicate-punctuation-line-begin-p
                  ;;rime-predicate-after-alphabet-char-p
                  ;;rime-predicate-auto-english-p
                  rime-predicate-hydra-p
                  ))
  (setq-default rime-inline-predicates
                '(rime-predicate-space-after-cc-p
                  rime-predicate-current-uppercase-letter-p))
  (load! "im-cursor-chg")
  (cursor-chg-mode 1)
  :bind
  ("M-l" . #'+rime-convert-string-at-point)
  (:map rime-active-mode-map
   ("<tab>" . #'+rime-inline-ascii)
   ("M-l" . #'+rime-convert-string-at-point))
  (:map rime-mode-map
   ("M-l" . #'+rime-convert-string-at-point)
   ("M-j" . #'rime-force-enable)))


(use-package! pinyinlib
  :commands (pinyinlib-build-regexp-string)
  :init
  (with-no-warnings
    (defun ivy--regex-pinyin (str)
      "The regex builder wrapper to support pinyin."
      (or (pinyin-to-utf8 str)
          (and (fboundp '+ivy-prescient-non-fuzzy)
               (+ivy-prescient-non-fuzzy str))
          (ivy--regex-plus str)))

    (defun my-pinyinlib-build-regexp-string (str)
      "Build a pinyin regexp sequence from STR."
      (cond ((equal str ".*") ".*")
            (t (pinyinlib-build-regexp-string str t))))

    (defun my-pinyin-regexp-helper (str)
      "Construct pinyin regexp for STR."
      (cond ((equal str " ") ".*")
            ((equal str "") nil)
            (t str)))

    (defun pinyin-to-utf8 (str)
      "Convert STR to UTF-8."
      (cond ((equal 0 (length str)) nil)
            ((equal (substring str 0 1) ";")
             (mapconcat
              #'my-pinyinlib-build-regexp-string
              (remove nil (mapcar
                           #'my-pinyin-regexp-helper
                           (split-string
                            (replace-regexp-in-string ";" "" str)
                            "")))
              ""))
            (t nil)))

    (after! orderless
      (defun completion--regex-pinyin (str)
        (orderless-regexp (pinyinlib-build-regexp-string str)))
      (add-to-list 'orderless-matching-styles 'completion--regex-pinyin))


    ;; (mapcar
    ;;  (lambda (item)
    ;;    (let ((key (car item))
    ;;          (value (cdr item)))
    ;;      (when (member value '(+ivy-prescient-non-fuzzy
    ;;                            ivy--regex-plus))
    ;;        (setf (alist-get key ivy-re-builders-alist)
    ;;              #'ivy--regex-pinyin))))
    ;;  ivy-re-builders-alist)
    ))


(after! pyim
  ;;(setq pyim-dicts
  ;;      '((:name "greatdict" :file "~/.doom.d/pyim/pyim-bigdict.pyim.gz")))

  (setq-default pyim-english-input-switch-functions
                '(
                  pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;;(pyim-isearch-mode 1)
  (setq pyim-page-tooltip 'posframe)

  (setq pyim-page-length 9)
                                        ;(if IS-MAC
                                        ;    (setq rime-shared-path "/Library/Input Methods/Squirrel.app/Contents/SharedSupport"
                                        ;          rime-user-path "~/Library/Rime/")
                                        ;  (setq rime-shared-path "~/.doom.d/extensions/rime/data"
                                        ;        rime-user-path "~/.rime/"))
  (add-to-list 'load-path "~/.doom.d/extensions/rime")
  (require 'liberime)
  ;;(liberime-start rime-shared-path (file-truename rime-user-path))
  (liberime-select-schema "luna_pinyin_simp")
  (setq pyim-default-scheme 'rime-quanpin)

  ;;; pinyin search for ivy
  (defun eh-ivy-cregexp (str)
    (let ((x (ivy--regex-plus str))
          (case-fold-search nil))
      (if (listp x)
          (mapcar (lambda (y)
                    ((if t) (cdr y)
                     y
                     (list (pyim-cregexp-build (car y))))
                    x))
        (pyim-cregexp-build x))))

  (setq ivy-re-builders-alist
        '((t . eh-ivy-cregexp)))
  )
