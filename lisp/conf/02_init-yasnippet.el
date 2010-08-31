(add-to-list 'load-path
              "~/lisp/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/lisp/yasnippet/snippets")
(setq yas/prompt-functions '(yas/dropdown-prompt))
