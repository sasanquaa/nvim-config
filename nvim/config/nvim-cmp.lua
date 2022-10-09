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

-- local formatter_split = function(vim_item, delimiter)
--     local abbr_t = vim.split(vim_item.abbr, delimiter, true)
--     local abbr_n = #abbr_t - 1
--     if abbr_n > 0 then
--         local abbr = ''
--         for i = 1, abbr_n do
--             abbr = abbr_t[i] .. (i ~= abbr_n and ' ' or '')
--         end
--         vim_item.abbr = vim.trim(abbr)
--         vim_item.menu = string.gsub(abbr_t[abbr_n + 1], '~$', '') .. ' '
--     end
-- end
-- local formatters = {
--     Class = function(vim_item)
--         formatter_split(vim_item, '-')
--     end,
--     Method = function(vim_item)
--         formatter_split(vim_item, ':')
--     end
-- }
-- formatters.Field = formatters.Method
-- formatters.Variable = formatters.Method
-- formatters.Enum = formatters.Class
-- formatters.Interface = formatters.Class

luasnip.config.set_config {
    region_check_events = 'InsertEnter',
    delete_check_events = 'TextChanged,InsertLeave'
}

cmp.setup {
    enabled = function()
        local context = require('cmp.config.context')
        if vim.api.nvim_get_mode().mode == 'c' then
            return true
        else
            return not context.in_treesitter_capture('comment')
                and not context.in_syntax_group('Comment')
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
            -- if formatters[vim_item.kind] then
            --     formatters[vim_item.kind](vim_item)
            -- end
            vim_item.abbr = string.gsub(vim_item.abbr, '~$', '')
            vim_item.kind = icons[vim_item.kind]
            return vim_item
        end
    }
}


-- local cmp_view = require('cmp.view.custom_entries_view')
-- local cmp_api = require('cmp.utils.api')
-- local cmp_types = require('cmp.types')
-- local cmp_misc = require('cmp.utils.misc')
-- local cmp_config = require('cmp.config')

-- cmp_view.draw = function(self)
--     local info = vim.fn.getwininfo(self.entries_win.win)[1]
--     local topline = info.topline - 1
--     local botline = info.topline + info.height - 1
--     local texts = {}
--     local fields = cmp_config.get().formatting.fields
--     -- local fields_n = #fields
--     local entries_buf = self.entries_win:get_buffer()
--     for i = topline, botline - 1 do
--         local e = self.entries[i + 1]
--         if e then
--             local view = e:get_view(self.offset, entries_buf)
--             local text = {}
--             table.insert(text, string.rep(' ', cmp_config.get().window.completion.side_padding))
--             for j, field in ipairs(fields) do
--                 if j ~= fields_n then
--                 table.insert(text, view[field].text)
--                 table.insert(text, string.rep(' ', 1 + self.column_width[field] - view[field].width))
--                 else
--                     table.insert(text, string.rep(' ', 1 + self.column_width[field] - view[field].width))
--                     table.insert(text, view[field].text)
--                 end
--             end
--             table.insert(text, string.rep(' ', cmp_config.get().window.completion.side_padding))
--             table.insert(texts, table.concat(text, ''))
--         end
--     end
--     vim.api.nvim_buf_set_lines(entries_buf, topline, botline, false, texts)
--     vim.api.nvim_buf_set_option(entries_buf, 'modified', false)
--     if cmp_api.is_cmdline_mode() then
--         vim.api.nvim_win_call(self.entries_win.win, function()
--             cmp_misc.redraw()
--         end)
--     end
-- end
