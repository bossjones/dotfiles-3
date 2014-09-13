call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-endwise'
Plug 'fatih/vim-go'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'rodjek/vim-puppet'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle'   }
Plug 'scrooloose/syntastic'

call plug#end()

""Disable VI's compatible mode
set nocompatible

""Disable autocomplete scratch window
set completeopt=menu

""Enable AI
set ai

""Enable syntax hightlighting
syntax on

""Alway use assume bash for sh
let is_bash=1

""Always show current position
set ruler

""Set backspace
set backspace=eol,start,indent

""Ignores
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc

""Auto indent
set autoindent

""Set to auto read when a file is changed from the outside
set autoread

""Show line numbers
set nu

""Set line numbers to green
highlight LineNr term=NONE cterm=NONE ctermfg=DarkGreen ctermbg=NONE

""Smart search
set incsearch
set smartcase

""No sound on errors
set noerrorbells
set novisualbell
set t_vb=

""Show matching bracets
set showmatch

""Set color scheme
colorscheme desert

""Enable filetype plugins
filetype plugin on

""Tab types
command Tab2 setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
command Tab4 setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab
command Tab setl tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

""Set default tabs
Tab2

""File specific tabs
au FileType bash,html,jade,javascript,puppet,ruby Tab2
au FileType c,erlang,haskell,java,markdown,python Tab4
au FileType go,perl,make Tab

nmap ` :SyntasticToggleMode<CR>

""Alt+j and Alt+k to move between tabs
nnoremap <A-j> gT
nnoremap <A-k> gt

""Toggle set list
nmap <leader>l :set list!<CR>

""TextMate style tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

""Sudo write
cmap w!! w !sudo tee % >/dev/null

""Toggle paste
set pastetoggle=<leader>p
