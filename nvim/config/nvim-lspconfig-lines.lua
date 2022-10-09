-- Modified version from https://git.sr.ht/~whynothugo/lsp_lines.nvim/tree/main
local highlight_groups = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
    [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
}

function string.replace_char(str, pos, r)
    return table.concat { str:sub(1, pos - 1), r, str:sub(pos + 1) }
end

local function lsp_lines_hide(namespace, bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

local function lsp_lines_show(namespace, bufnr, diagnostics)

    lsp_lines_hide(namespace, bufnr)

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

    local diagnostics_n = #diagnostics
    local virt_lines_by_lnum = {}

    for i, diagnostic in ipairs(diagnostics) do

        local lnum = diagnostic.lnum
        local message = diagnostic.message
        local severity = diagnostic.severity
        local col = diagnostic.col

        virt_lines_by_lnum[lnum] = virt_lines_by_lnum[lnum] or {}

        local same_line = i > 1 and diagnostics[i - 1].lnum == lnum
        local same_col = i > 1 and diagnostics[i - 1].col == col
        local same_col_peek = i + 1 <= diagnostics_n and diagnostics[i + 1].lnum == lnum and
            diagnostics[i + 1].col == col

        local virt_line_offset = string.rep(' ', col)
        local virt_line_continuation = same_col_peek and '├' or '└'
        local virt_line_message = '─── ' .. message
        local virt_line = { virt_line_offset .. virt_line_continuation .. virt_line_message,
            highlight_groups[severity] }

        local virt_lines = virt_lines_by_lnum[lnum]

        if same_line and not same_col and #virt_lines > 0 then
            for j, virt_line_prev in ipairs(virt_lines) do
                virt_lines[j][1] = string.replace_char(virt_line_prev[1], col + 1, '│')
            end
        end

        table.insert(virt_lines, virt_line)

    end


    for lnum, virt_lines in pairs(virt_lines_by_lnum) do
        local virt_lines_n = #virt_lines
        for i = 1, virt_lines_n do
            local virt_line = i > 1 and virt_lines[virt_lines_n - i + 2] or virt_lines[i]
            vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum, 0, { virt_lines = { { virt_line } } })
        end
    end

end

local function lsp_lines_show_current_line(diagnostics, ns, bufnr)
    local current_line_diag = {}
    local lnum = vim.fn.line('.') - 1
    for _, diagnostic in pairs(diagnostics) do
        if lnum == diagnostic.lnum then table.insert(current_line_diag, diagnostic) end
    end
    lsp_lines_show(ns, bufnr, current_line_diag)
end

local function lsp_lines_toggle()
    local new_value = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_value })
    return new_value
end

local function lsp_lines_setup()
    local group = "LspLines"
    vim.api.nvim_create_augroup(group, { clear = true })
    vim.keymap.set('n', 'L', lsp_lines_toggle)
    vim.diagnostic.handlers.virtual_lines = {
        show = function(namespace, bufnr, diagnostics, _)
            local ns = vim.diagnostic.get_namespace(namespace)
            if not ns.user_data.virt_lines_ns then
                ns.user_data.virt_lines_ns = vim.api.nvim_create_namespace("lsp_lines")
            end
            vim.api.nvim_clear_autocmds({ group = group })
            vim.api.nvim_create_autocmd("CursorMoved", {
                buffer = bufnr,
                callback = function()
                    if vim.diagnostic.config().virtual_lines then
                        lsp_lines_toggle()
                    end
                end,
                group = group,
                once = true
            })
            lsp_lines_show_current_line(diagnostics, ns.user_data.virt_lines_ns, bufnr)
        end,
        hide = function(namespace, bufnr)
            local ns = vim.diagnostic.get_namespace(namespace)
            if ns.user_data.virt_lines_ns then
                lsp_lines_hide(ns.user_data.virt_lines_ns, bufnr)
                vim.api.nvim_clear_autocmds({ group = group })
            end
        end
    }
    vim.diagnostic.config({ virtual_lines = false })
end

lsp_lines_setup()
