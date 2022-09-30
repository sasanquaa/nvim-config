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

function source_file(name)
    vim.cmd("source ~/.config/nvim/config/" .. name)
end

require("packer").startup(function(use)


    use { 'wbthomason/packer.nvim' }

    use { 'neoclide/coc.nvim', branch = 'release', event = "VimEnter",
        config = function() source_file("coc.vim") end }

    use { 'kyazdani42/nvim-tree.lua', config = function() source_file("nvim-tree.lua") end }
    use { 'kyazdani42/nvim-web-devicons' }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        config = function()
            source_file("nvim-treesitter.lua")
            source_file("nvim-treesitter.vim")
        end
    }

    use { 'itchyny/lightline.vim', config = function()
        source_file("lightline.lua")
        source_file("lightline.vim")
    end }
    use { 'lewis6991/gitsigns.nvim', config = function() source_file("gitsigns.lua") end }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }

    use { 'akinsho/toggleterm.nvim', tag = '*', config = function() source_file("toggleterm.lua") end }

    use { 'easymotion/vim-easymotion', config = function() source_file("easymotion.vim") end }
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
