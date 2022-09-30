vim.g['loaded_netrwPlugin'] = 1

local config = {
    view = {
        adaptive_size = true,
        hide_root_folder = true
    },
    renderer = {
        group_empty = true,
        full_name = true,
        highlight_git = true,
        indent_markers = {
            enable = true
        }
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true
    },
    filters = {
        dotfiles = true,
        custom = { "^gradle" }
    }
}

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() <= 0 then
            vim.cmd [[
                execute ':NvimTreeFocus'
                for i in range(1, winnr('$'))
                    if getwinvar(i, '&filetype') == 'NvimTree'
                        call setwinvar(i, '&statusline', '%#Normal#')
                        call setwinvar(i, '&signcolumn', 'yes')
                    endif
                endfor
            ]]
        end
    end
})

require("nvim-tree").setup(config)
