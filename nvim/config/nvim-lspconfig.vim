nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
nmap <silent> gD :lua vim.lsp.buf.declaration()<CR>
nmap <silent> gt :lua vim.lsp.buf.type_definition()<CR>
nmap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nmap <silent> gr :lua vim.lsp.buf.references()<CR>

nmap <silent> <Leader>rn :lua vim.lsp.buf.rename()<CR>
nmap <silent> <Leader>fa :lua vim.lsp.buf.format()<CR>
nmap <silent> <Leader>ca :lua vim.lsp.buf.code_action()<CR>
nmap <silent> K :lua vim.lsp.buf.hover()<CR>

xmap <silent> <Leader>fs :lua vim.lsp.buf.range_formatting()<CR>

autocmd User EasyMotionPromptBegin call LspDiagnosticsDisable()
autocmd User EasyMotionPromptEnd call LspDiagnosticsEnable()

function! LspDiagnosticsEnable() abort
    function! Enabler() abort
        let b:lsp_diagnostics_timer_id = -1
        let b:lsp_diagnostics_enabled = v:true
    endfunction
    let b:lsp_diagnostics_timer_id = timer_start(1000, { -> Enabler() })
endfunction

function! LspDiagnosticsDisable() abort
    if exists('b:lsp_diagnostics_timer_id') && b:lsp_diagnostics_timer_id != -1
        call timer_stop(b:lsp_diagnostics_timer_id)
    endif
    let b:lsp_diagnostics_enabled = v:false
endfunction
