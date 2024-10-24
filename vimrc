"avoiding annoying csapprox warning message
let g:csapprox_verbose_level = 0

"necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype off

"load pathogen managed plugins
execute pathogen#infect()

"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"Show matching brackets.
set showmatch

"Case insensitive matching
set ignorecase

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

""store lots of :cmdline history
if !has('nvim')
  set history=10000
endif

if has('nvim')
  let s:editor_root=expand('~/.config/nvim')
else
  let s:editor_root=expand('~/.vim')
endif

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom
set shortmess+=A "A don't give the 'ATTENTION' message when an existing swap file is found.

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

"add line numbers
set number
set showbreak=...
set wrap linebreak nolist

"mapping for command key to map navigation thru display lines instead
"of just numbered lines
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

"add some line space for easy reading
set linespace=4

"disable visual bell
set visualbell t_vb=

"safe write
set backupcopy=yes

"try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk
set fo=l

"statusline setup
set statusline=%f       "tail of the filename

"Git
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}

"RVM
set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T
"turn off the scroll bar
set guioptions-=L
set guioptions-=r

set directory=.,$TMPDIR

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"indent settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

"set 120 column border - coding style
set cc=120

"display tabs and trailing spaces
"set list
"set listchars=tab:\ \ ,extends:>,precedes:<
" disabling list because it interferes with soft wrap

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a

"hide buffers when not displayed
set hidden

"Activate smartcase
set ic
set smartcase

"Copy selection
set clipboard=unnamed

if has("gui_running")
    "tell the term has 256 colors
    set guitablabel=%M%t
    set lines=42
    set columns=213
    colorscheme jellybeans

    if has("gui_gnome")
        set term=gnome-256color
        colorscheme railscasts
        set guifont=Monospace\ Bold\ 12
    endif

    if has("gui_mac") || has("gui_macvim")
        set guifont=Menlo:h15
        set transparency=2
    endif

    if has("gui_win32") || has("gui_win32s")
        set guifont=Consolas:h12
        set enc=utf-8
    endif
else
    "dont load csapprox if there is no gui support - silences an annoying warning
    let g:CSApprox_loaded = 1
    let g:CSApprox_verbose_level = 0
    set t_Co=256

    "set railscasts colorscheme when running vim in gnome terminal
    if $COLORTERM == 'gnome-terminal'
        colorscheme molokai
    else
        if $TERM == 'xterm-color' || $TERM == 'xterm'
            colorscheme railscasts
        else
            colorscheme default
        endif
    endif
endif

" PeepOpen uses <Leader>p as well so you will need to redefine it so something
" else in your ~/.vimrc file, such as:
" nmap <silent> <Leader>q <Plug>PeepOpen

silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map to bufexplorer
nnoremap <leader>b :BufExplorer<cr>
"map to bufergator
let g:buffergator_suppress_keymaps = 1
nnoremap <leader>bg :BuffergatorToggle<cr>

"disable resizing when calling buffergator
let g:buffergator_autoexpand_on_split = 0

"map to CommandT TextMate style finder
nnoremap <leader>t :CommandT<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"bindings for ragtag
inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>
let g:ragtag_global_maps = 1

"ale syntax/lint options
let g:ale_set_highlights = 0
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

"jsx ale fix
let g:ale_linters = {'jsx': ['stylelint', 'eslint']}
let g:ale_linter_aliases = {'jsx': 'css'}

"airline theme
let g:airline_theme='molokai'

" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard+=unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

"key mapping for vimgrep result navigation
map <A-o> :copen<CR>
map <A-q> :cclose<CR>
map <A-j> :cnext<CR>
map <A-k> :cprevious<CR>

"key mapping for Gundo
nnoremap <F4> :GundoToggle<CR>

"snipmate setup
if filereadable('~/.vim/snippets/support_functions.vim')
  source ~/.vim/snippets/support_functions.vim
end

let g:snipMate = { 'snippet_version' : 1 }

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"key mapping for window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"key mapping for saving file
nmap <C-s> :w<CR>

"key mapping for tab navigation
nmap <S-Tab> gt
nmap <C-S-Tab> gT

"Key mapping for textmate-like indentation
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

