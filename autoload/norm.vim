call sign_define("norm_err", { "text": "NN", "texthl": "Lsp_Err" })

function s:callback(buf, data)
	call sign_unplace("norm", { "buffer": a:buf })
	let l:loclist = []
	for l:error in split(a:data, "\n")
		if l:error[:5] !=# "Error:" | continue | endif
		let l:fields = split(l:error, " \\+")
		let l:lnum = str2nr(l:fields[3])
		call add(l:loclist, {
			\ "bufnr": a:buf,
			\ "lnum": l:lnum,
			\ "col": str2nr(l:fields[5]),
			\ "text": join(l:fields[5:], " "),
			\ "valid": l:fields[2] })
		call sign_place(0, "norm", "norm_err", a:buf,
			\ { "lnum": l:lnum, "priority": -9 })
	endfor
	call g:lsp#loclist#set(bufwinnr(a:buf), "norm", l:loclist)
endfunction

function s:close_cb(client, buf)
	call delete(a:client["buffers"][a:buf]["tempname"])
	unlet a:client["buffers"][a:buf]["tempname"]
endfunction

function s:norm(client, buf)
	let l:path = tempname() . "." . expand("#" . a:buf . ":e")
	let a:client["buffers"][a:buf]["tempname"] = l:path
	call writefile(getbufline(a:buf, 1, "$"), l:path)
	let l:mode = { "command": ["norminette", l:path] }
	let l:channel = lsp#channel#open(l:mode, {
		\ "callback": function("s:callback", [a:buf]),
		\ "close_cb": function("s:close_cb", [a:client, a:buf]) })
endfunction

let g:norm#obj = {
	\ "buf_open": function("s:norm"),
	\ "buf_change": function("s:norm") }
