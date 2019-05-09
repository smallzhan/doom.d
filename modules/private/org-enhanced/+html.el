(setq org-html-head-include-default-style nil)
(setq org-html-postamble t)
(setq org-html-postamble-format
      '(("en" "<hr /> <p class=\"postamble\">[<b>Last Updated:</b> %T | <b>Created by</b> %c]</p>")))
(setq org-html-footnote-format " [%s]")

(add-to-list 'org-publish-project-alist
      `("orgfiles" ;; see the backquote ` not ' and the comma before the variable
         :base-directory , org-directory
         :base-extension "org"
         :publishing-directory , (concat org-directory "../public_html")
         :publishing-function org-html-publish-to-html
         :exclude "PrivatePage.org" ;; regexp
         :language: utf-8
         :headline-levels 3
         :section-numbers nil
         :table-of-contents nil
         :html-head: "<link rel=\"stylesheet\" href=\"org.css\" type=\"text/css\">"
         :footnotes t
         :language "utf-8"
         ;;:html-postamble: '(("en" "<hr />[<p class=\"author\">Author: %a (%e)</p> | <p class=\"date\">Last Update: %T</p> | <p class=\"creator\">%c</p> | <p class=\"xhtml-validation\">%v</p>]"))
         :auto-index t))
(add-to-list 'org-publish-project-alist
        '("homepage"
         :base-directory , (expand-file-name (concat org-directory "../homepage"))
         :base-extension "org"
         :publishing-directory , (expand-file-name (concat org-directory "../public_html"))
         :publishing-function org-html-publish-to-html
         :headline-levels 3
         :section-numbers nil
         :table-of-contents nil
         :footnotes t
         :style-include-default nil
         :language "utf-8"
         :html-head "<link rel=\"stylesheet\" href=\"theme/style.css\"  type=\"text/css\" />
<link rel=\"stylesheet\" href=\"theme/facebox.css\"  type=\"text/css\" />"
                                        ;:style "<link rel=\"stylesheet\" href=\"org.css\" type=\"text/css\">"
         :auto-preamble t
         :auto-postamble nil
         :auto-index nil))

(add-to-list 'org-publish-project-alist
             '("notes" :components ("orgfiles")))
(add-to-list 'org-publish-project-alist
             '("webpage" :components ("homepage")))
