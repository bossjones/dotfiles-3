""Disable VI's compatible mode
set nocompatible

""Disable autocomplete scratch window
set completeopt=menu

""Pathogen
call pathogen#infect()

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

""Set default tabs
setl expandtab
setl tabstop=2
setl softtabstop=2

""File specific tabs
au FileType bash,html,jade,javascript,puppet,ruby setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
au FileType c,erlang,haskell,java,markdown,python setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab
au FileType go,perl,make setl tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

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
