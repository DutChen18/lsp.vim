hi clear
if exists("syntax_on")
	syn reset
endif
set bg=dark
let g:colors_name="lsp_vscode"

hi Normal guibg=#1e1e1e guifg=#d4d4d4
hi Visual guibg=#3c3c3c
hi Comment guifg=#6a9955
hi String guifg=#ce9178
hi Character guifg=#ce9178
hi Number guifg=#b5cea8
hi Identifier guifg=#9cdcfe cterm=NONE gui=NONE
hi Function guifg=#dcdcaa
hi Statement guifg=#c586c0
hi PreProc guifg=#c586c0
hi Type guifg=#569cd6
hi SpecialChar guifg=#d7ba7d

hi link Lsp_variable Identifier
hi link Lsp_parameter Identifier
hi link Lsp_function Function
hi link Lsp_property Identifier
hi Lsp_class guifg=#4ec9b0
hi link Lsp_enum Lsp_class
hi Lsp_enumMember guifg=#4fc1ff
hi link Lsp_type Lsp_class
hi link Lsp_macro Type

hi Lsp_comment guifg=#858585
hi LineNr guifg=#858585
hi ColorColumn guibg=#858585
hi NonText guifg=#858585
hi Todo guibg=#1e1e1e guifg=#6a9955
hi Error guibg=#1e1e1e guifg=#f14c4c
hi Special guifg=#d4d4d4
hi MatchParen guibg=#1e1e1e

hi Lsp_Err cterm=bold gui=bold guifg=red
hi Lsp_Wrn cterm=bold gui=bold guifg=magenta
hi Lsp_Inf cterm=bold gui=bold guifg=cyan
hi Lsp_Hnt cterm=bold gui=bold guifg=green
