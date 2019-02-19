
augroup Lyne
	autocmd!
	autocmd ColorScheme * call lyne#defaults#colors()
	autocmd WinEnter * call lyne#update()
	autocmd BufWinEnter,CmdwinEnter * call lyne#soft_update()
	if exists('#CmdlineLeave')
		autocmd CmdlineLeave * call lyne#soft_update()
	endif
	autocmd VimEnter * call lyne#post()
augroup end

