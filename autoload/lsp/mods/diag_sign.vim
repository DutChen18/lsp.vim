call sign_define("lsp_err", { "text": "EE", "texthl": "Lsp_Err" })
call sign_define("lsp_wrn", { "text": "WW", "texthl": "Lsp_Wrn" })
call sign_define("lsp_inf", { "text": "II", "texthl": "Lsp_Inf" })
call sign_define("lsp_hnt", { "text": "HH", "texthl": "Lsp_Hnt" })
let s:signs = ["lsp_err", "lsp_wrn", "lsp_inf", "lsp_hnt"]

function s:diag(client, buf, diag)
	call sign_unplace("lsp", { "buffer": a:buf })
	for l:diag in a:diag
		let l:severity = l:diag["severity"]
		let l:sign = s:signs[l:severity - 1]
		let l:lnum = l:diag["range"]["start"]["line"] + 1
		call sign_place(0, "lsp", l:sign, a:buf,
			\ { "lnum": l:lnum, "priority": -l:severity })
	endfor
endfunction

let g:lsp#mods#diag_sign#obj = {
	\ "diag": function("s:diag") }
