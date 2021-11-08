function s:callback(server, message)
	if !has_key(a:message, "id")
		call a:server["options"]["notify_cb"](a:message)
	elseif has_key(a:message, "method")
		call a:server["options"]["request_cb"](a:message)
	else
		let l:request = remove(a:server["requests"], a:message["id"])
		call l:request["callback"](a:message)
	endif
endfunction

function s:close_cb(server)
	call a:server["options"]["close_cb"]()
endfunction

function g:lsp#server#open(mode, options)
	let l:server = {}
	let l:server["proto"] = g:lsp#proto#open(a:mode, {
		\ "callback": function("s:callback", [l:server]),
		\ "close_cb": function("s:close_cb", [l:server]) })
	let l:server["options"] = a:options
	let l:server["requests"] = {}
	let l:server["id"] = 0
	return l:server
endfunction

function g:lsp#server#close(server)
	call g:lsp#proto#close(a:server["proto"])
endfunction

function g:lsp#server#send(server, message, options)
	let a:message["jsonrpc"] = "2.0"
	if has_key(a:options, "callback")
		let a:message["id"] = a:server["id"]
		let a:server["requests"][a:message["id"]] = a:options
		let a:server["id"] += 1
	endif
	call g:lsp#proto#send(a:server["proto"], a:message)
	return get(a:message, "id", -1)
endfunction
