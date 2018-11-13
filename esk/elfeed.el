;;; esk/elfeed.el --- Elfeed setup
;;

(eval-when-compile (require 'elfeed nil t))

(defun esk/elfeed-grace-exit-before-kill-emacs ()
  "Save elfeed DB before quitting Emacs."
  (elfeed-db-save))

(eval-after-load 'elfeed
  '(progn
     ;; Store the database under a directory ignored by git
     (esk/csetq elfeed-db-directory (concat esk/top-dir "elfeed/"))
     (add-hook 'kill-emacs-hook #'esk/elfeed-grace-exit-before-kill-emacs)
     ;; (run-with-timer 0 (* 10 60) #'elfeed-update)
     (define-key esk/menu-map (kbd "f") (cons "Elfeed" #'elfeed))))
