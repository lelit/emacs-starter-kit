;;; esk/yasnippet.el --- Yasnippet setup
;;

(require 'yasnippet)

(yas-global-mode 1)
(esk/csetq yas-prompt-functions '(yas/dropdown-prompt yas/ido-prompt yas/x-prompt))
(esk/csetq yas-wrap-around-region 'cua)
