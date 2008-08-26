;; Python-mode
(add-hook 'python-mode-hook
          '(lambda()
             (setq indent-tabs-mode nil)
			 (setq tab-width 4)
			 ))
