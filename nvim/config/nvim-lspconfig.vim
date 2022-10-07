nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
nmap <silent> gD :lua vim.lsp.buf.declaration()<CR>
nmap <silent> gt :lua vim.lsp.buf.type_definition()<CR>
nmap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nmap <silent> gr :lua vim.lsp.buf.references()<CR>

nmap <silent> <Leader>rn :lua vim.lsp.buf.rename()<CR>
nmap <silent> <Leader>fa :lua vim.lsp.buf.formatting()<CR>
nmap <silent> <Leader>ca :lua vim.lsp.buf.code_action()<CR>
nmap <silent> K :lua vim.lsp.buf.hover()<CR>

xmap <silent> <Leader>fs :lua vim.lsp.buf.range_formatting()<CR>
