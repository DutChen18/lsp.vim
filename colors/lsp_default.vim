hi clear
if exists("syntax_on")
	syn reset
endif
set bg=dark
let g:colors_name="lsp_default"

function s:hsv2rgb(hsv)
	let a:hsv[0] = fmod(fmod(a:hsv[0], 1) + 1, 1)
	if a:hsv[1] > 1 | let a:hsv[1] = 1 | endif
	if a:hsv[2] > 1 | let a:hsv[2] = 1 | endif
	let l:c = a:hsv[2] * a:hsv[1]
	let l:h = a:hsv[0] * 6.0
	let l:m = a:hsv[2] - l:c
	let l:x = l:c * (1 - abs(fmod(l:h, 2) - 1))
	if 0 <= l:h && l:h < 1 | let l:rgb = [l:c, l:x, 0.0] | endif
	if 1 <= l:h && l:h < 2 | let l:rgb = [l:x, l:c, 0.0] | endif
	if 2 <= l:h && l:h < 3 | let l:rgb = [0.0, l:c, l:x] | endif
	if 3 <= l:h && l:h < 4 | let l:rgb = [0.0, l:x, l:c] | endif
	if 4 <= l:h && l:h < 5 | let l:rgb = [l:x, 0.0, l:c] | endif
	if 5 <= l:h && l:h < 6 | let l:rgb = [l:c, 0.0, l:x] | endif
	return [l:rgb[0] + l:m, l:rgb[1] + l:m, l:rgb[2] + l:m]
endfunction

function s:rgb2hex(rgb)
	let l:r = printf("%02x", float2nr(a:rgb[0] * 255))
	let l:g = printf("%02x", float2nr(a:rgb[1] * 255))
	let l:b = printf("%02x", float2nr(a:rgb[2] * 255))
	return "#" . l:r . l:g . l:b
endfunction

function s:hi(fg, bg, g)
	if !empty(a:fg)
		let l:fg = s:rgb2hex(s:hsv2rgb(a:fg))
		exec printf("hi %s guifg=%s", a:g, l:fg)
	endif
	if !empty(a:bg)
		let l:bg = s:rgb2hex(s:hsv2rgb(a:bg))
		exec printf("hi %s guibg=%s", a:g, l:bg)
	endif
	exec printf("hi %s cterm=NONE gui=NONE", a:g)
endfunction

let s:s = exists("g:lsp_saturation") ? g:lsp_saturation : 0.5
let s:v = exists("g:lsp_value") ? g:lsp_value : 0.5

function s:col(h1, h2)
	return [a:h1 / 6.0 + a:h2 / 24.0, s:s, s:v]
endfunction

function s:val(v)
	return [0, 0, s:v * a:v / 8.0]
endfunction

call s:hi(s:val(8), s:val(1), "Normal")
call s:hi(s:val(8), s:val(1), "Error")
call s:hi(s:val(8), s:val(1), "Special")
call s:hi(s:val(4), s:val(2), "LineNr")
call s:hi(s:val(4), s:val(1), "Comment")
call s:hi(s:val(4), s:val(1), "Lsp_comment")
call s:hi(s:val(4), s:val(1), "Todo")

call s:hi(s:val(2), [], "NonText")
call s:hi(s:val(2), [], "SpecialKey")
call s:hi([], s:val(2), "ColorColumn")
call s:hi([], s:val(2), "Visual")

call s:hi(s:col(0, 0), [], "Number")
call s:hi(s:col(0, 1), [], "Constant")
call s:hi(s:col(0, 2), [], "SpecialChar")

call s:hi(s:col(1, 0), [], "Function")
call s:hi(s:col(1, 0), [], "Lsp_function")
call s:hi(s:col(1, 1), [], "Delimiter")

call s:hi(s:col(2, 0), [], "Lsp_type")
call s:hi(s:col(2, 1), [], "Lsp_class")
call s:hi(s:col(2, 2), [], "Lsp_enum")

call s:hi(s:col(3, 0), [], "Identifier")
call s:hi(s:col(3, 0), [], "Lsp_variable")
call s:hi(s:col(3, 1), [], "Lsp_parameter")
call s:hi(s:col(3, 2), [], "Lsp_property")
call s:hi(s:col(3, 3), [], "Lsp_enumMember")

call s:hi(s:col(4, 0), [], "Type")
call s:hi(s:col(4, 1), [], "StorageClass")
call s:hi(s:col(4, 2), [], "Structure")

call s:hi(s:col(5, 0), [], "Statement")
call s:hi(s:col(5, 1), [], "Operator")
call s:hi(s:col(5, 2), [], "PreProc")
call s:hi(s:col(5, 3), [], "Lsp_macro")

call s:hi(s:col(0, 0), s:val(2), "Lsp_err")
call s:hi(s:col(5, 0), s:val(2), "Lsp_wrn")
call s:hi(s:col(3, 0), s:val(2), "Lsp_inf")
call s:hi(s:col(2, 0), s:val(2), "Lsp_hnt")
