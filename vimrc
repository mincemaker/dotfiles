" Let Pathogen bring in all the plugins
" http://github.com/paulnicholson/vim-pathogen.git
filetype off
call pathogen#runtime_append_all_bundles()
filetype indent plugin on
" ------------------------------------------------------------------------------
syntax on

set nocompatible " tends to make things work better
set incsearch " find the next match as we type the search
set hlsearch " hilight searches by default
set number
set visualbell t_vb=
set nocompatible  " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing

" Now we set some defaults for the editor
set textwidth=0   " Don't wrap words by default
set nobackup    " Don't keep a backup file
set viminfo='50,<1000,s100,\"50 " read/write a .viminfo file, don't store more than
"set viminfo='50,<1000,s100,:0,n~/.vim/viminfo
set history=100   " keep 50 lines of command line history
set ruler   " show the cursor position all the time

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

set t_Co=256

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
" set helpfile=$VIMRUNTIME/doc/help.txt.gz
set helpfile=$VIMRUNTIME/doc/help.txt

let mapleader = '\'

if has("autocmd")
  " Enabled file type detection
  " Use the default filetype settings. If you also want to load indent files
  " to automatically do language-dependent indenting add 'indent' as well.
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  " autocmd FileType php :set indentexpr=
  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=
endif

" Some Debian-specific things
augroup filetype
  au BufRead reportbug.*    set ft=mail
  au BufRead reportbug-*    set ft=mail
augroup END

" タブ幅の設定
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set modelines=0

"インデントはスマートインデント
set smartindent
"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時に最後まで行ったら最初に戻る
set wrapscan
"検索文字列入力時に順次対象文字列にヒットさせない
"set noincsearch
"タブの左側にカーソル表示
"set listchars=tab:\\
set nolist
"入力中のコマンドをステータスに表示する
set showcmd
"括弧入力時の対応する括弧を表示
set showmatch
"検索結果文字列のハイライトを有効にしない
set nohlsearch
"ステータスラインを常に表示
set laststatus=2

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"ステータスラインに文字コードと改行文字を表示する
"if winwidth(0) >= 120
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
"else
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
"endif
set statusline=[%n]%t\ %=%1*%m%*%r%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}[%<%{fnamemodify(getcwd(),':~')}]\ %-6(%l,%c%V%)\ %4P

" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
" set wildmenu
" コマンドライン補間をシェルっぽく
set wildmode=list:longest
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 外部のエディタで編集中のファイルが変更されたら自動で読み直す
set autoread

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#cb691f26
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" cvs,svnの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
autocmd FileType svn :set fileencoding=utf-8

" set tags
if has("autochdir")
  set autochdir
  set tags=tags;
else
  set tags+=tags
endif

" tags key map (C-z を C-tに,C-tはGNU/screenとかぶる)
map <C-z> <C-t>

" 辞書ファイルからの単語補間
:set complete+=k

" C-]でtjと同等の効果
nmap <C-]> g<C-]>

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye :let @"=expand("<cword>")<CR>


"表示行単位で行移動する
nmap j gj
nmap k gk
vmap j gj
vmap k gk

"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

",e でそのコマンドを実行
nmap ,e :execute '!' &ft ' %'<CR>

" netrw-ftp
let g:netrw_ftp_cmd="netkit-ftp"

" netrw-http
let g:netrw_http_cmd="wget -q -O"

" html escape function
:function HtmlEscape()
silent s/&/\&amp;/eg
silent s/</\&lt;/eg
silent s/>/\&gt;/eg
:endfunction

:function HtmlUnEscape()
silent s/&lt;/</eg
silent s/&gt;/>/eg
silent s/&amp;/\&/eg
:endfunction

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=8
hi PmenuSel ctermbg=12
hi PmenuSbar ctermbg=0

" ハイライト設定
function! WhitespaceHilight()
    syntax match Whitespace "\s\+$" display containedin=ALL
    highlight Whitespace ctermbg=red guibg=red
endf
"全角スペースをハイライトさせる。
function! JISX0208SpaceHilight()
    syntax match JISX0208Space "　" display containedin=ALL
    highlight JISX0208Space term=underline ctermbg=LightCyan
endf
"syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
if has("syntax")
    syntax on
        augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call WhitespaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

" changelog mode
if has("autocmd")
    autocmd FileType changelog map ,d ggi<CR><CR><ESC>kki<C-R>=strftime("%Y-%m-%d")<CR> gorou <hotchpotch@gmail.com><ESC>o<CR><TAB>* | map ,n ggo<CR><TAB>*
endif

if has("autocmd")
    autocmd FileType changelog map ,n :call InsertChangeLogEntry("gorou", "hotchpotch@gmail.com")<CR>a
endif

