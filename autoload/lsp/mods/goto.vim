function s:callback(message)
	if len(a:message["result"]) != 0
		call g:lsp#edit#goto(a:message["result"][0])
	endif
endfunction

function s:goto(method, client, ...)
	let l:buf = bufnr()
	let l:pos = getcharpos(".")
	let l:message = {
		\ "method": "textDocument/" . a:method,
		\ "params": {
			\ "textDocument": { "uri": g:lsp#buf#to_uri(l:buf) },
			\ "position": { "line": l:pos[1] - 1, "character": l:pos[2] - 1 }}}
	call g:lsp#client#send(a:client, l:message, {
		\ "callback": function("s:callback") })
endfunction

let g:lsp#mods#goto#obj = {
	\ ":declaration": function("s:goto", ["declaration"]),
	\ ":definition": function("s:goto", ["definition"]) }
