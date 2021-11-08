function g:lsp#client#call(client, type, ...)
	for l:mod in a:client["options"]["mods"]
		if has_key(l:mod, a:type)
			if call (l:mod[a:type], [a:client] + a:000)
				return 1
			endif
		endif
	endfor
endfunction

function g:lsp#client#open(options)
	let l:Call = function("g:lsp#client#call")
	let l:client = {}
	let l:client["server"] = g:lsp#server#open(a:options["channel"], {
		\ "notify_cb": function(l:Call, [l:client, "notify"]),
		\ "request_cb": function(l:Call, [l:client, "request"]),
		\ "close_cb": function(l:Call, [l:client, "close"]) })
	let l:client["options"] = a:options
	let l:client["buffers"] = {}
	call g:lsp#client#call(l:client, "open")
	return l:client
endfunction

function g:lsp#client#close(client)
	call g:lsp#client#call(a:client, "close")
	call g:lsp#server#close(a:client["server"])
endfunction

function g:lsp#client#send(client, message, options)
	return g:lsp#server#send(a:client["server"], a:message, a:options)
endfunction

function g:lsp#client#has(client, mod)
	return index(a:client["options"]["mods"], a:mod) != -1
endfunction

function g:lsp#client#owns(client, buf)
	return has_key(a:client["buffers"], a:buf)
endfunction
