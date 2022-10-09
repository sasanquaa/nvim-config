local lsp_util_open_floating_preview = vim.lsp.util.open_floating_preview
local lsp_util_stylize_markdown = vim.lsp.util.stylize_markdown
local lsp_signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_capabilities.workspace.codeLens = { refreshSupport = true }

function vim.lsp.util.open_floating_preview(contents, syntax, opts)
    opts = opts or {}
    -- opts.max_width = 60
    -- opts.max_height = 20
    return lsp_util_open_floating_preview(contents, syntax, opts)
end

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
    virtual_text = false,
    -- virtual_lines = false
})

lspconfig.jdtls.setup {
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
    -- handlers = {
    -- ['textDocument/codeLens'] = function(err, result, ctx, _)
    -- if result then
    --     for _, code_lens in ipairs(result) do
    --         response = vim.lsp.buf_request(0, 'codeLens/resolve', code_lens)
    --         if response then
    --             code_lens = response[1].result
    --             local _, pad = string.find(string.gsub(vim.fn.getline(code_lens.range.start.line + 1), '[\t]',
    --                 string.rep(' ', vim.opt.tabstop._value)), '^%s*')
    --             local opts = {
    --                 virt_lines = { { { string.rep(' ', pad) .. code_lens.command.title, 'Comment' } } },
    --                 virt_lines_above = true
    --             }
    --             vim.api.nvim_buf_set_extmark(0, ns, code_lens.range.start.line, 0, opts)
    --         end
    --     end
    -- end
    -- end,
    -- ['workspace/codeLens/refresh'] = function(err, result, ctx, _)
    -- local ns = vim.api.nvim_create_namespace('lsp_codelens')
    -- local params = {
    --     textDocument = { uri = 'file://' .. vim.fn.expand('%t') },
    -- }
    -- vim.lsp.buf_request(0, 'textDocument/codeLens', params)
    -- end,
    -- ['codeLens/resolve'] = function(err, result, ctx, _)

    -- end
    -- },
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
            contentProvider = { preferred = 'fernflower' },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true }
        }
    },
    capabilities = lsp_capabilities
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
    capabilities = lsp_capabilities
}

lspconfig.vimls.setup {
    on_attach = on_attach_common,
    capabilities = lsp_capabilities
}

lspconfig.ccls.setup {
    on_attach = on_attach_common,
    capabilities = lsp_capabilities,
    init_options = {
        compilationDatabaseDirectory = "Build"
    }
}

lspconfig.cmake.setup {
    init_options = {
        buildDirectory = "Build"
    }
}

for type, icon in pairs(lsp_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Someday to be used when nvim can inlay between characters (inline) or
-- conceal respects line wrap (anti-conceal)
function LspInlayHint()
    local ns = vim.api.nvim_create_namespace('lsp_inlayhints')
    local line_first = vim.fn.line('w0')
    local line_last = vim.fn.line('w$')
    local cursor_last = vim.fn.col({ line_first, '$' })
    local params = {
        textDocument = { uri = 'file://' .. vim.fn.expand('%t') },
        range = {
            start = {
                line = line_first - 1,
                character = 0
            },
            ['end'] = {
                line = line_last - 1,
                character = cursor_last - 1
            }
        }
    }
    local response, _ = vim.lsp.buf_request_sync(0, 'textDocument/inlayHint', params)
    if response then
        local inlay_hints = response[1].result
        for i, inlay_hint in ipairs(inlay_hints) do
            local opts = {
                id = i,
                virt_text = { { inlay_hint.label, 'IncSearch' } },
                virt_text_pos = 'overlay',
            }
            vim.api.nvim_buf_set_extmark(0, ns, inlay_hint.position.line, inlay_hint.position.character, opts)
        end
    end
end
