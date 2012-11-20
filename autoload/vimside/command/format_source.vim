" ============================================================================
" format_source.vim
"
" File:          format_source.vim
" Summary:       Vimside Format Source
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#command#format_source#Run()
  call vimside#swank#rpc#format_source#Run()
endfunction
