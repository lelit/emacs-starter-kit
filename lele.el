;-*- coding: utf-8 -*-
;:Progetto:  dot.emacs -- Lele's personal preferences
;:Creato:    ven 09 apr 2010 01:08:16 CEST
;:Autore:    Lele Gaifax <lele@metapensiero.it>
;:Licenza:   GNU General Public License version 3 or later
;

(setq user-mail-address "lele@metapensiero.it")


;; Claws-mail

(setq auto-mode-alist
      (cons '("/tmpmsg\\." . text-mode)
            auto-mode-alist))
(setq magic-mode-alist nil)


;; ERC

(eval-when-compile
  (require 'netrc)
  (require 'erc)
  (require 'erc-join))

(defun erc-auto-login-with-netrc (server nick)
  "Extract username and password from ~/.netrc to authenticate on freenode.net"

  (message "Authenticating %s on IRC server %s..." nick server)
  (when (require 'netrc nil t)
    (let ((freenode (netrc-machine (netrc-parse "~/.netrc") "freenode.net" t)))
      (when freenode
        (let ((freenode-password (netrc-get freenode "password"))
              (freenode-username (netrc-get freenode "login")))
          (when (string= freenode-username nick)
            (setq erc-prompt-for-password nil)
            (erc-message "PRIVMSG"
                         (concat "NickServ identify " freenode-password))))))))

(defun start-erc-session ()
  "Start an ERC session on freenode.net"

  ;; Load credentials from ~/.netrc if present
  (add-hook 'erc-after-connect 'erc-auto-login-with-netrc)

  (setq erc-autojoin-channels-alist
        '(("freenode.net"
           "#rafanass"
           "#linuxtrent"
           "#darcs"
           "#revctrl"
           "#tailor"
           "#sqlalchemy"
           "#airpim"
           )))
  (setq erc-email-userid user-mail-address)
  (setq erc-nick "lelit")

  (erc-autojoin-mode 1)

  (erc-select :server "irc.freenode.net"
              :port 6667
              :nick erc-nick
              :full-name (user-full-name))
  (recentf-mode nil))

(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))
;; (setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))


;; JABBER

(when (require 'jabber nil t)
  (setq jabber-account-list
        '(("lelegaifax@gmail.com"
           (:network-server . "talk.google.com")
           (:connection-type . ssl))))

  ;; Load authentication password from ~/.netrc if present

  (when (require 'netrc nil t)
    ;; Extract password from ~/.netrc file and add it to the
    ;; jabber-account-list. We extract all the network-server entries from
    ;; jabber-account-list, find the corresponding lines in ~/.netrc, use
    ;; the account name mentioned in there to find the entry in the
    ;; jabber-account-list, and add the password there. This means that
    ;; the JID has to be equal to the login value and the network-server
    ;; has to be equal to the machine value.  This probably doesn't work
    ;; for multiple JIDs connecting to the same network server, yet.
    (dolist (server (mapcar (lambda (elem)
                              (cdr (assq :network-server (cdr elem))))
                            jabber-account-list))
      (let* ((data (netrc-machine (netrc-parse "~/.netrc") server t))
             (username (netrc-get data "login"))
             (password (netrc-get data "password"))
             (account (assoc username jabber-account-list)))
        (unless (assq :password (cdr account))
          (setcdr account (cons (cons :password password)
                                (cdr account)))))
      )))


;; GNUS

; store all GNUS staff under my own subdirectory, not tracked by darcs
(setq gnus-home-directory (concat esk-user-specific-dir "/gnus/"))

; shutdown gnus if active, when exiting emacs
(defun gnus-grace-exit-before-kill-emacs ()
  (if (and (fboundp 'gnus-alive-p)
           (gnus-alive-p))
      (let ((noninteractive t))
        (gnus-group-exit))))

(add-hook 'kill-emacs-hook 'gnus-grace-exit-before-kill-emacs)


;; reStructuredText

(require 'rst)

;; aggiorna automaticamente il contents
(add-hook 'rst-adjust-hook 'rst-toc-update)

;; disabilita il font-lock dei titoli, dei code-blocks... che rallenta
;; troppo!
(setq rst-mode-lazy nil)
(setq rst-directive-face 'font-lock-builtin-face)

;; Attiva i bindings standard (vedi C-c p)
;;(add-hook 'rst-mode-hook 'rst-text-mode-bindings)


;; My wmii automatically starts up "emacs -f mine-emacs"

(defun mine-emacs ()
  "Connect to IRC and activate Emacs server, but ask first."
  (interactive)
  (set-frame-font "DejaVu Sans Mono-10" t)
  (if (y-or-n-p "Emacs server? ") (server-start))
  (if (y-or-n-p "GNUS? ") (gnus))
  (if (y-or-n-p "IRC? ") (start-erc-session))
  (if (y-or-n-p "Jabber? ") (jabber-connect-all))
  (message "Have a nice day!"))


;; Customize will write the settings here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(egg-enable-tooltip t)
 '(egg-show-key-help-in-buffers (quote (:log :file-log :reflog :diff)))
 '(longlines-show-hard-newlines t)
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
