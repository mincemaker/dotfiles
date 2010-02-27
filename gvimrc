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
endif
