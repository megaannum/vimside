" ============================================================================
" position.vim
"
" File:          position.vim
" Summary:       Vimside Position support
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function!  vimside#command#position#Clear()
  let g:vimside.project.positions = []
endfunction

function!  vimside#command#position#Set()
  let bufnum = bufnr("%")
  let pos = getpos(".")
  let g:vimside.project.positions = [bufnum, pos]
endfunction

function!  vimside#command#position#Previous()
  let positions = g:vimside.project.positions
" call s:LOG("vimside#command#position#Previous=". string(positions)) 
  let len = len(positions)
  if len > 0
    let [bufnum, pos] = positions

    call vimside#command#position#Set()

    execute "buffer ". bufnum
    call setpos('.', pos)
  endif
endfunction
