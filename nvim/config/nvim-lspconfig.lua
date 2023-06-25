local lsp_util_stylize_markdown = vim.lsp.util.stylize_markdown
local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " "
}
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

function vim.lsp.util.stylize_markdown(bufnr, contents, opts)
    vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')
    local result = lsp_util_stylize_markdown(bufnr, contents, opts)
    vim.api.nvim_buf_set_option(bufnr, 'syntax', '')
    return result
end

local function on_attach_common(client, bufnr)
    if client.resolved_capabilities.document_highlight then
        local group = 'LspDocumentHighlight'
        vim.api.nvim_create_augroup(group, {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            group = group,
            buffer = bufnr
        })
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references
        })
    end
end

local function on_publish_diagnostics(_, bufnr)
    local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'lsp_diagnostics_enabled')
    if not ok then
        return true
    end
    return result
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = on_publish_diagnostics,
    signs = on_publish_diagnostics,
    update_in_insert = on_publish_diagnostics,
    virtual_text = false
})

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = hl
    })
end

lspconfig.lua_ls.setup {
    on_attach = on_attach_common,
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim'}
            },
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    },
    capabilities = capabilities
}

lspconfig.vimls.setup {
    on_attach = on_attach_common,
    capabilities = capabilities
}

lspconfig.pyright.setup{}

lspconfig.tsserver.setup{}

lspconfig.svelte.setup{}

lspconfig.rust_analyzer.setup{
    diagnostics = {
        experimental = {
            enable = true
        }
    }
}

