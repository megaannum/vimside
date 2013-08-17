" ============================================================================
" typecheck_all.vim
"
" File:          typecheck_all.vim
" Summary:       Vimside Typecheck All
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function!  vimside#command#typecheck_all#Run()
  call vimside#command#show_errors_and_warning#Close()
  call vimside#swank#rpc#typecheck_all#Run()
endfunction
