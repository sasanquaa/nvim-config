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

    use { 'kyazdani42/nvim-tree.lua', config = function() SourceFile("nvim-tree.lua") end }
    use { 'kyazdani42/nvim-web-devicons' }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        config = function()
            SourceFile("nvim-treesitter.lua")
            SourceFile("nvim-treesitter.vim")
        end
    }
    use { 'nvim-treesitter/playground' }

    use { 'neovim/nvim-lspconfig', event = "VimEnter", config = function()
        SourceFile("nvim-lspconfig.lua")
        SourceFile("nvim-lspconfig.vim")
    end
    }

    use { 'hrsh7th/nvim-cmp', config = function()
        SourceFile("nvim-cmp.lua")
    end
    }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'L3MON4D3/LuaSnip' }

    use {
        "windwp/nvim-autopairs",
        config = function()
            SourceFile("nvim-autopairs.lua")
        end
    }

    use { 'itchyny/lightline.vim', config = function()
        SourceFile("lightline.lua")
        SourceFile("lightline.vim")
    end }
    use { 'lewis6991/gitsigns.nvim', config = function() SourceFile("gitsigns.lua") end }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }

    use { 'easymotion/vim-easymotion', config = function() SourceFile("easymotion.vim") end }
    use { 'haya14busa/incsearch.vim' }
    use { 'haya14busa/incsearch-easymotion.vim' }
    use { 'haya14busa/incsearch-fuzzy.vim' }

    use { 'doums/darcula' }

    if packer_bootstrap then
        require('packer').sync()
    end

end)

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua" },
    command = "source <afile> | PackerCompile"
})
