local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

function SourceFile(name)
    vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. 'config' .. '/' .. name)
end

require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }
    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    }
    use { 'RRethy/vim-illuminate' }
    use { "chrisgrieser/nvim-various-textobjs", config = function()
        require("various-textobjs").setup {
            keymaps = {
                useDefaults = false
            }
        }
        vim.keymap.set({ "o", "x" }, "aw", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
        vim.keymap.set({ "o", "x" }, "iw", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
    end }
    use { 'dstein64/nvim-scrollview' }
    use {
        "aznhe21/actions-preview.nvim",
        config = function()
            vim.keymap.set({ "v", "n" }, "<Leader>ca", require("actions-preview").code_actions)
            vim.keymap.set({ "n" }, "<Leader>cb", "<S-g><S-v>gg")
        end,
    }
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup {
            shell = "pwsh.exe",
            auto_scroll = false,
        }
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        vim.keymap.set({ "n" }, "<Leader>tt", "<cmd>ToggleTerm<CR>")
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end }
    use { 'chrisgrieser/nvim-spider', config = function()
        require('spider').setup {
            skipInsignificantPunctuation = false
        }
        vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
        vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
        vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")
        vim.keymap.set("n", "cw", "c<cmd>lua require('spider').motion('e')<CR>")
        vim.keymap.set("i", "<C-w>", "<Esc>cvb", { remap = true })
    end }
    use { 'tpope/vim-vinegar' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'nvim-telescope/telescope.nvim',
        tag = 'master',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    file_ignore_patterns = { "node_modules", "target", "Cargo.lock" }
                }
            }
            SourceFile('telescope.vim')
        end
    }
    use({
        "ramojus/mellifluous.nvim",
        config = function()
            vim.cmd("colorscheme mellifluous")
        end,
    })
    use {
        'haya14busa/incsearch.vim',
        'haya14busa/incsearch-easymotion.vim',
        'haya14busa/incsearch-fuzzy.vim',
        { 'easymotion/vim-easymotion',
            config = function()
                SourceFile('motion.vim')
            end
        }

    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({
                with_sync = true
            })
        end,
        config = function()
            SourceFile('treesitter.lua')
            SourceFile('treesitter.vim')
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    }
    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/nvim-cmp',
        'windwp/nvim-autopairs',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'lukas-reineke/lsp-format.nvim',
        { 'neovim/nvim-lspconfig',
            after = "nvim-treesitter",
            config = function()
                SourceFile('lsp.lua')
                SourceFile('lsp.vim')
                SourceFile('lsp-lines.lua')
            end
        },
    }
    if packer_bootstrap then
        require('packer').sync()
    end
end)
