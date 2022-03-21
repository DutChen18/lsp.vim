let s:popup = -1

function g:lsp#popup#atcursor(what, options)
	if s:popup != -1
		call popup_close(s:popup)
	endif
	let s:popup = popup_atcursor(a:what, a:options)
endfunction
