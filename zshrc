##
# zshrc template
# Last updated: 2026
# zsh 5.x+ required
##

# ============================================================
# Shell Options
# ============================================================
setopt auto_menu          # Tab で補完候補メニューを表示
setopt auto_cd            # ディレクトリ名だけで cd
setopt correct            # コマンドのスペル訂正
setopt auto_name_dirs     # 変数をディレクトリとして扱う
setopt auto_remove_slash  # 補完末尾の / を自動削除
setopt extended_glob      # 拡張グロブ (#, ^, ~) を有効化
setopt list_types         # 補完一覧でファイル種別を表示
setopt no_beep            # ビープ音を無効化
setopt always_last_prompt # 補完時にプロンプトを最下行に固定
setopt auto_param_keys    # 補完後のカーソル位置を自動調整
setopt auto_pushd         # cd を自動的に pushd に（cd 履歴を保持）
setopt pushd_ignore_dups  # pushd の重複を無視
setopt extended_history   # 履歴にタイムスタンプを記録
setopt hist_ignore_dups   # 連続する重複コマンドを履歴に残さない
setopt hist_ignore_all_dups # 同じコマンドが既にあれば古い方を削除
setopt hist_ignore_space  # スペース始まりのコマンドを履歴に残さない（機密コマンドの除外に便利）
setopt hist_reduce_blanks # 余分な空白を除去して履歴保存
setopt share_history      # セッション間で履歴をリアルタイム共有
setopt prompt_subst       # プロンプト内で変数展開/コマンド置換を有効化
setopt cdable_vars        # 変数名を cd のターゲットとして使用可能

# ============================================================
# History
# ============================================================

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=1000000   # メモリ上の履歴件数
SAVEHIST=1000000   # ファイルに保存する履歴件数（HISTSIZE と揃えておく）

# ============================================================
# Completion
# ============================================================

# -U: autoload 時に alias の展開を抑制（補完関数内の alias 誤爆を防ぐ）
# -z: zsh スタイルで autoload（ksh 互換モードを無効化）
autoload -Uz compinit
compinit

# 補完時に大文字小文字を無視（小文字入力で大文字にもマッチ）
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 補完候補が複数あるときカーソルキーで選択できるようにする
zstyle ':completion:*' menu select=1

# ${(s.:.)LS_COLORS}: LS_COLORS を ":" で分割して配列に展開する zsh 固有の記法
# 補完候補の色を ls と統一する
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# alias に対しても補完を効かせる
setopt complete_aliases

# ============================================================
# Key Bindings
# ============================================================

# Emacs 風キーバインド（^A: 行頭, ^E: 行末, ^K: 行末まで削除 など）
bindkey -e

bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char

# $terminfo を参照することでターミナル依存のエスケープシーケンスを吸収
[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]}  ]] && bindkey "${terminfo[kend]}"  end-of-line

# history-search-end: ^P/^N で「入力済み文字列をプレフィックスに」履歴検索する関数
# 例: "git" と打ってから ^P → git から始まる直近の履歴を遡る
autoload -Uz history-search-end
# zle -N: ユーザー定義のウィジェットを ZLE（zsh の行編集エンジン）に登録
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# ============================================================
# Environment
# ============================================================

export LANG=ja_JP.UTF-8
export EDITOR=vim

# WORDCHARS から "/" を除去 → "/" を単語区切りとみなす
# 例: ^W で "/usr/local/bin" を一気に消さず "/bin" だけ消せる
WORDCHARS="${WORDCHARS:s,/,,}"

# ============================================================
# Colors (ls / completion)
# ============================================================

case "${OSTYPE}" in
  darwin*)
    export CLICOLOR=1
    export LSCOLORS=exfxcxdxbxegedabagacad
    alias ls='ls -G'
    ;;
  linux*)
    export LS_COLORS='di=32:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    alias ls='ls --color=auto'
    ;;
esac

# ============================================================
# Aliases
# ============================================================

alias where='command -v'
alias j='jobs -l'

alias la='ls -a'
alias ll='ls -ltrAF'
alias l='ls -lh'

alias du='du -h'
alias df='df -h'

# ============================================================
# Local overrides
# ============================================================

# マシン固有の設定（PATH, 認証情報など）は ~/.zshrc.local に書く
# このファイルは Git 管理しないことを推奨
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================
# fzf (^R: 履歴検索 / ^T: ファイル検索 / **: 補完)
# fzf 0.48+ 必須: https://github.com/junegunn/fzf
# ============================================================

# (( $+commands[cmd] )): $commands は compinit が構築する PATH 上のコマンドハッシュ
# command -v より高速（外部プロセスを起動しない）
if (( $+commands[fzf] )); then
  # source <(...): プロセス置換。fzf --zsh が出力するシェルスクリプトをその場で source する
  source <(fzf --zsh)
else
  # fzf がない場合は組み込みのインクリメンタル検索を ^R/^S に割り当て
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^S' history-incremental-pattern-search-forward
fi

# ============================================================
# Prompt (starship)
# ============================================================

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  # fallback: starship がない環境向けの最小プロンプト
  # %n: ユーザー名, %m: ホスト名, %#: 一般ユーザーは % root は #
  PROMPT="%n@%m %# "
fi
