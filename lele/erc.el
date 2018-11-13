;;; lele/erc.el --- Lele's ERC specialization

(require 'netrc)
(require 'erc)
(require 'erc-join)

(defun esk/erc-auto-login-with-netrc (server nick)
  "Extract username and password from ~/.netrc to authenticate on freenode.net"

  (message "Authenticating %s on IRC server %s..." nick server)
  (let ((host (netrc-machine (netrc-parse "~/.netrc") "freenode.net" t)))
    (if host
        (let ((password (netrc-get host "password"))
              (username (netrc-get host "login")))
          (when (string= username nick)
            (erc/csetq erc-prompt-for-password nil)
            (erc-message "PRIVMSG"
                         (concat "NickServ identify " password))))
      (message "... credentials not found in ~/.netrc!"))))

(defun esk/start-erc-session ()
  "Start an ERC session on freenode.net"

  ;; Load credentials from ~/.netrc if present
  ;(add-hook 'erc-after-connect 'esk/erc-auto-login-with-netrc)

  (esk/csetq erc-autojoin-channels-alist
             '(("freenode.net"
                "#rafanass"
                "#linuxtrent"
                "#darcs"
                "#sqlalchemy"
                )))
  (esk/csetq erc-nick '("lelit" "lelix"))

  (erc-autojoin-mode 1)

  (message "Connecting to ZNC on daneel.arstecnica.it...")
  (let ((host (netrc-machine (netrc-parse "~/.netrc") "irc.arstecnica.it" t)))
    (if host
        (let ((password (netrc-get host "password")))
          (esk/csetq erc-email-userid (netrc-get host "login"))
          (erc-open "daneel.arstecnica.it"
                    7777
                    "lelit"
                    (user-full-name)
                    t
                    password))
      (message "... credentials not found in ~/.netrc!"))))

(esk/csetq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                 "324" "329" "332" "333" "353" "477"))
(esk/csetq erc-hide-list '("JOIN" "PART" "QUIT" "KICK" "NICK" "MODE"))
