colorscheme darcula

hi! link GitSignsAdd GitAddStripe
hi! link GitSignsChange GitChangeStripe
hi! link GitSignsDelete GitDeleteStripe

hi! link TSKeywordOperator TSKeyword

hi! link CmpItemKindClass TSClass
hi! link CmpItemKindConstant TSConstant
hi! link CmpItemKindConstructor TSConstructor
" hi! link CmpItemKindField TSField
hi! link CmpItemKindFunction TSFunction
hi! link CmpItemKindMethod TSMethod
hi! link CmpItemKindInterface TSClass
hi! link CmpItemKindKeyword TSKeyword
hi! link CmpItemKindText TSText
" hi! link CmpItemKindVariable TSVariable

" hi GitAddStripe guibg=#313335 ctermbg=236
" hi GitChangeStripe guibg=#313335 ctermbg=236
" hi GitDeleteStripe guibg=#313335 ctermbg=236
"
hi GitAddStripe guibg=NONE ctermbg=NONE
hi GitChangeStripe guibg=NONE ctermbg=NONE
hi GitDeleteStripe guibg=NONE ctermbg=NONE

hi CursorLine ctermfg=NONE guifg=fg
hi EndOfBuffer guifg=bg ctermfg=bg

hi LineNr ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi StatusLineNC ctermbg=236 guibg=#323232
hi StatusLine ctermbg=236 guibg=#323232

hi DiagnosticSignInfo guifg=lightblue guibg=NONE ctermfg=4 ctermbg=NONE
hi DiagnosticSignWarn guifg=orange guibg=NONE ctermfg=3 ctermbg=NONE
hi DiagnosticSignHint guibg=lightgrey guibg=NONE ctermfg=7 ctermbg=NONE
hi DiagnosticSignError guifg=red guibg=NONE ctermfg=1 ctermbg=NONE

hi DiagnosticUnderlineInfo gui=NONE cterm=NONE 
hi DiagnosticUnderlineWarn gui=NONE cterm=NONE 
hi DiagnosticUnderlineHint gui=NONE cterm=NONE 
hi DiagnosticUnderlineError gui=NONE cterm=NONE 

hi NvimTreeWindowPicker ctermfg=7 ctermbg=6

autocmd OptionSet termguicolors call ThemeUpdateCursorLine()

function ThemeUpdateCursorLine() abort
    echom v:option_new
    if v:option_new == 1
        hi CursorLine ctermfg=fg guifg=NONE 
    else
        hi CursorLine ctermfg=NONE guifg=fg 
    endif
endfunction
