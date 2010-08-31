(setq load-path (append '("~/lisp"
                          "~/lisp/apel"
                          "~/lisp/auto-install"
                          )
                        load-path))
(require 'init-loader)
(init-loader-load "~/lisp/conf")

