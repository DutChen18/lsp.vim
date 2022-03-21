function s:popup_callback(buf, items, id, result)
	if a:result != -1
		call g:lsp#edit#edit(a:buf, a:items[a:result - 1]["textEdit"])
	endif
endfunction

function s:callback(buf, client, message)
	if has_key(a:message, "result")
		let l:items = []
		let l:comps = a:message["result"]["items"]
		for l:item in l:comps
			call add(l:items, l:item["label"])
		endfor
		if len(l:items) != 0
			call g:lsp#popup#atcursor(l:items, {
				\ "filter": "popup_filter_menu",
				\ "cursorline": 1,
				\ "mapping": 0,
				\ "callback": function("s:popup_callback", [a:buf, l:comps]) })
		endif
	endif
endfunction

function s:completion(client, ...)
	let l:buf = bufnr()
	let l:pos = getcharpos(".")
	let l:message = {
		\ "method": "textDocument/completion",
		\ "params": {
			\ "textDocument": { "uri": g:lsp#buf#to_uri(l:buf) },
			\ "position": { "line": l:pos[1] - 1, "character": l:pos[2] - 1 }}}
	call g:lsp#client#send(a:client, l:message, {
		\ "callback": function("s:callback", [l:buf, a:client]) })
endfunction

let g:lsp#mods#completion#obj = {
	\ ":completion": function("s:completion") }
