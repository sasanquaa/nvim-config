-- local cmp_rust_source = {}

-- function cmp_rust_source:get_trigger_characters()
--     return { '.' }
-- end

-- function cmp_rust_source:complete(params, callback)
--     if params == nil then
--         return
--     end
--     callback({
--         { label = "ok", kind = vim.lsp.protocol.CompletionItemKind.Snippet },
--         -- { label = "some", kind = vim.lsp.protocol.CompletionItemKind.Snippet },
--         -- { label = "err",  kind = vim.lsp.protocol.CompletionItemKind.Snippet },
--     })
-- end

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

require("nvim-autopairs").setup {}
-- cmp.register_source('rust', cmp_rust_source)
cmp.setup {
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-2),
        ['<C-j>'] = cmp.mapping.scroll_docs(2),
        ['<C-p>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }),
        ['<C-n>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ['<TAB>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, { { name = 'rust' } }, {
        { name = 'buffer' },
    })
}
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { "lua_ls", "vimls", "rust_analyzer" },
    automatic_installation = true
}

local lsp_format = require('lsp-format')
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_format.setup {}

lspconfig.zls.setup {}

lspconfig.lua_ls.setup {
    on_attach = lsp_format.on_attach,
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    },
    capabilities = capabilities
}

lspconfig.vimls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities
}

lspconfig.pyright.setup {
    on_attach = lsp_format.on_attach,
}

lspconfig.rust_analyzer.setup {
    on_attach = lsp_format.on_attach,
    diagnostics = {
        enable = false
    },
    capabilities = capabilities
}
