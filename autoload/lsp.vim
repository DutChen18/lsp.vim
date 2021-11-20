function lsp#clangd(...)
	let l:options = get(a:000, 0, {})
	let l:args = get(l:options, "args", [
		\ "clangd",
		\ "--sync" ])
	let l:flags = get(l:options, "flags", [
		\ "-Wall",
		\ "-Wextra",
		\ "-ansi",
		\ "-pedantic",
		\ "-Wno-empty-translation-unit" ])
	let l:mods = get(l:options, "mods", [
		\ g:lsp#mods#init#obj,
		\ g:lsp#mods#file#obj,
		\ g:lsp#mods#auto#obj,
		\ g:lsp#mods#diag#obj,
		\ g:lsp#mods#diag_sign#obj,
		\ g:lsp#mods#diag_msg#obj,
		\ g:lsp#mods#change#obj,
		\ g:lsp#mods#sema#obj ])
	call extend(l:args, get(l:options, "extra_args", []))
	call extend(l:flags, get(l:options, "extra_flags", []))
	call extend(l:mods, get(l:options, "extra_mods", []))
	let g:lsp#client = g:lsp#client#open({
		\ "name": "clangd",
		\ "lang": { "c": "c", "cpp": "cpp", "m": "objective-c" },
		\ "channel": { "command": l:args },
		\ "init": { "fallbackFlags": l:flags },
		\ "mods": l:mods })
endfunction
