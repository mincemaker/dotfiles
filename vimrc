" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
call dein#begin(s:dein_dir)

" ------------------------------------------------------------------------------
" plugins
" ------------------------------------------------------------------------------
"coffee
call dein#add('kchmck/vim-coffee-script')
call dein#add('nathanaelkane/vim-indent-guides')
  nnoremap <silent> <C-C> :CoffeeCompile vert <CR><C-w>h
  setlocal splitright

" load the code2html plugin:
call dein#add('code2html')
  let html_use_css = 1

" load the SeeTab plugin:
call dein#add('SeeTab')
  let g:SeeTabCtermFG="yellow"
  let g:SeeTabCtermBG="red"

" YankRing.vim
call dein#add('vim-scripts/YankRing.vim')
nmap ,y :YRShow<CR>

" neocomplete
call dein#add('Shougo/neocomplete')
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)
call dein#add('ujihisa/neco-look')
call dein#add('ujihisa/neco-ruby')

  "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
          \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()
  inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  "--

" for ruby
call dein#add('matchit.zip')
call dein#add('vim-ruby/vim-ruby')
call dein#add('ruby-matchit')
call dein#add('ecomba/vim-ruby-refactoring')
call dein#add('tpope/vim-cucumber')
call dein#add('tpope/vim-endwise')
call dein#add('rhysd/unite-ruby-require.vim')

" load the rails plugin:
call dein#add('tpope/vim-rails')
  au BufNewFile,BufRead app/**/*.rhtml set fenc=utf-8
  au BufNewFile,BufRead app/**/*.rb set fenc=utf-8

" for python
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('davidhalter/jedi')

call dein#add('scrooloose/nerdcommenter')
" add a space between the comment delimiter and text
  let NERDSpaceDelims=1

call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-repeat')
" tell surround not to break the visual s keystroke (:help vs)
  xmap S <Plug>Vsurround

call dein#add('majutsushi/tagbar')
  nmap <leader>l :TagbarToggle<CR>

" unite.vim
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/unite-outline')
call dein#add('Shougo/neomru.vim')
call dein#add('thinca/vim-unite-history')
call dein#add('kmnk/vim-unite-giti')
call dein#add('tsukkee/unite-tag')
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

call dein#add('Shougo/vimshell')
call dein#add('Shougo/vimproc.vim', {
    \ 'build': {
    \     'windows': 'tools\\update-dll-mingw',
    \     'cygwin': 'make -f make_cygwin.mak',
    \     'mac': 'make -f make_mac.mak',
    \     'linux': 'make',
    \     'unix': 'gmake',
    \    },
    \ })
call dein#add('tyru/operator-camelize.vim')
call dein#add('kana/vim-operator-user')
  map <Leader>c <Plug>(operator-camelize)
  map <Leader>C <Plug>(operator-decamelize)

call dein#add('sjl/gundo.vim')
  nmap U :<C-u>GundoToggle<CR>

call dein#add('h1mesuke/vim-alignta')
  nnoremap [unite] <Nop>
  xnoremap [unite] <Nop>
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

call dein#add('thinca/vim-quickrun')
  let g:quickrun_config = {}
  let g:quickrun_config._ = {'runner' : 'vimproc'}
  let g:quickrun_config['rspec/bundle'] = {
    \ 'type': 'rspec/bundle',
    \ 'command': 'rspec',
    \ 'exec': 'bundle exec %c %s'
    \}
  let g:quickrun_config['rspec/normal'] = {
    \ 'type': 'rspec/normal',
    \ 'command': 'spec',
    \ 'exec': '%c %s'
    \}
  function! RSpecQuickrun()
    let b:quickrun_config = {'type' : 'rspec/normal'}
  endfunction
  autocmd BufReadPost *_spec.rb call RSpecQuickrun()

"call dein#add('mileszs/ack.vim')
"let g:ackprg="ack-grep -H --nocolor --nogroup --column"
call dein#add('ag.vim')

call dein#add('hallettj/jslint.vim')
  let $JS_CMD='node'

call dein#add('Shougo/vimfiler')
  nnoremap <F2> :VimFilerCurrentDir -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<Cr>
  nnoremap <leader>d :VimFilerBufferDir -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<CR>
