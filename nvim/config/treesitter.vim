autocmd VimEnter * silent call TSVimEnter()

function! TSVimEnter() abort
	execute 'TSEnable highlight'
	execute 'TSEnable indent'
endfunction
