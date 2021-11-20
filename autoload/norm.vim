hi default link Norm_err Lsp_Err
call sign_define("norm_err", { "text": "NN", "texthl": "Norm_Err" })

function s:getcol(buf, lnum, col)
	let l:col = 0
	let l:vcol = 0
	let l:line = getbufline(a:buf, a:lnum)[0]
	while l:vcol < a:col
		if l:line[l:col] ==# "\t"
			let l:vcol += 4
		else
			let l:vcol += 1
		endif
		let l:col += 1
	endwhile
	return l:col
endfunction

function s:callback(buf, version, path, data)
	call delete(a:path, "rf")
	if a:version != getbufvar(a:buf, "changedtick") | return | endif
	call sign_unplace("norm", { "buffer": a:buf })
	let l:loclist = []
	for l:error in split(a:data, "\n")
		if l:error[:5] !=# "Error:" | continue | endif
		let l:fields = split(l:error, " \\+")
		let l:lnum = str2nr(l:fields[3])
		let l:col = s:getcol(a:buf, l:lnum, str2nr(l:fields[5]) - 1) + 1
		call add(l:loclist, {
			\ "bufnr": a:buf,
			\ "lnum": l:lnum,
			\ "col": l:col,
			\ "text": join(l:fields[5:], " ") })
		call sign_place(0, "norm", "norm_err", a:buf,
			\ { "lnum": l:lnum, "priority": -9 })
	endfor
	call g:lsp#loclist#set(a:buf, "norm", l:loclist)
endfunction

function s:close_cb(client, buf)
	return
endfunction

function s:norm(client, buf)
	let l:dpath = tempname()
	call mkdir(l:dpath)
	let l:fpath = l:dpath . "/" . expand("#" . a:buf . ":t")
	echo l:fpath
	call writefile(getbufline(a:buf, 1, "$"), l:fpath)
	let l:mode = { "command": ["norminette", l:fpath] }
	let l:version = getbufvar(a:buf, "changedtick")
	let l:channel = lsp#channel#open(l:mode, {
		\ "callback": function("s:callback", [a:buf, l:version, l:dpath]),
		\ "close_cb": function("s:close_cb", [a:client, a:buf]) })
endfunction

let g:norm#obj = {
	\ "buf_open": function("s:norm"),
	\ "buf_change": function("s:norm") }
