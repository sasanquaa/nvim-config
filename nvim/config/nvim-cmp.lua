local icons = {
    Class = "ﴯ",
    Color = " ",
    Constant = " ",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Field = "",
    File = "",
    Folder = " ",
    Function = "",
    Interface = "",
    Keyword = "",
    Method = "",
    Module = "",
    Property = "",
    Snippet = "﬌",
    Struct = "",
    Text = "",
    Unit = "",
    Value = "",
    Variable = "",
}
local luasnip = require('luasnip')
local cmp = require('cmp')

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' })
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    performance = {
        debounce = 100
    },
    experimental = {
        ghost_text = true
    },
    formatting = {
        expandable_indicator = "",
        fields = { "kind", "abbr" },
        format = function(_, vim_item)
            -- local abbr_t = vim.split(vim_item.abbr, ":", true)
            -- local abbr_n = #abbr_t - 1
            -- local abbr = ""
            -- for i = 1, abbr_n do
            --     abbr = abbr_t[i] .. (i ~= abbr_n and ":" or "")
            -- end
            -- vim_item.abbr = vim.trim(abbr)
            vim_item.kind = icons[vim_item.kind]
            -- vim_item.menu = vim.trim(string.gsub(abbr_t[abbr_n + 1], "~$", ''))
            return vim_item
        end
    },
}
