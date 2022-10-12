local tree = require("nvim-tree")
local tree_cb = require("nvim-tree.config").nvim_tree_callback
local config = {
    view = {
        adaptive_size = true,
        hide_root_folder = true,
        preserve_window_proportions = true,
        mappings = {
            list = {
                { key = "<2-RightMouse>", action = "" },
                { key = "<2-LeftMouse>", action = "" },
                { key = "<C-x>", action = "" },
                { key = "<C-v>", action = "" },
                { key = "s", cb = tree_cb("vsplit") },
                { key = "i", cb = tree_cb("split") },
            }
        }
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
        custom = { "^gradle", "^compile_commands.json" }
    }
}

vim.g['loaded_netrwPlugin'] = 1

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() <= 0 then
            vim.cmd [[
                execute ':NvimTreeFocus'
                for i in range(1, winnr('$'))
                    if getwinvar(i, '&filetype') == 'NvimTree'
                        call setwinvar(i, '&statusline', '%#StatusLine#')
                        call setwinvar(i, '&signcolumn', 'yes')
                    else
                        execute i .. "wincmd c"
                    endif
                endfor
            ]]
        end
    end
})

tree.setup(config)
