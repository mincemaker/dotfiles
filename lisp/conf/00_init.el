(setq debug-on-error t)
(setq exec-path (cons "/opt/local/bin" exec-path))
(setenv "PATH"
        (concat '"/opt/local/bin:" (getenv "PATH")))
;; インデントはスペースで
(setq-default tab-width 4 indent-tabs-mode nil)
;; 行数表示
(line-number-mode t)
(global-set-key "\M-n" 'linum-mode)
;; 指定行へジャンプ
(global-set-key "\M-g" 'goto-line)
;; 対応する括弧をハイライト
(show-paren-mode 1)
;; スタートアップページを表示しない
(setq inhibit-startup-message t)
;; メニューを表示
(menu-bar-mode 1)

;; ASCIIモードでC-jがAquaSKKに伝わらないようにする
;(setq mac-pass-control-to-system nil)

;; Control + すべてのキー を無視する
(when (fboundp 'mac-add-ignore-shortcut) (mac-add-ignore-shortcut '(control)))
;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(global-set-key "\C-h" 'backward-delete-char)
(define-key global-map "\C-o" 'dabbrev-expand)
(menu-bar-mode 0)
(column-number-mode t)
(line-number-mode t)
(recentf-mode)
(display-time)
(setq scroll-step 1)

;; ウィンドウ設定
(if window-system (progn
  (set-background-color "Black")
  (set-foreground-color "White")
  (set-cursor-color "Gray")
))

;; タブキー
(setq default-tab-width 4)
(setq tab-width 4)
;(setq indent-line-function 'indent-relative-maybe)

(setq auto-save-default nil)
(setq auto-save-list-file-prefix "~/.autosave/")

(defun make-backup-file-name (filename)
  (expand-file-name
   (concat "~/.emacs.backup/" (file-name-nondirectory filename) "~")
   (file-name-directory filename)))

(setq cssm-indent-function #'cssm-c-style-indenter)
(setq javascript-indent-level 8)

; colors ; こっからカラーの設定だけどこれはMeadow使ってたときの設定。コンソールでは意味ない(256色モード使ってないので)
;;(require 'font-lock)
;;(set-face-foreground 'font-lock-comment-face "red")

; colors for Tab and Space
(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-u-2 '((t (:foreground "blue" :underline t))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-u-2 'my-face-u-2)
(defvar my-face-u-1 'my-face-u-1)

; タブと全角スペースの色かえる
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
//     ("\t" 0 my-face-u-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;;(ad-activate 'font-lock-mode)


; インクリメンタルにバッファきりかえられるやつ。必須すぎ
(iswitchb-mode 1)

; 同じ名前のバッファがあった場合上の階層のディレクトリとかも一緒に出して区別できるようにユニークなバッファ名にしてくれるやつ
; コレも必須
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; shell-mode でエスケープを綺麗に表示
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
   "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; shell-modeで上下でヒストリ補完
(add-hook 'shell-mode-hook
   (function (lambda ()
      (define-key shell-mode-map [up] 'comint-previous-input)
      (define-key shell-mode-map [down] 'comint-next-input))))

;; ElScreen
;(require 'elscreen)
;(if window-system
;    (define-key elscreen-map "\C-z" 'iconify-or-deiconify-frame)
;  (define-key elscreen-map "\C-z" 'suspend-emacs))

