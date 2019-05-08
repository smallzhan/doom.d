;; some org export to jekyll settings

;;(with-eval-after-load 'org
(defvar jekyll-directory (expand-file-name (concat org-directory "../blog/"))
  "Path to Jekyll blog.")
                                        ;(defvar jekyll-drafts-dir "_drafts/"
                                        ;  "Relative path to drafts directory.")
(defvar jekyll-posts-dir "_posts/"
  "Relative path to posts directory.")
(defvar jekyll-post-ext ".org"
  "File extension of Jekyll posts.")
(defvar jekyll-post-template
  "#+BEGIN_EXPORT html\n---\nlayout: post\ntitle: %s\ncomments: true\nexcerpt: \ncategories:\n  -  \ntags:\n  -  \n---\n#+END_EXPORT\n\n* "
  "Default template for Jekyll posts. %s will be replace by the post title.")


(defvar jekyll-base-directory (expand-file-name "../blog" org-directory)
  "jekyll base-directory")

(defvar jekyll-publish-directory (expand-file-name "~/Projects/smallzhan.github.io"))
(defun jekyll-make-slug (s)
  "Turn a string into a slug."
  (let ((s-pinyin (if (fboundp 'pyim-hanzi2pinyin-simple)
                      (if (<= (length s) 4)
                          (pyim-hanzi2pinyin-simple s nil " " nil)
                        (pyim-hanzi2pinyin-simple s t nil nil))
                    s)))
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
  (let ((draft-file (concat jekyll-directory jekyll-posts-dir
                            (format-time-string "%Y-%m-%d-p-")
                            (jekyll-make-slug title)
                            jekyll-post-ext)))
    (if (file-exists-p draft-file)
        (find-file draft-file)
      (find-file draft-file)
      (insert (format jekyll-post-template (jekyll-yaml-escape title))))))


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

(provide 'org-jekyll)
