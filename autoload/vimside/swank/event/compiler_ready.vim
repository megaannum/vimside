" ============================================================================
" compiler_ready.vim
"
" File:          vimside#swank#event#compiler_ready.vim
" Summary:       Vimside Event compiler-ready
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#swank#event#compiler_ready#Handle(...)
  if a:0 != 0
    call s:ERROR("vimside#swank#event#compiler_ready#Handle: has additional args=". string(a:000))
  endif
  call s:LOG("compiler_ready#Handle") 

  let msg = "Compiler Ready..."
  call vimside#cmdline#Display(msg) 
endfunction
