local config = {
    ensure_installed = { "bash", "markdown", "markdown_inline", "json", "c", "cpp", "cmake", "lua", "vim", "java", "kotlin" },
    highlight = {
        enabled = true,
        additional_vim_regex_highlighting = false
    },
    always_show_bufferline = false,
    indent = {
        enabled = true,
        disable = { 'java' }
    }
}

require("nvim-treesitter.configs").setup(config)
