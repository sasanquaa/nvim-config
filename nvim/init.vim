filetype on
syntax off

set noswapfile
set nobackup
" set noautoident
" set nosmartindent
set nowritebackup 
set noequalalways
set showtabline=0
set number 
set cursorline 
set updatetime=100
set signcolumn=yes:1
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set completeopt=menu,preview,noinsert
set pumheight=12

source ~/.config/nvim/lua/plugins.lua
source ~/.config/nvim/config/theme.vim
source ~/.config/nvim/config/terminal.vim

autocmd FileType help,groovy,asm,ld,tsplayground setlocal syntax=ON
