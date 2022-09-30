function! LightLineFilter() abort
    for i in range(1, winnr('$'))
        if getwinvar(i, '&filetype') == 'NvimTree'
            call setwinvar(i, '&statusline', '%#Normal#')
            call setwinvar(i, '&signcolumn', 'yes')
        endif
    endfor
endfunction

autocmd VimEnter * autocmd WinEnter,BufEnter * call LightLineFilter()
