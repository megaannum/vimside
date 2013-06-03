" ============================================================================
" indexer_ready.vim
"
" File:          vimside#swank#event#indexer_ready.vim
" Summary:       Vimside Event indexer-ready
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#swank#event#indexer_ready#Handle(...)
  if a:0 != 0
    call s:ERROR("vimside#swank#event#indexer_ready#Handle: has additional args=". string(a:000))
  endif
  call s:LOG("indexer_ready#Handle") 

  let msg = "Indexer Ready..."
  call vimside#cmdline#Display(msg) 
  " TODO record event info?
endfunction
