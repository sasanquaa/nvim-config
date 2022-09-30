function! LightLineFilter() abort
    for i in range(1, winnr('$'))
        let filetype = getwinvar(i, '&filetype')
        if filetype == 'NvimTree' || filetype == 'Terminal'
            call setwinvar(i, '&statusline', '%#StatusLine#')
            if filetype != 'Terminal'
                call setwinvar(i, '&signcolumn', 'yes')
            endif
        endif
    endfor
endfunction

autocmd VimEnter * autocmd WinEnter,BufEnter * call LightLineFilter()
