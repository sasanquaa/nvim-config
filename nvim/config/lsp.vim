" nmap <silent> <Leader>rn :lua vim.lsp.buf.rename()<CR>
nmap <silent> <Leader>fa :lua vim.lsp.buf.format()<CR>
nmap <silent> <Leader>fd :silent! !dx fmt<CR>
" nmap <silent> <Leader>ca :lua vim.lsp.buf.code_action()<CR>
nmap <silent> K :lua vim.lsp.buf.hover()<CR>
nmap <silent> D :lua vim.diagnostic.open_float()<CR>

xmap <silent> <Leader>fs :lua vim.lsp.buf.range_formatting()<CR>
" xmap <silent> <Leader>ca :lua vim.lsp.buf.code_action()<CR>
