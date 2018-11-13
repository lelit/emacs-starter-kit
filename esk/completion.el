;;; esk/completion.el --- A few common completion tricks
;;

(require 'company)

;; Ignore some more directory patterns
(add-to-list 'completion-ignored-extensions ".egg-info/")
(add-to-list 'completion-ignored-extensions "__pycache__/")

;; Respect the case, I can't imagine why these aren't the default
(esk/csetq company-dabbrev-downcase nil)
(esk/csetq company-dabbrev-ignore-case t)

(defun esk/company-sort-preferring-exact-or-same-case (candidates)
  (let ((exact nil)
        (sameprefix nil)
        (others nil)
        (plen (length company-prefix)))
    (mapc (lambda (candidate)
            (if (equal company-prefix candidate)
                (push candidate exact)
              (if (equal company-prefix (substring candidate 0 plen))
                  (push candidate sameprefix)
                (push candidate others))))
          candidates)
    (append exact sameprefix others)))

(add-to-list 'company-transformers #'esk/company-sort-preferring-exact-or-same-case)

(global-company-mode)
