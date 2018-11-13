;;; esk/misc.el --- Things that don't fit anywhere else
;;

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))

(add-hook 'before-make-frame-hook #'esk/turn-off-tool-bar)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(ansi-color-for-comint-mode-on)

(esk/csetq color-theme-is-global t)
(add-hook 'compilation-mode-hook #'esk/turn-on-truncate-lines)
(esk/csetq compilation-scroll-output t)
(esk/csetq echo-keystrokes 0.1)
(esk/csetq ediff-window-setup-function #'ediff-setup-windows-plain)
(esk/csetq enable-local-eval t)
(esk/csetq font-lock-maximum-decoration t)
(esk/csetq gc-cons-threshold 20000000)
(esk/csetq imenu-auto-rescan t)
(esk/csetq indent-tabs-mode nil)
(esk/csetq indicate-empty-lines t)
(esk/csetq inhibit-startup-message t)
(esk/csetq mode-require-final-newline 'ask)
(esk/csetq parens-require-spaces nil)
(esk/csetq scroll-preserve-screen-position t)
(esk/csetq shift-select-mode nil)
(esk/csetq sentence-end-double-space nil)
(esk/csetq transient-mark-mode t)
(esk/csetq truncate-partial-width-windows nil)
(esk/csetq uniquify-buffer-name-style 'forward)
(esk/csetq visible-bell t)
(esk/csetq visual-line-fringe-indicators '(left-curly-arrow
                                           right-curly-arrow))
(esk/csetq whitespace-style '(face
                              trailing
                              lines-tail
                              empty
                              space-before-tab
                              space-after-tab
                              indentation
                              indentation::space
                              tabs))

(add-to-list 'safe-local-variable-values '(lexical-binding . t))

;; Transparently open compressed files
(auto-compression-mode t)

;; Enable syntax highlighting for older Emacsen that have it off
(global-font-lock-mode t)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; Turn on the global smartparens-mode, except in web-mode buffers
(add-to-list 'sp-ignore-modes-list 'web-mode)
(smartparens-global-mode)

;; ido-mode is like magic pixie dust!
(ido-mode t)
(ido-everywhere 1)
(esk/csetq ido-enable-prefix nil)
(esk/csetq ido-enable-flex-matching t)
(esk/csetq ido-create-new-buffer 'always)
(esk/csetq ido-use-filename-at-point nil)
(esk/csetq ido-max-prospects 10)
(esk/csetq ido-ignore-files '("\\`#" "\\`.#" "\\.orig\\'"
                         "\\`\\.\\./" "\\`\\./" "\\`__pycache__/"))
(esk/csetq ido-ignore-directories '("\\`\\.\\./" "\\`\\./" "\\`__pycache__/"))
(esk/csetq ido-auto-merge-work-directories-length -1)
(esk/csetq ido-file-extensions-order '(".py" ".js" t))

;; even more when coupled with flx
(require 'flx-ido)
(flx-ido-mode t)

;; Makefiles are an exception, TAB is mandatory at bol
(add-hook 'makefile-mode-hook #'esk/turn-on-whitespace-mode-makefiles)
(add-hook 'makefile-gmake-mode-hook #'esk/turn-on-whitespace-mode-makefiles)

(add-hook 'text-mode-hook #'turn-on-auto-fill)
(add-hook 'text-mode-hook #'turn-on-flyspell)

(defvar esk/coding-hook nil
  "Hook that gets run on activation of any programming mode.")

;; Use a shorter answer
(defalias 'yes-or-no-p #'y-or-n-p)

;; Seed the random-number generator
(random t)

;; Activate file backups
(esk/csetq version-control t)
(esk/csetq delete-old-versions t)
(esk/csetq backup-by-copying-when-linked t)
(esk/csetq vc-make-backup-files t)

;; Don't clutter up directories with files~
(esk/csetq backup-directory-alist `(("." . ,(expand-file-name
                                             (concat esk/top-dir "backups")))))

;; Ignore files contained within a .git directory
(esk/csetq backup-enable-predicate #'esk/backup-enable-predicate)

;; Associate modes with file extensions

(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.\\(xml\\|xsl\\|rng\\|zcml\\)\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.\\(html\\|jinja\\|jinja2\\|mako\\|pt\\|xhtml\\)\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.raml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("Makefile\\." . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\(gitlab\\.com\\|github\\.com\\).+\\.txt\\'" . gfm-mode))

(autoload 'rst-mode "rst")
(add-to-list 'auto-mode-alist '("\\.rst\\'" . rst-mode))

(autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t)
(add-to-list 'auto-mode-alist '("\\.po[tx]?\\'\\|\\.po\\." . po-mode))
(modify-coding-system-alist 'file "\\.po[tx]?\\'\\|\\.po\\." 'po-find-file-coding-system)

(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

(autoload 'vbnet-mode "vbnet-mode" "Mode for editing VB.NET code." t)
(add-to-list 'auto-mode-alist '("\\.vb\\'" . vbnet-mode))

(autoload 'nix-mode "nix-mode")
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(eval-after-load 'grep
  '(when (boundp 'grep-find-ignored-files)
    (add-to-list 'grep-find-ignored-files "target")
    (add-to-list 'grep-find-ignored-files "*.class")))

(eval-after-load 'web-mode
  '(progn
     (push '("jinja" . "\\.jinja2\\'") web-mode-engine-file-regexps)
     (push '("django" . "/templates/\\([^/]*/\\)?[^/]*\\.html\\'")
           web-mode-engine-file-regexps)
     (setq web-mode-content-types-alist
           '(("javascript" . ".*\\.js\\.jinja2\\'")))))

;; Default to unified diffs
(esk/csetq diff-switches "-u")

;; Cosmetics

(set-face-background 'vertical-border "white")
(set-face-foreground 'vertical-border "white")

(global-prettify-symbols-mode)

(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

;; make emacs use the clipboard
(esk/csetq select-enable-clipboard t)

(add-hook 'c++-mode-hook #'esk/run-coding-hook)
(add-hook 'c-mode-hook #'esk/run-coding-hook)
(add-hook 'css-mode-hook #'esk/run-coding-hook)
(add-hook 'dockerfile-mode-hook #'esk/run-coding-hook)
(add-hook 'html-mode-hook #'esk/run-coding-hook)
(add-hook 'json-mode-hook #'esk/run-coding-hook)
(add-hook 'nxml-mode-hook #'esk/run-coding-hook)
(add-hook 'rst-mode-hook #'esk/run-coding-hook)
(add-hook 'sh-mode-hook #'esk/run-coding-hook)
(add-hook 'sql-mode-hook #'esk/run-coding-hook)
(add-hook 'sql-mode-hook #'sqlind-setup)
(add-hook 'vbnet-mode-hook #'esk/run-coding-hook)
(add-hook 'web-mode-hook #'esk/run-coding-hook)
(add-hook 'yaml-mode-hook #'esk/run-coding-hook)

(esk/csetq c-default-style '((c-mode . "stroustrup")
                             (c++-mode . "stroustrup")
                             (objc-mode . "stroustrup")))

;; avoid flood of pointless warnings
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
