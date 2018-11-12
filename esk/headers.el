;;; esk/headers.el --- Standard file header skeletons
;;
;; The project name, license and copyright holder can be easily customized within a
;; .dir-locals.el file, for example:
;;
;;  ((nil . ((esk/project-name . "my-project")
;;           (esk/project-license . "MIT License")
;;           (esk/project-copyright-holder . "Arstecnica s.r.l."))))
;;

(require 'autoinsert)

(auto-insert-mode t)

(defvar esk/project-name nil
  "Last project name.")

(put 'esk/project-name 'safe-local-variable 'stringp)

(defun esk/project-name ()
  (setq esk/project-name (read-string "Project: " esk/project-name)))

(defvar esk/project-license "GNU General Public License version 3 or later"
  "Last project license.")

(put 'esk/project-license 'safe-local-variable 'stringp)

(defun esk/project-license ()
  (setq esk/project-license (read-string "License: " esk/project-license)))

(defvar esk/project-copyright-holder (user-full-name)
  "Last project copyright holder")

(put 'esk/project-copyright-holder 'safe-local-variable 'stringp)

(defun esk/project-copyright-holder ()
  (setq esk/project-copyright-holder (read-string "Copyright holder: " esk/project-copyright-holder)))

(define-skeleton esk/file-header
  "Standard file header."
  "Summary: "
  comment-start `(delete-horizontal-space) " -*- coding: utf-8 -*-" comment-end "\n"
  comment-start `(delete-horizontal-space) " :Project:   " (esk/project-name) " -- " str "\n"
  comment-start `(delete-horizontal-space) " :Created:   " (format-time-string "%c") comment-end "\n"
  comment-start `(delete-horizontal-space) " :Author:    " (user-full-name) " <" user-mail-address ">" comment-end "\n"
  comment-start `(delete-horizontal-space) " :License:   " (esk/project-license) "\n"
  comment-start `(delete-horizontal-space) " :Copyright: © " (format-time-string "%Y") " " (esk/project-copyright-holder) comment-end "\n"
  comment-start `(delete-horizontal-space) comment-end "\n\n")

(define-skeleton esk/file-header:block
  "Standard file header (block comment)."
  "Summary: "
  comment-start `(delete-horizontal-space) " -*- coding: utf-8 -*-\n"
  " * :Project:   " (esk/project-name) " -- " str "\n"
  " * :Created:   " (format-time-string "%c") "\n"
  " * :Author:    " (user-full-name) " <" user-mail-address ">\n"
  " * :License:   " (esk/project-license) "\n"
  " * :Copyright: © " (format-time-string "%Y") " " (esk/project-copyright-holder) "\n"
  " " `(delete-horizontal-space) comment-end "\n\n")

(define-skeleton esk/file-header:html
  "Standard HTML file header."
  "Summary: "
  comment-start `(delete-horizontal-space) " -*- coding: utf-8 -*-\n"
  "---- :Project:   " (esk/project-name) " -- " str "\n"
  "---- :Created:   " (format-time-string "%c") "\n"
  "---- :Author:    " (user-full-name) " <" user-mail-address ">\n"
  "---- :License:   " (esk/project-license) "\n"
  "---- :Copyright: © " (format-time-string "%Y") " " (esk/project-copyright-holder) "\n"
  "-" `(delete-horizontal-space) comment-end "\n\n")

(define-skeleton esk/file-header:org
  "Standard ORG file header."
  "Title: "
  "# -*- coding: utf-8 -*-\n"
  "#+TITLE: " str "\n"
  "#+SUBTITLE: " - "\n"
  "#+CATEGORY:\n"
  "#+AUTHOR: " (user-full-name) " <" user-mail-address ">\n"
  "#+DATE: " (format-time-string "%x") "\n"
  "#+STARTUP: showall\n"
  "#+OPTIONS: H:4\n"
  "#+LANGUAGE: it\n"
  "#+LATEX_CLASS_OPTIONS: [a4paper]\n"
  "#+LATEX_HEADER: \\usepackage[italian]{babel}\n"
  "#+LATEX_HEADER_EXTRA: \\setlength{\\parindent}{0pt}\n"
  "# Local IspellDict: italiano\n\n"
  "* " str "\n")

(define-skeleton esk/file-header:preventivo
  "Intestazione per i preventivi ORG."
  "Title: "
  "# -*- coding: utf-8 -*-\n"
  "#+TITLE: Preventivo " str "\n"
  "#+AUTHOR: " (user-full-name) " <" user-mail-address ">\n"
  "#+DATE: " (format-time-string "%x") "\n"
  "#+CATEGORY: " - "\n"
  "#+SEQ_TODO: TODO(t) WiP(w) | DONE(d) CANCELLED(c)\n"
  "#+STARTUP: showall\n"
  "#+OPTIONS: H:4\n"
  "#+PROPERTY: Effort_ALL 1:00 2:00 3:00 4:00 5:00 6:00 7:00 1d\n"
  "#+COLUMNS: %40ITEM(Voce) %13Effort(Ore stimate){:} %CLOCKSUM(Ore lavorate)\n"
  "#+LANGUAGE: it\n"
  "#+LATEX_CLASS_OPTIONS: [a4paper]\n"
  "#+LATEX_HEADER: \\usepackage[italian]{babel}\n"
  "#+LATEX_HEADER_EXTRA: \\setlength{\\parindent}{0pt}\n"
  "# Local IspellDict: italiano\n\n"
  "#+BEGIN: columnview :hlines 1 :id global :indent t\n"
  "#+END:\n\n"
  "* " str "\n\n"
  "** Preventivo\n\n"
  "*** Preanalisi\n"
  "    :PROPERTIES:\n"
  "    :Effort:   1:00\n"
  "    :END:\n\n"
  "*** Stima\n"
  "    :PROPERTIES:\n"
  "    :Effort:   0:30\n"
  "    :END:\n")

(define-skeleton esk/file-header:evolutiva
  "Intestazione per il planning delle evolutive."
  "Title: "
  "# -*- coding: utf-8 -*-\n"
  "#+TITLE: " str "\n"
  "#+SUBTITLE: " - "\n"
  "#+CATEGORY:\n"
  "#+AUTHOR: " (user-full-name) " <" user-mail-address ">\n"
  "#+DATE: " (format-time-string "%x") "\n"
  "#+SEQ_TODO: BUG(b) APPROFONDIRE(a) DAFARE(d) EVOLUTIVA(e) FIX(f) | CHIUSA(c) RESPINTA(r)\n"
  "#+STARTUP: showall\n"
  "#+OPTIONS: H:4\n"
  "#+PROPERTY: Effort_ALL 1:00 2:00 3:00 4:00 5:00 6:00 7:00 1g 2g 3g 4g 5g 1s 2s 3s 4s\n"
  "#+COLUMNS: %40ITEM(Voce) %13Effort(Ore stimate){:} %CLOCKSUM(Ore lavorate)\n"
  "#+LANGUAGE: it\n"
  "#+LATEX_CLASS_OPTIONS: [a4paper]\n"
  "#+LATEX_HEADER: \\usepackage[italian]{babel}\n"
  "#+LATEX_HEADER_EXTRA: \\setlength{\\parindent}{0pt}\n"
  "#+LINK: issue " (progn (git-link-homepage "origin") (current-kill 0)) "/issues/\n"
  "# Local IspellDict: italiano\n\n"
  "#+BEGIN: columnview :id global :maxlevel 1 :skip-empty-rows t\n"
  "#+END:\n\n"
  "* Cose da approfondire\n\n"
  "* Errori e problemi da risolvere\n\n"
  "  #+BEGIN: columnview :id local :indent t :skip-empty-rows t\n"
  "  #+END:\n\n"
  "* Migliorie\n\n"
  "  #+BEGIN: columnview :id local :indent t :skip-empty-rows t\n"
  "  #+END:\n\n")

(define-skeleton esk/file-header:mako
  "Standard Mako file header."
  "Summary: "
  "## -*- coding: utf-8 -*-\n"
  "## :Project:   " (esk/project-name) " -- " str "\n"
  "## :Created:   " (format-time-string "%c") "\n"
  "## :Author:    " (user-full-name) " <" user-mail-address ">\n"
  "## :License:   " (esk/project-license) "\n"
  "## :Copyright: " "© " (format-time-string "%Y") " " (esk/project-copyright-holder) "\n"
  "##\n\n")

(define-skeleton esk/file-header:jinja2
  "Standard Jinja2 file header."
  "Summary: "
  "{# -*- coding: utf-8; mode: web -*-\n"
  "## :Project:   " (esk/project-name) " -- " str "\n"
  "## :Created:   " (format-time-string "%c") "\n"
  "## :Author:    " (user-full-name) " <" user-mail-address ">\n"
  "## :License:   " (esk/project-license) "\n"
  "## :Copyright: " "© " (format-time-string "%Y") " " (esk/project-copyright-holder) "\n"
  "#}\n\n")

(define-skeleton esk/file-header:sql
  "Standard SQL file header."
  "Summary: "
  comment-start `(delete-horizontal-space) " -*- coding: utf-8; sql-product: " (symbol-name (sql-read-product "SQL product: ")) " -*-" comment-end "\n"
  comment-start `(delete-horizontal-space) " :Project:   " (esk/project-name) " -- " str comment-end "\n"
  comment-start `(delete-horizontal-space) " :Created:   " (format-time-string "%c") comment-end "\n"
  comment-start `(delete-horizontal-space) " :Author:    " (user-full-name) " <" user-mail-address ">" comment-end "\n"
  comment-start `(delete-horizontal-space) " :License:   " (esk/project-license) "\n"
  comment-start `(delete-horizontal-space) " :Copyright: © " (format-time-string "%Y") " " (esk/project-copyright-holder) comment-end "\n"
  comment-start `(delete-horizontal-space) comment-end "\n\n")

(add-to-list 'auto-insert-alist '(("\\.css\\'" . "CSS header") . esk/file-header))
(add-to-list 'auto-insert-alist '(("\\.html\\'" . "HTML header") . esk/file-header:html))
(add-to-list 'auto-insert-alist '(("\\.jinja2\\'" . "Jinja2 header") . esk/file-header:jinja2))
(add-to-list 'auto-insert-alist '(("\\.js\\'" . "Javascript header") . esk/file-header))
(add-to-list 'auto-insert-alist '(("\\.mako\\'" . "Mako header") . esk/file-header:mako))
(add-to-list 'auto-insert-alist '(("\\.org\\'" . "ORG header") . esk/file-header:org))
(add-to-list 'auto-insert-alist '(("\\.pt\\'" . "ZPT header") . esk/file-header))
(add-to-list 'auto-insert-alist '(("\\.py\\'" . "Python header") . esk/file-header))
(add-to-list 'auto-insert-alist '(("\\.rst\\'" . "ReST header") . esk/file-header))
(add-to-list 'auto-insert-alist '(("\\.scss\\'" . "SCSS header") . esk/file-header))
(add-to-list 'auto-insert-alist '(("\\.sql\\'" . "SQL header") . esk/file-header:sql))

(add-to-list 'auto-insert-alist '(c-mode . esk/file-header:block))
(add-to-list 'auto-insert-alist '(makefile-gmake-mode . esk/file-header))
