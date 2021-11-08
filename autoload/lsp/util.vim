function g:lsp#util#caps(client)
	let l:caps = {}
	call g:lsp#client#call(a:client, ":caps", l:caps)
	return l:caps
endfunction

function g:lsp#util#with_mod(mod, ...)
	let l:clients = []
	let l:all = a:0 > 0 ? a:1 : g:lsp#mods#init#clients
	for l:client in l:all
		if !g:lsp#client#has(l:client, a:mod) | continue | endif
		call add(l:clients, l:client)
	endfor
	return l:clients
endfunction

function g:lsp#util#with_buf(buf, ...)
	let l:clients = []
	let l:all = a:0 > 0 ? a:1 : g:lsp#mods#init#clients
	for l:client in l:all
		if !g:lsp#client#owns(l:client, a:buf) | continue | endif
		call add(l:clients, l:client)
	endfor
	return l:clients
endfunction

function g:lsp#util#slice(expr, start, end)
	let l:result = []
	for l:i in range(a:end - a:start)
		call add(l:result, a:expr[l:i + a:start])
	endfor
	return l:result
endfunction
