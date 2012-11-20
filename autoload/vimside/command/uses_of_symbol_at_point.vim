" ============================================================================
" uses_of_symbol_at_point.vim
"
" File:          uses_of_symbol_at_point.vim
" Summary:       Vimside Uses of Symbol At Point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function!  vimside#command#uses_of_symbol_at_point#Run()
  call vimside#swank#rpc#uses_of_symbol_at_point#Run()
endfunction
