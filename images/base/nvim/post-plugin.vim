
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
function! s:setupConflicted()
  set stl+=%{ConflictedVersion()}
  " Resolve and move to next conflicted file.
  nnoremap ]m :GitNextConflict<cr>
endfunction
autocmd User VimConflicted call s:setupConflicted()

"
" ~~ FZF ~~
"
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
nnoremap <silent> <Leader>t :BTags<CR>
nnoremap <silent> <Leader>T :Tags<CR>

" floating fzf window with borders
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

function! FZFWithDevIcons()
  let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "bat --color always --style numbers {2..}"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND.'| devicon-lookup'), '\n')
    return l:files
  endfunction

  function! s:edit_file(items)
    let items = a:items
    let i = 1
    let ln = len(items)
    while i < ln
      let item = items[i]
      let parts = split(item, ' ')
      let file_path = get(parts, 1, '')
      let items[i] = file_path
      let i += 1
    endwhile
    call s:Sink(items)
  endfunction

  let opts = fzf#wrap({})
  let opts.source = <sid>files()
  let s:Sink = opts['sink*']
  let opts['sink*'] = function('s:edit_file')
  let opts.options .= l:fzf_files_options
  call fzf#run(opts)
endfunction

" Open fzf Files
nnoremap <silent> <C-p> :call FZFWithDevIcons()<CR>

function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
