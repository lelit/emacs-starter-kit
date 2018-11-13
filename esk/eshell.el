;;; esk/eshell.el --- Making the defaults a bit saner
;;

(eval-when-compile
  (require 'em-dirs))

(esk/csetq eshell-cmpl-cycle-completions nil)
(esk/csetq eshell-save-history-on-exit t)
(esk/csetq eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\|\\.bzr\\|_darcs\\)/\\'")

(eval-after-load 'esh-opt
  '(progn
     (require 'em-prompt)
     (require 'em-term)
     (require 'em-cmpl)
     (setenv "PAGER" "cat")
     (set-face-attribute 'eshell-prompt nil :foreground "turquoise1")

     ;; TODO: submit these via M-x report-emacs-bug
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))))

(defun eshell/cds ()
  "Change directory to the project's root."
  (eshell/cd (locate-dominating-file default-directory "src")))

(defun eshell/find (dir &rest opts)
  (find-dired dir (mapconcat #'identity opts " ")))
