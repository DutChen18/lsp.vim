function s:callback(buf, client, message)
	if has_key(a:message, "result")
		let l:items = []
		for l:item in a:message["result"]["signatures"]
			call add(l:items, l:item["label"])
		endfor
		if len(l:items) != 0
			call g:lsp#popup#atcursor(l:items, {})
		endif
	endif
endfunction

function s:signature(client, ...)
	let l:buf = bufnr()
	let l:pos = getcharpos(".")
	let l:message = {
		\ "method": "textDocument/signatureHelp",
		\ "params": {
			\ "textDocument": { "uri": g:lsp#buf#to_uri(l:buf) },
			\ "position": { "line": l:pos[1] - 1, "character": l:pos[2] - 1 }}}
	call g:lsp#client#send(a:client, l:message, {
		\ "callback": function("s:callback", [l:buf, a:client]) })
endfunction

let g:lsp#mods#signature#obj = {
	\ ":signature": function("s:signature") }
