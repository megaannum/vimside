" ============================================================================
" selection.vim
"
" File:          selection.vim
" Summary:       Vimside Selection
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" list of [file, start, end]
let s:selections = []
let s:selection_index = -1
let s:selections_lnum = -1
let s:selections_cnum = -1
let s:selections_offset = -1


function! s:Init()
  let [found, value] = g:vimside.GetOption('swank-rpc-expand-selection-information')
  if ! found
    throw "Vimside: Option not found: "'swank-rpc-expand-selection-information'"
  endif
  if value == 'visual'
    let s:selection_clear = function("vimside#selection#visual#Clear")
    let s:selection_display = function("vimside#selection#visual#Display")
    let s:selection_cursor_moved = function("vimside#selection#visual#CursorMoved")
  elseif value == 'highlight'
    let s:selection_clear = function("vimside#selection#highlight#Clear")
    let s:selection_display = function("vimside#selection#highlight#Display")
    let s:selection_cursor_moved = function("vimside#selection#highlight#CursorMoved")
  else
    throw "Vimside: Option bad value: "'swank-rpc-expand-selection-information' ". value
  endif

endfunction

call s:Init()

function!  vimside#selection#Clear()
call s:LOG("vimside#selection#Clear TOP") 
  let s:selection_index = -1
  let s:selections = []
  call s:selection_clear()
  call s:Init()
call s:LOG("vimside#selection#Clear BOTTOM") 
endfunction

function!  vimside#selection#Add(file, start, end)
call s:LOG("vimside#selection#Add TOP start=". a:start .", end=". a:end) 
  call add(s:selections, [a:file, a:start, a:end])
  let s:selection_index = len(s:selections) - 1

  let [l,c] = vimside#util#GetLineColumnFromOffset(a:start)
call s:LOG("vimside#selection#Add START l=". l .", c=". c) 
  let [l,c] = vimside#util#GetLineColumnFromOffset(a:end)
call s:LOG("vimside#selection#Add END l=". l .", c=". c) 

  let lnum = line(".")
  let cnum = col(".")
call s:LOG("vimside#selection#Add BEFORE lnum=". lnum .", cnum=". cnum) 
  call s:selection_clear()
  call s:selection_display(a:file, a:start, a:end)
  let lnum = line(".")
  let cnum = col(".")
call s:LOG("vimside#selection#Add AFTER lnum=". lnum .", cnum=". cnum) 
call s:LOG("vimside#selection#Add BOTTOM") 
endfunction

function!  vimside#selection#Expand()
call s:LOG("vimside#selection#Expand TOP") 
  let lnum = line(".")
  let cnum = col(".")
call s:LOG("vimside#selection#Expand lnum=". lnum .", cnum=". cnum) 
  let offset = line2byte(lnum)+cnum-1
call s:LOG("vimside#selection#Expand offset=". offset) 

  if s:selections_lnum == -1
call s:LOG("vimside#selection#Expand first time") 
    " first time
    let s:selections_lnum = lnum
    let s:selections_cnum = cnum
    call vimside#swank#rpc#expand_selection#Run()

  elseif s:selection_cursor_moved()
call s:LOG("vimside#selection#Expand moved") 
    " cursor moved
    let s:selections_lnum = lnum
    let s:selections_cnum = cnum
    call vimside#selection#Clear()
    call vimside#swank#rpc#expand_selection#Run()

  else
    let slen = len(s:selections)
    if s:selection_index == -1
call s:LOG("vimside#selection#Expand s:selection_index == -1") 
      call vimside#selection#Clear()
      call vimside#swank#rpc#expand_selection#Run()

    elseif slen == 0
call s:LOG("vimside#selection#Expand slen == 0") 
      call vimside#selection#Clear()
      call vimside#swank#rpc#expand_selection#Run()

    else
      let [file, start, end] = s:selections[0]
      let current_file = expand('%:p')
      if file != current_file
        call vimside#selection#Clear()
        call vimside#swank#rpc#expand_selection#Run()

      elseif s:selection_index + 1 < slen
call s:LOG("vimside#selection#Expand s:selection_index + 1 < slen") 
        let s:selection_index += 1
        let [file, start, end] = s:selections[s:selection_index]
        if file != current_file
          call vimside#selection#Clear()
          call vimside#swank#rpc#expand_selection#Run()
        else
          call s:selection_clear()
          call s:selection_display(file, start, end)
        endif

      else
        let [file, start, end] = s:selections[slen-1]
call s:LOG("vimside#selection#Expand start=". start) 
        if file != current_file
          call vimside#selection#Clear()
          call vimside#swank#rpc#expand_selection#Run()

        elseif start == 0
          call s:selection_clear()
          call s:selection_display(file, start, end)
        else
call s:LOG("vimside#selection#Expand EXPAND") 
          " ok, expand the selection set
          if start > 1
            let start -= 1
          endif

          let dic = {
                 \ 'args': {
                 \   'start': start,
                 \   'end': end
                 \ }
                 \ }
          call vimside#swank#rpc#expand_selection#Run(dic)
        endif
      endif
    endif
  endif

call s:LOG("vimside#selection#Expand BOTTOM") 
endfunction

if 0
function!  vimside#selection#ExpandOLD()
call s:LOG("vimside#selection#Expand") 
  if s:selection_index == -1
    call vimside#selection#Clear()
    return 0
  elseif len(s:selections) == 0
    call vimside#selection#Clear()
    return 0
  else
    let [file, start, end] = s:selections[0]
    let current_file = expand('%:p')
    if file != current_file
      call vimside#selection#Clear()
      return 0
    elseif s:selection_index + 1 < len(s:selections) 
      let s:selection_index += 1
      let [file, start, end] = s:selections[s:selection_index]
      if file != current_file
        call vimside#selection#Clear()
        return 0
      else
        call s:selection_display(file, start, end)
        return 1
      endif
    else
      return 0
    endif
  endif
endfunction
endif

function!  vimside#selection#Contract()
call s:LOG("vimside#selection#Contract TOP") 
call s:LOG("vimside#selection#Contract: s:selection_index=". s:selection_index) 
  if s:selection_index > 0
    let s:selection_index -= 1
call s:LOG("vimside#selection#Contract: len(s:selections)=". len(s:selections)) 
    if len(s:selections) > s:selection_index
      let [file, start, end] = s:selections[s:selection_index]
call s:LOG("vimside#selection#Contract: file=". file) 
      let current_file = expand('%:p')
call s:LOG("vimside#selection#Contract: current_file=". current_file) 
      if file == current_file
        call s:selection_clear()
        call s:selection_display(file, start, end)
      endif
    endif
  else
    call vimside#selection#Clear()
  endif
call s:LOG("vimside#selection#Contract BOTTOM") 
endfunction

