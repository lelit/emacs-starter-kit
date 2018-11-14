;;; esk/python.el --- setup of python stuff  -*- lexical-binding:t -*-
;;

(eval-when-compile
  (require 'python)
  (require 'virtualenv))

(require 'smartparens-python)

(defun esk/virtualenv-activate (dir)
  "Activate the virtualenv located in DIR."

  ;; Removing the eventually present trailing slash
  (when (string= (substring dir -1 nil) "/")
    (setq dir (substring dir 0 -1)))

  ;; Eventually deactivate previous virtualenv
  (when virtualenv-name
    (virtualenv-deactivate))

  ;; Storing old variables
  (setq virtualenv-old-path (getenv "PATH"))
  (setq virtualenv-old-exec-path exec-path)

  (setq virtualenv-name (file-name-nondirectory dir))

  ;; I usually have the concrete virtual env isolated in a "env"
  ;; subdirectory, so use that if it exists.
  (if (file-exists-p (concat dir "/env/bin"))
      (setq dir (concat dir "/env")))

  (setenv "VIRTUAL_ENV" dir)
  (virtualenv-add-to-path (concat dir "/bin"))
  (add-to-list 'exec-path (concat dir "/bin"))

  (message (concat "Virtualenv '" virtualenv-name "' activated.")))

(defun esk/activate-virtual-desktop ()
  "Turn on a virtualenv and its related desktop, in auto-save mode"
  (interactive)

  (require 'virtualenv)

  ;; Eventually deactivate current desktop
  (when desktop-save-mode
    (virtualenv-deactivate)
    (desktop-kill))

  (let ((dir (ido-read-directory-name "Virtual desktop: ")))
    (esk/virtualenv-activate dir)
    (esk/csetq desktop-base-file-name "emacs.desktop")
    (esk/csetq desktop-dirname dir)
    (esk/csetq desktop-save t)
    (esk/csetq desktop-save-mode t)
    (unless (desktop-read dir)
      (dired dir))
    (esk/csetq server-name (md5 dir)))

  ;; Activate the Emacs server
  (server-start)

  ;; Activate projectile)
  (require 'projectile)
  (projectile-mode)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(defun esk/python-region-as-new-variable ()
  "Create a new variable, just before current statement, initialized to current region."
  (interactive)
  (let ((text (delete-and-extract-region (point) (mark)))
        (name (read-string "Variable name: " nil nil "varname")))
    (insert name)
    (python-nav-beginning-of-statement)
    (esk/open-previous-line 1)
    (insert name " = " text)))

(defun esk/python-add-symbol-to-__all__ ()
  "Take the symbol under the point and add it to the __all__ tuple, if it's not already there."
  ;; adapted from
  ;; http://stackoverflow.com/questions/860357/emacs-function-to-add-symbol-to-all-in-python-mode#860569
  (interactive)
  (save-excursion
    (let ((thing (thing-at-point 'symbol)) found)
      (goto-char (point-min))
      (while (and (not found)
                  (re-search-forward (rx symbol-start "__all__" symbol-end
                                         (0+ space) "=" (0+ space)
                                         (syntax open-parenthesis))
                                     nil t))
        (setq found (not (python-syntax-comment-or-string-p))))
      (if found
          (when (not (looking-at (rx-to-string
                                  `(and (0+ (not (syntax close-parenthesis)))
                                        (syntax string-quote) ,thing (syntax string-quote)))))
            (insert (format "\'%s\', " thing))
            (esk/sort-symbols nil (beginning-of-thing 'sexp) (end-of-thing 'sexp)))
        (goto-char (point-max))
        (insert (format "\n\n__all__ = (\'%s\',)\n" thing))))))

(defun esk/python-mode-setup ()
  ;; Run other hooks
  (esk/run-coding-hook)

  ;; Activate flymake
  (flymake-mode 1)

  ;; Prettify only lambda keyword
  (setq prettify-symbols-alist '(("lambda" . ?λ)))
  (prettify-symbols-mode -1)
  (prettify-symbols-mode))

(defun esk/python-split-string ()
  "Split string at point."
  (interactive)
  (let ((ssp (python-syntax-context 'string)))
    (when ssp
      (let ((ssqc (char-after ssp))
            (ws (progn
                  (looking-at "\s*")
                  (match-string-no-properties 0))))
        (insert ssqc)
        (newline-and-indent)
        (insert ssqc)
        (insert ws)))))

(defconst esk/python-c-style
  '("python"
    (indent-tabs-mode . nil)
    (c-basic-offset . 4))
  "Rectified CPython style")

(c-add-style "python3" esk/python-c-style)

(eval-after-load 'python
  '(progn
     (add-hook 'python-mode-hook #'esk/python-mode-setup)

     ;; Avoid pointless warning
     (esk/csetq python-indent-guess-indent-offset-verbose nil)

     ;; Activate pdbtrack in M-x shell buffers
     (add-hook 'comint-output-filter-functions #'python-pdbtrack-comint-output-filter-function)

     (require 'company-jedi)

     (add-to-list 'company-backends 'company-jedi)

     (define-key python-mode-map [C-return] #'esk/python-split-string)
     (define-key python-mode-map (kbd "C-c +") #'esk/python-add-symbol-to-__all__)
     (define-key python-mode-map (kbd "C-c b") #'python-nav-backward-defun)
     (define-key python-mode-map (kbd "C-c f") #'python-nav-forward-defun)
     (define-key python-mode-map (kbd "C-c u") #'python-nav-backward-statement)
     (define-key python-mode-map (kbd "C-c d") #'python-nav-forward-statement)
     (define-key python-mode-map (kbd "C-c r") #'py-isort-buffer)
     (define-key python-mode-map (kbd "C-c v") #'esk/python-region-as-new-variable)
     (define-key python-mode-map (kbd "C-c S") #'esk/sort-symbols)))

(eval-after-load 'py-isort
  '(progn
     ;; --multi_line_output
     (esk/csetq py-isort-options '("-m 3"))))
