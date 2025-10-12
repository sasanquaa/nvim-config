local function ts_on_enter()
    vim.cmd('TSEnable highlight')
    vim.cmd('TSEnable indent')
end

vim.api.nvim_create_autocmd('VimEnter', {
    callback = ts_on_enter,
    desc = 'Enable Treesitter highlight and indent on startup',
})


local config = {
    ensure_installed = {
        "bash",
        "markdown",
        "markdown_inline",
        "json",
        "lua",
        "vim",
        "rust",
        "zig",
        "python",
        "toml",
        "arduino"
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
