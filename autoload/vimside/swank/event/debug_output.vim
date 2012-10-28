" ============================================================================
" debug_output.vim
"
" File:          vimside#swank#event#debug_output.vim
" Summary:       Vimside Debug output
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function! vimside#swank#event#debug_output#Handle(...)
call s:LOG("vimside#swank#event#debug_output#Handle: ". string(a:000))
endfunction
