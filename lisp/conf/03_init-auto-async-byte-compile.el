(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regxp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
