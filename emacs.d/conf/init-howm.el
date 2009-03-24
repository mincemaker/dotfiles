(add-to-list 'load-path "~/lisp/howm/")
(setq howm-menu-lang 'ja)
(require 'elscreen-howm)
(require 'howm)
(setq howm-todo-menu-types "[-+~!]")
(setq howm-directory "~/Dropbox/howm/")
(setq howm-file-name-format "%Y/%m/%Y_%m_%d.howm") ; 1日1ファイル
(setq howm-keyword-case-fold-search t) ; <<< で大文字小文字を区別しない
(setq howm-menu-expiry-hours 2) ; メニューを2時間キャッシュ
