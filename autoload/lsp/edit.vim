function g:lsp#edit#edit(buf, edit)
	let l:start_range = a:edit["range"]["start"]
	let l:start = getbufline(a:buf, l:start_range["line"] + 1)[0]
	let l:start = slice(l:start, 0, l:start_range["character"])
	let l:end_range = a:edit["range"]["end"]
	let l:end = getbufline(a:buf, l:end_range["line"] + 1)[0]
	let l:end = slice(l:end, l:end_range["character"])
	for l:i in range(l:start_range["line"], l:end_range["line"])
		call deletebufline(a:buf, l:start_range["line"] + 1)
	endfor
	let l:text = l:start . a:edit["newText"] . l:end
	let l:text = split(l:text, "\n")
	call appendbufline(a:buf, l:start_range["line"], l:text)
	let l:line = l:start_range["line"] + len(l:text)
	let l:col = len(l:text[len(l:text) - 1]) - len(l:end) + 1
	call setcursorcharpos(l:line, l:col)
endfunction

function g:lsp#edit#goto(goto)
	execute "confirm e " . a:goto["uri"]
	let l:line = a:goto["range"]["start"]["line"] + 1
	let l:col = a:goto["range"]["start"]["character"] + 1
	call setcursorcharpos(l:line, l:col)
endfunction
