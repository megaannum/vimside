" ============================================================================
" repl_config.vim
"
" File:          repl_config.vim
" Summary:       Vimside Search
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function!  vimside#command#repl_config#Run()
  call vimside#swank#rpc#repl_config#Run()
endfunction
