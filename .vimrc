""Enable AI
set ai

""Disable VI's compatible mode
set nocompatible

""Enable syntax hightlighting
syntax enable

""Always show current position
set ruler

""Set backspace
set backspace=eol,start,indent

""Ignores
set wildignore=*.o,*.obj,*.bak,*.exe

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

""Tabs
set expandtab
set tabstop=4
set shiftwidth=4

""File specific tabs
au FileType make setl noexpandtab

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

""Alt+j and Alt+k to move between tabs
nnoremap <A-j> gT
nnoremap <A-k> gt

""Ctrl+Space for autocomplete
imap <c-space> <c-x><c-o>
