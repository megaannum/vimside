" ============================================================================
" ensime.vim
"
" File:          ensime.vim
" Summary:       Vimside Ensime
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#command#ensime#Start()
  call vimside#StartEnsime()
endfunction

function! vimside#command#ensime#Stop()
  call vimside#StopEnsime()
endfunction
