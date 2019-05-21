;;; config/private/+ui.el -*- lexical-binding: t; -*-

;; theme
;; cycle by +my/toggle-cycle-theme, binding SPC t t
(defvar +my-themes '(doom-one
                     doom-nord
                     doom-spacegrey
                     doom-nova
                     doom-opera
                     doom-sourcerer
                     doom-Iosvkem
                     doom-molokai
                     doom-dracula))
(setq doom-theme 'doom-one)

;; disable line-number
(setq display-line-numbers-type nil)

;;font
(if IS-WINDOWS
    (setq doom-font (font-spec :family "DejaVu Sans Mono" :size 14))

  (setq doom-font (font-spec :family "Fira Code" :size 13))
  )

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

(defvar chinese-fonts '("PingFang SC" "Microsoft YaHei"))

(let ((font (find-fonts chinese-fonts)))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font "fontset-default" charset font)))


;;
;;
;; (defun +my|init-font(frame)
;;   (with-selected-frame frame
;;     (if (display-graphic-p)
;;         (+my/better-font))))

;; (if (and (fboundp 'daemonp) (daemonp))
;;     (add-hook 'after-make-frame-functions #'+my|init-font)
;;   (+my/better-font))
