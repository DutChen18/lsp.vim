function g:lsp#buf#list()
	let l:buffers = []
	for l:buf in range(1, bufnr('$'))
		if !bufexists(l:buf) | continue | endif
		call add(l:buffers, l:buf)
	endfor
	return l:buffers
endfunction

function g:lsp#buf#to_uri(buf)
	let l:uri = expand("#" . a:buf . ":p")
	if has("win32")
		return "file://" . substitute(l:uri, "\\\\", "/", "g")[2:]
	else
		return "file://" . l:uri
	endif
endfunction

function g:lsp#buf#by_uri(uri)
	for l:buf in g:lsp#buf#list()
		if g:lsp#buf#to_uri(l:buf) == a:uri | return l:buf | endif
	endfor
endfunction

function g:lsp#buf#changes(old, new)
	let l:n = min([len(a:old), len(a:new)])
	let [l:i, l:j] = [0, -1]
	while l:i < l:n
		if a:old[l:i] !=# a:new[l:i] | break | endif
		let l:i += 1
	endwhile
	while l:j > l:i - l:n - 1
		if a:old[l:j] !=# a:new[l:j] | break | endif
		let l:j -= 1
	endwhile
	let [l:k, l:l] = [len(a:old) + l:j + 1, len(a:new) + l:j + 1]
	let l:lines = g:lsp#util#slice(a:new, l:i, l:l)
	return [{
		\ "range": {
			\ "start": { "line": l:i, "character": 0 },
			\ "end": { "line": l:k, "character": 0 } },
		\ "text": join(l:lines + [""], "\n") }]
endfunction
