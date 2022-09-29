vim.g['loaded_netrwPlugin'] = 1
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
vim.g['incsearch#auto_nohlsearch'] = 1
vim.g['coc_global_extensions'] = { 'coc-json', 'coc-java', 'coc-vimlsp', 'coc-pairs' }

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)

    use { 'wbthomason/packer.nvim' }

    use { 'neoclide/coc.nvim', branch = 'release' }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = { "json", "c", "cpp", "lua", "java" },
            highlight = {
                enabled = true,
                additional_vim_regex_highlighting = false
            },
            always_show_bufferline = false,
            indent = {
                enabled = true
            }
        }
    end
    }

    use { 'kyazdani42/nvim-tree.lua', config = function()
        require("nvim-tree").setup {
            view = {
                adaptive_size = true,
                hide_root_folder = true
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
                custom = { "^gradle" }
            }
        }
    end
    }

    use { 'kyazdani42/nvim-web-devicons' }

    use { 'itchyny/lightline.vim' }
    use { 'lewis6991/gitsigns.nvim', config = function()
        require("gitsigns").setup()
    end
    }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }

    use { 'akinsho/toggleterm.nvim', tag = '*', config = function()
        require("toggleterm").setup()
    end
    }

    use { 'easymotion/vim-easymotion' }
    use { 'haya14busa/incsearch.vim' }
    use { 'haya14busa/incsearch-easymotion.vim' }
    use { 'haya14busa/incsearch-fuzzy.vim' }

    use { 'doums/darcula' }

    if packer_bootstrap then
        require('packer').sync()
    end

end)

vim.cmd('PackerCompile')

local commands = [[
colorscheme darcula

hi! link CocErrorSign ErrorSign
hi! link CocWarningSign WarningSign
hi! link CocInfoSign InfoSign
hi! link CocHintSign HintSign
hi! link CocErrorFloat Pmenu
hi! link CocWarningFloat Pmenu
hi! link CocInfoFloat Pmenu
hi! link CocHintFloat Pmenu
hi! link CocHighlightText IdentifierUnderCaret
hi! link CocHighlightRead IdentifierUnderCaret
hi! link CocHighlightWrite IdentifierUnderCaretWrite
hi! link CocErrorHighlight CodeError
hi! link CocWarningHighlight CodeWarning
hi! link CocInfoHighlight CodeInfo
hi! link CocHintHighlight CodeHint

hi! link GitSignsAdd GitAddStripe
hi! link GitSignsChange GitChangeStripe
hi! link GitSignsDelete GitDeleteStripe

hi GitAddStripe guibg=#313335 ctermbg=236
hi GitChangeStripe guibg=#313335 ctermbg=236
hi GitDeleteStripe guibg=#313335 ctermbg=236

hi CursorLine ctermfg=bg guifg=none
hi EndOfBuffer guifg=bg ctermfg=bg

noremap <silent><expr> <Leader><Leader><Leader> incsearch#go(ConfigEasyFuzzyMotion())

inoremap <silent><expr> <TAB> coc#pum#visible() ? CocCompletionSelectAndConfirm() : 
                            \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#next()\<CR>" : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? CocCompletionSelectAndConfirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-Space> coc#refresh()

nnoremap <silent> K :call CocShowDocumentation()<CR>
nnoremap <silent> ntf :NvimTreeFocus<CR>
nnoremap <silent> ntt :NvimTreeToggle<CR>
nnoremap <silent> ntc :NvimTreeClose<CR>
nnoremap <silent> nts :NvimTreeFindFile<CR>
nnoremap <silent> ntr :NvimTreeRefresh<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <Leader>rn <Plug>(coc-rename)
nmap <Leader>fs <Plug>(coc-format-selected)
nmap <silent> <Leader>fa :call CocActionAsync('format')<CR>
nmap <silent> <Leader>or :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>
nmap <Leader>af <Plug>(coc-fix-current)

xmap <Leader>fs <Plug>(coc-format-selected)

autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd VimEnter * silent call OnVimEnter()
autocmd TextChangedI * silent call CocCompletionEnsureBackspace()

function! ConfigEasyFuzzyMotion(...) abort
    return extend(copy({
    \   'converters': [incsearch#config#fuzzy#converter()],
    \   'modules': [incsearch#config#easymotion#module()],
    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
    \   'is_expr': 0,
    \   'is_stay': 1
    \ }), get(a:, 1, {}))
endfunction

function! StatusLine()
    for i in range(1, winnr('$'))
        if getwinvar(i, '&filetype') == 'NvimTree'
            call setwinvar(i, '&statusline', '%#Normal#')
            call setwinvar(i, '&signcolumn', 'yes')
        endif
    endfor
endfunction

function! OnVimEnter()
    if !argc() 
       execute 'NvimTreeFocus' 
    endif

    execute 'TSEnable highlight'
    execute 'TSEnable indent'

    autocmd WinEnter,BufEnter * call StatusLine()
    autocmd FileType help,asm,ld setlocal syntax=ON

endfunction

function! CocShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

let s:coc_completion_prev_index = -1
let s:coc_completion_prev_col = -1
let s:coc_completion_backspace_disabled = v:false

function! CocCompletionSelectAndConfirm()

    call CocCompletionBackspaceDisable()

    call coc#_select_confirm()
    call timer_start(11, { -> CocCompletionBackspaceEnable() } )

    return ""
endfunction

function! CocCompletionBackspaceEnable()
    let s:coc_completion_backspace_disabled = v:false
    noa set completeopt+=noinsert
endfunction

function! CocCompletionBackspaceDisable()
    let s:coc_completion_backspace_disabled = v:true
    noa set completeopt-=noinsert
endfunction

function! CocCompletionEnsureBackspace()
    if s:coc_completion_backspace_disabled == v:true
        return
    endif
    let col = col(".") - 1
    if col && !(getline(".")[col - 1] =~# '\s') && coc#pum#visible()
        let info = coc#pum#info()
        if col < s:coc_completion_prev_col
            if info["inserted"] == v:false
                call coc#start()
            else
                if info["index"] != s:coc_completion_prev_index
                    call coc#start()
                endif
            endif
        endif
        let s:coc_completion_prev_index = info["index"]
    endif
    let s:coc_completion_prev_col = col
endfunction

]]

vim.cmd(commands)
vim.cmd('filetype on')
vim.cmd('syntax off')
vim.cmd('set noswapfile')
vim.cmd('set nobackup')
vim.cmd('set nowritebackup')
vim.cmd('set showtabline=0')
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.updatetime = 100
vim.opt.signcolumn = 'yes:1'
vim.opt.backspace = 'indent,eol,start'
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.completeopt:append('noinsert')
