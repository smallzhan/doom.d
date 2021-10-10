;; -*- lexical-binding: t; -*-
(require 'ox-latex)
(setq org-latex-listings t)
(setq org-latex-compiler "xelatex")
(setq org-preview-latex-default-process 'dvisvgm)
(setq org-highlight-latex-and-related '(latex))

(add-to-list 'org-latex-classes
             `("my-beamer"
               ,(concat
                 "\\documentclass[presentation]{beamer}"
                 "\n\\usepackage[UTF8]{ctex}"
                 "\n\\mode<presentation> {"
                 "\n\\setbeamercovered{transparent}"
                 "\n\\setbeamertemplate{theorems}[numbered]"
                 "\n\\usefonttheme[onlymath]{serif}"
                 "\n}"
                 "\n\\usepackage{amsmath, amssymb}"
                 "\n\\usepackage{hyperref}"
                 "\n\\usepackage[english]{babel}"
                 "\n\\usepackage{tikz}"
                 "\n\\setbeamerfont{smallfont}{size=\\small}"
                 "\n[NO-DEFAULT-PACKAGES]"
                 "\n[NO-PACKAGES]"
                 "\n[EXTRA]")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
               
(add-to-list 'org-latex-classes
             `("my-article"
               ,(concat
                 "\\documentclass{ctexart}"
                 "\n\\usepackage{hyperref}"
                 "\n[NO-DEFAULT-PACKAGES]"
                 "\n[PACKAGES]"
                 "\n[EXTRA]")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
