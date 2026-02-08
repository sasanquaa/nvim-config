vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.equalalways = false
vim.opt.showtabline = 0
vim.opt.colorcolumn = "100"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.updatetime = 100
vim.opt.signcolumn = "yes:1"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.pumheight = 12
vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>e", ":Explore<CR>", { noremap = true, silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Markdown file preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Highlights word(s) under cursor
    { "RRethy/vim-illuminate" },

    -- Subword text object
    {
        "chrisgrieser/nvim-various-textobjs",
        config = function()
            require("various-textobjs").setup({ keymaps = { useDefaults = false } })

            vim.keymap.set({ "o", "x" }, "aw", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
            vim.keymap.set({ "o", "x" }, "iw", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
        end,
    },

    -- Vertical scrollbar on the right side
    { "dstein64/nvim-scrollview" },

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({ shell = "pwsh.exe", auto_scroll = false })

            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
                vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
            end

            vim.keymap.set("n", "<Leader>tt", "<cmd>ToggleTerm<CR>")
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end,
    },

    -- Subword motions
    {
        "chrisgrieser/nvim-spider",
        config = function()
            require('spider').setup({ skipInsignificantPunctuation = false })

            vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
            vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
            vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")
            vim.keymap.set("n", "cw", "c<cmd>lua require('spider').motion('e')<CR>")
            vim.keymap.set("i", "<C-w>", "<Esc>cvb", { remap = true })
        end,
    },

    { "tpope/vim-vinegar" },
    { "tpope/vim-commentary" },
    { "tpope/vim-surround" },

    -- Text motions
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        enabled = true,
        config = function()
            local leap = require('leap')
            leap.opts.preview_filter =
                function(ch0, ch1, ch2)
                    return not (
                        ch1:match('%s') or
                        ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
                    )
                end
            leap.opts.equivalence_classes = {
                ' \t\r\n', '([{', ')]}', '\'"`'
            }

            vim.keymap.set({ 'n', 'x', 'o' }, 'gw', '<Plug>(leap)')
            vim.keymap.set('n', 'gW', '<Plug>(leap-from-window)')
        end,
    },

    -- Fuzzy search
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = { file_ignore_patterns = { "%.uid", "%.tscn", "%.tres", "%.res", "project.godot", "node_modules", "target", "Cargo.lock", "addons" } },
            })

            local ts = require('telescope.builtin')
            local opts = { silent = true }

            vim.keymap.set('n', 'gd', ts.lsp_definitions, opts)
            vim.keymap.set('n', 'gt', ts.lsp_type_definitions, opts)
            vim.keymap.set('n', 'gi', ts.lsp_implementations, opts)
            vim.keymap.set('n', 'gr', ts.lsp_references, opts)
            vim.keymap.set('n', '<Leader>f', ts.find_files, opts)
            vim.keymap.set('n', '<Leader>/', ts.live_grep, opts)
            vim.keymap.set('n', '<Leader>b', ts.buffers, opts)
            vim.keymap.set('n', '<Leader>z', ts.current_buffer_fuzzy_find, opts)
            vim.keymap.set('n', '<Leader>?', ts.keymaps, opts)
            vim.keymap.set('n', '<Leader>s', ts.lsp_document_symbols, opts)
            vim.keymap.set('n', '<Leader>S', ts.lsp_workspace_symbols, opts)
            vim.keymap.set('n', '<Leader>d', function() ts.diagnostics({ bufnr = 0 }) end, opts)
            vim.keymap.set('n', '<Leader>D', ts.diagnostics, opts)
        end,
    },

    -- Theme
    {
        "ramojus/mellifluous.nvim",
        config = function()
            vim.cmd("colorscheme mellifluous")
        end,
    },

    -- Syntax and highlight
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "markdown",
                    "markdown_inline",
                    "json",
                    "lua",
                    "vim",
                    "rust",
                    "python",
                    "toml",
                },
                highlight = {
                    enabled = true,
                    additional_vim_regex_highlighting = false
                },
                always_show_bufferline = false,
                indent = {
                    enabled = true
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                }
            }

            local function ts_on_enter()
                vim.cmd('TSEnable highlight')
                vim.cmd('TSEnable indent')
            end

            vim.api.nvim_create_autocmd('VimEnter', {
                callback = ts_on_enter,
                desc = 'Enable Treesitter highlight and indent on startup',
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Identation indicators
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    -- Auto pairs
    { 'nvim-mini/mini.pairs', version = '*', opts = {} },

    -- Auto completion
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            keymap = {
                preset = 'none',
                ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback' },
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<C-space>'] = { 'show', 'fallback' },
                ['<CR>'] = { 'select_and_accept', 'fallback' },
                ['<TAB>'] = { 'select_and_accept', 'fallback' }
            },
            appearance = {
                nerd_font_variant = 'mono',
                kind_icons = {
                    Text = '',
                    Method = '',
                    Function = '',
                    Constructor = '',

                    Field = '',
                    Variable = '',
                    Property = '',

                    Class = '',
                    Interface = '',
                    Struct = '',
                    Module = '',

                    Unit = '',
                    Value = '',
                    Enum = '',
                    EnumMember = '',

                    Keyword = '',
                    Constant = '',

                    Snippet = '',
                    Color = '',
                    File = '',
                    Reference = '',
                    Folder = '',
                    Event = '',
                    Operator = '',
                    TypeParameter = '',
                },
            },
            completion = {
                menu = { border = 'single' },
                documentation = {
                    window = { border = 'single' },
                    auto_show = false
                },
                accept = { auto_brackets = { enabled = true } },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },

    -- LSP code actions preview popup
    {
        "aznhe21/actions-preview.nvim",
        config = function()
            vim.keymap.set({ "v", "n" }, "<Leader>a", require("actions-preview").code_actions)
            vim.keymap.set("n", "<Leader>%", "<S-g><S-v>gg")
        end,
    },

    -- LSP inline diagnostics
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup { preset = "minimal" }

            vim.diagnostic.config({ virtual_text = false })
        end
    },

    -- LSP servers installer
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "vimls", "pylsp", "rust_analyzer", "taplo" },
            automatic_installation = true
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "lukas-reineke/lsp-format.nvim", opts = {} },
        },
        config = function()
            vim.keymap.set('n', '\\fa', function() vim.lsp.buf.format() end, { silent = true })
            vim.keymap.set('n', '\\fd', ':silent! !dx fmt<CR>', { silent = true, noremap = true })
            vim.keymap.set('n', '\\fg', ':silent! !gdscript-formatter --safe %<CR>', { silent = true, noremap = true })
            vim.keymap.set('x', '\\fa', function() vim.lsp.buf.format() end, { silent = true })
            vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { silent = true })
            vim.keymap.set('n', 'D', function() vim.diagnostic.open_float() end, { silent = true })
            vim.keymap.set("n", "<Leader>r", function()
                local cmd_id
                cmd_id = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
                    callback = function()
                        local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
                        vim.api.nvim_feedkeys(key, "c", false)
                        vim.api.nvim_feedkeys("0", "n", false)
                        cmd_id = nil
                        return true
                    end,
                })
                vim.lsp.buf.rename()
                vim.defer_fn(function()
                    if cmd_id then
                        vim.api.nvim_del_autocmd(cmd_id)
                    end
                end, 500)
            end)
            vim.api.nvim_create_autocmd({ "CmdwinEnter" }, {
                callback = function()
                    vim.keymap.set("n", "<esc>", ":quit<CR>", { buffer = true })
                end,
            })
            vim.highlight.priorities.semantic_tokens = 95

            local lsp_format = require('lsp-format')

            vim.lsp.enable({ 'taplo', 'lua_ls', 'vimls', 'pylsp', 'rust_analyzer', 'gdscript' })
            vim.lsp.config('lua_ls', {
                on_attach = lsp_format.on_attach,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                            return
                        end
                    end
                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    })
                end,
                settings = {
                    Lua = {}
                },
            })
            vim.lsp.config('vimls', {
                on_attach = lsp_format.on_attach,
            })
            vim.lsp.config('pylsp', {
                on_attach = lsp_format.on_attach,
                settings = {
                    pylsp = {
                        plugins = {
                            black = {
                                enabled = true,
                                line_length = 100
                            }
                        }
                    }
                }
            })
            vim.lsp.config('rust_analyzer', {
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
            })
            vim.lsp.config('tailwindcss', {
                on_attach = lsp_format.on_attach,
            })

            vim.lsp.config('gdscript', {
                on_init = function()
                    vim.fn.serverstart("127.0.0.1:6004")
                end
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.gd",
                callback = function()
                    vim.cmd("normal! <leader>fg")
                end,
            })
        end,
    },
})
