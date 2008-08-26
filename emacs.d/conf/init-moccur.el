(load "moccur")
;;color-moccurのお勧め設定。
(setq moccur-split-word t) ;スペース区切りでAND検索
;(setq moccur-use-migemo t) ;migemoを使う

(require 'anything)
(require 'color-moccur)

(setq *moccur-buffer-name-exclusion-list*
      '("\.svn" "*Completions*" "*Messages*"))
