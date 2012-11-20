" ============================================================================
" show_errors_and_warning.vim
"
" File:          show_errors_and_warning.vim
" Summary:       Vimside Show Compiler Errors and Warnings
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function!  vimside#command#show_errors_and_warning#Run()
" call s:LOG("vimside#command#show_errors_and_warning#Run TOP") 

  let entries = g:vimside.project.java_notes + g:vimside.project.scala_notes
  if len(entries) > 0
    call vimside#quickfix#Display(entries)
  else
    let msg = "No Errors or Warnings"
    call vimside#cmdline#Display(msg) 
  endif

" call s:LOG("vimside#command#show_errors_and_warning#Run BOTTOM") 
endfunction
