local icons = {
    Class = 'ﴯ',
    Color = ' ',
    Constant = ' ',
    Constructor = '',
    Enum = '',
    EnumMember = '',
    Field = '',
    File = '',
    Folder = ' ',
    Function = '',
    Interface = '',
    Keyword = '',
    Method = '',
    Module = '',
    Property = '',
    Snippet = '﬌',
    Struct = '',
    Text = '',
    Unit = '',
    Value = '',
    Variable = '',
}
local luasnip = require('luasnip')
local cmp = require('cmp')

luasnip.config.set_config {
    region_check_events = 'TextChanged,InsertEnter',
    delete_check_events = 'TextChanged,InsertLeave'
}

cmp.setup {
    enabled = function()
        local context = require('cmp.config.context')
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
        end
    end,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-2),
        ['<C-j>'] = cmp.mapping.scroll_docs(2),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
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
        { name = 'path' }
    },
    performance = {
        debounce = 100
    },
    experimental = {
        ghost_text = true
    },
    formatting = {
        expandable_indicator = '',
        fields = { 'kind', 'abbr' },
        format = function(_, vim_item)
            vim_item.abbr = string.gsub(vim_item.abbr, '~$', '')
            vim_item.kind = icons[vim_item.kind]
            return vim_item
        end
    }
}
