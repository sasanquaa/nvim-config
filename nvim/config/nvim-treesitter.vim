nnoremap <silent> ntf :NvimTreeFocus<CR>
nnoremap <silent> ntt :NvimTreeToggle<CR>
nnoremap <silent> ntc :NvimTreeClose<CR>
nnoremap <silent> nts :NvimTreeFindFile<CR>
nnoremap <silent> ntr :NvimTreeRefresh<CR>

autocmd VimEnter * silent call TSVimEnter()

function! TSVimEnter() abort
    execute 'TSEnable highlight'
    execute 'TSEnable indent'
endfunction
