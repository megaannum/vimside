" ============================================================================
" highlight.vim
"
" File:          highlight.vim
" Summary:       Vimside Highlight Selection display
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Use Vim's highlight selection to display syntax region.
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! s:GetOption(name)
  let [found, value] = g:vimside.GetOption(a:name)
  if ! found
    throw "Option not found: '". a:name ."'
  endif
  return value
endfunction

function! s:Color_2_Number(color)
  " is it a name
  let rgbtxt = forms#color#util#ConvertName_2_RGB(a:color)
  if rgbtxt == ''
    let nos = forms#color#term#ConvertRGBTxt_2_Int(a:color)
  else
    let nos = forms#color#term#ConvertRGBTxt_2_Int(rgbtxt)
  endif
  return nos
endfunction

function! s:InitGui()
  if &background == 'light' 
    let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-light')

  else " &background == 'dark'
    let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-dark')
  endif
call s:LOG("s:InitGui: selectedColor=". selectedColor) 
  execute "hi VimsideSeclection_HL gui=bold guibg=#" . selectedColor
endfunction

function! s:InitCTerm()
  if g:vimside.plugins.forms
    if &background == 'light' 
      let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-light')
    else " &background == 'dark'
      let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-dark')
    endif
call s:LOG("s:InitCTerm: selectedColor=". selectedColor) 
    let selectedNumber = s:Color_2_Number(selectedColor)
  else
    if &background == 'light' 
      " TODO: hardcode for now
      let selectedNumber = '87'
    else " &background == 'dark'
      " TODO: hardcode for now
      let selectedNumber = '87'
    endif
  endif
call s:LOG("s:InitCTerm: selectedNumber=". selectedNumber) 
  execute "hi VimsideSeclection_HL cterm=bold ctermbg=" . selectedNumber
endfunction

function! s:Initialize()
  if has("gui_running")
    call s:InitGui()
  else
    call s:InitCTerm()
  endif
endfunction

call s:Initialize()

function! s:GetMatchRanges(line1, line2, column1, column2)
  let lnum1 = a:line1
  let lnum2 = a:line2
  let col1 = a:column1
  let col2 = a:column2

  if lnum1 == lnum2
    " one lines
    if col1 == 1
      let range = [ '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(col2+2).'v' ]
    else
      let range = [ '\%'.lnum1.'l\%>'.(col1+1).'v.*\%<'.(col2+2).'v' ]
    endif
  elseif lnum1+1 == lnum2
    " two lines
    " let range1 = '\%'.lnum1.'l\%>'.(col1+1).'v.*\%<'.(80).'v'
    if col1 == 1
      let range1 = '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(80).'v'
    else
      let range1 = '\%'.lnum1.'l\%>'.(col1+1).'v.*\%<'.(80).'v'
    endif
    let range2 = '\%'.lnum2.'l\%>'.(1).'v.*\%<'.(col2+1).'v'
    let range = [ range1, range2 ]
  else
    " general case
    let range = [ ]
    if col1 == 1
      let range_start = '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(80).'v'
    else
      let range_start = '\%'.lnum1.'l\%>'.(col1+1).'v.*\%<'.(80).'v'
    endif
    call add(range, range_start)

    let range_mid =
             \'\%>'.(0).'v'.
             \'\%<'.(80).'v'.
             \'\%>'.(lnum1).'l'.
             \'\%<'.(lnum2).'l'.
             \'.'
    call add(range, range_mid)

    let range_end = '\%'.lnum2.'l\%>'.(0).'v.*\%<'.(col2+2).'v'
    call add(range, range_end)

  endif
" call s:LOG("s:GetMatchRanges: range=". string(range)) 
  return range
endfunction


let s:line_start = -1
let s:line_end = -1
let s:auto_set = 0
call s:LOG("vimside#command#selection#highlight# LOADING ") 

function! vimside#command#selection#highlight#SetAutoCmds()
  if ! s:auto_set
    augroup VIMSIDE_SELECT_HL
      autocmd!
      autocmd CursorMoved * call vimside#command#selection#Clear()
      autocmd BufLeave * call vimside#command#selection#Clear()
    augroup END
    let s:auto_set = 1
  endif
endfunction

function! vimside#command#selection#highlight#RemoveAutoCmds()
  if s:auto_set
    augroup VIMSIDE_SELECT_HL
      autocmd!
    augroup END
    let s:auto_set = 0
  endif
endfunction

function! vimside#command#selection#highlight#CursorMoved()
  let lnum = line(".")
call s:LOG("vimside#command#selection#highlight#CursorMoved: lnum=". lnum) 
" call s:LOG("vimside#command#selection#highlight#CursorMoved: s:line_start=". s:line_start) 
" call s:LOG("vimside#command#selection#highlight#CursorMoved: s:line_end=". s:line_end) 
  return lnum < s:line_start || lnum > s:line_end
endfunction

function! vimside#command#selection#highlight#Clear()
call s:LOG("vimside#command#selection#highlight#Clear: TOP") 
  call vimside#command#selection#highlight#RemoveAutoCmds()
  if exists("s:sids")
call s:LOG("vimside#command#selection#highlight#Clear: clearing sids") 
    for sid in s:sids
call s:LOG("vimside#command#selection#highlight#Clear: clear sid=". sid) 
      try
        if matchdelete(sid) == -1
call s:LOG("vimside#command#selection#highlight#Clear: failed to clear sid=". sid) 
        endif
      catch /.*/
call s:ERROR("vimside#command#selection#highlight#Clear: sid=". sid) 
      endtry
    endfor
    unlet s:sids
  endif
call s:LOG("vimside#command#selection#highlight#Clear: matches=". string(getmatches())) 
call s:LOG("vimside#command#selection#highlight#Clear: BOTTOM") 
endfunction

function! vimside#command#selection#highlight#Display(file, start, end)
call s:LOG("vimside#command#selection#highlight#Display: start=". a:start .", end=". a:end) 
  call vimside#command#selection#highlight#SetAutoCmds()
  let current_file = expand('%:p')
  if a:file == current_file
    let [line1, column1] = vimside#util#GetLineColumnFromOffset(a:start)
    let [line2, column2] = vimside#util#GetLineColumnFromOffset(a:end)
    let s:line_start = line1
    let s:line_end = line2
call s:LOG("vimside#command#selection#highlight#Display: line1=". line1 .", column1=". column1) 
call s:LOG("vimside#command#selection#highlight#Display: line2=". line2 .", column2=". column2) 
call s:LOG("vimside#command#selection#highlight#Display: s:line_start=". s:line_start) 
call s:LOG("vimside#command#selection#highlight#Display: s:line_end=". s:line_end) 

    let patterns = s:GetMatchRanges(line1, line2, column1, column2)
    let s:sids = []
    for pattern in patterns
      let sid = matchadd("VimsideSeclection_HL", pattern)
call s:LOG("vimside#command#selection#highlight#Display: sid=". sid) 
      call add(s:sids, sid)
    endfor
  endif
endfunction

