" skip initialization for vim-tiny or vim-small.
if 0 | endif


"------------------------------------------
" neobundle
"------------------------------------------
if has('vim_starting')
    " turn off vi compatability
    if &compatible
        set nocompatible
    endif

    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" --- my bundles ---

" luna colorscheme
NeoBundle 'bcumming/vim-luna'
" sensible defaults
NeoBundle 'tpope/vim-sensible'
" airline status bar
NeoBundle 'bling/vim-airline'
" awesome git!
NeoBundle 'tpope/vim-fugitive'
" git in the gutter
NeoBundle 'airblade/vim-gitgutter'
" use silver searcher in place of grep
NeoBundle 'rking/ag.vim'
" control-p for finding files
NeoBundle 'kien/ctrlp.vim'
" use .gitignore to filter for commands that search files
NeoBundle 'vim-scripts/gitignore'
" support for syntax, indentation etc in Julia
NeoBundle 'JuliaLang/julia-vim'
" easy swapping of windows
NeoBundle 'wesQ3/vim-windowswap.git'

" --- EB bundles ---
" Syntastic plugin
NeoBundle 'vim-syntastic/syntastic.git'
" Surround plugin for matching symbols
"NeoBundle 'tpope/vim-surround.git'
NeoBundle 'anyakichi/vim-surround' " seems more active than above plugin
" NERDTree filesystem explorer
NeoBundle 'scrooloose/nerdtree.git'
" Color scheme from Valloric repo
NeoBundle 'Valloric/vim-valloric-colorscheme'

if v:version > 703
    " provides fuzzy completer and clang based cleverness
    NeoBundle 'Valloric/YouCompleteMe', {
         \ 'build'      : {
            \ 'mac'     : './install.py --clang-completer',
            \ 'unix'    : './install.py',
            \ }
         \ }
endif

call neobundle#end()

" turn on file specific rules set in the path ~/.vim/after/__language__.vim
" also required by neobundle
filetype plugin indent on

" prompt to install uninstalled bundles found on startup
NeoBundleCheck

"------------------------------------------
" general settings
"------------------------------------------

" set leader to space
let mapleader = "\<Space>"

" syntax hilighting
syntax on

" utf
set encoding=utf-8

 " swap between buffers without needing to save
set hidden

" none of these are word dividers
set iskeyword+=_,#

 " line numbers
set nu

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
set shiftwidth=4
set softtabstop=4
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

"------------------------------------------
" search options
"------------------------------------------
" search as characters are entered
set incsearch
" highlight matches
set hlsearch

"------------------------------------------
" color scheme settings
"------------------------------------------
set background=dark
if has("gui_running")
    colorscheme valloric
else
    colorscheme valloric
    set t_Co=256
endif

" hilight current line by making the row number on the lhs stand out
set cursorline
hi CursorLine ctermbg=NONE cterm=NONE term=NONE
hi CursorLineNr ctermfg=117 ctermbg=236  term=bold cterm=bold

" GUI default font
set guifont=Hack\ Regular:h16

"------------------------------------------
" key bindings
"------------------------------------------

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
nnoremap <Right> :tabnext<CR>
nnoremap <Left>  :tabprev<CR>

" this makes vim's regex search not stupid
nnoremap / /\v
vnoremap / /\v

" edit and source vimrc on the fly
noremap <leader>v :e! $MYVIMRC<CR>
noremap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

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
