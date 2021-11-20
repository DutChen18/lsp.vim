function s:diag(client, buf, diag)
	let l:loclist = []
	for l:diag in a:diag
		call add(l:loclist, {
			\ "bufnr": a:buf,
			\ "lnum": l:diag["range"]["start"]["line"] + 1,
			\ "col": l:diag["range"]["start"]["character"] + 1,
			\ "text": l:diag["message"] })
	endfor
	call g:lsp#loclist#set(bufwinnr(a:buf), "diag", l:loclist)
endfunction

let g:lsp#mods#diag_msg#obj = {
	\ "diag": function("s:diag") }
