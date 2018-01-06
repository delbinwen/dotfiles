" Remove vi old behavior
set nocompatible
filetype off

" Vim plug configuration
call plug#begin('~/.vim/plugged')

" Editor
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Raimondi/delimitMate'
Plug 'sjl/vitality.vim'
Plug 'gcmt/taboo.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'rizzatti/dash.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Markup
Plug 'plasticboy/vim-markdown'

" Vim themes
Plug 'dracula/vim', {'as': 'dracula'}

" Go
Plug 'fatih/vim-go'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins setup 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Airline
set timeoutlen=1000 ttimeoutlen=50
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = -1

" NERDTree
let NERDTreeChDirMode                   = 2
let NERDTreeShowBookmarks               = 1
let NERDTreeWinSize                     = 30
let NERDTreeQuitOnOpen                  = 1
let g:nerdtree_tabs_open_on_gui_startup = 0
nmap <leader>n :NERDTreeMirrorToggle<CR>

" delimitMate
let delimitMate_expand_space = 1
let delimitMate_matchpairs   = "(:),[:],{:}"

" Dracula theme
color dracula

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax hl
syntax enable

" Set font
set guifont=Source\ Code\ Pro\ for\ Powerline:h12

"" Markdown
let g:vim_markdown_folding_disabled=1

