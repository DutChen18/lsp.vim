let s:ll = {}

function g:lsp#loclist#set(win, ctx, list)
	if !has_key(s:ll, a:win)
		let s:ll[a:win] = {}
	endif
	let s:ll[a:win][a:ctx] = a:list
	let l:ll = []
	for [l:k, l:v] in items(s:ll[a:win])
		call extend(l:ll, l:v)
	endfor
	call setloclist(a:win, l:ll)
endfunction
