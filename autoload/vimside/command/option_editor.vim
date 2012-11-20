" ============================================================================
" option_editor.vim
"
" File:          option_editor.vim
" Summary:       Vimside Option Editor
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#command#option_editor#Run()
  call vimside#forms#optioneditor#Run()
endfunction
