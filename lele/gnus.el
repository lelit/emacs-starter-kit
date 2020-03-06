;;-*- coding: utf-8 -*-
;;:Progetto: dot.emacs -- Lele's Gnus configuration
;;:Creato:   sab 07 feb 2004 03:56:23 CET
;;:Autore:   Lele Gaifax <lele@nautilus.homeip.net>
;;:Licenza:  GNU General Public License version 3 or later
;;

(esk/csetq gnus-select-method '(nntp "gmane"
                                     (nntp-address "news.gmane.io")
                                     (nnir-search-engine nntp)))

(esk/csetq gnus-posting-styles
           '((".*"
              (signature-file "~/.signature")
              (name "Lele Gaifax")
              (organization "Nautilus Entertainments"))
             ("^mail.+:"
              (name "Lele Gaifax")
              (organization "Nautilus Entertainments")
              (signature-file "~/.mail-signature"))))

(setq esk/gnus-user-groups '("gmane.comp.python.general"
                             "gmane.comp.python.devel"
                             "gmane.comp.python.distutils.devel"
                             "gmane.comp.web.pylons.general"
                             "gmane.comp.python.sqlalchemy.user"
                             "gmane.comp.db.postgresql.general"
                             "gmane.comp.db.postgresql.pgadmin.devel"
                             "gmane.emacs.python-mode"
                             "gmane.mail.imap.offlineimap.general"
                             "gmane.mail.notmuch.general"
                             "gmane.comp.python.reportlab.user"
                             "gmane.comp.python.pypy"
                             "gmane.comp.python.buildout.devel"
                             "gmane.comp.version-control.git.magit"
                             "gmane.comp.version-control.darcs.user"
                             "gmane.comp.version-control.subversion.trac.general"
                             "gmane.comp.version-control.subversion.trac.devel"
                             "gmane.emacs.help"
                             "gmane.emacs.devel"
                             "gmane.emacs.gnus.user"
                             "gmane.emacs.orgmode"
                             "gmane.org.user-groups.linux.italian.linuxtrent"))
