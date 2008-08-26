;; yasnippet
(require 'yasnippet)
;; トリガはSPC, 次の候補への移動はTAB
(setq yas/trigger-key (kbd "SPC"))
(setq yas/next-field-key (kbd "TAB"))
;; ポップアップを dropdown-list にする (効果なし？)
(require 'dropdown-list)
(setq yas/text-popup-function #'yas/dropdown-list-popup-for-template)
;; コメントやリテラルではスニペットを展開しない
(setq yas/buffer-local-condition
      '(or (not (or (string= "font-lock-comment-face"
                             (get-char-property (point) 'face))
                    (string= "font-lock-string-face"
                             (get-char-property (point) 'face))))
           '(require-snippet-condition . force-in-comment)))

(require 'anything-c-yasnippet)
(setq anything-c-yas-space-match-any-greedy t) ;スペース区切りで絞り込めるようにする デフォルトは nil
(global-set-key (kbd "C-c y") 'anything-c-yas-complete) ;C-c yで起動 (同時にお使いのマイナーモードとキーバインドがかぶるかもしれません)
(yas/initialize)
(yas/load-directory "~/lisp/snippets/") ;snippetsのディレクトリを指定
(add-to-list 'yas/extra-mode-hooks 'ruby-mode-hook)
(add-to-list 'yas/extra-mode-hooks 'cperl-mode-hook)
