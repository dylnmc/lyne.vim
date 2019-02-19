
" autoload/lyne.vim

if exists('g:_lyne_loaded')
	finish
endif
let g:_lyne_loaded = 1

let s:notSetup = 1

let s:hls_active = {'left': [], 'right': []}
let s:hls_inactive = {'left': [], 'right': []}

let s:lyne_statusline_active = ''
let s:lyne_statusline_inactive = ''

function! lyne#statusline(c)
	let l:hls = a:c ? s:hls_active : s:hls_inactive

	for l:fun in s:pre_compile_functions
		silent! call call(l:fun, [a:c, -1])
	endfor

	let l:stl = ''

	if len(s:pre_functions)
		let l:stl .= '%{lyne#pre()}'
	endif

	let l:defaultHl = 'StatusLine'.(a:c ? '' : 'NC')
	let l:pad = ['', ' ']

	let l:prevHl = ''
	for l:side in ['left', 'right']
		let l:hls[l:side] = []
		let l:segs = (a:c ? s:active : s:inactive)[l:side]
		let l:segNum = 0
		let l:segMax = len(l:segs)
		for l:seg in l:segs
			if len(l:seg) < 2
				continue
			endif
			let l:type = l:seg[0]
			let l:flag = l:seg[1]
			let l:data = l:seg[2:]
			if (l:type ==# 'h')
				let l:data = split(l:data, ':', 1)
				let l:sep = len(l:data) ==# 1 ? get(s:separators, l:side) : join(l:data[1:], ':')
				let l:data = empty(l:data[0]) ? l:defaultHl : l:data[0]
				let l:stl .= l:pad[l:flag =~# '[>:]'].'%#'.join([l:side, l:prevHl, l:data], '_').'#'.l:sep.'%#'.l:data.'#'.l:pad[l:flag =~# '[<:]']
				call add(l:hls[l:side], [l:prevHl, l:data])
				let l:prevHl = l:data
			elseif (l:type ==# 'e')
				let l:stl .= l:pad[l:flag =~# '[>:]'].l:data.l:pad[l:flag =~# '[<:]']
			elseif (l:type ==# 'r')
				let l:stl .= '%{lyne#func_wrap('.join([string(l:data), a:c, string(l:flag)], ',').')}'
			elseif (l:type ==# 'f')
				let l:stl .= lyne#func_wrap(l:data, a:c, l:flag)
			endif
			let l:segNum += 1
		endfor
		if (l:side ==# 'left')
			let l:stl .= '%='
		endif
	endfor

	if len(s:post_functions)
		let l:stl .= '%{lyne#post()}'
	endif

	for l:fun in s:post_compile_functions
		silent! call call(l:fun, [a:c, -1])
	endfor

	return l:stl
endfunction

function! lyne#update()
	let l:wc = winnr()
	for l:wn in range(1, winnr('$'))
		call setwinvar(l:wn, '&statusline', l:wn ==# l:wc ? s:lyne_statusline_active : s:lyne_statusline_inactive)
	endfor
endfunction

function! lyne#soft_update()
	if (s:notSetup)
		call lyne#setup()
	endif
	call setwinvar(winnr(), '&statusline', s:lyne_statusline_active)
endfunction

function! lyne#setup()
	let s:notSetup = 0
	call lyne#defaults#colors()
	for l:name in ['active', 'inactive']
		let s:[l:name] = lyne#defaults#get(l:name)
		let l:settings = type(get(g:, 'lyne_'.l:name)) ==# 4 ? get(g:, 'lyne_'.l:name) : {}
		let l:left = filter(type(get(l:settings, 'left')) ==# 3 ? get(l:settings, 'left') : [], { i,v -> type(v) ==# 1 })
		let l:right = filter(type(get(l:settings, 'right')) ==# 3 ? get(l:settings, 'right') : [], { i,v -> type(v) ==# 1 })
		if ! empty(l:left)
			call extend(s:[l:name], {'left':l:left}, 'force')
		endif
		if ! empty(l:right)
			call extend(s:[l:name], {'right':l:right}, 'force')
		endif
	endfor
	for l:name in ['separators', 'pre_functions', 'post_functions', 'pre_compile_functions', 'post_compile_functions', 'mode_hl', 'mode_map']
		let s:[l:name] = lyne#defaults#get(l:name)
		let l:settings = get(g:, 'lyne_'.l:name)
		if type(l:settings) !=# type(s:[l:name])
			continue
		endif
		if type(l:settings) ==# 4
			call extend(s:[l:name], l:settings, 'force')
		else
			let s:[l:name] = l:settings
		endif
	endfor
	let s:lyne_statusline_active = lyne#statusline(1)
	let s:lyne_statusline_inactive = lyne#statusline(0)
endfunction

function! lyne#pre()
	for l:func in s:pre_functions
		silent! call call(l:func, [-1, winnr()])
	endfor
	return ''
endfunction

function! lyne#post()
	for l:func in lyne#get_post_functions()
		silent! call call(l:func, [-1, winnr()])
	endfor
	return ''
endfunction

function! lyne#func_wrap(func, c, flag)
	silent! let l:result = call(a:func, [a:c, winnr()])
	return (a:flag =~# '[>:]' ? ' ' : '').l:result.(a:flag =~# '[<:]' ? ' ' : '')
endfunction

function! lyne#get_active(...)
	return copy(s:active)
endfunction
function! lyne#get_inactive(...)
	return copy(s:inactive)
endfunction
function! lyne#get_separators(...)
	return copy(s:separators)
endfunction
function! lyne#get_mode_hl(...)
	return copy(s:mode_hl)
endfunction
function! lyne#get_mode(...)
	return copy(s:mode_map[mode(1)])
endfunction
function! lyne#get_pre_functions(...)
	return copy(s:pre_functions)
endfunction
function! lyne#get_post_functions(...)
	return copy(s:post_functions)
endfunction
function! lyne#get_pre_compile_functions(...)
	return copy(s:pre_compile_functions)
endfunction
function! lyne#get_post_compile_functions(...)
	return copy(s:post_compile_functions)
endfunction
function! lyne#get_hls_active(...)
	return copy(s:hls_active)
endfunction
function! lyne#get_hls_inactive(...)
	return copy(s:hls_inactive)
endfunction

