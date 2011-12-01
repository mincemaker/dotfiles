if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim
  filetype off
  call neobundle#rc(expand('~/.vim/bundle'))
  filetype plugin on
  filetype indent on
endif
" ------------------------------------------------------------------------------
syntax on

set nocompatible " tends to make things work better
set incsearch " find the next match as we type the search
set hlsearch " hilight searches by default
set number
set visualbell t_vb=
set nocompatible  " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set cmdheight=1

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
"autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

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

" http://vim.1045645.n5.nabble.com/Recommend-simple-mappings-td1223622.html
nmap <silent> ;: :call NumberToggle()<CR>

function! NumberToggle()
    if exists("&rnu")
        if &number
            setlocal relativenumber
        else
            if &relativenumber
                setlocal norelativenumber
            else
                setlocal number
            endif
        endif
    else
        if &number
            setlocal nonumber
        else
            setlocal number
        endif
    endif
endfunction

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
set ambiwidth=double

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
":function HtmlEscape()
"silent s/&/\&amp;/eg
"silent s/</\&lt;/eg
"silent s/>/\&gt;/eg
":endfunction
"
":function HtmlUnEscape()
"silent s/&lt;/</eg
"silent s/&gt;/>/eg
"silent s/&amp;/\&/eg
":endfunction

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
hi StatusLine term=NONE cterm=NONE ctermfg=black ctermbg=gray

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
NeoBundle 'mattn/zencoding-vim'

" load the code2html plugin:
NeoBundle 'code2html'
let html_use_css = 1

" load the SeeTab plugin:
NeoBundle 'SeeTab'
let g:SeeTabCtermFG="yellow"
let g:SeeTabCtermBG="red"

" YankRing.vim
NeoBundle 'chrismetcalf/vim-yankring'
nmap ,y :YRShow<CR>

" neocomplcache
NeoBundle 'Shougo/neocomplcache'
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

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" eskk
NeoBundle 'tyru/eskk.vim'
NeoBundle 'tyru/cul.vim'
NeoBundle 'tyru/savemap.vim'
NeoBundle 'tyru/vice.vim'
" eskk settings via. http://d.hatena.ne.jp/hamaco/20100708/1278598112
if has('vim_starting')
	let g:eskk_dictionary = '~/.skk-jisyo'

	if has('mac')
		let g:eskk_large_dictionary = "~/Library/Application\ Support/AquaSKK/SKK-JISYO.L"
	elseif has('win32') || has('win64')
		let g:eskk_large_dictionary = "~/dic/SKK_JISYO.L"
	else
		let g:eskk_large_dictionary = "~/dic/SKK-JISYO.L"
	endif
endif
let g:eskk_debug = 0
let g:eskk_egg_like_newline = 1
let g:eskk_revert_henkan_style = "okuri"
let g:eskk_enable_completion = 0

" load the rails plugin:
NeoBundle 'tpope/vim-rails'
au BufNewFile,BufRead app/**/*.rhtml set fenc=utf-8
au BufNewFile,BufRead app/**/*.rb set fenc=utf-8

" load the nerdtree plugin:
NeoBundle 'scrooloose/nerdtree'
" and configure it to open using \d and \D
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>D :NERDTreeFind<CR>

NeoBundle 'scrooloose/nerdcommenter'
" add a space between the comment delimiter and text
let NERDSpaceDelims=1

NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
" tell surround not to break the visual s keystroke (:help vs)
xmap S <Plug>Vsurround

NeoBundle 'chrismetcalf/vim-taglist'
nmap <leader>l :TlistToggle<CR>

" unite.vim
NeoBundle 'Shougo/unite.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'thinca/vim-unite-history'
nmap br :Unite file_mru<CR>
nmap bR :UniteWithCurrentDir file_mru<CR>
nmap bg :Unite file_rec -buffer-name=files<CR>
nmap bG :UniteWithBufferDir file -buffer-name=files<CR>
nmap ;; :Unite buffer<CR>
nmap bo :Unite outline<CR>
nmap bh :Unite history/command<CR>
nnoremap bf :UniteWithInput file_rec<CR>
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <C-o> <Plug>(unite_insert_leave):<C-u>call unite#mappings#do_action('above')<CR>
endfunction
let g:unite_source_file_mru_limit = 200

highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4

NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimproc'
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'

NeoBundle 'tyru/operator-camelize.vim'
NeoBundle 'kana/vim-operator-user'
map <Leader>c <Plug>(operator-camelize)
map <Leader>C <Plug>(operator-decamelize)

NeoBundle 'sjl/gundo.vim'
nmap U :<C-u>GundoToggle<CR>

NeoBundle 'h1mesuke/vim-alignta'
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap f [unite]
xmap f [unite]

let g:unite_source_alignta_preset_arguments = [
      \ ["Align at '='", '=>\='],  
      \ ["Align at ':'", '01 :'],
      \ ["Align at '|'", '|'   ],
      \ ["Align at ')'", '0 )' ],
      \ ["Align at ']'", '0 ]' ],
      \ ["Align at '}'", '}'   ],
      \]

let s:comment_leadings = '^\s*\("\|#\|/\*\|//\|<!--\)'
let g:unite_source_alignta_preset_options = [
      \ ["Justify Left",      '<<' ],
      \ ["Justify Center",    '||' ],
      \ ["Justify Right",     '>>' ],
      \ ["Justify None",      '==' ],
      \ ["Shift Left",        '<-' ],
      \ ["Shift Right",       '->' ],
      \ ["Shift Left  [Tab]", '<--'],
      \ ["Shift Right [Tab]", '-->'],
      \ ["Margin 0:0",        '0'  ],
      \ ["Margin 0:1",        '01' ],
      \ ["Margin 1:0",        '10' ],
      \ ["Margin 1:1",        '1'  ],
      \
      \ 'v/' . s:comment_leadings,
      \ 'g/' . s:comment_leadings,
      \]
unlet s:comment_leadings

nnoremap <silent> [unite]a :<C-u>Unite alignta:options<CR>
xnoremap <silent> [unite]a :<C-u>Unite alignta:arguments<CR>

NeoBundle 'thinca/vim-quickrun'
augroup RSpec
autocmd!
autocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
augroup END
let g:quickrun_config = {}
let g:quickrun_config['ruby.rspec'] = {'command': "spec", 'cmdopt': "-l {line('.')}"}

NeoBundle 'mileszs/ack.vim'
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

NeoBundle 'thinca/vim-ambicmd'
cnoremap <expr> <Space> ambicmd#expand("\<Space>")
cnoremap <expr> <CR>    ambicmd#expand("\<CR>")

NeoBundle 'Shougo/vimfiler'
NeoBundle 'bronson/vim-closebuffer'
NeoBundle 'kana/vim-smartword'
NeoBundle 'mattn/googletranslate-vim'
NeoBundle 'motemen/git-vim'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'vim-ruby/vim-ruby'

" colorscheme
NeoBundle 'Railscasts-Theme-GUIand256color'
NeoBundle 'Solarized'
NeoBundle 'molokai'
NeoBundle 'vim-scripts/Lucius'
syntax enable
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

filetype plugin indent on

