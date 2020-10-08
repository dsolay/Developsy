
" Buffer delete all others (delete all except current one)
command Bdo BufOnly
cabbrev bdo BufOnly

" Visual diff command.
command Ldiffthis Linediff
cabbrev ldiffthis Linediff

command Ldiffoff Linediffreset
cabbrev ldiffoff LinediffReset

" Load colors! On the initial install this will error out, so make it silent
" so it installs without issues.
silent! colorscheme gruvbox
set background=dark

" Enable the powerline fonts.
let g:airline_powerline_fonts = 1

" Show the buffers at the top
let g:airline#extensions#tabline#enabled = 1

" Show the buffer numbers so I can `:b 1`, etc
let g:airline#extensions#tabline#buffer_nr_show = 1

" Aside from the buffer number, I literally just need the file name, so
" strip out extraneous info.
let g:airline#extensions#tabline#fnamemod = ':t'

" disables the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#show_splits = 0

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme gruvbox

"
" ~~ NERDTree config ~~
"
let g:NERDTreeMouseMode = 3
let g:NERDTreeGitStatusShowIgnored = 1

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" abbreviate T to t
cabbrev t T

" Use spaces instead just for yaml
autocmd Filetype yaml setl expandtab

"
" ~~ ALE config ~~
"

" Highlighting on top of the error gutter is a bit overkill...
let g:ale_set_highlights = 0

let g:ale_sign_error = '✘'
highlight ALEErrorSign ctermfg=DarkRed ctermbg=NONE

let g:ale_sign_warning = '◉'
highlight ALEWarningSign ctermfg=Yellow ctermbg=NONE

" disable linting while typing
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 1
let g:ale_keep_list_window_open=0
let g:ale_set_quickfix=0
let g:ale_list_window_size = 5
let g:ale_fix_on_save = 1
let g:ale_disable_lsp = 1

"
" ~~ Vim doge ~~
"
noremap <Leader>dg :DogeGenerate
noremap <Leader>qdg :DogeGenerate<CR>

"
" ~~ Vim comflicted ~~
"
set stl+=%{ConflictedVersion()}
nnoremap ]m :GitNextConflict<cr>
