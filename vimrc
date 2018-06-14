" skip initialization for vim-tiny or vim-small.
if 0 | endif

set nocompatible

"-----------------------------------------------
" vim-plug
" ----------------------------------------------
" NeoBundle seems it's not going to be updated
" so we switch to this plugin manager

" Automatically install vim-plug and run PlugInstall if vim-plug is not found.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/myplugins')

" --- PLUGINS ---

" Tracking git changes
Plug 'airblade/vim-gitgutter'

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

" two alternative status bar
" *DISABLED* Plug 'itchyny/lightline.vim'
Plug 'bluz71/vim-moonfly-statusline'

" markdown for VIM
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" syntax for Pandoc
Plug 'vim-pandoc/vim-pandoc-syntax'

" Fuzzy finding
Plug 'junegunn/fzf.vim'

" Enhanced support for writing LaTeX files
Plug 'lervag/vimtex'

" ***PLUGIN FOR COLORS***
Plug 'morhetz/gruvbox'
Plug 'bluz71/vim-moonfly-colors'
    let g:moonflySpellInverse   = 1
    let g:moonflyCursorColor    = 1
    let g:moonflyTerminalColors = 1

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'bcumming/vim-luna'

call plug#end()

" turn on file specific rules set in the path ~/.vim/after/__language__.vim
" also required by neobundle
filetype plugin indent on

"------------------------------------------
" general settings
"------------------------------------------
" syntax hilighting
syntax on

set autoindent        " indented text
set autoread          " pick up external changes to files
set autowrite         " write files when navigating with :next/:previous
set background=dark   " default background for color schemes
set belloff=all       " bells are annoying
set breakindent       " wrap long lines *with* indentation
set noswapfile        " avoid creating .swp files

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
set tabstop=4         " make real tabs 4 wide
set showbreak=\\\\\   " use this to wrap long lines
set foldmethod=syntax " fold according to syntax (if available)
set matchpairs=(:),{:},[:]

" splitting windows
set splitbelow        " Split below current window
set splitright        " Split window to the right

" wrap long lines
set wrap

" Tell vim to remember certain things when we exit
" '10  :  marks will be remembered for up to 10 previously edited files
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
set viminfo='10,\"100,:20,%,n~/.viminfo

" restore position based on info saved in viminfo
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
" Default directory in local /tmp
let s:undoDir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undoDir)
    call mkdir(s:undoDir, "", 0700)
endif
let &undodir=s:undoDir
set undofile          " Maintain undo history

set t_Co=256 " set terminal colors

"------------------------------------------
" terminal configuration
"------------------------------------------
if !has("gui_running") && !has("nvim")
    " Note, Neovim cursor shape and 24-bit true colors work without any
    " help required; the following 'help' is for terminal Vim only. 

    " if tmux
    if &term == 'screen-256color' || &term == 'screen'
        " Change the cursor to an I-beam when in insert mode.
        let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
        " Make CTRL-Left/Right work inside tmux.
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
        " Make Vim *set termguicolors* work inside tmux.
        set t_8b=[48;2;%lu;%lu;%lum
        set t_8f=[38;2;%lu;%lu;%lum
    " else not tmux
    else
        " Change the cursor to an I-beam when in insert mode.
        let &t_SI = "\e[6 q"
        let &t_EI = "\e[2 q"
    endif
endif



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


" hilight current line by making the row number on the lhs stand out
set cursorline
hi CursorLine ctermbg=NONE cterm=NONE term=NONE
hi CursorLineNr ctermfg=117 ctermbg=236  term=bold cterm=bold

" GUI default font
if has("gui_running")
    set gfn=Source\ Code\ Pro:h14
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set guitablabel=%M\ %t
endif

"------------------------------------------
" key bindings
"------------------------------------------
" set leader to space
let mapleader = "\<Space>"
let maplocalleader = ","

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" hit leader then "e" to reload files that have changed outside the editor
nnoremap <leader>e :edit<CR>

" hit leader then "n" to remove line numbers
nnoremap <leader>n :set nu!<CR>

" hit space space to remove hilights from previous search
nnoremap <leader><Space> :nohlsearch<CR>

" use the combination jk to exit insert mode
" ... easier than reaching up for the escape key
inoremap jk <ESC>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :wqa<CR>
nnoremap <leader>w :w!<CR>

" turn paste on
" this ignores indentation rules when pasting
nnoremap <leader>P :set paste! paste?<CR>

" make left and right keys cycle between tabs
nnoremap <leader><Right> :tabnext<CR>
nnoremap <leader><Left>  :tabprev<CR>

" this makes vim's regex search not stupid
" I MUST UNDERSTAND WHAT THIS MEANS !!!
"nnoremap / /\v
"vnoremap / /\v

" edit and source vimrc on the fly
noremap <leader>V :e! $MYVIMRC<CR>
noremap <silent><leader>E :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Y should behave like C and D, yank from cursor till end of line
noremap Y y$

" Center search when navigating
noremap n nzz
noremap N Nzz

" Confirm quit
"noremap <C-q> :confirm qall<CR>

" Delete previous word when in insert mode via Ctrl-b
inoremap <C-b> <C-O>diw

" Yank and put helpers.
"noremap <leader>y        :let @0=getreg('*')<CR>
"noremap <leader>p        "0]p
"noremap <leader>P        "0]P

" ----------------------------------
"  Window management mapping
" ----------------------------------
nnoremap <silent> <leader>s  :split<CR>
nnoremap <silent> <leader>-  :new<CR>
nnoremap <silent> <leader>v  :vsplit<CR>
nnoremap <silent> <leader>t  :$tabnew<CR>

" ------------------------
"  Function key mappings
" ------------------------
nnoremap <localleader>5 :call Spelling()<CR>
nnoremap <localleader>0 :call Listing()<CR>

" -----------------
" Helper functions
" -----------------
" Check where we left off before closing
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction


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


" Toggle spelling mode and add the dictionary to the completion list of
" sources if spelling mode has been entered, otherwise remove it when
" leaving spelling mode.
"
function! Spelling()
    setlocal spell!
    if &spell
        set complete+=kspell
        echo "Spell mode enabled"
    else
        set complete-=kspell
        echo "Spell mode disabled"
    endif
endfunction

" Toggle special characters list display.
"
function! Listing()
    if &filetype == "go"
        if g:listMode == 1
            set listchars=eol:$,tab:>-,trail:-
            highlight SpecialKey ctermfg=12 guifg=#78c2ff
            let g:listMode = 0
        else
            set listchars=tab:\¦\ 
            highlight SpecialKey ctermfg=235 guifg=#262626
            let g:listMode = 1
        endif
        return
    endif

    " Note, Neovim has a Whitespace highlight group, Vim does not.
    if has("nvim")
        if g:listMode == 1
            set listchars=eol:$,tab:>-,trail:-
            highlight Whitespace ctermfg=12 guifg=#78c2ff
            let g:listMode = 0
        else
            set listchars=tab:\ \ ,trail:-
            highlight Whitespace ctermfg=235 guifg=#262626
            let g:listMode = 1
        endif
    else
        set list!
    endif
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


"------------------------------------------
" color scheme settings
"------------------------------------------
"colorscheme nova
"colorscheme moonfly
"colorscheme dracula
if exists('+termguicolors')
    set termguicolors
endif
" enable italic only if using correct terminfo profile
if &term == 'screen-256color' || &term == 'screen'
    let g:gruvbox_italic=0
else
    let g:gruvbox_italic=1
endif
colorscheme gruvbox
