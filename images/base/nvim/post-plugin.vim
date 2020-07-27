
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

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" abbreviate T to t
cabbrev t T

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

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme gruvbox

let g:NERDTreeMouseMode = 3

let g:NERDTreeGitStatusShowIgnored = 1

" Use spaces instead just for yaml
autocmd Filetype yaml setl expandtab

" Highlighting on top of the error gutter is a bit overkill...
let g:ale_set_highlights = 0

" I want errors to be styled a bit more like neomake
let g:ale_sign_error = '✘'
highlight ALEErrorSign ctermfg=DarkRed ctermbg=NONE

" Same with warnings
let g:ale_sign_warning = '◉'
highlight ALEWarningSign ctermfg=Yellow ctermbg=NONE

" disable linting while typing
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 1
let g:ale_keep_list_window_open=0
let g:ale_set_quickfix=0
let g:ale_list_window_size = 5
let g:ale_fix_on_save = 1

" Rely on tmux for the repl integration to work
let g:slime_target = 'tmux'

" This will ensure that the second panel in the current
" window is used when I tell slime to send code to the
" repl.
if exists("$TMUX")
	let s:socket_name = split($TMUX, ',')[0]

	let g:slime_default_config = {
					\ 'socket_name': s:socket_name,
					\ 'target_pane': ':.1'
					\ }
endif

" I dont like the default mappings of this plugin...
" let g:slime_no_mappings = 1

" Ctrl+s will send the paragraph over to the repl.
" nmap <c-s> <Plug>SlimeLineSend

" Ctrl+x will send the highlighted section over to the repl.
" xmap <c-s> <Plug>SlimeRegionSend

" Make it so that ctrlp ignores files in .gitignore
let g:ctrlp_user_command = '(git status --short | awk "{ print \$2 }"; git ls-files -- %s) | sort -u'

" No mostrar en ciertos tipos de buffers y archivos
let g:indentLine_fileTypeExclude = ['text', 'sh', 'help', 'terminal']
let g:indentLine_bufNameExclude = ['NERD_tree.*', 'term:.*']
