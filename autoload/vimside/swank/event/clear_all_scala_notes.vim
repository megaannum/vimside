" ============================================================================
" clear_all_scala_notes.vim
"
" File:          vimside#swank#event#clear_all_scala_notes.vim
" Summary:       Vimside Event clear-all-scala-notes
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#swank#event#clear_all_scala_notes#Handle(...)
if 0 " XXXX
  if a:0 != 0
    call s:ERROR("vimside#swank#event#clear_all_scala_notes#Handle: has additional args=". string(a:000))
  endif
endif " XXXX

call s:LOG("clear_all_scala_notes#Handle") 
  let g:vimside.project.scala_notes = []
  call vimside#quickfix#Close()
endfunction
