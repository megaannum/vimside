" ============================================================================
" debug_thread_start.vim
"
" File:          vimside#swank#event#debug_thread_start.vim
" Summary:       Vimside Debug thread_start
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function! vimside#swank#event#debug_thread_start#Handle(...)
call s:LOG("vimside#swank#event#debug_thread_start#Handle: ". string(a:000))
endfunction

