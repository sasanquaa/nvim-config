let g:coc_global_extensions = [ 'coc-json', 'coc-java', 'coc-vimlsp', 'coc-sumneko-lua', 'coc-pairs' ]

let s:coc_completion_prev_index = -1
let s:coc_completion_prev_col = -1
let s:coc_completion_backspace_disabled = v:false

inoremap <silent><expr> <TAB> coc#pum#visible() ? CocCompletionSelectAndConfirm() : 
                            \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#next()\<CR>" : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? CocCompletionSelectAndConfirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-Space> coc#refresh()

nnoremap <silent> K :call CocShowDocumentation()<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <Leader>rn <Plug>(coc-rename)
nmap <Leader>fs <Plug>(coc-format-selected)
nmap <silent> <Leader>fa :call CocActionAsync('format')<CR>
nmap <silent> <Leader>or :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>
nmap <Leader>af <Plug>(coc-fix-current)

xmap <Leader>fs <Plug>(coc-format-selected)

autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd TextChangedI * silent call CocCompletionEnsureBackspace()

function! CocShowDocumentation() abort
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

function! CocCompletionSelectAndConfirm() abort
    call CocCompletionBackspaceDisable()
    call coc#_select_confirm()
    call timer_start(11, { -> CocCompletionBackspaceEnable() } )
    return ""
endfunction

function! CocCompletionBackspaceEnable() abort
    let s:coc_completion_backspace_disabled = v:false
    noa set completeopt+=noinsert
endfunction

function! CocCompletionBackspaceDisable() abort
    let s:coc_completion_backspace_disabled = v:true
    noa set completeopt-=noinsert
endfunction

function! CocCompletionEnsureBackspace() abort
    if s:coc_completion_backspace_disabled == v:true
        return
    endif
    let col = col(".") - 1
    if col && !(getline(".")[col - 1] =~# '\s') && coc#pum#visible()
        let info = coc#pum#info()
        if col < s:coc_completion_prev_col
            if info["inserted"] == v:false
                call coc#start()
            else
                if info["index"] != s:coc_completion_prev_index
                    call coc#start()
                endif
            endif
        endif
        let s:coc_completion_prev_index = info["index"]
    endif
    let s:coc_completion_prev_col = col
endfunction
