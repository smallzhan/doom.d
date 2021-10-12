;;; config/private/+ui.el -*- lexical-binding: t; -*-

;; theme
;; cycle by +my/toggle-cycle-theme, binding SPC t t

(setq doom-theme 'doom-one)

;; disable line-number
(setq display-line-numbers-type nil)

(defvar default-fonts '("JetBrains Mono" "Fira Code" "SF Mono"))
;;font
(if IS-MAC
    (setq doom-font (font-spec :family (nth (random (length default-fonts)) default-fonts) :size 13))
  (setq doom-font (font-spec :family "DejaVu Sans Mono" :size 14)))

;;(setq doom-unicode-font (font-spec :family "Sarasa Mono SC" :size 14))
;(set-default-font "Sarasa Mono SC 14")
(set-face-attribute 'fixed-pitch nil
                    :family "Sarasa Mono SC"
                    :inherit '(default))
 
(defun find-fonts (fontlist)
  (let ((font (car fontlist))
        (other (cdr fontlist)))
    (if (null font)
     nil
     (if (find-font (font-spec :name font))
         font
       (find-fonts other)))))

(defvar chinese-fonts '("PingFang SC" "Microsoft YaHei" "Sarasa Mono SC"))


(run-at-time "2sec" nil
             (lambda ()         
               (let ((font (find-fonts chinese-fonts)))        
                 (dolist (charset '(kana han cjk-misc bopomofo))
                   (set-fontset-font t charset font)))))
