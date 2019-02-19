
if exists('g:_lyne_defaults_loaded')
	finish
endif
let g:_lyne_defaults_loaded = 1

let s:active = {
\	'left': [
\		'h|LyneMode', 'r:lyne#get_mode',
\		'h|LyneBufname', 'r>lyne#utils#get_bufname', 'e|%<', 'r<lyne#utils#get_bufflags',
\		'h|StatusLine', 'e>%{&filetype}'
\	],
\	'right': ['e<[%l/%L] %p%%', 'h|LyneBufname', 'e:%02v']
\}

let s:inactive = {
\	'left': ['e:%f%<%h%w%m%r'],
\	'right': ['e:%p%%']
\}

let s:separators = {'left': '', 'right': ''}

let s:pre_functions = []
let s:post_functions = ['lyne#utils#update_bufname', 'lyne#utils#update_mode', 'lyne#utils#update_separators']

let s:pre_compile_functions = []
let s:post_compile_functions = []

let s:mode_hl = {
\	'n'        : 'Normal',
\	'no'       : 'Normal',
\	'nov'      : 'Normal',
\	'noV'      : 'Normal',
\	"no\<c-v>" : 'Normal',
\	'niI'      : 'Insert',
\	'niR'      : 'Replace',
\	'niV'      : 'Visual',
\	'v'        : 'Visual',
\	'V'        : 'Visual',
\	"\<c-v>"   : 'Visual',
\	's'        : 'Visual',
\	'S'        : 'Visual',
\	"\<c-s>"   : 'Visual',
\	'i'        : 'Insert',
\	'ic'       : 'Insert',
\	'ix'       : 'Insert',
\	'R'        : 'Replace',
\	'Rc'       : 'Replace',
\	'Rv'       : 'Replace',
\	'Rx'       : 'Replace',
\	'c'        : 'Command',
\	'cv'       : 'Term',
\	'ce'       : 'Term',
\	'r'        : 'Prompt',
\	'rm'       : 'Prompt',
\	'r?'       : 'Prompt',
\	'!'        : 'Term',
\	't'        : 'Term'
\}

let s:mode_map = {
\	'n'        : 'N',
\	'no'       : 'N·OP',
\	'nov'      : 'N·OP·v',
\	'noV'      : 'N·OP·V',
\	"no\<c-v>" : 'N·OP·^V',
\	'niI'      : 'I·^O',
\	'niR'      : 'R·^O',
\	'niV'      : 'V',
\	'v'        : 'v',
\	'V'        : 'V',
\	"\<c-v>"   : '^V',
\	's'        : 's',
\	'S'        : 'S',
\	"\<c-s>"   : '^S',
\	'i'        : 'I',
\	'ic'       : 'I·Comp',
\	'ix'       : 'I·^X',
\	'R'        : 'R',
\	'Rc'       : 'R·Comp',
\	'Rv'       : 'R·Virt',
\	'Rx'       : 'R·^X',
\	'c'        : 'C',
\	'cv'       : 'Ex·C',
\	'ce'       : 'Ex',
\	'r'        : 'Enter',
\	'rm'       : 'More',
\	'r?'       : 'Confirm',
\	'!'        : 'Shell',
\	't'        : 'Term'
\}

function lyne#defaults#get(name)
	return copy(get(s:, a:name))
endfunction

function! lyne#defaults#colors()
	highlight LyneDefaultModeNormal  guibg=#6699cc ctermbg=4 guifg=black ctermfg=0
	highlight LyneDefaultModeInsert  guibg=#d3d0c8 ctermbg=7 guifg=black ctermfg=0
	highlight LyneDefaultModeVisual  guibg=#cc99cc ctermbg=5 guifg=black ctermfg=0
	highlight LyneDefaultModeReplace guibg=#f2777a ctermbg=1 guifg=black ctermfg=0
	highlight LyneDefaultModeCommand guibg=#66cccc ctermbg=6 guifg=black ctermfg=0
	highlight LyneDefaultModePrompt  guibg=#d3d0c8 ctermbg=7 guifg=black ctermfg=0
	highlight LyneDefaultModeTerm    guibg=#d3d0c8 ctermbg=7 guifg=black ctermfg=0
	highlight LyneDefaultBufnameUnmodified guibg=#393939 ctermbg=8 guifg=#d3d0c8 ctermfg=2
	highlight LyneDefaultBufnameModified   guibg=#393939 ctermbg=8 guifg=#d3d0c8 ctermfg=2 gui=bold cterm=bold
	if empty(synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui'))
		highlight StatusLine guibg=black
	endif
	if empty(synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'cterm'))
		highlight StatusLine ctermbg=0
	endif
	if empty(synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui'))
		highlight StatusLine guifg=white
	endif
	if empty(synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'cterm'))
		highlight StatusLine ctermfg=7
	endif
	highlight StatusLine gui=NONE cterm=NONE
	highlight! default link LyneModeInsert  LyneDefaultModeInsert
	highlight! default link LyneModeNormal  LyneDefaultModeNormal
	highlight! default link LyneModeVisual  LyneDefaultModeVisual
	highlight! default link LyneModeReplace LyneDefaultModeReplace
	highlight! default link LyneModeCommand LyneDefaultModeCommand
	highlight! default link LyneModePrompt  LyneDefaultModePrompt
	highlight! default link LyneModeTerm    LyneDefaultModeTerm
	highlight! default link LyneBufnameUnmodified LyneDefaultBufnameUnmodified
	highlight! default link LyneBufnameModified LyneDefaultBufnameModified
	silent! call call('lyne#colors#'.get(g:, 'colors_name', ''), [])
endfunction

