let s:map = {}

function s:notify(client, message)
	if a:message["method"] ==# "textDocument/publishDiagnostics"
		let l:buf = g:lsp#buf#by_uri(a:message["params"]["uri"])
		let l:version = a:message["params"]["version"]
		let s:map[l:buf]["last_received"] = l:version
		echo s:map[l:buf]
		if s:map[l:buf]["last_sent"] != s:map[l:buf]["last_received"]
			return
		endif
		if !has_key(a:client["buffers"], l:buf) | return | endif
		let l:diag = a:message["params"]["diagnostics"]
		let a:client["buffers"][l:buf]["diagnostics"] = l:diag
		call lsp#client#call(a:client, "diag", l:buf, l:diag)
	endif
endfunction

function s:buf_close(client, buf)
	call g:lsp#client#call(a:client, "diag", a:buf, [])
endfunction

function s:buf_open(client, buf)
	let s:map[a:buf] = {
		\ "last_sent": getbufvar(a:buf, "changedtick"),
		\ "last_received": 0 }
endfunction

function s:buf_change(client, buf, changes)
	let l:r = a:changes[0]["range"]["start"] ==# a:changes[0]["range"]["end"]
	let l:c = l:r && a:changes[0]["text"] ==# ""
	if l:c
		if s:map[a:buf]["last_sent"] == s:map[a:buf]["last_received"]
			let l:diag = a:client["buffers"][a:buf]["diagnostics"]
			call lsp#client#call(a:client, "diag", a:buf, l:diag)
		endif
	else
		let s:map[a:buf]["last_sent"] = getbufvar(a:buf, "changedtick")
	end
endfunction

let g:lsp#mods#diag#obj = {
	\ "notify": function("s:notify"),
	\ "buf_open": function("s:buf_open"),
	\ "buf_close": function("s:buf_close"),
	\ "buf_change": function("s:buf_change") }
