" ============================================================================
" full_typecheck_finished.vim
"
" File:          vimside#swank#event#full_typecheck_finished.vim
" Summary:       Vimside Event full-typecheck-finished
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let [found, use_signs] = g:vimside.GetOption('tailor-full-typecheck-finished-use-signs')
if found
  let s:full_typecheck_finished_use_signs = use_signs
else
  let s:full_typecheck_finished_use_signs = 0
endif

function! vimside#swank#event#full_typecheck_finished#Handle(...)
  if a:0 != 0
    call s:ERROR("vimside#swank#event#full_typecheck_finished#Handle: has additional args=". string(a:000))
  endif
  call s:LOG("full_typecheck_finished#Handle TOP") 

  call vimside#command#show_errors_and_warning#Run("c")
if 0 " REMOVE
  let entries = g:vimside.project.java_notes + g:vimside.project.scala_notes
  if len(entries) > 0
    call vimside#quickfix#Display(entries, s:full_typecheck_finished_use_signs) 
  else
    let msg = "Full Typecheck Finished..."
    call vimside#cmdline#Display(msg) 
  endif
endif " REMOVE

  call s:LOG("full_typecheck_finished#Handle BOTTOM") 
endfunction
