;;; starter-kit-erc.el --- Some erc helpers
;;

(eval-when-compile (require 'erc))

(defun erc-generate-log-file-name-brief (buffer target nick server port)
  "Computes a log file name from the TARGET and SERVER only.
This results in a filename of the form #channel@server.txt."
  (let ((file (concat target "@" server ".txt")))
    (convert-standard-filename file)))

(eval-after-load 'erc
  '(progn
     ;; logging
     (setq erc-log-insert-log-on-open nil)
     (setq erc-log-channels t)
     (setq erc-log-channels-directory "~/irclogs/")
     (setq erc-generate-log-file-name-function 'erc-generate-log-file-name-brief)
     (setq erc-save-buffer-on-part t)
     (setq erc-hide-timestamps nil)
     (setq erc-notifications-icon
           "/usr/share/notify-osd/icons/hicolor/scalable/status/notification-message-im.svg")

     (add-hook 'erc-insert-post-hook 'erc-save-buffer-in-logs)
     (add-hook 'erc-mode-hook (lambda ()
                                (when (not (featurep 'xemacs))
                                  (set (make-local-variable
                                        'coding-system-for-write)
                                       'emacs-mule))))

     (setq erc-auto-set-away nil)
     (setq erc-autoaway-mode nil)
     (setq erc-modules
           (quote
            (
             autojoin
             button
             completion
             fill
             hl-nicks
             irccontrols
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