""Enable AI
set ai

""Disable VI's compatible mode
set nocompatible

""Enable syntax hightlighting
syntax enable

""Python syntax highlighting for scon files
autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

""Python syntax highlighting for waf files
autocmd BufReadPre wscript set filetype=python
autocmd BufReadPre wscript set filetype=python

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

""Turn backup off
"set nobackup
"set nowb
"set noswapfile

""Enable filetype plugins
filetype plugin on

""Set default tabs
setl expandtab
setl tabstop=2
setl softtabstop=2

""File specific tabs
au FileType bash,html,javascript setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
au FileType c,erlang,markdown,python setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab
au FileType make,go setl tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

""Spell check
function! ToggleSpell()
  if !exists("b:spell")
    setlocal spell spelllang=en_us
    let b:spell = 1
  else
    setlocal nospell
    unlet b:spell
  endif
endfunction
 
nmap <F4> :call ToggleSpell()<CR>
imap <F4> <Esc>:call ToggleSpell()<CR>
nmap <c-t> :CommandT<CR>

""Alt+j and Alt+k to move between tabs
nnoremap <A-j> gT
nnoremap <A-k> gt

""Ctrl+Space for autocomplete
imap <c-space> <c-x><c-o>

""Toggle set list
nmap <leader>l :set list!<CR>

""TextMate style tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
