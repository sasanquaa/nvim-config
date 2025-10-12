vim.g["incsearch#auto_nohlsearch"] = 1

local function easy_motion_fuzzy(opts)
    opts = opts or {}

    local result = {
        converters = { vim.fn["incsearch#config#fuzzy#converter"]() },
        modules = { vim.fn["incsearch#config#easymotion#module"]() },
        keymap = { ["\r"] = "<Over>(easymotion)" },
        is_expr = 0,
        is_stay = 1,
    }

    for k, v in pairs(opts) do
        result[k] = v
    end

    return result
end

vim.keymap.set('n', 'gw', function()
    return vim.fn['incsearch#go'](easy_motion_fuzzy())
end, { silent = true, expr = true, noremap = true })
