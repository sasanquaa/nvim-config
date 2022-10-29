local lsp_util_stylize_markdown = vim.lsp.util.stylize_markdown
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

lspconfig.jdtls.setup {
    autostart = false,
    on_attach = function(client, bufnr)
        on_attach_common(client, bufnr)
        if client.config.init_options.extendedClientCapabilities.classFileContentsSupport then
            local group = 'LspJavaClassFileContents' .. client.id
            vim.api.nvim_create_augroup(group, {
                clear = false
            })
            if #vim.api.nvim_get_autocmds({ group = group }) == 0 then
                vim.api.nvim_create_autocmd("BufReadCmd",
                    { group = group, pattern = "jdt://*", callback = function(table)
                        local buf = table.buf
                        local uri = table.match
                        local params = {
                            uri = uri
                        }
                        local response, _ = client.request_sync('java/classFileContents', params, 1000, buf)
                        if response then
                            local content = vim.split(response.result, '\n', true)
                            vim.api.nvim_buf_set_option(buf, 'modifiable', true)
                            vim.lsp.buf_attach_client(buf, client.id)
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
                            vim.api.nvim_buf_set_option(0, 'filetype', 'java')
                            vim.api.nvim_buf_set_option(buf, 'modifiable', false)
                        end
                    end
                    })
            end
        end
    end,
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
    capabilities = capabilities,
}

lspconfig.ccls.setup {
    on_attach = on_attach_common,
    init_options = {
        completion = {
            placeholder = false,
            filterAndSort = false
        },
        index = {
            multiVersion = 1,
            multiVersionBlacklist = { "^/usr/include" }
        }
    },
    capabilities = capabilities
}

lspconfig.cmake.setup {
    on_attach = on_attach_common,
    capabilities = capabilities
}
