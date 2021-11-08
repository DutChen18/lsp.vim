let s:props = []

function s:callback(client, buf, message)
	let l:version = a:client["buffers"][a:buf]["version"]
	if l:version != getbufvar(a:buf, "changedtick") | return | endif
	let [l:l, l:c] = [1, 1]
	let l:caps = a:client["capabilities"]["semanticTokensProvider"]
	call s:buf_close(a:client, a:buf)
	for l:i in range(0, len(a:message["result"]["data"]) - 1, 5)
		let l:d = a:message["result"]["data"][l:i:l:i + 4]
		let l:l += l:d[0]
		let l:c = (l:d[0] == 0 ? l:c : 1) + l:d[1]
		let l:type = l:caps["legend"]["tokenTypes"][l:d[3]]
		let l:name = "Lsp_" . l:type
		if empty(prop_type_get(l:name))
			exec printf("hi default link %s Normal", l:name)
			call prop_type_add(l:name, { "highlight": l:name })
			call add(s:props, l:name)
		endif
		let l:p = { "length": l:d[2], "bufnr": a:buf, "type": l:name }
		call prop_add(l:l, l:c, l:p)
	endfor
endfunction

function s:buf_close(client, buf)
	for l:prop in s:props
		call prop_remove({ "type": l:prop, "bufnr": a:buf, "all": 1 })
	endfor
endfunction

function s:buf_change(client, buf)
	let l:message = {
		\ "method": "textDocument/semanticTokens/full",
		\ "params": {
			\ "textDocument": { "uri": g:lsp#buf#to_uri(a:buf) }}}
	call g:lsp#client#send(a:client, l:message, {
		\ "callback": function("s:callback", [a:client, a:buf]) })
endfunction

let g:lsp#mods#sema#obj = {
	\ "buf_open": function("s:buf_change"),
	\ "buf_close": function("s:buf_close"),
	\ "buf_change": function("s:buf_change") }
