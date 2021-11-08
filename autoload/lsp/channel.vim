function s:callback(options, ...)
	call a:options["callback"](a:2)
endfunction

function s:close_cb(options, ...)
	call a:options["close_cb"]()
endfunction

function g:lsp#channel#open(mode, options)
	let l:options = {}
	let l:options["mode"] = "raw"
	let l:options["close_cb"] = function("s:close_cb", [a:options])
	if has_key(a:mode, "address")
		let l:options["callback"] = function("s:callback", [a:options])
		let l:channel = ch_open(a:mode["address"], l:options)
		return ch_status(l:channel) !=# "fail" ? l:channel : 0
	elseif has_key(a:mode, "command")
		let l:options["out_cb"] = function("s:callback", [a:options])
		let l:job = job_start(a:mode["command"], l:options)
		let l:channel = job_getchannel(l:job)
		return ch_status(l:channel) !=# "fail" ? l:channel : 0
	endif
endfunction

function g:lsp#channel#close(channel)
	call ch_close(a:channel)
	let l:job = ch_getjob(a:channel)
	if ch_status(l:job) !=# "fail"
		call job_stop(l:job)
	endif
endfunction

function g:lsp#channel#send(channel, message)
	call ch_sendraw(a:channel, a:message)
endfunction
