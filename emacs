;; PATH
(setq load-path (append '("~/lisp/"
              "~/.emacs.d/conf")
            load-path))
(setq exec-path (cons "/usr/local/bin" exec-path))
(setenv "PATH"
        (concat '"/usr/local/bin:" (getenv "PATH")))

;; $B9T?tI=<((B
(line-number-mode t)
;; $B;XDj9T$X%8%c%s%W(B
(global-set-key "\M-g" 'goto-line)
;; $BBP1~$9$k3g8L$r%O%$%i%$%H(B
(show-paren-mode 1)
;; $B%9%?!<%H%"%C%W%Z!<%8$rI=<($7$J$$(B
(setq inhibit-startup-message t)

;; ASCII$B%b!<%I$G(BC-j$B$,(BAquaSKK$B$KEA$o$i$J$$$h$&$K$9$k(B
;(setq mac-pass-control-to-system nil) 

;; Control + $B$9$Y$F$N%-!<(B $B$rL5;k$9$k(B
(mac-add-ignore-shortcut '(control))

;; $B%U%)%s%H@_Dj(B
;(if (eq window-system 'mac)
;   (progn
;     (require 'carbon-font)
;     (fixed-width-set-fontset "hiramaru" 12)))

;; $B%&%#%s%I%&@_Dj(B
(if window-system (progn
  (set-background-color "Black")
  (set-foreground-color "White")
  (set-cursor-color "Gray")
))

;; $B%?%V%-!<(B
(setq default-tab-width 4)
(setq tab-width 4)
;(setq indent-line-function 'indent-relative-maybe)

;; $B%&%#%s%I%&$rF)L@2=(B
(add-to-list 'default-frame-alist '(alpha . (0.85 0.85)))
;; $B%a%K%e!<%P!<$r1#$9(B
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
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
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

(defalias 'perl-mode 'cperl-mode) ; cperl$B%b!<%I(B
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
(defun my-insert-date () ; $BF|IUF~$l$k4X?t!#(Bperl$B%b%8%e!<%k$N(BChanges$B=q$/$H$-$K<g$K;HMQ(B
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%R:%S+09:00" (current-time))))

(global-set-key "\C-ct" 'perltidy-region)

; colors ; $B$3$C$+$i%+%i!<$N@_Dj$@$1$I$3$l$O(BMeadow$B;H$C$F$?$H$-$N@_Dj!#%3%s%=!<%k$G$O0UL#$J$$(B(256$B?'%b!<%I;H$C$F$J$$$N$G(B)
;;(require 'font-lock)
;;(set-face-foreground 'font-lock-comment-face "red")

; colors for Tab and Space
(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-u-2 '((t (:foreground "blue" :underline t))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-u-2 'my-face-u-2)
(defvar my-face-u-1 'my-face-u-1)

; $B%?%V$HA43Q%9%Z!<%9$N?'$+$($k(B
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
//     ("\t" 0 my-face-u-2 append)
     ("$B!!(B" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;;(ad-activate 'font-lock-mode)


; $B%$%s%/%j%a%s%?%k$K%P%C%U%!$-$j$+$($i$l$k$d$D!#I,?\$9$.(B
(iswitchb-mode 1)

; $BF1$8L>A0$N%P%C%U%!$,$"$C$?>l9g>e$N3,AX$N%G%#%l%/%H%j$H$+$b0l=o$K=P$7$F6hJL$G$-$k$h$&$K%f%K!<%/$J%P%C%U%!L>$K$7$F$/$l$k$d$D(B
; $B%3%l$bI,?\(B
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; shell-mode $B$G%(%9%1!<%W$re:No$KI=<((B
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
   "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; shell-mode$B$G>e2<$G%R%9%H%jJd40(B
(add-hook 'shell-mode-hook
   (function (lambda ()
      (define-key shell-mode-map [up] 'comint-previous-input)
      (define-key shell-mode-map [down] 'comint-next-input))))

;; ElScreen
(require 'elscreen)
(if window-system
    (define-key elscreen-map "\C-z" 'iconify-or-deiconify-frame)
  (define-key elscreen-map "\C-z" 'suspend-emacs))

;; dmacro
(defconst *dmacro-key* "\C-t" "$B7+$jJV;XDj%-!<(B")
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
     ("$B!!(B" 0 my-face-zenkaku-spc append)
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

;; $B3F<o@_Dj%U%!%$%k(B
(load "init-c")
(load "init-moccur")
(load "init-anything")
(load "init-yasnippet")
(load "init-perl.el")
(load "init-python.el")