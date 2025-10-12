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

local function source_file(name)
    vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. 'config' .. '/' .. name)
end

require("lazy").setup({
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    { "RRethy/vim-illuminate" },

    {
        "chrisgrieser/nvim-various-textobjs",
        config = function()
            require("various-textobjs").setup({ keymaps = { useDefaults = false } })
            vim.keymap.set({ "o", "x" }, "aw", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
            vim.keymap.set({ "o", "x" }, "iw", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
        end,
    },

    { "dstein64/nvim-scrollview" },

    {
        "aznhe21/actions-preview.nvim",
        config = function()
            vim.keymap.set({ "v", "n" }, "<Leader>a", require("actions-preview").code_actions)
            vim.keymap.set("n", "%", "<S-g><S-v>gg")
        end,
    },

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

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = { file_ignore_patterns = { "node_modules", "target", "Cargo.lock" } },
            })
            source_file("telescope.lua")
        end,
    },

    {
        "ramojus/mellifluous.nvim",
        config = function()
            vim.cmd("colorscheme mellifluous")
        end,
    },

    {
        "haya14busa/incsearch.vim",
        dependencies = {
            "haya14busa/incsearch-easymotion.vim",
            "haya14busa/incsearch-fuzzy.vim",
            {
                "easymotion/vim-easymotion",
                config = function()
                    source_file("motion.lua")
                end,
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            source_file("treesitter.lua")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "windwp/nvim-autopairs",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "lukas-reineke/lsp-format.nvim",
        },
        config = function()
            source_file("lsp.lua")
            source_file("lsp-lines.lua")
        end,
    },
})
