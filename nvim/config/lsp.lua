local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local function truncate_text(text, min_width, max_width)
    if string.len(text) > max_width then
        return vim.fn.strcharpart(text, 0, max_width)
    elseif string.len(text) < min_width then
        return text .. string.rep(' ', min_width - string.len(text))
    else
        return text
    end
end

require("nvim-autopairs").setup {}
cmp.setup {
    formatting = {
        format = function(_, vim_item)
            if vim_item.menu ~= nil then
                vim_item.menu = truncate_text(vim_item.menu, 35, 35)
            end
            if vim_item.abbr ~= nil then
                vim_item.abbr = truncate_text(vim_item.abbr, 25, 25)
            end
            return vim_item
        end
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
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
    }, {
        { name = 'buffer' },
    })
}
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { "lua_ls", "vimls", "zls", "pyright", "rust_analyzer", "taplo" },
    automatic_installation = true
}

local lsp_format = require('lsp-format')
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_format.setup {}

lspconfig.taplo.setup {}

lspconfig.zls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities
}

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

-- lspconfig.pbls.setup {
--     on_attach = lsp_format.on_attach,
--     capabilities = capabilities
-- }

lspconfig.vimls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities
}

lspconfig.pyright.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities
}

lspconfig.rust_analyzer.setup {
    on_attach = lsp_format.on_attach,
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false
            },
            check = {
                command = "clippy"
            }
        }
    },
    capabilities = capabilities
}
