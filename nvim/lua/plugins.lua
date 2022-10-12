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
    vim.cmd("source ~/.config/nvim/config/" .. name)
end

require("packer").startup(function(use)

    use { 'wbthomason/packer.nvim' }

    use { 'doums/darcula' }

    use { 'kyazdani42/nvim-tree.lua', ensure_dependencies = true, requires = "kyazdani42/nvim-web-devicons",
        config = function()
            SourceFile("nvim-tree.lua")
            SourceFile("nvim-tree.vim")
        end }

    use {
        "windwp/nvim-autopairs",
        config = function()
            SourceFile("nvim-autopairs.lua")
        end
    }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }

    use { 'haya14busa/incsearch.vim' }
    use { 'haya14busa/incsearch-easymotion.vim' }
    use { 'haya14busa/incsearch-fuzzy.vim' }
    use { 'easymotion/vim-easymotion',
        requires = { "haya14busa/incsearch.vim", "haya14busa/incsearch-easymotion.vim", "haya14busa/incsearch-fuzzy.vim" },
        config = function() SourceFile("easymotion.vim") end }

    use { 'lewis6991/gitsigns.nvim', config = function() SourceFile("gitsigns.lua") end }
    use { 'itchyny/lightline.vim', requires = "lewis6991/gitsigns.nvim", config = function()
        SourceFile("lightline.lua")
        SourceFile("lightline.vim")
    end }

    use { 'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function()
            SourceFile("nvim-treesitter.lua")
            SourceFile("nvim-treesitter.vim")
        end
    }

    use { 'neovim/nvim-lspconfig', event = "VimEnter", config = function()
        SourceFile("nvim-lspconfig.lua")
        SourceFile("nvim-lspconfig.vim")
        SourceFile("nvim-lspconfig-lines.lua")
    end
    }

    use { 'hrsh7th/nvim-cmp', ensure_dependencies = true,
        requires = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip" },
        config = function()
            SourceFile("nvim-cmp.lua")
        end
    }

    if packer_bootstrap then
        require('packer').sync()
    end

end)

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua" },
    command = "source <afile> | PackerCompile"
})
