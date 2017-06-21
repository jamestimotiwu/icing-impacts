"Plugin Directory
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'davidhalter/jedi-vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
"Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'

"GUIs
Plug 'altercation/vim-colors-solarized'
Plug 'liuchengxu/space-vim-dark'

Plug 'tpope/vim-fugitive'
Plug 'nvie/vim-flake8'
Plug 'jmcantrell/vim-virtualenv'
Plug 'jpalardy/vim-slime'
Plug 'fs111/pydoc.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
"Plug 'Yggdroot/indentLine'


call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Vim Airline Settings

set laststatus=2

"Personal Settings
"Author: James Timotiwu
"
"General{

set encoding=utf-8
syntax enable
set background=dark
"colorscheme solarized
colorscheme space-vim-dark
:set cursorline

"Airline Settings
let g:airline_theme='powerlineish'
let g:airline_left_sep='›'
let g:airline_right_sep='‹'

"Fonts
set guioptions-=T
set lines=40
set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
set hidden "allow buffer switching without saving (?)

"Programming{
let python_higlight_all=1
syntax on

"Folding
"set foldmethod=indent
"Preset Settings

""Python Buffer Reader
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

"Author: Henry Lin
" 
" Here are some helpful vim settings that vim may not have on by default.
" To toggle any of these settings off, simply append a " character to the
" front of the line
"
" If there's ever a setting you think this file does not have, then
" look it up! There is plenty of documentation online to help you 
" customize your vim. In particular, this .vimrc does not mention
" much about key remapping, which may be of interest to some of you.
"
" If there is any setting you would like more information for in vim,
" in normal mode, type :h setting. (Example, :h autoindent)
"
" Note that this .vimrc does not use any plugins. Look them up on your own
" if you're interested.
"
" NOTE: If you do happen to modify this file, to activate these new vim
" settings, one way would be to save and quit vim, and reopen your file
" of interest.

" UI (User interface) settings
set number                  " Show line numbers
set scrolloff=5             " Show 5 lines of content beneath the cursor
syntax on                   " Turn on automatic highlighting
set ruler                   " Show line and column number separated by a comma
"set nowrap                  " See :h nowrap

" Search settings
set hlsearch                " Highlights all search matches
set incsearch               " While typing search command, shows currently matched pattens

" Tab settings
set autoindent              " Copy indent from current line when starting new line
set smarttab                " See :h smarttab
set shiftwidth=4            " Sets the shift width to 4
set tabstop=4               " Number of spaces a <Tab> counts for (appearance only!)
set expandtab               " Use spaces instead of tabs. See also 'set noexpandtab'

" File settings
"set nobackup                " Sets to not save the backup file (example: list.cpp~)
"set noswapfile              " Sets to not save the swapfile
set nowritebackup
filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" Input settings
set backspace=indent,eol,start " allow backspacing over everything in insert mode
if has('mouse')
    set mouse=a               " See :h mouse
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some random (possibly unconventional) settings that might interest you
" Uncomment these to activate.

" Remappings to switch tabs. Only works in normal mode
" Source: http://vim.wikia.com/wiki/Alternative_tab_navigation
" Note that some terminals cannot remap C-tab for some reason, which is why
" I chose <S-h> and <S-l>
"
"nnoremap <S-h> :tabprevious<CR>    " Remaps shift+h to going to the previous tab
"nnoremap <S-l>   :tabnext<CR>      " Remaps shift+l to going to the next tab
"


