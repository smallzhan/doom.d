;; some org export to jekyll settings

;;(with-eval-after-load 'org
;; (defvar jekyll-directory (expand-file-name (concat org-directory "/blog/"))
;;   "Path to Jekyll blog.")
;;                                         ;(defvar jekyll-drafts-dir "_drafts/"
;;                                         ;  "Relative path to drafts directory.")
(defvar jekyll-posts-dir "_posts/"
  "Relative path to posts directory.")
(defvar jekyll-post-ext ".org"
  "File extension of Jekyll posts.")
(defvar jekyll-post-roam-template
  "#+TITLE: %s\n#+BEGIN_EXPORT html\n---\nlayout: post\ntitle: %s\ncomments: true\nexcerpt: \ncategories:\n  -  \ntags:\n  -  \n---\n#+END_EXPORT\n\n"
  "Default template for Jekyll posts. %s will be replace by the post title.")
(defvar jekyll-post-template
  (concat jekyll-post-roam-template "* "))

(defvar jekyll-base-directory (expand-file-name "blog" org-roam-directory)
  "jekyll base-directory")

(defvar jekyll-publish-directory (expand-file-name "~/Projects/smallzhan.github.io"))

(defun my-pinyinlib-convert-cc (cc)
  "convert character cc to pinyin if cc is chinese character"
  (let ((i 0)
        (str (char-to-string cc)))
    (if (< cc 255) ;; FIXME: english character...
        str
      (catch '__
        (dolist (l pinyinlib--simplified-char-table)
          (if (string-match (char-to-string cc) l)
              (throw '__ (char-to-string (+ 97 i)))
            (cl-incf i)))))))

(defun my-pinyinlib-convert-chinese (chinese)
  "convert chinese string to pinyin"
  (mapconcat (lambda (c) (my-pinyinlib-convert-cc c))
             chinese ""))

(defun jekyll-make-slug (s)
  "Turn a string into a slug."
  (unless (featurep 'pinyinlib)
    (require 'pinyinlib))
  (let ((s-pinyin (my-pinyinlib-convert-chinese s)))
    (replace-regexp-in-string
     " " "-" (downcase
              (replace-regexp-in-string
               "[^A-Za-z0-9 ]" "" s-pinyin)))))

(defun jekyll-yaml-escape (s)
  "Escape a string for YAML."
  (if (or (string-match ":" s)
          (string-match "\"" s))
      (concat "\"" (replace-regexp-in-string "\"" "\\\\\"" s) "\"")
    s))

;;;###autoload
(defun my-pages-start-post (title)
  "Start a new github-pages entry"
  (interactive "sPost Title: ")
  (let ((draft-file (concat (file-name-as-directory (expand-file-name jekyll-posts-dir jekyll-base-directory))
                            (format-time-string "%Y-%m-%d-p-")
                            (jekyll-make-slug title)
                            jekyll-post-ext)))
    (if (file-exists-p draft-file)
        (find-file draft-file)
      (find-file draft-file)
      (let ((jtitle (jekyll-yaml-escape title)))
        (insert (format jekyll-post-template jtitle jtitle))))))


(defun my-jekyll-blog-post-name ()
  (setq my-jekyll-blog-post--title (read-string "Title: "))
  (my-jekyll-blog-post-name-from-title my-jekyll-blog-post--title))
 
(defun my-jekyll-blog-post-name-from-title (title)
  (expand-file-name
   (format  "%s-p-%s.org"
            (format-time-string "%Y-%m-%d") (jekyll-make-slug title))
   (expand-file-name jekyll-posts-dir jekyll-base-directory)))


(add-to-list 'org-capture-templates
             '("b" "start blog post" plain
               (file my-jekyll-blog-post-name)
               "%(let ((jtitle (jekyll-yaml-escape my-jekyll-blog-post--title)))
                   (format jekyll-post-template jtitle jtitle))"
               :clock-in t :clock-resume t))

(setq org-roam-capture-templates
      '(("b" "start blog post" entry  "* Time Elapse :noexport:\n\n%?"
               :if-new (file+head "%(my-jekyll-blog-post-name-from-title \"${title}\")"
                                  "%(let ((jtitle (jekyll-yaml-escape \"${title}\")))
                                     (format jekyll-post-roam-template jtitle jtitle))")
               :clock-in t :clock-resume t :immediate-finish t :unnarrowed t)))

(add-to-list 'org-publish-project-alist
             `("smallzhan-github-io" ;; settings for cute-jumper.github.io
               :base-directory , jekyll-base-directory
               :base-extension "org"
               :publishing-directory , jekyll-publish-directory
               :recursive t
               ;;         :publishing-function org-html-publish-to-html
               :publishing-function org-gfm-publish-to-gfm
               :with-toc nil
               :headline-levels 4
               :auto-preamble nil
               :auto-sitemap nil
               :html-extension "html"
               :body-only t))

(add-to-list 'org-publish-project-alist
             '("blog" :components ("smallzhan-github-io")))

