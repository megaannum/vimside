" ============================================================================
" visual.vim
"
" File:          visual.vim
" Summary:       Vimside Visual Selection display
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Use Vim's visual selection to display syntax region.
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:line_start = -1
let s:line_end = -1

function! vimside#command#selection#visual#Clear()
call s:LOG("vimside#command#selection#visual#Clear: TOP") 
  let m = mode()
  if m == 'v' || m == 'V' || m == "\<C-v>"
    execute "normal v"
  endif
endfunction

function! vimside#command#selection#visual#CursorMoved()
  let lnum = line(".")
call s:LOG("vimside#command#selection#visual#CursorMoved: lnum=". lnum) 
  return lnum < s:line_start || lnum > s:line_end
endfunction

function! vimside#command#selection#visual#Display(file, start, end)
" call s:LOG("vimside#command#selection#visual#Display: start=". a:start .", end=". a:end) 
  let current_file = expand('%:p')
  if a:file == current_file
    let [s:line_start,_] = vimside#util#GetLineColumnFromOffset(a:start-1)
    let [s:line_end,_] = vimside#util#GetLineColumnFromOffset(a:end)
call s:LOG("vimside#command#selection#visual#Display: line_start=". s:line_start) 
call s:LOG("vimside#command#selection#visual#Display: line_end=". s:line_end) 

    execute "goto ". (a:start+1)
    execute "normal v"
    execute "goto ". a:end
  endif
endfunction
