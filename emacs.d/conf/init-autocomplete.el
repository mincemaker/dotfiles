(add-to-list 'load-path "/Users/mincemaker/lisp/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/mincemaker/lisp/ac-dict")
(ac-config-default)
(setq ac-use-menu-map t)
;; デフォルトで設定済み
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

