function s:callback(proto, message)
	let a:proto["buffer"] .= a:message
	let l:idx = stridx(a:proto["buffer"], "\r\n\r\n")
	if l:idx < 0 | return | endif
	let l:data = strpart(a:proto["buffer"], 0, l:idx)
	let l:headers = {}
	for l:header in split(l:data, "\r\n")
		let [l:key, l:val] = split(l:header, ":")
		let l:headers[toupper(l:key)] = trim(l:val)
	endfor
	let l:len = str2nr(l:headers["CONTENT-LENGTH"])
	if l:len > len(a:proto["buffer"]) - l:idx - 4 | return | endif
	let l:data = strpart(a:proto["buffer"], l:idx + 4, l:len)
	let a:proto["buffer"] = strpart(a:proto["buffer"], l:idx + 4 + l:len)
	call a:proto["options"]["callback"](json_decode(l:data))
	call s:callback(a:proto, "")
endfunction

function s:close_cb(proto)
	call a:proto["options"]["close_cb"]()
endfunction

function g:lsp#proto#open(mode, options)
	let l:proto = {}
	let l:proto["channel"] = g:lsp#channel#open(a:mode, {
		\ "callback": function("s:callback", [l:proto]),
		\ "close_cb": function("s:close_cb", [l:proto]) })
	let l:proto["options"] = a:options
	let l:proto["buffer"] = ""
	return l:proto
endfunction

function g:lsp#proto#close(proto)
	call g:lsp#channel#close(a:proto["channel"])
endfunction

function g:lsp#proto#send(proto, message)
	let l:content = json_encode(a:message)
	let l:headers = "Content-Length: " . len(l:content) . "\r\n\r\n"
	call g:lsp#channel#send(a:proto["channel"], l:headers . l:content)
endfunction
