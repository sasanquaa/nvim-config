local lsp_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts)
    opts = opts or {}
    opts.max_width = 60
    opts.max_height = 20
    return lsp_util_open_floating_preview(contents, syntax, opts)
end

local on_publish_diagnostics = function(_, bufnr)
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
    virtual_text = on_publish_diagnostics
})

local function on_attach_common(client, bufnr)
    if client.resolved_capabilities.document_highlight then
        local group = 'LspDocumentHighlight'
        vim.api.nvim_create_augroup(group, {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            group = group,
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')

lspconfig.jdtls.setup {
    on_attach = on_attach_common,
    init_options = {
        extendedClientCapabilities = {
            progressReportProvider = true,
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            advancedExtractRefactoringSupport = true,
            advancedOrganizeImportsSupport = true,
            generateConstructorsPromptSupport = true,
            generateDelegateMethodsPromptSupport = true,
            moveRefactoringSupport = true,
            overrideMethodsPromptSupport = true,
            inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" }
        }
    },
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' }
        }
    },
    capabilities = capabilities
}

lspconfig.sumneko_lua.setup {
    on_attach = on_attach_common,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    },
    capabilities = capabilities
}

lspconfig.vimls.setup {
    on_attach = on_attach_common,
    capabilities = capabilities
}

lspconfig.ccls.setup {
    on_attach = on_attach_common,
    capabilities = capabilities,
    init_options = {
        compilationDatabaseDirectory = "Build"
    }
}

lspconfig.cmake.setup {
    init_options = {
        buildDirectory = "Build"
    }
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


vim.api.nvim_create_autocmd("BufReadCmd", { pattern = "jdt://*", callback = function(table)
    local client
    for _, c in ipairs(vim.lsp.get_active_clients()) do
        if c.config.init_options and c.config.init_options.extendedClientCapabilities and
            c.config.init_options.extendedClientCapabilities.classFileContentsSupport then
            client = c
            break
        end
    end
    local buf = table.buf
    local uri = table.match
    local params = {
        uri = uri
    }
    local response, _ = client.request_sync('java/classFileContents', params, 1000, buf)
    if response then
        local content = vim.split(response.result, '\n', true)
        -- local name = vim.split(vim.split(uri, "/", true)[6], '?', true)[1]
        vim.api.nvim_buf_set_option(buf, 'modifiable', true)
        -- vim.api.nvim_buf_set_name(buf, name)
        vim.lsp.buf_attach_client(buf, client.id)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
        vim.api.nvim_buf_set_option(0, 'filetype', 'java')
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end

end
})
