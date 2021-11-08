let g:lsp#mods#init#clients = []

function s:init_cb(client, message)
	let a:client["capabilities"] = a:message["result"]["capabilities"]
	let l:message = { "method": "initialized", "params": {} }
	call g:lsp#client#send(a:client, l:message, {})
	call g:lsp#client#call(a:client, "init")
	call add(g:lsp#mods#init#clients, a:client)
endfunction

function s:exit_cb(client, message)
	let l:message = { "method": "exit" }
	call g:lsp#client#send(a:client, l:message, {})
endfunction

function s:open(client)
	let l:message = { "method": "initialize", "params": {
		\ "processId": getpid(),
		\ "capabilities": g:lsp#util#caps(a:client),
		\ "initializationOptions": a:client["options"]["init"] }}
	call g:lsp#client#send(a:client, l:message, {
		\ "callback": function("s:init_cb", [a:client]) })
endfunction

function s:close(client)
	let l:idx = index(g:lsp#mods#init#clients, a:client)
	if l:idx == -1 | return | endif
	call remove(g:lsp#mods#init#clients, l:idx)
	call g:lsp#client#call(a:client, "exit")
endfunction

function s:exit(client)
	call s:close(a:client)
	let l:message = { "method": "shutdown" }
	call g:lsp#client#send(a:client, l:message, {
		\ "callback": function("s:exit_cb", [a:client]) })
endfunction

let g:lsp#mods#init#obj = {
	\ "open": function("s:open"),
	\ "close": function("s:close"),
	\ ":exit": function("s:exit") }
