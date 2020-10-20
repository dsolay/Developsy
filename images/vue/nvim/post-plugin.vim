"
" ~~ Emmet ~~
"

"Redefine trigger key
let g:user_emmet_leader_key='<C-z>'

" Enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
