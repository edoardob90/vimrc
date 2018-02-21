" skip initialization for vim-tiny or vim-small.
if 0 | endif

set nocompatible

"-----------------------------------------------
" vim-plug
" ----------------------------------------------
" NeoBundle seems it's not going to be updated
" so we switch to this plugin manager

call plug#begin('~/.vim/myplugins')

" --- PLUGINS ---

" Tracking git changes
Plug 'airblade/vim-gitgutter'

" luna colorscheme
Plug 'bcumming/vim-luna'

" sensible defaults
Plug 'tpope/vim-sensible'

" control-p for finding files
Plug 'kien/ctrlp.vim'

" use .gitignore to filter for commands that search files
Plug 'vim-scripts/gitignore'

" Surround plugin for matching symbols
Plug 'tpope/vim-surround'

" PLUMED syntax
Plug 'edoardob90/vim-plumed'

" alternative status bar
Plug 'itchyny/lightline.vim'

" markdown for VIM
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" syntax for Pandoc
Plug 'vim-pandoc/vim-pandoc-syntax'

" Nova color scheme
Plug 'trevordmiller/nova-vim'

" Fuzzy finding
Plug 'junegunn/fzf.vim'

call plug#end()

" turn on file specific rules set in the path ~/.vim/after/__language__.vim
" also required by neobundle
filetype plugin indent on

"------------------------------------------
" general settings
"------------------------------------------
" set leader to space
let mapleader = "\<Space>"

" syntax hilighting
syntax on

" set to auto read when a file is changed from outside
set autoread

" utf
set encoding=utf-8

 " swap between buffers without needing to save
set hidden

" none of these are word dividers
set iskeyword+=_,#

 " line numbers
set number
set relativenumber

" optimize macro execution by not redrawing until macro is finished
set lazyredraw

" hilight tabs and trailing spaces
set list
set listchars=tab:-.,trail:.

" show matching brackets
set showmatch

" leave 10 rows of space when scrolling
set scrolloff=10

" text formatting
set expandtab
set softtabstop=2
set shiftwidth=4
set tabstop=4 " make real tabs 4 wide

" wrap long lines
set wrap

" Tell vim to remember certain things when we exit
" '10  :  marks will be remembered for up to 10 previously edited files
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
set viminfo='10,\"100,:20,%,n~/.viminfo

" now restore position based on info saved in viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" When you type the first tab, it will complete as much as possible, the second
" tab hit will provide a list, the third and subsequent tabs will cycle through
" completion options so you can complete the file without further keys
set wildmode=longest,list,full
" completion with menu
set wildmenu

" Sometimes, $MYVIMRC does not get set even though the vimrc is sourced
" properly. So far, I've only seen this on Linux machines on rare occasions.
if has("unix") && strlen($MYVIMRC) < 1
  let $MYVIMRC=$HOME . '/.vimrc'
endif

" backspace
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Maintain undo history between sessions
set undofile
set undodir=~/.vim/undodir

"------------------------------------------
" search options
"------------------------------------------
" search as characters are entered
set incsearch
" highlight matches
set hlsearch
" ignore case
set ignorecase
" ... unless you type a capital
set smartcase

"------------------------------------------
" color scheme settings
"------------------------------------------
set background=dark
if has("gui_running")
    colorscheme nova
else
    set t_Co=256
    colorscheme nova
endif

" hilight current line by making the row number on the lhs stand out
set cursorline
hi CursorLine ctermbg=NONE cterm=NONE term=NONE
hi CursorLineNr ctermfg=117 ctermbg=236  term=bold cterm=bold

" GUI default font
if has("gui_running")
    "set guifont=Hack\ Regular:h16
    set gfn=Source\ Code\ Pro:h14
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

"------------------------------------------
" key bindings
"------------------------------------------

" fast saving
nmap <leader>w :w!<CR>

" :W sudo saves the file
command W w !sudo tee % > /dev/null

" hit leader then "e" to reload files that have changed outside the editor
nnoremap <leader>e :edit<CR>

" hit leader then "n" to remove line numbers
nnoremap <leader>n :set nu!<CR>

" hit space space to remove hilights from previous search
nnoremap <leader><Space> :nohlsearch<CR>

" use the combination jk to exit insert mode
" ... easier than reaching up for the escape key
inoremap jk <ESC>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :wqa<CR>
nnoremap <Leader>w :w!<CR>

" turn paste on
" this ignores indentation rules when pasting
nnoremap <leader>p :set paste! paste?<CR>

" make left and right keys cycle between tabs
nnoremap <leader><Right> :tabnext<CR>
nnoremap <leader><Left>  :tabprev<CR>

" this makes vim's regex search not stupid
" I MUST UNDERSTAND WHAT THIS MEANS !!!
"nnoremap / /\v
"vnoremap / /\v

" edit and source vimrc on the fly
noremap <leader>v :e! $MYVIMRC<CR>
noremap <silent><leader>E :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" -----------------
" Helper functions
" -----------------
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"------------------------------------------
" plugin-specific settings
"------------------------------------------

" --- ctrlp ---
" configure ctrlp to use ag for searching
" this interacts nicely with the gitignore vim package
let g:ctrlp_use_caching = 0
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif

" --- calendar.vim ---
let g:calendar_date_endian="little"
let g:calendar_google_calendar=1
