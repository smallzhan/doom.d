;;; private/org-enhanced/autoload.el -*- lexical-binding: t; -*-
;;;

;; ;;;###autoload
;; (defun mrb/insert-created-timestamp()
;;   "Insert a CREATED property using org-expiry.el for TODO entries"
;;   (org-expiry-insert-created)
;;   (org-back-to-heading)
;;   (org-end-of-line)
;;   (insert " ")
;;   )

;; ;;;###autoload
;; (defun mrb/add-tags-in-capture()
;;   (interactive)
;;   "Insert tags in a capture window without losing the point"
;;   (save-excursion
;;     (org-back-to-heading)
;;     (org-set-tags)))



;;;###autoload
(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

(defun bh/insert-heading-inactive-timestamp ()
  (save-excursion
    (org-return)
    (org-cycle)
    (bh/insert-inactive-timestamp)))

;;;###autoload
(defun my/org-clock-in ()
  "Clock in tasks everywhere"
  (interactive)
  (org-clock-in '(4)))

;;;###autoload
(defun bh/org-agenda-to-appt ()
  "Rebuild the reminders"
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

;;;###autoload
(defun myorg-update-parent-cookie ()
  (when (equal major-mode 'org-mode)
    (save-excursion
      (ignore-errors
        (org-back-to-heading)
        (org-update-parent-todo-statistics)))))

(defun org-time-today ()
  "Time in seconds today at 0:00.
Returns the float number of seconds since the beginning of the
epoch to the beginning of today (00:00)."
  (float-time (apply 'encode-time
                     (append '(0 0 0) (nthcdr 3 (decode-time))))))

(defun filter-by-tags (current-tag)
  (let ((head-tags (org-get-tags-at)))
    (member current-tag head-tags)))

;;;###autoload
(defun org-clock-sum-today-by-tags (include-tags timerange &optional tstart tend noinsert)
  (interactive "P")
  (let* ((timerange-numeric-value (prefix-numeric-value timerange))
         (files (org-add-archive-files (org-agenda-files)))
         ;;(include-tags '("PROG" "READING" "NOTE" "OTHER" "@Work" "@Self" "MEETING" "LEARN"))
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
          (org-clock-sum tstart tend #'(lambda() (filter-by-tags current-tag)))
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

;;;###autoload
(defun bh-archive-done-tasks ()
  (interactive)
  (dolist (tag (list
                "/DONE"
                "/CANCELLED"))
    (org-map-entries 'org-archive-subtree tag 'file)))

;;;###autoload
(defun my-archive-done-tasks ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward
            (concat "\\* " (regexp-opt org-done-keywords) " ") nil t)
      (goto-char (line-beginning-position))
      (org-archive-subtree))))


;; Exclude DONE state tasks from refile targets
;;;###autoload
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))

;;;###autoload
(defun hot-expand (str &optional mod)
  "Expand org template.

STR is a structure template string recognised by org like <s. MOD is a
string with additional parameters to add the begin line of the
structure element. HEADER string includes more parameters that are
prepended to the element after the #+HEADER: tag."
  (let (text)
    (when (region-active-p)
      (setq text (buffer-substring (region-beginning) (region-end)))
      (delete-region (region-beginning) (region-end)))
    (insert str)
    ;; (if (fboundp 'org-try-structure-completion)
    ;;     (org-try-structure-completion) ; < org 9
    ;;   (progn
    ;;     ;; New template expansion since org 9
    ;;     (require 'org-tempo nil t)
    ;;     (org-tempo-complete-tag)))
    (if (fboundp 'org-tempo-complete-tag) ;; may always org 9
        (org-tempo-complete-tag)
      (progn
        (require 'org-tempo nil t)
        (org-tempo-complete-tag)))
    (when mod (insert mod) (forward-line))
    (when text (insert text))))
