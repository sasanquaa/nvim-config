filetype on
syntax off

set noswapfile
set nobackup
set nowritebackup 
set showtabline=0
set number 
set termguicolors 
set cursorline 
set updatetime=100
set signcolumn=yes:1
set backspace=indent,eol,start
set shiftwidth=4
set noequalalways
set tabstop=4
set softtabstop=4
set expandtab
set completeopt+=noinsert

source ~/.config/nvim/lua/plugins.lua
source ~/.config/nvim/config/theme.vim
source ~/.config/nvim/config/terminal.vim

autocmd FileType help,asm,ld setlocal syntax=ON
