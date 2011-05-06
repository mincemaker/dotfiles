if has('gui_running')
  set nu
  set cmdheight=1
  set columns=100
  set lines=50
  set showtabline=2
  set imdisable
  set incsearch
  set transparency=5
  set guioptions-=T
  set guicursor=a:blinkon0
  set migemo
  map <silent> gw :macaction selectNextWindow:
  map <silent> gW :macaction selectPreviousWindow:
  let Tlist_Ctags_Cmd = "/opt/local/bin/jexctags"
  set iminsert=0 imsearch=0
  set antialias
  hi IMLine guibg=DarkGreen guifg=Black
  noremap ¥ \ " (円マークでバックスラッシュ入力)
  noremap <C-]> <Esc> " (CTRL-[でESC入力)
  set linespace=1
  set guifontwide=Ricty:h16
  set guifont=Ricty:h16

  set background=dark
  let g:solarized_termcolors=256
  colorscheme solarized
endif
