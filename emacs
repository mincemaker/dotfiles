(setq debug-on-error t)
;; PATH
(setq load-path (append '("~/lisp/"
              "~/lisp/apel"
              "~/.emacs.d/conf")
            load-path))
(setq exec-path (cons "/opt/local/bin" exec-path))
(setenv "PATH"
        (concat '"/opt/local/bin:" (getenv "PATH")))
;; インデントはスペースで
(setq-default tab-width 4 indent-tabs-mode nil)
;; 行数表示
(line-number-mode t)
;; 指定行へジャンプ
(global-set-key "\M-g" 'goto-line)
;; 対応する括弧をハイライト
(show-paren-mode 1)
;; スタートアップページを表示しない
(setq inhibit-startup-message t)

;; ASCIIモードでC-jがAquaSKKに伝わらないようにする
;(setq mac-pass-control-to-system nil) 

;; Control + すべてのキー を無視する
(when (fboundp 'mac-add-ignore-shortcut) (mac-add-ignore-shortcut '(control)))
;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; フォント設定
(when (>= emacs-major-version 23)
 (set-face-attribute 'default nil
                     :family "monaco"
                     :height 140)
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0208
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0212
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'mule-unicode-0100-24ff
  '("monaco" . "iso10646-1"))
 (setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.2)
        (".*osaka-bold.*" . 1.2)
        (".*osaka-medium.*" . 1.2)
        (".*courier-bold-.*-mac-roman" . 1.0)
        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
        (".*monaco-bold-.*-mac-roman" . 0.9)
        ("-cdac$" . 1.3))))

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

;; ウィンドウを透明化
(add-to-list 'default-frame-alist '(alpha . (0.85 0.85)))
;; メニューバーを隠す
;(tool-bar-mode -1)

(autoload 'javascript-mode "javascript" "JavaScript mode" t)
;(autoload 'riece "riece" "Start Riece" t)

(require 'yaml-mode)

(setq auto-mode-alist
      (append '(("\\.js\\'" . javascript-mode)
        ("\\.tt\\'" . xml-mode)
        ("\\.pod\\'" . pod-mode)
        ("\\.ya?ml\\'" . yaml-mode))
        auto-mode-alist))
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
;(add-hook 'text-mode-hook 'ruler-mode)
;(add-hook 'cperl-mode-hook 'ruler-mode)

(global-font-lock-mode t)
(setq font-lock-support-mode 'jit-lock-mode)
(setq-default transient-mark-mode t)

(setq auto-save-default nil)
(setq auto-save-list-file-prefix "~/.autosave/")

(defun make-backup-file-name (filename)
  (expand-file-name
   (concat "~/.emacs.backup/" (file-name-nondirectory filename) "~")
   (file-name-directory filename)))

(setq cssm-indent-function #'cssm-c-style-indenter)
(setq javascript-indent-level 8)

(defalias 'perl-mode 'cperl-mode) ; cperlモード
(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 4)
(setq cperl-brace-offset -4)
(setq cperl-label-offset -4)
(setq cperl-indent-parens-as-block t)
(setq cperl-close-paren-offset -4)
(setq cperl-tab-always-indent t)
;(setq cperl-invalid-face nil)
(setq cperl-highlight-variables-indiscriminately t)

(defun perltidy-region ()
  "Run perltidy on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "perltidy -q" nil t)))
(defun perltidy-defun ()
  "Run perltidy on the current defun."
  (interactive)
  (save-excursion (mark-defun)
  (perltidy-region)))
(defun my-insert-date () ; 日付入れる関数。perlモジュールのChanges書くときに主に使用
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%R:%S+09:00" (current-time))))

(global-set-key "\C-ct" 'perltidy-region)

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

;; dmacro
(defconst *dmacro-key* "\C-t" "繰り返指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

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

;; ;; migemo
;; (load "migemo.el")
;; (setq migemo-use-pattern-alist t)
;; (setq migemo-use-frequent-pattern-alist t)
;; (setq migemo-command "cmigemo")
;; (setq migemo-options '("-q" "-t" "emacs"))
;; (setq migemo-dictionary "/usr/local/share/migemo/euc-jp/migemo-dict")
;; (setq migemo-user-dictionary nil)
;; (setq migemo-regex-dictionary nil)

;; installer
(require 'install-elisp)
(setq install-elisp-repository-directory "~/lisp/")

;; one-key
(require 'one-key)
(require 'one-key-config)

;; egg
(require 'egg)

;; emacs-nav
(require 'nav)

;; 各種設定ファイル
(load "init-c")
(load "init-moccur")
(load "init-anything")
(load "init-yasnippet")
(load "init-perl.el")
(load "init-ruby.el")
(load "init-python.el")
(load "init-ac.el")
;(load "init-howm.el")
(load "init-key-chord.el")
(load "init-org.el")
(load "init-undo-tree.el")
(load "init-autocomplete.el")
(load "init-autoinstall.el")


