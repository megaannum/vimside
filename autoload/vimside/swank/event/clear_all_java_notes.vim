" ============================================================================
" clear_all_java_notes.vim
"
" File:          vimside#swank#event#clear_all_java_notes.vim
" Summary:       Vimside Event clear-all-java-notes
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
" Version:       1.0
" Modifications:
"
" Tested on vim 7.3 on Linux
"
" Depends upon: NONE
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#swank#event#clear_all_java_notes#Handle(...)
  if a:0 != 0
    call s:ERROR("vimside#swank#event#clear_all_java_notes#Handle: has additional args=". string(a:000))
  endif
  call s:LOG("clear_all_java_notes#Handle") 
  let g:vimside.project.java_notes = []
endfunction
