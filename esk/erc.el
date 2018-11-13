;;; esk/erc.el --- Some erc helpers
;;

(eval-when-compile (require 'erc))

(defun esk/erc-generate-log-file-name-brief (buffer target nick server port)
  "Computes a log file name from the TARGET and SERVER only.
This results in a filename of the form #channel@server.txt."
  (let ((file (concat target "@" server ".txt")))
    (convert-standard-filename file)))

(eval-after-load 'erc
  '(progn
     (esk/csetq erc-log-insert-log-on-open nil)
     (esk/csetq erc-log-channels t)
     (esk/csetq erc-log-channels-directory "~/irclogs/")
     (esk/csetq erc-generate-log-file-name-function #'esk/erc-generate-log-file-name-brief)
     (esk/csetq erc-log-write-after-send t)
     (esk/csetq erc-log-write-after-insert t)
     (esk/csetq erc-save-buffer-on-part nil)
     (esk/csetq erc-hide-timestamps nil)
     (esk/csetq erc-notifications-icon
            "/usr/share/notify-osd/icons/hicolor/scalable/status/notification-message-im.svg")
     (esk/csetq erc-auto-set-away nil)
     (esk/csetq erc-autoaway-mode nil)
     (esk/csetq erc-modules
            (quote
             (
              autojoin
              button
              completion
              fill
              hl-nicks
              irccontrols
              log
              match
              move-to-prompt
              netsplit
              noncommands
              notifications
              readonly
              ring
              smiley
              stamp
              track
              )))))
