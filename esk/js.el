;;; esk/js.el --- Some helpful Javascript helpers
;;

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(eval-when-compile
  (require 'js2-mode)
  (require 'hl-line))

(esk/csetq js2-include-jslint-globals nil)
(esk/csetq js2-indent-switch-body t)

(defun esk/js2-apply-jsl-declares ()
  "Extract top level //jsl:declare XXX comments"
  (setq js2-additional-externs
        (nconc (esk/js2-get-jsl-declares)
               js2-additional-externs)))

(defun esk/js2-get-jsl-declares ()
  (cl-loop for node in (js2-ast-root-comments js2-mode-ast)
           when (and (js2-comment-node-p node)
                     (save-excursion
                       (goto-char (+ 2 (js2-node-abs-pos node)))
                       (looking-at "jsl:declare ")))
           append (esk/js2-get-jsl-declares-in
                   (match-end 0)
                   (js2-node-abs-end node))))

(defun esk/js2-get-jsl-declares-in (beg end)
  (let (res)
    (save-excursion
      (goto-char beg)
      (while (re-search-forward js2-mode-identifier-re end t)
        (push (match-string-no-properties 0) res)))
    (nreverse res)))

(eval-after-load 'js2-mode
  '(progn
     (add-hook 'js2-mode-hook #'js2-highlight-unused-variables-mode)

     (add-hook 'js2-mode-hook #'esk/run-coding-hook)

     ;; Register some mode-specific hooks
     (add-hook 'js2-mode-hook
               (lambda ()
                 ;; Prettify the function keyword
                 (setq-local prettify-symbols-alist '(("function" .  ?ƒ)))

                 ;; Parse additional externs
                 (add-hook 'js2-post-parse-callbacks #'esk/js2-apply-jsl-declares nil 'local)
                 (js2-reparse t)))

     ;; Activate imenu support
     (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

     ;; Nice warnings/errors summary on F7
     (define-key js2-mode-map [f7] #'js2-display-error-list)

     ;; Bind js2-edit-extjs-template-at-point to C-c t
     (define-key js2-mode-map (kbd "C-c t") #'js2-edit-extjs-template-at-point)

     ;; Display warnings/errors on the mode line
     (add-hook 'js2-parse-finished-hook
               (lambda ()
                 (setq mode-name "JS2")
                 (when (> (length js2-parsed-errors) 0)
                   (setq mode-name
                         (list mode-name
                               ":"
                               (propertize (format "%dE" (length js2-parsed-errors))
                                           'face 'error))))
                 (when (> (length js2-parsed-warnings) 0)
                   (setq mode-name
                         (list mode-name
                               ":"
                               (propertize (format "%dW" (length js2-parsed-warnings))
                                           'face 'warning))))
                 (force-mode-line-update)))))

(eval-after-load 'json-mode
  '(progn
     (add-hook 'json-mode-hook (lambda () (setq-local js-indent-level 2)))))

;; Avoid escape nightmares by editing ExtJS templates in separate buffer
;;
;; Execute `M-x js2-edit-extjs-template-at-point' with the point inside the
;; following array of strings:
;;
;;   tpl: [
;;       '<div class=\'bh-summary\'>',
;;       '    <header>{header}</header>',
;;       '',
;;       '    <label>{fullname}</label>',
;;       '</div>'
;;   ]
;;
;; to edit the template in a separate buffer containing just the script, correctly handling
;; backslashed chars:
;;
;;   <div class='bh-summary'>
;;       <header>{header}</header>
;;
;;       <label>{fullname}</label>
;;   </div>
;;
;; The template definition may contain a configuration object defining template member
;; functions, for example:
;;
;;   tpl: [
;;       '<div class=\'bh-summary\'>',
;;       '    <header>{header}</header>',
;;       '',
;;       '    <label>{[this.uppercase(fullname)]}</label>',
;;       '</div>',
;;       {
;;         uppercase: function(s) {
;;           return s.toUpperCase();
;;         }
;;       }
;;   ]
;;
;; Such object is ignored and left in place as-is.
;;
;; Confirm the changes with `C-c C-c', abort them with `C-c C-k'.

(defvar-local eet/template-buffer nil
  "The buffer containing the template being edited.")

(defvar-local eet/template-start nil
  "The position in the original buffer where the template begins.")

(defvar-local eet/template-end nil
  "The position in the original buffer where the template ends.")

(defvar-local eet/original-line nil
  "The line containing the point in the original buffer when the template edit began.")

(defvar-local eet/original-winconf nil
  "The windows configuration when the template edit began.")

(defun js2-edit-extjs-template-at-point ()
  "Edit an array of strings representing an ExtJS template in a different buffer."
  (interactive)
  (let* ((ppss (syntax-ppss))
         (inner-sexp-start (nth 1 ppss))
         (line (line-number-at-pos (point))))
    (if inner-sexp-start
        (save-excursion
          (goto-char inner-sexp-start)
          (if (looking-at "\\[[\s\n]+['\"]")
              (eet/edit (1+ inner-sexp-start) (eet/find-template-end) line)
            (message "Not within an array of strings!")))
      (message "Not within a sexp!"))))

(defun eet/find-template-end ()
  "Find and return the end of the template."
  (let (end)
    (save-excursion
      (forward-sexp 1)
      (forward-char -1)
      (setq end (point))
      ;; Here the point is over the ending ']': go backward by one s-exp, that
      ;; may be either the last string, or the optional configuration object;
      ;; in the latter case, search backward for the comma separator
      (forward-sexp -1)
      (when (looking-at "{")
        (search-backward ",")
        (setq end (point))))
    end))

(defun eet/edit (start end line)
  "Extract the template from the array of strings into a new buffer."
  (let ((template (buffer-substring-no-properties start end))
        (template-buffer (current-buffer))
        (winconf (current-window-configuration))
        (offset-lines (- line (line-number-at-pos start))))
    (pop-to-buffer (generate-new-buffer "*template-edit*"))
    ;; Insert the original template strings, ensuring the presence of an
    ;; end-of-line after the last string
    (insert template "\n")
    (eet/implode)
    (goto-char (point-min))
    (when (looking-at "<")
      (html-mode))
    (eet/mode 1)
    (forward-line (1- offset-lines))
    (hl-line-highlight)
    (set-buffer-modified-p nil)
    (setq eet/template-buffer template-buffer
          eet/template-start start
          eet/template-end end
          eet/original-line line
          eet/original-winconf winconf)
    (message "Type C-c C-c to confirm changes, C-c C-k to abort")))

(defun eet/implode ()
  "Remove string quotes from each line and unescape remaining text."
  (goto-char (point-min))
  (let ((start (point))
        quote)
    (while (re-search-forward "['\"]" (point-max) t)
      (setq quote (char-to-string (char-before)))
      (delete-region start (point))
      (end-of-line)
      (let ((end (point)))
        (search-backward quote)
        (delete-region (point) end))
      (eet/unescape-char-in-line quote)
      (eet/unescape-char-in-line "\\")
      (forward-line)
      (setq start (point))))
  (whitespace-cleanup))

(defun eet/unescape-char-in-line (char)
  "Drop the escape from given CHARs in the current line."
  (save-excursion
    (let (start)
      (beginning-of-line)
      (setq start (point))
      (end-of-line)
      (while (search-backward (concat "\\" char) start t)
        (replace-match "")
        (insert char)))))

(defun eet/abort ()
  "Used in eet/mode to close the popup window."
  (interactive)
  (let ((winconf eet/original-winconf)
        (template-buffer eet/template-buffer)
        (original-line eet/original-line))
    (kill-buffer)
    (set-window-configuration winconf)
    (switch-to-buffer template-buffer)
    (goto-char (point-min))
    (forward-line (1- original-line))))

(defun eet/conclude ()
  "Used in eet/mode to confirm changes and close the popup window."
  (interactive)
  (let ((line (eet/explode))
        (contents (buffer-substring-no-properties (point-min) (- (point-max) 2)))
        (template-buffer eet/template-buffer)
        (template-start eet/template-start)
        (template-end eet/template-end)
        (winconf eet/original-winconf))
    (kill-buffer)
    (set-window-configuration winconf)
    (switch-to-buffer template-buffer)
    (goto-char template-start)
    (delete-char (- template-end template-start))
    (insert "\n")
    (insert contents)
    ;; If we are looking at a comma it means that what follows is the template
    ;; configuration object, otherwise insert a newline to properly indent the
    ;; ending ']'
    (unless (looking-at ",")
      (insert "\n"))
    (let ((end (1+ (point))))
      (goto-char template-start)
      (forward-line line)
      (indent-region template-start end))))

(defun eet/explode ()
  "Reinsert string quotes around each line and separate them with an ending comma."
  (save-excursion
    (goto-char (point-max))
    (insert "\n"))
  (whitespace-cleanup)
  (let ((line (line-number-at-pos (point)))
        start)
    (goto-char (point-min))
    (while (and (re-search-forward "^" nil t)
                (not (eobp)))
      (setq start (point))
      (eet/escape-char-in-line "\\")
      (eet/escape-char-in-line "'")
      (insert "'")
      (end-of-line)
      (insert "'")
      (unless (eobp)
        (insert ","))
      (forward-line)
      (setq start (point)))
    line))

(defun eet/escape-char-in-line (char)
  "Escape given CHARs in current line."
  (save-excursion
    (let (start)
      (beginning-of-line)
      (setq start (point))
      (end-of-line)
      (while (search-backward char start t)
        (replace-match "")
        (insert "\\" char)
        (backward-char 2)))))

(defvar eet/mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-k") #'eet/abort)
    (define-key map (kbd "C-c C-c") #'eet/conclude)
    map)
  "Keymap for eet/mode minor mode.")

(define-minor-mode eet/mode
  "Minor mode for useful keybindings while editing template."
  nil " TemplateEdit" eet/mode-map)
