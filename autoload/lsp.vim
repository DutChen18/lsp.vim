function lsp#clangd()
	let l:flags = [
		\ "-Wall",
		\ "-Wextra",
		\ "-ansi",
		\ "-pedantic",
		\ "-Wno-empty-translation-unit"]
	let g:lsp#client = g:lsp#client#open({
		\ "name": "clangd",
		\ "lang": { "c": "c" },
		\ "channel": { "command": ["clangd", "--sync"] },
		\ "init": { "fallbackFlags": l:flags },
		\ "mods": [
			\ g:lsp#mods#init#obj,
			\ g:lsp#mods#file#obj,
			\ g:lsp#mods#auto#obj,
			\ g:lsp#mods#diag#obj,
			\ g:lsp#mods#change#obj,
			\ g:lsp#mods#sema#obj ]})
endfunction
