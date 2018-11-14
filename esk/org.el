;;-*- coding: utf-8 -*-
;;:Project:   dot.emacs -- OrgMode customization
;;:Created:   sab 10 nov 2018 14:29:57 CET
;;:Author:    Lele Gaifax <lele@metapensiero.it>
;;:License:   GNU General Public License version 3 or later
;;:Copyright: © 2018 Lele Gaifax
;;

(require 'org)
(require 'org-duration)

(when (require 'org-bullets nil t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

(esk/csetq org-ellipsis "⤵")

;; Redefine "g" as 8 hours, "w" as 5 days, "m" as 4 weeks
(esk/csetq org-duration-units `(("d" . ,(* 60 8))
                                ("w" . ,(* 60 8 5))
                                ("m" . ,(* 60 8 5 4))
                                ;; italian variants
                                ("g" . ,(* 60 8))
                                ("s" . ,(* 60 8 5))))

;; Recognize "number followed by duration unit" as a number, to align them on the right
(esk/csetq org-table-number-regexp
       "^\\([<>]?[-+^.0-9]*[0-9][-+^.0-9eEdDx()%:]*\\|[<>]?[-+]?0[xX][0-9a-fA-F.]+\\|[<>]?[-+]?[0-9]+#[0-9a-zA-Z.]+\\|nan\\|[-+u]?inf\\|[1-9][0-9]*[dmwgs]?\\)$")

(esk/csetq org-duration-format 'h:mm)
