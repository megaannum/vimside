" ============================================================================
" symbol_at_point.vim
"
" File:          symbol_at_point.vim
" Summary:       Vimside Symbol At Point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function!  vimside#command#symbol_at_point#Run()
  call vimside#swank#rpc#symbol_at_point#Run()
endfunction
