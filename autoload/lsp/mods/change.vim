function s:change(client, buf, new, version)
	let l:old = a:client["buffers"][a:buf]["text"]
	let l:changes = g:lsp#buf#changes(l:old, a:new)
	let l:message = { "method": "textDocument/didChange", "params": {
		\ "textDocument": {
			\ "uri": g:lsp#buf#to_uri(a:buf),
			\ "version": a:version },
		\ "contentChanges": l:changes }}
	call g:lsp#client#send(a:client, l:message, {})
	call g:lsp#client#call(a:client, "buf_change", a:buf, l:changes)
endfunction

function s:callback(timer)
	for l:client in g:lsp#util#with_mod(g:lsp#mods#change#obj)
		for [l:buf, l:buffer] in items(l:client["buffers"])
			let l:buf = str2nr(l:buf)
			let l:version = getbufvar(l:buf, "changedtick")
			if l:version <= l:buffer["version"] | continue | endif
			let l:new = getbufline(l:buf, 1, "$")
			call s:change(l:client, l:buf, l:new, l:version)
			let l:buffer["version"] = l:version
			let l:buffer["text"] = l:new
		endfor
	endfor
endfunction

call timer_start(500, function("s:callback"), { "repeat": -1 })

function s:buf_open(client, buf)
	let l:buffer = a:client["buffers"][a:buf]
	let l:buffer["version"] = getbufvar(a:buf, "changedtick")
	let l:buffer["text"] = getbufline(a:buf, 1, "$")
endfunction

let g:lsp#mods#change#obj = {
	\ "buf_open": function("s:buf_open") }
