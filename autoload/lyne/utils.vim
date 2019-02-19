
" post-compile-functions

function! lyne#utils#update_separators()
	let l:hls_active = lyne#get_hls_active()
	let l:hls_inactive = lyne#get_hls_inactive()
	for l:side in ['left', 'right']
		for l:hl in (l:hls_active[l:side] + l:hls_inactive[l:side])
			execute 'highlight! link '.l:side.'_'.l:hl[0].'_'.l:hl[1].' LyneSeparator'
		endfor
	endfor
endfunction


" pre-functions

function! lyne#utils#update_bufname()
	if (&modified)
		highlight! link LyneBufname LyneBufnameModified
	else
		highlight! link LyneBufname LyneBufnameUnmodified
	endif
endfunction


" post-functions

function! lyne#utils#update_mode()
	execute 'highlight! link LyneMode LyneMode'.lyne#get_mode_hl()[mode(1)]
endfunction

function! lyne#utils#update_separators()
	let l:hls_active = lyne#get_hls_active()
	let l:hls_inactive = lyne#get_hls_inactive()
	for l:side in ['left', 'right']
		for l:hl in (l:hls_active[l:side] + l:hls_inactive[l:side])
			if (l:side ==# 'left')
				let l:fgId = synIDtrans(hlID(l:hl[0]))
				let l:bgId = synIDtrans(hlID(l:hl[1]))
			else
				let l:fgId = synIDtrans(hlID(l:hl[1]))
				let l:bgId = synIDtrans(hlID(l:hl[0]))
			endif

			if (l:fgId == 0)
				let l:guifg   = ''
				let l:ctermfg = ''
			else
				let l:guifg   = synIDattr(l:fgId, synIDattr(l:fgId, 'reverse', 'gui')   ? 'fg' : 'bg', 'gui')
				let l:ctermfg = synIDattr(l:fgId, synIDattr(l:fgId, 'reverse', 'cterm') ? 'fg' : 'bg', 'cterm')
			endif
			if (l:bgId == 0)
				let l:guibg   = ''
				let l:ctermbg = ''
			else
				let l:guibg   = synIDattr(l:bgId, synIDattr(l:bgId, 'reverse', 'gui')   ? 'fg' : 'bg', 'gui')
				let l:ctermbg = synIDattr(l:bgId, synIDattr(l:bgId, 'reverse', 'cterm') ? 'fg' : 'bg', 'cterm')
			endif

			let l:hls =
			\	  ' guibg='.  (empty(l:guibg)   ? 'fg' : l:guibg)
			\	. ' ctermbg='.(empty(l:ctermbg) ? 'NONE' : l:ctermbg)
			\	. ' guifg='.  (empty(l:guifg)   ? 'bg' : l:guifg)
			\	. ' ctermfg='.(empty(l:ctermfg) ? 'NONE' : l:ctermfg)

			if (!empty(l:hls))
				exec 'highlight '.join([l:side, l:hl[0], l:hl[1]], '_').' '.l:hls
			endif
		endfor
	endfor
endfunction

function! lyne#utils#get_bufname(c, winnr)
	let l:bufnr = winbufnr(a:winnr)
	let l:ft = getwinvar(a:winnr, '&filetype', '')
	let l:bufname = bufname(l:bufnr)
	if l:ft ==# 'help'
		return fnamemodify(l:bufname, ':t')
	endif
	return (empty(l:bufname) ? '[no name]' : fnamemodify(l:bufname, ':p:~:.')) " .l:flags
endfunction

function! lyne#utils#get_bufflags(c, winnr)
	if getwinvar(a:winnr, '&filetype', '') ==# 'help'
		return ''
	endif
	let l:flags  = getwinvar(a:winnr, '&modified', 0) ? '+' : ''
	let l:flags .= getwinvar(a:winnr, '&modifiable', 1) ? '' : '-'
	let l:flags .= getwinvar(a:winnr, '&readonly', 0) ? 'RO' : ''
	return empty(l:flags) ? l:flags : '['.l:flags.']'
endfunction

