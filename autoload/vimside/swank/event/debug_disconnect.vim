" ============================================================================
" debug_disconnect.vim
"
" File:          vimside#swank#event#debug_disconnect.vim
" Summary:       Vimside Debug disconnect
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function! vimside#swank#event#debug_disconnect#Handle(...)
call s:LOG("vimside#swank#event#debug_disconnect#Handle: ". string(a:000))
endfunction

