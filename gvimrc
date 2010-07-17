if has('gui_macvim')
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
  set macatsui
  set guifont=Osaka-Mono:h14
  set transparency=240
  hi IMLine guibg=DarkGreen guifg=Black
  noremap \ \ " (円マークでバックスラッシュ入力)
  noremap <C-]> <Esc> " (CTRL-[でESC入力)
endif
