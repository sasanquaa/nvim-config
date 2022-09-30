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
    component = { githead = "%{get(b:, 'gitsigns_head', '')}" }
}
