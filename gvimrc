if has('gui_running')
  set nu
  set columns=88
  set lines=40
  set showtabline=2
  set imdisable
  set incsearch
  set transparency=5
  set guioptions-=T
  set migemo
  map <silent> gw :macaction selectNextWindow:
  map <silent> gW :macaction selectPreviousWindow:
  let Tlist_Ctags_Cmd = "/opt/local/bin/jexctags"
  colorscheme wombat
  set iminsert=0 imsearch=0
  set antialias
  hi IMLine guibg=DarkGreen guifg=Black
  noremap ¥ \ " (円マークでバックスラッシュ入力)
  noremap <C-]> <Esc> " (CTRL-[でESC入力)
  set linespace=1
  set guifontwide=セプテンバー:h16
  set guifont=Inconsolata:h16
endif
