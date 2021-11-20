function s:notify(client, message)
	if a:message["method"] ==# "textDocument/publishDiagnostics"
		let l:buf = g:lsp#buf#by_uri(a:message["params"]["uri"])
		if !has_key(a:client["buffers"], l:buf) | return | endif
		let l:diag = a:message["params"]["diagnostics"]
		let a:client["buffers"][l:buf]["diagnostics"] = l:diag
		call lsp#client#call(a:client, "diag", l:buf, l:diag)
	endif
endfunction

function s:buf_close(client, buf)
	call g:lsp#client#call(a:client, "diag", a:buf, [])
endfunction

let g:lsp#mods#diag#obj = {
	\ "notify": function("s:notify"),
	\ "buf_close": function("s:buf_close") }
