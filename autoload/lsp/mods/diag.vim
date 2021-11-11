call sign_define("lsp_err", { "text": "EE", "texthl": "Lsp_Err" })
call sign_define("lsp_wrn", { "text": "WW", "texthl": "Lsp_Wrn" })
call sign_define("lsp_inf", { "text": "II", "texthl": "Lsp_Inf" })
call sign_define("lsp_hnt", { "text": "HH", "texthl": "Lsp_Hnt" })
let s:signs = ["lsp_err", "lsp_wrn", "lsp_inf", "lsp_hnt"]

function s:notify(client, message)
	if a:message["method"] ==# "textDocument/publishDiagnostics"
		let l:buf = g:lsp#buf#by_uri(a:message["params"]["uri"])
		if !has_key(a:client["buffers"], l:buf) | return | endif
		let l:diag = a:message["params"]["diagnostics"]
		let a:client["buffers"][l:buf]["diagnostics"] = l:diag
		call lsp#client#call(a:client, "diag", l:buf, l:diag)
	endif
endfunction

function s:buf_close(client, buf)
	call g:lsp#client#call(a:client, "diag", a:buf, [])
endfunction

let g:lsp#mods#diag#obj = {
	\ "notify": function("s:notify"),
	\ "buf_close": function("s:buf_close") }
