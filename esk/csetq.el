;;; csetq.el --- customize-aware setq macro

;; see http://permalink.gmane.org/gmane.emacs.bugs/107690
(defmacro esk/csetq (variable value)
  "Macro to set the value of a variable, possibly a custom user option.
Inspect the given VARIABLE and use its `custom-set' function if defined,
or `set-default' if its a per-buffer variable, or `set' to assign the VALUE.
This is an helper that should be used only within this esk framework,
not in the generic assignments."
  `(funcall (or (get ',variable 'custom-set)
                (and (plist-member (symbol-plist ',variable) 'standard-value) 'set-default)
                'set)
            ',variable ,value))
