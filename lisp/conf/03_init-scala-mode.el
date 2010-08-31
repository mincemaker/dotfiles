(add-to-list 'load-path "~/lisp/scala-mode")
(add-hook 'scala-mode-hook
                    '(lambda ()
                                    (yas/minor-mode-on)))
(setq yas/scala "~/lisp/scala-mode/contrib/yasnippet/snippets")
(yas/load-directory yas/scala)
(require 'scala-mode-auto)
(setq scala-interpreter "/opt/local/bin/scala-2.8")

(require 'scala-mode)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
(add-to-list 'load-path "~/lisp/ensime/elisp/")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; MINI HOWTO: open .scala file. Ensure bin/server.sh is executable. M-x ensime

