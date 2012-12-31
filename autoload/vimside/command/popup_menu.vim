" ============================================================================
" popup_menu.vim
"
" File:          popup_menu.vim
" Summary:       Vimside PopUp Menu
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#command#popup_menu#Run()
  call vimside#forms#menu#MakePopUp()
endfunction
