autocmd BufUnload * call s:unload(bufnr("<afile>"))

function s:unload(buf)
	for l:client in g:lsp#util#with_buf(a:buf)
		call s:buf_close(l:client, a:buf)
	endfor
endfunction

function s:buf_open(client, buf, lang)
	let l:text = join(getbufline(a:buf, 1, "$") + [""], "\n")
	let a:client["buffers"][a:buf] = {}
	let l:message = { "method": "textDocument/didOpen", "params": {
		\ "textDocument": {
			\ "uri": g:lsp#buf#to_uri(a:buf),
			\ "languageId": a:lang,
			\ "version": getbufvar(a:buf, "changedtick"),
			\ "text": l:text }}}
	call g:lsp#client#send(a:client, l:message, {})
	call g:lsp#client#call(a:client, "buf_open", a:buf)
endfunction

function s:buf_close(client, buf)
	unlet a:client["buffers"][a:buf]
	let l:message = { "method": "textDocument/didClose", "params": {
		\ "textDocument": {
			\ "uri": g:lsp#buf#to_uri(a:buf) }}}
	call g:lsp#client#send(a:client, l:message, {})
	call g:lsp#client#call(a:client, "buf_close", a:buf)
endfunction

function s:exit(client)
	for l:buf in keys(a:client["buffers"])
		call g:lsp#client#call(a:client, "buf_close", str2nr(l:buf))
	endfor
endfunction

let g:lsp#mods#file#obj = {
	\ "exit": function("s:exit"),
	\ ":buf_open": function("s:buf_open"),
	\ ":buf_close": function("s:buf_close") }
