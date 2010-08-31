(defun my-c-mode-hook ()
;  (c-set-style "linux")
  (setq tab-width 4)
  (setq c-basic-offset tab-width))
(add-hook 'c-mode-hook 'my-c-mode-hook)

;; c++-mode-hock（C＋＋のインデントの設定）
(defun my-c++-mode-hook ()
  (c-set-style "k&r")
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (c-toggle-auto-state -1)
  (define-key c-mode-base-map "\C-m" 'newline-and-indent))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
