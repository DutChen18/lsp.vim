let s:ll = {}
hi default Lsp_Loc guibg=red
call prop_type_add("lsp_loc", { "highlight": "Lsp_Loc", "priority": 100 })

function g:lsp#loclist#set(buf, ctx, list)
	let l:win = bufwinnr(a:buf)
	if !has_key(s:ll, l:win)
		let s:ll[l:win] = {}
	endif
	let s:ll[l:win][a:ctx] = {
		\ "version": getbufvar(a:buf, "changedtick"),
		\ "items": a:list }
	let l:ll = []
	for [l:k, l:v] in items(s:ll[l:win])
		if l:v["version"] == getbufvar(a:buf, "changedtick")
			call extend(l:ll, l:v["items"])
		endif
	endfor
	call setloclist(l:win, l:ll)
	let l:client = g:lsp#util#with_buf(a:buf)[0]
	let l:last_line = line("$")
	call prop_remove({ "type": "lsp_loc", "bufnr": a:buf, "all": 1 })
	for l:loc in l:ll
		if l:loc["lnum"] > l:last_line | continue | endif
		let l:last_line_str = getbufline(a:buf, l:loc["lnum"])
		if l:loc["col"] > len(l:last_line_str) | continue | endif
		let l:p = { "length": 1, "bufnr": a:buf, "type": "lsp_loc" }
		call prop_add(l:loc["lnum"], l:loc["col"], l:p)
	endfor
endfunction
