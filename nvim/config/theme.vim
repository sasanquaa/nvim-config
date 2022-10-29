colorscheme material

hi! link GitSignsAdd GitAddStripe
hi! link GitSignsChange GitChangeStripe
hi! link GitSignsDelete GitDeleteStripe

hi! link TSKeywordOperator TSKeyword

hi! link CmpItemKindClass TSClass
hi! link CmpItemKindConstant TSConstant
hi! link CmpItemKindConstructor TSConstructor
hi! link CmpItemKindFunction TSFunction
hi! link CmpItemKindOperator TSKeyword
hi! link CmpItemKindMethod TSMethod
hi! link CmpItemKindInterface TSClass
hi! link CmpItemKindKeyword TSKeyword
hi! link CmpItemKindText TSText

hi GitAddStripe guibg=NONE ctermbg=NONE
hi GitChangeStripe guibg=NONE ctermbg=NONE
hi GitDeleteStripe guibg=NONE ctermbg=NONE

" hi CursorLine ctermfg=bg guifg=bg
hi EndOfBuffer guifg=bg

hi LineNr ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi StatusLineNC ctermbg=23 guibg=#2E3C43
hi StatusLine ctermbg=23 guibg=#2E3C43

hi DiagnosticSignInfo guifg=lightblue guibg=NONE ctermfg=4 ctermbg=NONE
hi DiagnosticSignWarn guifg=orange guibg=NONE ctermfg=3 ctermbg=NONE
hi DiagnosticSignHint guibg=lightgrey guibg=NONE ctermfg=7 ctermbg=NONE
hi DiagnosticSignError guifg=red guibg=NONE ctermfg=1 ctermbg=NONE

hi DiagnosticUnderlineInfo gui=NONE cterm=NONE 
hi DiagnosticUnderlineWarn gui=NONE cterm=NONE 
hi DiagnosticUnderlineHint gui=NONE cterm=NONE 
hi DiagnosticUnderlineError gui=NONE cterm=NONE 
" hi NvimTreeWindowPicker ctermfg=7 ctermbg=6

" autocmd OptionSet termguicolors call ThemeUpdateCursorLine()

" function ThemeUpdateCursorLine() abort
"     echom v:option_new
"     if v:option_new == 1
"         hi CursorLine ctermfg=fg guifg=NONE 
"     else
"         hi CursorLine ctermfg=NONE guifg=fg 
"     endif
" endfunction
