local config = {
    ensure_installed = {"bash", "markdown", "markdown_inline", "json", "c", "cpp", "cmake", "lua", "vim",
                        "rust", "python", "typescript", "svelte", "glsl"},
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
