local config = {
    ensure_installed = {
        "bash",
        "markdown",
        "markdown_inline",
        "json",
        "lua",
        "vim",
        "rust",
        "python",
        "toml"
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

require("nvim-treesitter.configs").setup(config)
