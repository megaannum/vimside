" ============================================================================
" completions.vim
"
" File:          completions.vim
" Summary:       Vimside Compeltions
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:completions_phase = 0
let g:completions_in_process = 0
let s:completions_start = 0
let g:completions_base = ''
let g:completions_results = []

function! vimside#command#completions#Run(findstart, base)
" call s:LOG("vimside#command#completions#Run( findstart=". a:findstart .", base=". a:base) 
  if ! exists("g:vimside.started")
    return
  endif
  if ! g:vimside.started
    return
  endif

" call s:LOG("vimside#command#completions#Run( completions_phase=". s:completions_phase) 

  if s:completions_phase == 0
    " Get Completions
    if a:findstart 
      let g:completions_in_process = 1
      w
      let line = getline('.')
      let pos = col('.') -1
      let bc = strpart(line,0,pos)
      let match_text = matchstr(bc, '\zs[^ \t#().[\]{}\''\";: ]*$')
" call s:LOG("vimside#command#completions#Run( match_text=". match_text) 
      let s:completions_start = len(bc)-len(match_text)
" call s:LOG("vimside#command#completions#Run( completions_start=". s:completions_start) 
      call vimside#command#completions#StartAutoCmd()
      return s:completions_start 
    elseif ! g:completions_in_process
      return []
    else
      if len(a:base) > 0
        let g:completions_base = a:base
        let g:completions_results = []
        call vimside#swank#rpc#completions#Run()
        let s:completions_phase = 1
      else
        let s:completions_phase = 0
      endif
" call s:LOG("vimside#command#completions#Run( return []")
      return []
    endif
  elseif ! g:completions_in_process
    if a:findstart 
      return ''
    else
      return []
    endif
  else
    " Display Completions
    if a:findstart 
" call s:LOG("vimside#command#completions#Run( completions_start=". s:completions_start) 
      return s:completions_start
    else
      let s:completions_phase = 0
      let g:completions_base = ''
" call s:LOG("vimside#command#completions#Run( g:completions_results=". string(g:completions_results))
      let g:completions_in_process = 0
      call vimside#command#completions#StopAutoCmd()
      return g:completions_results
    endif

  endif
endfunction

function!  vimside#command#completions#Abort()
" call s:LOG("vimside#command#completions#Abort") 
  if pumvisible() == 0
    let s:completions_phase = 0
    let g:completions_in_process = 0
    call vimside#command#completions#StopAutoCmd()
  endif
endfunction

function!  vimside#command#completions#StartAutoCmd()
  augroup VIMSIDE_COMPLETIONS
    au!
    autocmd CursorMovedI,InsertLeave *.scala call vimside#command#completions#Abort()
  augroup end
endfunction

function!  vimside#command#completions#StopAutoCmd()
  augroup VIMSIDE_COMPLETIONS
    au!
  augroup END
endfunction