"  autocmd! FileType vimfiler call g:my_vimfiler_settings()
"  function! g:my_vimfiler_settings()
"    nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
"    nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
"    nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
"  endfunction

  let my_action = { 'is_selectable' : 1 }
  function! my_action.func(candidates)
    wincmd p
    exec 'split '. a:candidates[0].action__path
  endfunction
  call unite#custom_action('file', 'my_split', my_action)

  let my_action = { 'is_selectable' : 1 }
  function! my_action.func(candidates)
    wincmd p
    exec 'vsplit '. a:candidates[0].action__path
  endfunction
  call unite#custom_action('file', 'my_vsplit', my_action)

call dein#add('kien/ctrlp.vim')
  let g:ctrlp_map = '<c-o>'

call dein#add('scrooloose/syntastic')
  let g:syntastic_enable_signs=1
  let g:syntastic_auto_loc_list=1

call dein#add('basyura/bitly.vim.git')
call dein#add('basyura/TweetVim.git')
call dein#add('basyura/twibill.vim.git')
call dein#add('mattn/webapi-vim.git')
call dein#add('tyru/open-browser.vim.git')
call dein#add('yomi322/neco-tweetvim.git')
call dein#add('yomi322/unite-tweetvim.git')
  let g:tweetvim_display_source = 1
  let g:tweetvim_tweet_per_page = 50

  nnoremap bw :<C-u>Unite tweetvim<CR>
  nnoremap ,th :<C-u>TweetVimHomeTimeline<CR>
  nnoremap ,tm :<C-u>TweetVimMentions<CR>
  nnoremap ,ts :<C-u>TweetVimSay<CR>
  nnoremap ,tc :<C-u>TweetVimCommandSay

call dein#add('haya14busa/vim-easymotion')
  hi link EasyMotionTarget ErrorMsg
  hi link EasyMotionShade  Comment
  nmap s <Plug>(easymotion-s)
  vmap s <Plug>(easymotion-s)
  omap z <Plug>(easymotion-s)

call dein#add('bronson/vim-closebuffer')
call dein#add('kana/vim-smartword')
call dein#add('mattn/googletranslate-vim')
call dein#add('mattn/vdbi-vim')
call dein#add('mattn/emmet-vim')
call dein#add('sudo.vim')
call dein#add('thinca/vim-qfreplace')

" gitv
call dein#add('gregsexton/gitv')
call dein#add('tpope/vim-fugitive')
  autocmd FileType git :setlocal foldlevel=99
  autocmd FileType gitv call s:my_gitv_settings()
  function! s:my_gitv_settings()
    setlocal iskeyword+=/,-,.
    nnoremap <silent><buffer> C :<C-u>Git checkout <C-r><C-w><CR>
    nnoremap <buffer> <Space>rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
    nnoremap <buffer> <Space>R :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
    nnoremap <buffer> <Space>h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
    nnoremap <buffer> <Space>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
  endfunction
  function! s:gitv_get_current_hash()
    return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
  endfunction

if !has('gui_running')
  set t_Co=256
endif
call dein#add('itchyny/lightline.vim')

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

" colorscheme
call dein#add('Railscasts-Theme-GUIand256color')
call dein#add('Solarized')
call dein#add('molokai')
call dein#add('vim-scripts/Lucius')
  syntax enable
"  set background=dark
"  let g:solarized_termcolors=256
"  colorscheme solarized
  colorscheme solarized

" 設定終了
call dein#end()

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" ------------------------------------------------------------------------------
"  settings
" ------------------------------------------------------------------------------
set incsearch " find the next match as we type the search
set hlsearch " hilight searches by default
set number
set visualbell t_vb=
set nocompatible  " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set cmdheight=1
set noundofile

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

"autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
" set helpfile=$VIMRUNTIME/doc/help.txt.gz
set helpfile=$VIMRUNTIME/doc/help.txt

let mapleader = '\'

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

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=8
hi PmenuSel ctermbg=12
hi PmenuSbar ctermbg=0


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


"" 後から入れないと困る設定
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

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

"Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" Ctrl-iでヘルプ
nnoremap <C-i>  :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

