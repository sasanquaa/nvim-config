let g:incsearch#auto_nohlsearch=1

noremap <silent><expr> <Leader><Leader><Leader> incsearch#go(EasyMotionFuzzy())

function! EasyMotionFuzzy(...) abort
    return extend(copy({
    \   'converters': [incsearch#config#fuzzy#converter()],
    \   'modules': [incsearch#config#easymotion#module()],
    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
    \   'is_expr': 0,
    \   'is_stay': 1
    \ }), get(a:, 1, {}))
endfunction
