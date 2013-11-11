;;; starter-kit-js.el --- Some helpful Javascript helpers
;;
;; Part of the Emacs Starter Kit

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(eval-when-compile (require 'js2-mode))

(defun js2-apply-jsl-declares ()
  "Extract top level //jsl:declare XXX comments"
  (setq js2-additional-externs
        (nconc (js2-get-jsl-declares)
               js2-additional-externs)))

(defun js2-get-jsl-declares ()
  (loop for node in (js2-ast-root-comments js2-mode-ast)
        when (and (js2-comment-node-p node)
                  (save-excursion
                    (goto-char (+ 2 (js2-node-abs-pos node)))
                    (looking-at "jsl:declare ")))
        append (js2-get-jsl-declares-in
                (match-end 0)
                (js2-node-abs-end node))))

(defun js2-get-jsl-declares-in (beg end)
  (let (res)
    (save-excursion
      (goto-char beg)
      (while (re-search-forward js2-mode-identifier-re end t)
        (push (match-string-no-properties 0) res)))
    (nreverse res)))

(eval-after-load 'js2-mode
  '(progn
     (add-hook 'js2-mode-hook 'run-coding-hook)
     (add-hook 'js2-mode-hook
               (lambda ()
                 (add-hook 'js2-post-parse-callbacks
                           'js2-apply-jsl-declares nil t)))))

(provide 'starter-kit-js)
;;; starter-kit-js.el ends here
