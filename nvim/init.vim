set noswapfile
set nobackup
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

exec printf('source %s/%s', stdpath('config'), 'config/string.lua')
exec printf('source %s/%s', stdpath('config'), 'config/terminal.vim')
exec printf('source %s/%s', stdpath('config'), 'config/netrw.vim')
exec printf('source %s/%s', stdpath('config'), 'config/plugins.lua')

autocmd FileType help setlocal syntax=ON
