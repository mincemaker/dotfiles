(defvar is_emacs22 (equal emacs-major-version 22))
(defvar is_emacs23 (equal emacs-major-version 23))
(defvar is_emacs24 (equal emacs-major-version 24))
(defvar is_window-sys (not (eq (symbol-value 'window-system) nil)))
(defvar is_mac (or (eq window-system 'mac) (featurep 'ns)))
(defvar is_carbon (and is_mac is_emacs22 is_window-sys))
(defvar is_cocoa (and is_mac (or is_emacs23 is_emacs24) is_window-sys))
(defvar is_inline-patch (eq (boundp 'mac-input-method-parameters) t))
(defvar is_darwin (eq system-type 'darwin))

(when is_cocoa
  (set-face-attribute 'default nil
                      :family "Menlo"
                      :height 150)
  (set-fontset-font nil
                    'japanese-jisx0208
                    (font-spec :family "YukarryAA"))

  ;; ウィンドウを透明化
  (add-to-list 'default-frame-alist '(alpha . (0.85 0.85)))
  ;; メニューバーを隠す
  (tool-bar-mode -1)

  (add-hook 'text-mode-hook 'ruler-mode)
  (add-hook 'cperl-mode-hook 'ruler-mode)

  (global-font-lock-mode t)
  (setq font-lock-support-mode 'jit-lock-mode)
  (setq-default transient-mark-mode t)

  ;; Show tab, zenkaku-space, white spaces at end of line
  ;; http://www.bookshelf.jp/soft/meadow_26.html#SEC317
  (defface my-face-tab         '((t (:background "Yellow"))) nil :group 'my-faces)
  (defface my-face-zenkaku-spc '((t (:background "LightBlue"))) nil :group 'my-faces)
  (defface my-face-spc-at-eol  '((t (:foreground "Red" :underline t))) nil :group 'my-faces)
  (defvar my-face-tab         'my-face-tab)
  (defvar my-face-zenkaku-spc 'my-face-zenkaku-spc)
  (defvar my-face-spc-at-eol  'my-face-spc-at-eol)
  (defadvice font-lock-mode (before my-font-lock-mode ())
             (font-lock-add-keywords
               major-mode
               '(("\t" 0 my-face-tab append)
                 ("　" 0 my-face-zenkaku-spc append)
                 ("[ \t]+$" 0 my-face-spc-at-eol append)
                 )))
  (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
  (ad-activate 'font-lock-mode)
  ;; settings for text file
  (add-hook 'text-mode-hook
            '(lambda ()
               (progn
                 (font-lock-mode t)
                 (font-lock-fontify-buffer))))
)

