;;;  -*- lexical-binding: t; -*-

;;;###autoload
(defun +my/better-font()
  "Changing font to better."
  (interactive)
  ;; english font
  (if (display-graphic-p)
      (progn
        (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Source Code Pro" 17)) ;; 11 13 17 19 23
        ;; chinese font
        (dolist (charset '(kana han symbol cjk-misc bopomofo))
          (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "WenQuanYi Micro Hei Mono" :size 20)))))) ;; 14 16 20 22 28


;;;###autoload
(defun +my--support-format-p()
  (and (featurep! :editor format)
       (memq major-mode '(c-mode c++-mode emacs-lisp-mode java-mode python-mode))))

;;;###autoload
(defun +my/indent-buffer()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

;;;###autoload
(defun +my/rename-this-file-and-buffer (new-name)
  "Rename both current buffer and file it's visiting to NEW_NAME"
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

;;;###autoload
(defun +my--replace-pairs(content pairs &optional to-direction)
  "replace pairs in `content'"
  (when (or (not to-direction) (string= to-direction "auto"))
    (setq to-direction
          (if (catch 'break
                (mapc
                 (lambda (pair)
                   (if (string-match (aref pair 0) content)
                       (throw 'break t))) pairs)
                nil)
              "positive"
            "negative")))
  (with-temp-buffer
    (insert content)
    (mapc
     (lambda (pair)
       (goto-char (point-min))
       (while (search-forward-regexp (elt pair 0) nil "noerrro")
         (replace-match (elt pair 1))))
     (cond
      ((string= to-direction "positive")
       pairs)
      ((string= to-direction "negative")
       (mapcar
        (lambda(pair)
          (vector (elt pattern 1) (elt pattern 0))) pairs))
      (t
       (user-error "Your 3rd argument %s is invalid" to-direction))))
    (buffer-string)))


;;;###autoload
(defun +my/dos2unix ()
  "Replace DOS eolns CR LF with Unix eolns CR"
  (interactive)
    (goto-char (point-min))
      (while (search-forward (string ?\C-m) nil t) (replace-match "")))

;;;###autoload
(defun +my/hide-dos-eol ()
  "Hide ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;;;###autoload
(defun +my/show-dos-eol ()
  "Show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M ?\^M))


(defun function-advices (function)
  "Return FUNCTION's advices."
  (let ((flist (indirect-function function)) advices)
    (while (advice--p flist)
      (setq advices `(,@advices ,(advice--car flist)))
      (setq flist (advice--cdr flist)))
    advices))

;; Modified from the original function written by @xuchunyang (https://emacs-china.org/t/advice/7566/)
(define-advice describe-function-1 (:after (function) advice-remove-button)
  "Add a button to remove advice."
  (when (get-buffer "*Help*")
    (with-current-buffer "*Help*"
      (save-excursion
        (goto-char (point-min))
        (let ((ad-list (function-advices function)))
          (while (re-search-forward "^\\(?:This function has \\)?:[-a-z]+ advice: \\(.+\\)\\.?$" nil t)
            (let* ((name (string-trim (match-string 1) "[‘'`]" "[’']"))
                   (symbol (intern-soft name))
                   (advice (or symbol (car ad-list))))
              (when advice
                (when symbol
                  (cl-assert (eq symbol (car ad-list))))
                (let ((inhibit-read-only t))
                  (insert " » ")
                  (insert-text-button
                   "Remove"
                   'cursor-sensor-functions `((lambda (&rest _) (message "%s" ',advice)))
                   'help-echo (format "%s" advice)
                   'action
                   ;; In case lexical-binding is off
                   `(lambda (_)
                      (when (yes-or-no-p (format "Remove %s ? " ',advice))
                        (message "Removing %s of advice from %s" ',function ',advice)
                        (advice-remove ',function ',advice)
                        (revert-buffer nil t)))
                   'follow-link t))))
            (setq ad-list (cdr ad-list))))))))
