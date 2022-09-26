call plug#begin()

Plug 'neoclide/coc.nvim', { 'branch': 'release' } "LSP
Plug 'pocco81/auto-save.nvim' "Auto save

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } "Syntax highlight & indent

Plug 'akinsho/toggleterm.nvim', { 'tag': '*' } "Terminal 
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' } "Tabs line (Top)
Plug 'itchyny/lightline.vim' "Status line (Bottom)

Plug 'doums/darcula' "IntelliJ darcula theme

Plug 'tpope/vim-commentary' "Quick comment

Plug 'kyazdani42/nvim-tree.lua' "File explorer
Plug 'kyazdani42/nvim-web-devicons'

Plug 'airblade/vim-gitgutter' "Sign column for Git

Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

call plug#end()

colorscheme darcula

hi clear SignColumn

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

hi! link GitGutterAdd GitAddStripe
hi! link GitGutterChange GitChangeStripe
hi! link GitGutterDelete GitDeleteStripe

let g:lightline = { 'colorscheme': 'darculaOriginal' }
let g:gitgutter_sign_removed = '▶'
let g:gitgutter_signs=0
let g:incsearch#auto_nohlsearch = 1

filetype on
syntax off

set noswapfile
set nobackup
set number
set termguicolors
set cursorline
set nowritebackup
set updatetime=100
set signcolumn=number

set statusline+=%{GitStatus()}
set backspace=indent,eol,start
" set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
" set smarttab
" set smartindent
set completeopt+=noinsert

noremap <silent><expr> <Leader><Leader><Leader> incsearch#go(<SID>config_easyfuzzymotion())

inoremap <silent><expr> <TAB> coc#pum#visible() ? CocCompletionSelectAndConfirm() : 
                            \ coc#expandableOrJumpable() ? "\<C-r>=coc#snippet#next()\<CR>" : "\<Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? CocCompletionSelectAndConfirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-Space> coc#refresh()

nnoremap <silent> K :call CocShowDocumentation()<CR>
nnoremap ntf :NvimTreeFocus<CR>
nnoremap ntt :NvimTreeToggle<CR>
nnoremap ntc :NvimTreeClose<CR>
nnoremap nts :NvimTreeFindFile<CR>
nnoremap ntr :NvimTreeRefresh<CR>

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
autocmd TextChangedI * call CocCompletionEnsureBackspace()

lua << EOF
    require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "cpp", "lua", "java" },
        highlight = {
            enabled = true,
            additional_vim_regex_highlighting = false
        },
        indent = {
            enabled = true
        }
    }
    require("nvim-tree").setup {}
    require("bufferline").setup {}
    require("auto-save").setup {
        enabled = true,
        write_all_buffers = true
    }
    require("toggleterm").setup {}
EOF

function! s:config_easyfuzzymotion(...) abort
    return extend(copy({
    \   'converters': [incsearch#config#fuzzy#converter()],
    \   'modules': [incsearch#config#easymotion#module()],
    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
    \   'is_expr': 0,
    \   'is_stay': 1
    \ }), get(a:, 1, {}))
endfunction

function! OnVimEnter()
    if !argc() 
       execute 'NvimTreeFocusTree' 
    endif

    execute 'TSEnable highlight'
    execute 'TSEnable indent'

    " let extensions = ['coc-json', 'coc-pairs', 'coc-vimlsp', 'coc-java']
    " let installed_extensions = map(CocAction('extensionStats'), "v:val['id']")

    " for extension in extensions
    "     if index(extensions, extension) < 0
    "        execute 'CocInstall ' . extension
    "     endif
    " endfor

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

function! GitStatus()
    return join(filter(map(['A','M','D'], {i,v -> v.': '.GitGutterGetHunkSummary()[i]}), 'v:val[-1:]'), ' ')
endfunction
