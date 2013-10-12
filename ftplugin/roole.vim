" Language:    Roole
" Maintainer:  "UnCO" Lin
" URL:         http://github.com/unc0/vim-roole
" License:     WTFPL

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl isi< isk< cms< inc< ofu< sua<"

setlocal isident+=$
setlocal iskeyword+=-
setlocal commentstring=//\ %s
setlocal omnifunc=csscomplete#CompleteCSS
setlocal suffixesadd=.roo,.css
setlocal comments=s1:/*,mb:*,ex:*/

let &l:include = '^\s*@import\s\+\%(url(\)\=["'']\='

" vim:set sw=2:
