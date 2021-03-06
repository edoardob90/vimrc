" Neovim init script
"
" Date: 16 aug 2018
" Author: Edoardo Baldi (edoardob90@gmail.com)
"
" Purpose: clean and purge the old vimrc script, which is sourced as a whole
" by Neovim right now.
" Add only the stuff I *really* need and understand. Narrow down the seleciton
" of plugins.
"
" -------------------
" init.vim STARTS
" -------------------
"
"
" Disable old features compatibility
set nocompatible

" Set up my plugin manager

call plug#begin('~/.vim/myplugins')

" --------
" PLUGINS
" --------
" sensible defaults: all the stuff the should be by default active in every
" vim/neovim
Plug 'tpope/vim-sensible'

" Surround plugin for matching symbols
Plug 'tpope/vim-surround'

" Commentary (comment text object)
Plug 'tpope/vim-commentary'

" Custom text object
" the base plugin
Plug 'kana/vim-textobj-user'
" LaTeX math & other text objects
Plug 'rbonvall/vim-textobj-latex'
" markdown text objects
Plug 'coachshea/vim-textobj-markdown'

" Status bar
Plug 'itchyny/lightline.vim'

" distraction free writing with vim
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" GIT plugins:
" Tracking git changes
Plug 'airblade/vim-gitgutter'
" Git wrapper
Plug 'tpope/vim-fugitive'

" Scratch space
Plug 'mtth/scratch.vim'

" Colorschemes
Plug 'chriskempson/base16-vim'

" Various language packs for syntax
Plug 'sheerun/vim-polyglot'

" Markdown
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-colors-pencil'

" Wolfram Language syntax
Plug 'arnoudbuzing/wolfram-vim'

" Modern replacement for matchit
Plug 'andymass/vim-matchup'

" === Autocomplete plugins ===
" Deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" ---------------
" END OF PLUGINS
" ---------------
call plug#end()


"------------------------------------------
" general settings
"------------------------------------------
" NOT NEEDED because vim-plug sets this
"filetype plugin indent on

" NOT NEEDED because vim-plug sets this
"syntax on

" now the general settings (tabs, spaces, bells, backgrounds...)
set autoindent        " indented text
set autoread          " pick up external changes to files
set autowrite         " write files when navigating with :next/:previous
set background=dark   " default background for color schemes
set belloff=all       " bells are annoying
set breakindent       " wrap long lines *with* indentation
set noswapfile        " avoid creating .swp files
set noshowmode        " don't show modes, useless with alternative status bars plugins

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
set foldmethod=manual " manual folding
set matchpairs=(:),{:},[:],<:>

" splitting windows
set splitbelow        " Split below current window
set splitright        " Split window to the right

" wrap long lines
set wrap

" Tell vim to remember certain things when we exit
" '10  :  marks will be remembered for up to 10 previously edited files
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
if !has("nvim")
    set viminfo='10,\"100,:20,%,n~/.viminfo
else
    " Do nothing to use nvim default
    " or something like:
    "   set viminfo+=n~/.shada
endif

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
" From the book 'Modern Vim', TIP 24, p.99
set undofile
" Set directory if using vim; neovim uses $XDG_DATA_HOME/nvim/undo or
" $HOME/.local/share/nvim/undo is the env variable is not set
if !has('nvim')
    set undodir=~/.vim/undo
endif
augroup vimrc
    autocmd!
    autocmd BufWritePre /tmp/* setlocal noundofile
augroup END

" Python code indent
" (relies on the helper function GetGooglePythonIndent, see below in
" respective section)
setlocal indentexpr=GetGooglePythonIndent(v:lnum)
let s:maxoff = 50 " maximum number of lines to look backwards.
let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

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
    set gfn=Menlo:h18
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

" quickly exit
nnoremap <leader>q :q<CR>
" save everything and exit
nnoremap <leader>Q :wqa<CR>
" force write
nnoremap <leader>w :w!<CR>

" turn paste on
" this ignores indentation rules when pasting
nnoremap <leader>P :set paste! paste?<CR>

" make left and right keys cycle between tabs
nnoremap <leader><Right> :tabnext<CR>
nnoremap <leader><Left>  :tabprev<CR>

" this makes vim's regex search not stupid
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
noremap <C-q> :confirm qall<CR>

" Delete previous word when in insert mode via Ctrl-b
inoremap <C-b> <C-O>diw

" Create the `tags` file in current folder (MUST install `ctags` beforehand)
command! MakeTags !ctags -R .

" ----------------------------------
"  Window management
" ----------------------------------
"set wh=30
"set wiw=30
"set winminheight=1
"set winminwidth=10

nnoremap <silent> <leader>s  :split<CR>
nnoremap <silent> <leader>-  :new<CR>
nnoremap <silent> <leader>v  :vsplit<CR>
nnoremap <silent> <leader>t  :$tabnew<CR>

nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent><leader>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent><leader>- :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

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

" Indent Python helper function

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction


"------------------------------------------
" color scheme settings
"------------------------------------------
" set gui colors for vim terminal (if VIM supports it)
if exists('+termguicolors')
    set termguicolors
endif

" Base16-shell --> see ~/.dotfile/zshrc or config in $DOTFILES
if filereadable(expand("~/.vimrc_background"))
    "let base16colorspace=256 " usually this is not needed
    source ~/.vimrc_background
else
   " set manually a color scheme
   colorscheme pencil
endif

"------------------------------------------------
" plugin specific settings (when and if needed)
"------------------------------------------------

" ---------
" Deoplete
" ---------
let g:deoplete#enable_at_startup = 1

" following lines are taken from here
" https://www.gregjs.com/vim/2016/configuring-the-deoplete-asynchronous-keyword-completion-plugin-with-tern-for-vim
if !exists('g:deoplete#omni_patterns')
    let g:deoplete#omni_patterns = {}
endif

" actually disable auto-completion
" let g:deoplete#disable_auto_complete = 1

" automatically close the scratch window at the top of the vim window on finishing a complete or leave insert
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

augroup omnifuncs
    autocmd!
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup end

" setup TAB to complete and cycle through suggested
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" ------------
"  Vim Pencil
" ------------
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,md call pencil#init()
  autocmd FileType text         call pencil#init({'wrap': 'hard'})
augroup END
