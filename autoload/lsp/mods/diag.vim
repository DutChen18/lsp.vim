call sign_define("lsp_err", { "text": "EE", "texthl": "Lsp_Err" })
call sign_define("lsp_wrn", { "text": "WW", "texthl": "Lsp_Wrn" })
call sign_define("lsp_inf", { "text": "II", "texthl": "Lsp_Inf" })
call sign_define("lsp_hnt", { "text": "HH", "texthl": "Lsp_Hnt" })
let s:signs = ["lsp_err", "lsp_wrn", "lsp_inf", "lsp_hnt"]

function s:notify(client, message)
	if a:message["method"] ==# "textDocument/publishDiagnostics"
		let l:buf = g:lsp#buf#by_uri(a:message["params"]["uri"])
		if !has_key(a:client["buffers"], l:buf) | return | endif
		call sign_unplace("lsp", { "buffer": l:buf })
		let l:diag = a:message["params"]["diagnostics"]
		let a:client["buffers"][l:buf]["diagnostics"] = l:diag
		for l:diag in l:diag
			let l:severity = l:diag["severity"]
			let l:sign = s:signs[l:severity - 1]
			let l:lnum = l:diag["range"]["start"]["line"] + 1
			call sign_place(0, "lsp", l:sign, l:buf,
				\ { "lnum": l:lnum, "priority": -l:severity })
		endfor
	endif
endfunction

function s:buf_close(client, buf)
	call sign_unplace("lsp", { "buffer": a:buf })
endfunction

let g:lsp#mods#diag#obj = {
	\ "notify": function("s:notify"),
	\ "buf_close": function("s:buf_close") }
