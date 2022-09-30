local config = {
    ensure_installed = { "json", "c", "cpp", "lua", "java", "vim" },
    highlight = {
        enabled = true,
        additional_vim_regex_highlighting = false
    },
    always_show_bufferline = false,
    indent = {
        enabled = true
    }
}

require("nvim-treesitter.configs").setup(config)
