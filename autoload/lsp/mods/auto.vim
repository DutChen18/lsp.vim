autocmd BufReadPost * call s:load(bufnr("%"))
autocmd BufNewFile * call s:load(bufnr("%"))

function s:load(buf)
	let l:ft = getbufvar(a:buf, "&filetype")
	for l:client in g:lsp#util#with_mod(g:lsp#mods#auto#obj)
		let l:langs = l:client["options"]["lang"]
		if !has_key(l:langs, l:ft) | continue | endif
		let l:lang = l:langs[l:ft]
		call g:lsp#client#call(l:client, ":buf_open", a:buf, l:lang)
	endfor
endfunction

function s:init(client)
	let l:langs = a:client["options"]["lang"]
	for l:buf in g:lsp#buf#list()
		let l:ft = getbufvar(l:buf, "&filetype")
		let l:clients = g:lsp#util#with_buf(l:buf)
		if len(l:clients) > 0 | continue | endif
		if !has_key(l:langs, l:ft) | continue | endif
		let l:lang = l:langs[l:ft]
		call g:lsp#client#call(a:client, ":buf_open", l:buf, l:lang)
	endfor
endfunction

let g:lsp#mods#auto#obj = {
	\ "init": function("s:init") }
