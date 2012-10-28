" ============================================================================
" error.vim
"
" File:          error.vim
" Summary:       Error maager for Vimside
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
" ============================================================================

let s:errors = []

function! vimside#error#record(msg)
  echoerr a:msg
  let t = exists("*strftime")
        \ ? strftime("%Y%m%d-%H%M%S: ")    
        \ : "" . localtime() . ": "
  all add(s:errors, t .': '. a:msg)
endfunction

function! vimside#error#get()
  return copy(s:errors)
endfunction

function! vimside#error#clear()
  let s:errors = []
endfunction
