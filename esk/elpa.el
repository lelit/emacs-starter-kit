;;; esk/elpa.el --- Install a base set of packages automatically.
;;

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/"))
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(when (< emacs-major-version 27)
  (package-initialize))

(defvar esk/packages
  (list
   'company
   'company-jedi
   'darcsum
   'dash
   'erc-hl-nicks
   'expand-region
   'flx-ido
   'ido-hacks
   'ido-grid-mode
   'git-link
   'iedit
   'jedi-core
   'js2-mode
   'json-mode
   'magit
   'markdown-mode
   'projectile
   'py-isort
   'scss-mode
   'smartparens
   'vc-darcs
   'web-mode
   'wgrep
   'whitespace-cleanup-mode
   'yaml-mode
   'yasnippet
   )
  "Libraries that should be installed by default.")

(defun esk/install-packages ()
  "Install all starter-kit packages that aren't installed."
  (interactive)
  (dolist (package esk/packages)
    (unless (or (member package package-activated-list)
                (functionp package))
      (message "Installing %s" (symbol-name package))
      (package-install package))))

(defun esk/upgrade-packages ()
  "Automatically upgrade installed packages to latest version."
  (package-list-packages)
  (package-menu-mark-upgrades)
  (let ((upgrades (package-menu--find-upgrades)))
    (if upgrades
        (package-menu-execute t))))

(defun esk/online? ()
  "See if we're online.

Windows does not have the network-interface-list function, so we
just have to assume it's online."
  ;; TODO how could this work on Windows?
  (if (functionp 'network-interface-list)
      (member 'up (mapcar (lambda (iface) (if (equal (car iface) "lo")
                                         nil
                                       (car (last (car (last (network-interface-info
                                                              (car iface))))))))
                          (network-interface-list)))
    t))
