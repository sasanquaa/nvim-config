function string.starts(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function string.replace_char(str, pos, r)
    return table.concat { str:sub(1, pos - 1), r, str:sub(pos + 1) }
end

-- https://gist.github.com/jaredallard/ddb152179831dd23b230
function string.split(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

local highlight_groups = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
    [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint"
}

local function hide(namespace, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

local function show(namespace, bufnr, diagnostics)
    hide(namespace, bufnr)

    if #diagnostics == 0 then
        return
    end

    table.sort(diagnostics, function(a, b)
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        elseif a.col ~= b.col then
            return a.col > b.col
        else
            return #a.message < #b.message
        end
    end)

    local virt_lines_by_lnum = {} -- map of line number -> list of tuples of [message, severitiy]
    local virt_line_message_format = '─── %s'

    for i, diagnostic in ipairs(diagnostics) do
        local lnum = diagnostic.lnum
        local message = diagnostic.message
        local severity = diagnostic.severity
        local col = diagnostic.col

        local same_col_peek = i + 1 <= #diagnostics and diagnostics[i + 1].lnum == lnum and diagnostics[i + 1].col ==
            col -- peek if the next diagnostic is also in the same line and column

        local virt_lines = virt_lines_by_lnum[lnum] or {}
        local virt_lines_length = #virt_lines                  -- old length before table.insert
        local virt_line_messages = string.split(message, '\n') -- split message by newline
        local virt_line_offset = string.rep(' ', col)

        for j, msg in ipairs(virt_line_messages) do
            local virt_line_continuation = j == #virt_line_messages and (same_col_peek and '├' or '└') or '├'
            local virt_line_message = string.format(virt_line_message_format, msg)
            local virt_line = { table.concat { virt_line_offset, virt_line_continuation, virt_line_message },
                highlight_groups[severity] } -- tuple of [msg, severity]
            table.insert(virt_lines, virt_line)
        end

        -- for adjusting previously added diagnostics
        local same_line = i > 1 and diagnostics[i - 1].lnum == lnum
        local same_col = i > 1 and diagnostics[i - 1].col == col

        if same_line and not same_col and #virt_lines > 0 then
            for j, virt_line_prev in ipairs(virt_lines) do
                if j > virt_lines_length then -- loop up to the first new message added by this iteration
                    break
                end
                virt_lines[j][1] = string.replace_char(virt_line_prev[1], col + 1, '│')
            end
        end

        virt_lines_by_lnum[lnum] = virt_lines
    end

    for lnum, virt_lines in pairs(virt_lines_by_lnum) do
        for i = 1, #virt_lines do
            local virt_line = i > 1 and virt_lines[#virt_lines - i + 2] or virt_lines[i]
            vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum, 0, {
                virt_lines = { { virt_line } }
            })
        end
    end
end

local function show_current_line(diagnostics, ns, bufnr)
    local current_line_diag = {}
    local lnum = vim.fn.line('.') - 1
    for _, diagnostic in pairs(diagnostics) do
        if lnum == diagnostic.lnum then
            table.insert(current_line_diag, diagnostic)
        end
    end
    show(ns, bufnr, current_line_diag)
end

local function toggle()
    local new_value = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_lines = new_value
    })
    return new_value
end

local function setup()
    local group = "LspLines"
    vim.api.nvim_create_augroup(group, {
        clear = true
    })
    vim.keymap.set('n', 'L', toggle)
    vim.diagnostic.handlers.virtual_lines = {
        show = function(namespace, bufnr, diagnostics, _)
            local ns = vim.diagnostic.get_namespace(namespace)
            if not ns.user_data.virt_lines_ns then
                ns.user_data.virt_lines_ns = vim.api.nvim_create_namespace("lsp_lines")
            end
            vim.api.nvim_clear_autocmds({
                group = group
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                buffer = bufnr,
                callback = function()
                    if vim.diagnostic.config().virtual_lines then
                        toggle()
                    end
                end,
                group = group,
                once = true
            })
            show_current_line(diagnostics, ns.user_data.virt_lines_ns, bufnr)
        end,
        hide = function(namespace, bufnr)
            local ns = vim.diagnostic.get_namespace(namespace)
            if ns.user_data.virt_lines_ns then
                hide(ns.user_data.virt_lines_ns, bufnr)
                vim.api.nvim_clear_autocmds({
                    group = group
                })
            end
        end
    }
    vim.diagnostic.config({
        virtual_lines = false
    })
end

setup()
