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
set tabstop=4
set softtabstop=4
set expandtab
set completeopt+=noinsert

runtime lua/plugins.lua
runtime config/theme.vim

autocmd FileType help,asm,ld setlocal syntax=ON
