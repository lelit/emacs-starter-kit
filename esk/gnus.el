;;; esk/gnus.el --- Gnus customization
;;

(eval-when-compile
  (require 'gnus)
  (require 'gnus-group)
  (require 'gnus-start)
  (require 'gnus-art)
  (require 'gnus-msg)
  (require 'mm-decode))

;; Since I only use Gnus to read the newsgroups, disable reading and writing
;; the generic newsrc file
(esk/csetq gnus-read-newsrc-file nil)
(esk/csetq gnus-save-newsrc-file nil)

;; Store all Gnus stuff under a directory ignored by git
(esk/csetq gnus-home-directory (concat esk/top-dir "gnus/"))
(esk/csetq gnus-init-file (concat gnus-home-directory "gnus-init"))
(esk/csetq gnus-startup-file (concat gnus-home-directory "newsrc"))

;; Also, I manually select which newsgroups I'm gonna follow, so don't bother
;; with keeping a notion of "new" newsgroups
(esk/csetq gnus-save-killed-list nil)
(esk/csetq gnus-check-new-newsgroups nil)

;; Customize appearence
(esk/csetq gnus-permanently-visible-groups ".")
(esk/csetq gnus-summary-line-format "%U%R%z%d %(%[%-20,20a%]%) %I%s\n")
(esk/csetq gnus-summary-same-subject "⤷")

;; Prefer plain text alternative
(esk/csetq mm-discouraged-alternatives '("text/html" "text/richtext" "image/.*"))
(esk/csetq mm-automatic-display
       '("text/plain" "text/enriched" "text/richtext"
         ;; "text/html"
         "text/x-verbatim"
         "text/x-vcard" "image/.*" "message/delivery-status" "multipart/.*"
         "message/rfc822" "text/x-patch" "text/dns" "application/pgp-signature"
         "application/emacs-lisp" "application/x-emacs-lisp"
         "application/x-pkcs7-signature"
         "application/pkcs7-signature" "application/x-pkcs7-mime"
         "application/pkcs7-mime"
         ;; Mutt still uses this even though it has already been withdrawn.
         "application/pgp\\'"
         "text/x-org"))
(esk/csetq gnus-buttonized-mime-types '("multipart/alternative" "multipart/signed"))

;; Archive - putting sent mail and news somewhere
(esk/csetq gnus-message-archive-group
       '((if (message-news-p)
             (concat "sent-news-"
                     (format-time-string "%b-%y"))
           (concat "sent-mail-"
                   (format-time-string "%b-%y")))))

(defun esk/gnus-grace-exit-before-kill-emacs ()
  "Shutdown gnus if active, when exiting emacs."
  (if (and (fboundp 'gnus-alive-p)
           (gnus-alive-p))
      (let ((noninteractive t))
        (gnus-group-exit))))

(defun esk/gnus-switch-to-group-buffer ()
  "Switch to the main Gnus buffer."
  (interactive)
  (switch-to-buffer "*Group*"))

(defun esk/gnus-subscribe-to-user-groups ()
  "Subscribe to user's groups, if defined.
If user wants, she should define the list esk/gnus-user-groups in her
`~/.emacs.d/her-name/gnus.el' containing the newsgroups she's interested to."
  (require 'gnus-start)
  (when (boundp 'esk/gnus-user-groups)
    (unless gnus-have-read-active-file
      (gnus-read-active-file))
    (mapc (lambda (group)
            (unless (gnus-group-entry group)
              (gnus-subscribe-newsgroup group))) (reverse esk/gnus-user-groups))))

(eval-after-load 'gnus
  '(progn
     (esk/gnus-subscribe-to-user-groups)
     (add-hook 'kill-emacs-hook #'esk/gnus-grace-exit-before-kill-emacs)
     (define-key esk/menu-map (kbd "n") (cons "News" #'esk/gnus-switch-to-group-buffer))))
