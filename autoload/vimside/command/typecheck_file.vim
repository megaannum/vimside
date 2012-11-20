" ============================================================================
" typecheck_file.vim
"
" File:          typecheck_file.vim
" Summary:       Vimside Typecheck File
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function!  vimside#command#typecheck_file#Run()
  call vimside#swank#rpc#typecheck_file#Run()
endfunction
