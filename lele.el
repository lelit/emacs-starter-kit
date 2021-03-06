;;-*- coding: utf-8 -*-
;;:Progetto:  dot.emacs -- Lele's personal preferences
;;:Creato:    ven 09 apr 2010 01:08:16 CEST
;;:Autore:    Lele Gaifax <lele@metapensiero.it>
;;:Licenza:   GNU General Public License version 3 or later
;;

(esk/csetq user-mail-address "lele@metapensiero.it")
(esk/csetq user-full-name "Lele Gaifax")


;; notmuch

(load (concat esk/user-specific-dir "notmuch"))
(esk/csetq notmuch-crypto-process-mime t)

;; Use async send-mail
;; (require 'smtpmail-async)
;; (setq send-mail-function #'async-smtpmail-send-it
;;       message-send-mail-function #'async-smtpmail-send-it)


;; reStructuredText

(eval-when-compile (require 'rst))

(eval-after-load 'rst
  '(progn
     ;; automatically update contents summary
     (add-hook 'rst-adjust-hook #'rst-toc-update)

     ;; disable new auto indent
     (add-hook 'rst-mode-hook (lambda () (electric-indent-local-mode -1)))))


;; projectile

(require 'projectile)

(eval-after-load 'projectile
  '(progn
     ;; These are common associations in PatchDB context
     (add-to-list 'projectile-other-file-alist '("sql" "rst" "py"))
     (add-to-list 'projectile-other-file-alist '("rst" "sql" "py"))
     (add-to-list 'projectile-other-file-alist '("ascx" "ascx.vb"))
     (add-to-list 'projectile-other-file-alist '("aspx" "aspx.vb"))
     ;; And this is for javascripthon
     (add-to-list 'projectile-other-file-alist '("pj" "js" "py"))))

(defun lele/projectile-mode-line ()
  "Report project name in the modeline."
  (format "%s[%s]" projectile-mode-line-prefix (projectile-project-name)))

(projectile-mode)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


;; google-translate

(when (require 'google-translate nil t)
  (esk/csetq google-translate-default-source-language "en")
  (esk/csetq google-translate-default-target-language "it")
  (global-set-key "\C-ct." #'google-translate-at-point)
  (global-set-key "\C-ctt" #'google-translate-query-translate)
  (global-set-key "\C-ctr." #'google-translate-at-point-reverse)
  (global-set-key "\C-ctrt" #'google-translate-query-translate-reverse))


;; Automatically update copyright years when saving

(esk/csetq copyright-names-regexp (regexp-quote (user-full-name)))
(esk/csetq copyright-year-ranges t)
(add-hook 'before-save-hook #'copyright-update)


;; Customize my main Emacs instance: I'm used to have one Emacs dedicated to
;; news, mail, chat and so on, living in the second i3 workspace. This function
;; is then called by my i3 configuration file with
;;
;;  exec --no-startup-id i3-msg 'workspace 2; exec emacs -f mine-emacs-!; workspace 1'

(defun esk/mine-emacs (&optional dont-ask)
  "Connect to IRC, GNUS, Notmuch and activate Emacs server, but ask first.
If DONT-ASK is non-nil, interactively when invoked with a prefix arg,
start everything unconditionally."
  (interactive "P")

  (if (or dont-ask (y-or-n-p "Emacs server? ")) (server-start))
  (if (or dont-ask (y-or-n-p "Notmuch? ")) (notmuch))
  (if (or dont-ask (y-or-n-p "GNUS? ")) (gnus))
  (if (or dont-ask (y-or-n-p "IRC? ")) (esk/start-erc-session))
  (if (or dont-ask (y-or-n-p "Elfeed? ")) (elfeed))

  ;; Activate the Emacs server
  (server-start)

  (message "Have a nice day!"))

(defun esk/mine-emacs-! ()
  "Unconditionally start my emacs setup."
  (esk/mine-emacs t))


;; Use a nicer font

;(set-frame-font "DejaVu Sans Mono-10" t)
(set-frame-font "Cousine-10" t)


;; Enable some "dangerous" functionalities

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


;; Customize will write the settings here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-mode-text "")
 '(auto-revert-tail-mode-text "")
 '(canlock-password "4ed8bef8ca02417ad311454b547d2c0b6206cd99")
 '(desktop-restore-eager 20)
 '(erc-fill-column 115)
 '(extended-command-suggest-shorter nil)
 '(fill-column 95)
 '(flymake-start-on-flymake-mode nil)
 '(git-commit-summary-max-length 70)
 '(ido-ignore-buffers
   '("\\` "
     "newsrc-dribble"
     "daneel\\.arstecnica\\.it:"
     "\\*notmuch-saved-search-unread\\*"))
 '(ispell-dictionary "american")
 '(js2-strict-trailing-comma-warning t)
 '(longlines-show-hard-newlines t)
 '(magit-delete-by-moving-to-trash nil)
 '(message-fill-column 78)
 '(message-kill-buffer-on-exit t)
 '(mm-text-html-renderer 'w3m)
 '(mode-line-percent-position '(-3 "%o"))
 '(notmuch-fcc-dirs "metapensiero/Sent")
 '(notmuch-wash-wrap-lines-length 90)
 '(org-list-allow-alphabetical t)
 '(org-time-clocksum-format
   '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
 '(package-selected-packages
   '(company
     company-jedi
     darcsum
     docker-tramp
     dockerfile-mode
     elfeed
     erc-hl-nicks
     expand-region
     feature-mode
     flx-ido
     git-timemachine
     google-translate
     iedit
     js2-mode
     less-css-mode
     lsp-mode
     magit
     nginx-mode
     notmuch
     notmuch-labeler
     org-bullets
     plantuml-mode
     projectile
     py-isort
     pycoverage
     rainbow-mode
     smartparens
     treemacs
     typescript-mode
     vc-darcs
     w3m
     web-mode
     wgrep
     whitespace-cleanup-mode
     yaml-mode
     yasnippet))
 '(plantuml-jar-path '"/usr/share/plantuml/plantuml.jar")
 '(projectile-mode-line-function 'lele/projectile-mode-line)
 '(python-fill-docstring-style 'pep-257-nn)
 '(python-flymake-command
   '("flake8" "--max-line-length=95" "--ignore=E121,E123,E126,E226,E24,E266,E704,E711,W503,W504,W601" "-"))
 '(python-flymake-command-output-pattern
   (list "^\\(?:.*\\.p[yj]\\|<?stdin>?\\):\\(?1:[0-9]+\\):\\(?:\\(?2:[0-9]+\\):\\)? \\(?3:.*\\)$" 1 2 nil 3))
 '(python-flymake-msg-alist
   '(("\\(^redefinition\\|.*unused.*\\|used$\\)" . :warning)
     ("^E[0-9]+" . :error)
     ("^W[0-9]+" . :note)))
 '(scss-compile-at-save nil)
 '(send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "mail.arstecnica.it")
 '(smtpmail-smtp-service 25)
 '(tramp-syntax 'default nil (tramp))
 '(web-mode-markup-indent-offset 2)
 '(wgrep-enable-key "")
 '(whitespace-line-column nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-search-feed-face ((t (:foreground "orange red"))))
 '(elfeed-search-title-face ((t (:foreground "firebrick"))))
 '(powerline-active1 ((t (:inherit mode-line :background "dark gray" :foreground "white")))))
