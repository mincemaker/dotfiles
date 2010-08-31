(add-to-list 'load-path "~/lisp/howm/")
(setq howm-menu-lang 'ja)
(require 'elscreen-howm)
(require 'howm)
(setq howm-todo-menu-types "[-+~!]")
(setq howm-directory "~/Dropbox/howm/")
(setq howm-file-name-format "%Y/%m/%Y_%m_%d.howm") ; 1日1ファイル
(setq howm-keyword-case-fold-search t) ; <<< で大文字小文字を区別しない
(setq howm-menu-expiry-hours 2) ; メニューを2時間キャッシュ
;; メニューの色
(custom-set-faces
  '(howm-mode-title-face ((((class color)) (:foreground "red"))))
  '(howm-reminder-normal-face ((((class color)) (:foreground "red")))))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/memo/agenda.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(howm-mode-title-face ((((class color)) (:foreground "red"))))
 '(howm-reminder-normal-face ((((class color)) (:foreground "red")))))

