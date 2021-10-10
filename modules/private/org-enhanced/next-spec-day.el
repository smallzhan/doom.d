;; -*- lexical-binding: t; -*-
;; This file is from https://github.com/chenfengyuan/elisp/blob/master/next-spec-day.el
;; All credits to [[FengYuan Chen][https://github.com/chenfengyuan]]
;;
;;; How to use:
;; 1. add `(load "/path/to/next-spec-day")` to your dot emacs file.
;; 2. set `NEXT_SPEC_DEADLINE` and/or `NEXT_SPEC_SCHEDULED` property of a
;;    TODO task, with its value is an sexp for next-day, or a symbol in
;;    `next-spec-day-alist'. i.e.
;;    * TODO TEST1
;;      SCHEDULED: <2019-07-22 Mon 15:00-16:00>
;;      :PROPERTIES:
;;      :LAST_REPEAT: [2019-07-15 Mon 21:51]
;;      :NEXT_SPEC_SCHEDULED: (memq (calendar-day-of-week date) '(1 3 5))
;;      :END:
;;
;;    * TODO TEST2
;;      SCHEDULED: <2019-07-22 Mon 15:00-16:00>
;;      :PROPERTIES:
;;      :LAST_REPEAT: [2019-07-15 Mon 21:51]
;;      :NEXT_SPEC_SCHEDULED: workday
;;      :END:
;;
;;
;;; Change log:
;; 2021/03/24
;;      * cl --> cl-lib
;;      
;; 2019/07/15
;;      * Tidy the code. Add support to timestamp such as <2019-07-15 Mon 15:00-16:00>
;;
;; 2019/07/14
;;      * First edition. Just copy the file from the url.
;;        https://github.com/chenfengyuan/elisp/blob/master/next-spec-day.el

(eval-when-compile (require 'cl-lib))

(unless (fboundp 'read-from-whole-string) (require 'thingatpt))

(defvar next-spec-day-search-days 365
  "how many days seach forward to satisfy the requirement.")

(defvar next-spec-day-alist
  '((last-workday-of-month
     .
     ((or
       (and (= (calendar-last-day-of-month m y) d)
            (/= (calendar-day-of-week date) 0)
            (/= (calendar-day-of-week date) 6))
       (and (< (- (calendar-last-day-of-month m y) d) 3)
            (string= (calendar-day-name date) "Friday")))))
    (last-day-of-month
     .
     ((= (calendar-extract-day date)
         (calendar-last-day-of-month
          (calendar-extract-month date)
          (calendar-extract-year date)))))
    (workday
     .
     ((memq (calendar-day-of-week date) '(1 2 3 4 5))))
    (workday-135
     .
     ((memq (calendar-day-of-week date) '(1 3 5)))))
 "Some useful sexp used for NEXT_SPEC_{DEADLINE, SCHEDULED}.")

(defun next-spec-day ()
  "Next spec day satisfy the sexp from `NEXT_SPEC_{DEADLINE, SCHEDULED}'"
  (when (string= org-state "DONE")
    (catch 'exit
      (dolist (type '("NEXT_SPEC_DEADLINE" "NEXT_SPEC_SCHEDULED"))
        (when (stringp (org-entry-get nil type))
          (let* ((time (org-entry-get nil (substring type (length "NEXT_SPEC_"))))
                 (pt (if time (org-parse-time-string time) (decode-time (current-time))))
                 (func (ignore-errors (read-from-whole-string (org-entry-get nil type)))))
            (unless func (message "Sexp is wrong") (throw 'exit nil))
            (when (symbolp func)
              (setq func (cadr (assoc func next-spec-day-alist))))
            (cl-incf (nth 3 pt))
            (cl-do ((i 0 (1+ i)))
                ((or
                  (> i next-spec-day-search-days)
                  (let* ((d (nth 3 pt))
                         (m (nth 4 pt))
                         (y (nth 5 pt))
                         (date (list m d y)))
                    (eval func)))
                 (when (> i next-spec-day-search-days)
                   (setf pt nil)))
              (cl-incf (nth 3 pt)))
            (if pt
                (funcall
                 (if (string= "NEXT_SPEC_DEADLINE" type)
                     'org-deadline
                   'org-schedule)
                 nil
                 (let ((time-string (format-time-string
                                     (org-time-stamp-format)
                                     (apply 'encode-time pt))))
                   (concat
                    (substring time-string 0 -1)
                    (substring time (1- (length time-string)) nil))))
              (error (format "Not satisfied in next %d days." next-spec-day-search-days))))))
      (when (or
             (org-entry-get nil "NEXT_SPEC_SCHEDULED")
             (org-entry-get nil "NEXT_SPEC_DEADLINE"))
        (org-entry-put nil "TODO" (car org-todo-heads))
        (org-entry-put nil "LAST_REPEAT"
                       (format-time-string (org-time-stamp-format t t)))))))

(add-hook 'org-after-todo-state-change-hook 'next-spec-day)


