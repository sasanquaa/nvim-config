local config = {
    ensure_installed = { "json", "c", "cpp", "lua", "java", "vim", "kotlin" },
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

local ts_query = require("vim.treesitter.query")
local java_query = [[
(
    (field_declaration
        (variable_declarator
            name: (identifier) @field))
    (#set! "priority" 101)
)
]]
local java_query_files = ts_query.get_query_files("java", "highlights", nil)
for _, file in pairs(java_query_files) do
    local f = assert(io.open(file, "rb"))
    java_query = java_query .. f:read("*all")
    f:close()
end
ts_query.set_query("java", "highlights", java_query)
