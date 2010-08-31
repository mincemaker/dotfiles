(defconst *dmacro-key* "\C-t" "繰り返指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)