function! InsertChangeLogEntry(name, mail)
    if strpart(getline(1), 0, 10) == strftime("%Y-%m-%d")
        execute "normal ggo\<CR>\<TAB>*"
    else
        let s:header = strftime("%Y-%m-%d") . " " . a:name . " <" . a:mail . ">"
        execute "normal ggi\<CR>\<CR>\<ESC>kki" . s:header . "\<CR>\<CR>\<TAB>*"
    endif
endfunction

" encoding
nmap ,U :set encoding=utf-8<CR>
nmap ,E :set encoding=euc-jp<CR>
nmap ,S :set encoding=cp932<CR>

" バッファ関連のショートカット色々
nmap <Space> :bn<CR>
nnoremap ,c       :new<CR>
nnoremap ,<C-c>   :new<CR>
nnoremap ,k       :bd<CR>
nnoremap ,<C-k>   :bd<CR>
nnoremap ,<Tab>   :wincmd w<CR>
nnoremap ,Q       :only<CR>
nnoremap ,w       :ls<CR>
nnoremap ,<C-w>   :ls<CR>
nnoremap ,a       :e #<CR>
nnoremap ,<C-a>   :e #<CR>

" ------------------------------------------------------------------------------
" plugins
" ------------------------------------------------------------------------------

" load the code2html plugin:
" --- BUNDLE: git://github.com/vim-scripts/code2html.git
let html_use_css = 1

" load the SeeTab plugin:
" --- BUNDLE: git://github.com/vim-scripts/SeeTab.git
let g:SeeTabCtermFG="black"
let g:SeeTabCtermBG="red"


" YankRing.vim
" --- BUNDLE: git://github.com/chrismetcalf/vim-yankring.git
nmap ,y :YRShow<CR>

" fuzzyfinder
" --- BUNDLE: git://github.com/vim-bundles/fuzzyfinder.git
map ,fmf  :FuzzyFinderMruFile<CR>
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_file_exclude = '\v\~$|\.(o|exe|bak|swp|gif|jpg|png)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
let g:fuf_mrufile_exclude = '\v\~$|\.bak$|\.swp|\.howm$|\.(gif|jpg|png)$'
let g:fuf_mrufile_maxItem = 10000
let g:fuf_enumeratingLimit = 20
let g:fuf_keyPreview = '<C-]>'
let g:fuf_previewHeight = 0

nmap bg :FufBuffer<CR>
nmap bG :FufFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
nmap gb :FufFile **/<CR>
nmap br :FufMruFile<CR>
nmap bq :FufQuickfix<CR>
nmap bl :FufLine<CR>
nnoremap <silent> <C-]> :FufTag! <C-r>=expand('<cword>')<CR><CR>

" qbuf
" --- BUNDLE: git://github.com/vim-scripts/QuickBuf.git
let g:qb_hotkey = ";;"

" neocomplcache
" --- BUNDLE: git://github.com/Shougo/neocomplcache.git
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" eskk
" --- BUNDLE: git://github.com/tyru/eskk.vim.git
" eskk settings via. http://d.hatena.ne.jp/hamaco/20100708/1278598112
if has('vim_starting')
	let g:eskk_dictionary = '~/.skk-jisyo'

	if has('mac')
		let g:eskk_large_dictionary = "~/Library/Application\ Support/AquaSKK/SKK-JISYO.L"
	elseif has('win32') || has('win64')
		let g:eskk_large_dictionary = "~/SKK_JISYO.L"
	else
	endif
endif
let g:eskk_debug = 0
let g:eskk_egg_like_newline = 1
let g:eskk_revert_henkan_style = "okuri"
let g:eskk_enable_completion = 0

" load the rails plugin:
" --- BUNDLE: git://github.com/tpope/vim-rails.git
au BufNewFile,BufRead app/**/*.rhtml set fenc=utf-8
au BufNewFile,BufRead app/**/*.rb set fenc=utf-8

" load the nerdtree plugin:
" --- BUNDLE: git://github.com/scrooloose/nerdtree.git
" and configure it to open using \d and \D
nmap <leader>d :NERDTreeToggle<cr>
nmap <leader>D :NERDTreeFind<cr>

" --- BUNDLE: git://github.com/scrooloose/nerdcommenter.git
" add a space between the comment delimiter and text
let NERDSpaceDelims=1

" --- BUNDLE: git://github.com/tpope/vim-surround.git
" tell surround not to break the visual s keystroke (:help vs)
xmap S <Plug>Vsurround

" --- BUNDLE: git://github.com/bronson/vim-taglist.git
nmap <leader>l :TlistToggle<cr>

" --- BUNDLE: git://git.wincent.com/command-t.git
" --- BUNDLE: git://github.com/bronson/vim-closebuffer.git
" --- BUNDLE: git://github.com/vim-ruby/vim-ruby.git
" --- BUNDLE: git://github.com/mattn/zencoding-vim.git