cmap w!! w !sudo tee > /dev/null %

let ScreenShot = {'Icon':0, 'Credits':0, 'force_background':'#FFFFFF'}

"Enabling Zencoding
let g:user_zen_settings = {
  \  'php' : {
  \    'extends' : 'html',
  \    'filters' : 'c',
  \  },
  \  'xml' : {
  \    'extends' : 'html',
  \  },
  \  'haml' : {
  \    'extends' : 'html',
  \  },
  \  'erb' : {
  \    'extends' : 'html',
  \  },
 \}

" when press { + Enter, the {} block will expand.
imap {<CR> {}<ESC>i<CR><ESC>O

" NERDTree settings
nmap wm :NERDTree<cr>
let NERDTreeIgnore=['\.swp$']

nnoremap <Esc>A <up>
nnoremap <Esc>B <down>
nnoremap <Esc>C <right>
nnoremap <Esc>D <left>
inoremap <Esc>A <up>
inoremap <Esc>B <down>
inoremap <Esc>C <right>
inoremap <Esc>D <left>

"set noballooneval
map <C-t> :CtrlP<CR>
map <xCSI>[62~ <MouseDown>]
if !has('nvim')
  set ttymouse=xterm2
endif

let Tlist_Ctags_Cmd='/Users/eduardomatos/.vim/taglist_45'

"my maps
noremap <D-≈> :e <C-R>=expand("%:p:h") . '/'<CR>
if has("balloon_eval")
  set noballooneval
endif

augroup filetypedetect
  autocmd BufRead,BufNewFile *.prawn set filetype=ruby
augroup END

nmap <F8> :set columns+=10<CR>
nmap <F9> :set lines+=10<CR>

"change key to expand emmet
let g:user_emmet_leader_key = '<c-e>'

" Vim airline configs
let g:airline#extensions#tabline#enabled = 1

" GitGutter configs
let g:gitgutter_enabled = 1
let g:gitgutter_realtime = 0
let g:gitgutter_max_signs = 500
let g:gitgutter_highlight_lines = 1
let g:gitgutter_escape_grep = 1
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = 'xx'
let g:gitgutter_sign_removed_first_line = "^_"

set signcolumn=yes

" GitGutter override colors
hi GitGutterAdd               ctermbg=Black     ctermfg=LightGreen    guibg=Black   guifg=LightGreen
hi GitGutterChange            ctermbg=Black     ctermfg=LightYellow   guibg=Black   guifg=LightYellow
hi GitGutterDelete            ctermbg=Black     ctermfg=LightRed      guibg=Black   guifg=LightRed
hi myGitGutterAddLine           ctermbg=NONE     ctermfg=NONE   guibg=NONE   guifg=NONE
hi myGitGutterChangeLine        ctermbg=NONE     ctermfg=NONE   guibg=NONE   guifg=NONE
hi myGitGutterDeleteLine        ctermbg=NONE     ctermfg=NONE  guibg=NONE   guifg=NONE

highlight link GitGutterAddLine myGitGutterAddLine
highlight link GitGutterChangeLine myGitGutterChangeLine
highlight link GitGutterDeleteLine myGitGutterDeleteLine

" Search color highlight
hi Search    ctermbg=2    ctermfg=232    guibg=#47583B  guifg=NONE  cterm=NONE      gui=NONE

" Border column max width
hi ColorColumn ctermbg=2 guibg=LightGreen

" JSHint options
let g:jshint2_close = 0
let g:jshint2_save = 0
let g:jshint2_read = 0
let g:jshint2_height = 5
let g:jshint2_quickfix = 0

" Disable Ruby Provider
let g:loaded_ruby_provider = 1

" CommandT options
set wildignore=&wildignore,**/bower_components/*,**/node_modules/*

function! s:OpenEmberAddonFile()
  let l:moduleName = expand("<cfile>")
  let l:addonName = matchstr(l:moduleName, "^[^/]*")
  let l:filename  = matchstr(l:moduleName, "^[^/]*/\\zs.*")
  execute ":edit node_modules/" . l:addonName . "/addon/" . l:filename . ".js"
endfunction

nnoremap <leader>oaf :call <SID>OpenEmberAddonFile()<CR>

