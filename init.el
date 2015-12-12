;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))

;;; Common variables

(setq

 ;; top directory, usually ~/.emacs.d/
 esk/top-dir (file-name-directory (or (buffer-file-name) load-file-name))

 ;; starter kit lisp sources directory
 esk/lisp-dir (concat esk/top-dir "esk/")

 ;; not-yet-packaged-packages directory
 esk/autoload-dir (concat esk/top-dir "elpa-to-submit/")

 ;; directory where user specific stuff go
 esk/user-specific-dir (concat esk/top-dir user-login-name "/")

 ;; directory containing overrides
 esk/overrides-dir (concat esk/top-dir "overrides/")

 ;; user specific configuration file
 esk/user-specific-config (concat esk/top-dir user-login-name))


;; see http://permalink.gmane.org/gmane.emacs.bugs/107690
(defmacro csetq (variable value)
  "Macro to set the value of a variable, possibly a custom user option.
Inspect the given VARIABLE and use its `custom-set' function if defined,
or `set-default' if its a per-buffer variable, or `set' to assign the VALUE.
This is an helper that should be used only within this esk framework,
not in the generic assignments."
  `(funcall (or (get ',variable 'custom-set)
                (and (plist-member (symbol-plist ',variable) 'standard-value) 'set-default)
                'set)
            ',variable ,value))


(defun esk/load (file)
  "Load a source file and its per-user override."
  (let ((full-path (concat esk/lisp-dir file))
        (user-override (concat esk/user-specific-dir file)))
    (load full-path)
    (if (file-exists-p (concat user-override ".el"))
        (load user-override))))

;; Define and load external packages
;; Hey, package.el, (package-initialize) is done there!

(esk/load "elpa")

;; On your first run, this should pull in all the base packages.
(when (esk/online?)
  (unless package-archive-contents (package-refresh-contents))
  (esk/install-packages))


;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

(require 'uniquify)
(require 'ansi-color)
(require 'tramp)

;; Autoloaded stuff

(add-to-list 'load-path esk/autoload-dir)
(add-to-list 'load-path (concat esk/autoload-dir "magit/lisp"))
(add-to-list 'load-path (concat esk/autoload-dir "git-modes"))

(load (concat esk/autoload-dir "loaddefs.el"))

;; Load up starter kit customizations

(mapc 'esk/load '(; generic customizations
                  "defuns"
                  "bindings"
                  "misc"
                  "registers"

                  ; major modes
                  "erc"
                  "eshell"
                  "jabber"
                  "js"
                  "lisp"
                  "python"

                  ; extensions
                  "completion"
                  "gnus"
                  "skeletons"
                  "yasnippet"
                  ))

(if (locate-file "darcs" exec-path exec-suffixes #'file-executable-p)
    (esk/load "darcs"))

(if (locate-file "git" exec-path exec-suffixes #'file-executable-p)
    (esk/load "git"))

;; Load generic customizations
(load (concat esk/top-dir "custom") 'noerror)

;; Load system specific customizations
(load (concat esk/top-dir (system-name)) 'noerror)

;; Where emacs will write user custom settings
(setq custom-file (concat esk/user-specific-config ".el"))

;; Load user specific customizations
(load esk/user-specific-config 'noerror)

;; Overrides for possibly old bundled versions
(if (file-exists-p esk/overrides-dir)
    (add-to-list 'load-path esk/overrides-dir))

;;; init.el ends here
