nnoremap <silent> <Leader>termh :belowright split \| terminal <CR>
nnoremap <silent> <Leader>termv :belowright vsplit \| terminal <CR>

tnoremap <Esc> <C-\><C-n>

autocmd TermOpen * silent call TermOpen() 

function! TermOpen() abort
    setlocal signcolumn=no
    setlocal number!
    setlocal statusline=%#StatusLine#
    setlocal filetype=Terminal
endfunction
