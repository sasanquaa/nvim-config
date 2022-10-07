function string.starts(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function LightlineFileName()
    local name = vim.fn.expand('%t')
    if string.starts(name, "jdt://") then
        name = vim.split(name, "%3C", true)
        name = vim.split(name[#name], '(', true)
        name = name[#name]
    end
    name = vim.split(name, "/", true)
    name = name[#name]
    return name
end

function LightlineGitHead()
    local head = vim.b.gitsigns_head or ''
    if head ~= '' then
        head = ' ' .. head
    end
    return head
end

vim.g['lightline'] = {
    colorscheme = 'darcula',
    active = {
        right = {
            { 'githead', 'fileformat', 'fileencoding', 'filetype' },
            { 'lineinfo' }
        },
        left = {
            { 'mode', 'paste' },
            { 'readonly', 'filename', 'modified' }
        }
    },
    inactive = {
        right = {
            { 'githead' },
            { 'lineinfo' }
        }
    },
    component = {
        filename = "%{luaeval('LightlineFileName()')}",
        githead = "%{luaeval('LightlineGitHead()')}"
    }
}
