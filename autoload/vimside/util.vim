" ============================================================================
" util.vim
"
" File:          vimside#util.vim
" Summary:       Vimside utility code
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================
"

"======================================================================
" Vimside Util
"======================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

" copied from Vim's editexiting.vim
" return 0 or 1
function! vimside#util#GotoExistingSourceLocation(line, file)
  " Is it in the current window
  let l:winnr = bufwinnr(a:file)
  if l:winnr <= 0
    " Not found in current window, look in other tabs
    let bufnr = bufnr(a:fname)
    if bufnr != -1
      for i in range(tabpagenr('$'))
        if index(tabpagebuflist(i + 1), bufnr) >= 0
          " Make this tab page the current one and find the window number.
          execute 'tabnext ' . (i + 1)
          let l:winnr = bufwinnr(a:file)
          break;
        endif     
      endfor      
    endif     
  endif

  if l:winnr > 0
    execute l:winnr . "wincmd w"
    execute ":normal ". l:line  ."G". l:column ." "

    return 1
  else
    return 0
  endif

endfunction

" manditory
"   file
"   line or offset
" optional
"   column   (default: 0 - Number)
"   location (default: same_window)
"      same_window
"      split_window
"      vsplit_window
"      tab_window
"   edit_existing  (default: 0 - Boolean false)
"     if edit_existing == 1 (true), then 
"       if the file is found, then location is ignored
"
" Note that edit_existing == 1 is about the same as
"   location == 'same_window' if file is the window's current file.
function! vimside#util#GotoSourceLocation(dic)
  if ! has_key(a:dic, 'file')
    call s:ERROR("vimside#util#GotoSourceLocation no file attribute") 
    return
  else
    let l:file = fnameescape(fnamemodify(a:dic['file'], ':p'))
  endif
  if has_key(a:dic, 'line')
    let l:line = a:dic['line']
    if has_key(a:dic, 'column')
      let l:column = a:dic['column']
    else
      let l:column = 0
    endif
  elseif  has_key(a:dic, 'offset')
    let l:offset = a:dic['offset']
    let [l:line, l:column] = vimside#util#GetLineColumnFromOffset(l:offset)
  else
    call s:ERROR("vimside#util#GotoSourceLocation no line or offset attribute") 
    return
  endif
  if has_key(a:dic, 'location')
    let l:location = a:dic['location']
    if ! vimside#util#ValidLocation(l:location)
      let l:location = 'same_window'
    endif
  else
    let l:location = 'same_window'
  endif

  if ! has_key(a:dic, 'edit_existing') 
        \ || ! a:dic['edit_existing']
        \ || ! vimside#util#GotoExistingSourceLocation(l:line, l:file)

    let current_file = expand('%:p')

    " TODO do I need to end commands with '!', i.e., tabnew!
    " Note, for now the 'if' and 'then' blocks are the same but
    " they are kept separate so that this might be revisited.
    if current_file == l:file
      if location == 'same_window'
        execute ":normal ". l:line  ."G". l:column ." "
      elseif location == 'split_window'
        execute "split ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      else location == 'vsplit_window'
        execute "vsplit ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      else location == 'tab_window'
        execute "tabnew ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      endif

    else 
      if location == 'same_window'
        execute "edit ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      elseif location == 'split_window'
        execute "split ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      elseif location == 'vsplit_window'
        execute "vsplit ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      else  " location == 'tab_window'
        execute "tabnew ". l:file
        execute ":normal ". l:line  ."G". l:column ." "
      endif
    endif
  endif

endfunction

" returns 
"  'tab_window' or 'split_window' or 'vsplit_window' or 'same_window'
function! vimside#util#GetLocation(option_name, default_location)
  let [found, location] = g:vimside.GetOption(a:option_name)
  if ! found
    call s:ERROR("Option not found '". a:option_name ."'") 
    let location = a:default_location

  elseif location != 'tab_window'
    \ && location != 'split_window'
    \ && location != 'vsplit_window'
    \ && location != 'same_window'
    call s:ERROR("Option '". a:option_name ."' has bad location value '". location ."'") 

    let location = a:default_location
  endif

  return location
endfunction

"   location
"      same_window
"      split_window
"      vsplit_window
"      tab_window
" return 0 or 1
function! vimside#util#ValidLocation(location)
  if location != 'same_window' 
     \ && location != 'split_window'
     \ && location != 'vsplit_window'
     \ && location != 'tab_window'
    return 0
  else
    return 1
  endif
endfunction

" [status, filename]
function! vimside#util#GetCurrentFilename()
  let fn = expand('%:p')
  return (fn == '') ? [0, 'Unknown file name'] : [1, fn ]
  endif
endfunction

" return byte offset into file
function! vimside#util#GetCurrentOffset()
" call s:LOG("vimside#util#GetCurrentOffset line=". line(".") ." col=". col(".")) 
  return line2byte(line("."))+col(".")-1
endfunction

" return [line, column] of offset
function! vimside#util#GetLineColumnFromOffset(offset, ...)
  if a:0 == 0
    " current file
    if a:offset == 0
      return [1, 1]
    else
      let line = byte2line(a:offset)
      let offline = line2byte(line)
      let column = a:offset - offline
      return [line, column]
    endif
  else
    let file = a:1
    let extension = fnamemodify(file, ":e")
    if extension != 'scala' && extension != 'java'
        return [-1, -1]
    else
      try
        execute "silent sp ". file
        let line = byte2line(a:offset)
        let offline = line2byte(line)
        let column = a:offset - offline
        return [line, column]
      finally
        q
      endtry
    endif
  endif
endfunction

" return line, column and line text of offset
function! vimside#util#GetLineColumnTextFromOffset(offset, ...)
  if a:0 == 0
" call s:LOG("GetLineColumnTextFromOffset current file") 
    " current file
    let line = byte2line(a:offset)
    let offline = line2byte(line)
    let column = a:offset - offline
    let text = getline(line)
    return [line, column, text]
  else
    let file = a:1
" call s:LOG("GetLineColumnTextFromOffset file=". file) 
    " There may be a faster way but this is simple
    try
      execute "silent sp ". file
      let line = byte2line(a:offset)
      let offline = line2byte(line)
      let column = a:offset - offline
      let text = getline(line)
      return [line, column, text]
    finally
      q
    endtry
  endif
endfunction


function! vimside#util#CodeDetailsString(code, details)
  let [type, msg] = vimside#ensime#messages#GetProtocolConstant(a:code)
  return msg . "(" . type . "): " . a:details
endfunction

" return 1 if arg is a Number
" return 0 if arg is not a Number with no additional argument
" throws exception if arg si not a Number and there is (any) additional argument
function! vimside#util#IsNumber(arg, ...)
  return (a:0 == 0)
        \ ? s:CheckExpectedType(a:arg, 0)
        \ : s:CheckExpectedType(a:arg, 0, a:000)
endfunction

function! vimside#util#IsString(arg, ...)
  return (a:0 == 0)
        \ ? s:CheckExpectedType(a:arg, 1)
        \ : s:CheckExpectedType(a:arg, 1, a:000)
endfunction

function! vimside#util#IsFuncRef(arg, ...)
  return (a:0 == 0)
        \ ? s:CheckExpectedType(a:arg, 2)
        \ : s:CheckExpectedType(a:arg, 2, a:000)
endfunction

function! vimside#util#IsList(arg, ...)
  return (a:0 == 0)
        \ ? s:CheckExpectedType(a:arg, 3)
        \ : s:CheckExpectedType(a:arg, 3, a:000)
endfunction

function! vimside#util#IsDictionary(arg, ...)
  return (a:0 == 0)
        \ ? s:CheckExpectedType(a:arg, 4)
        \ : s:CheckExpectedType(a:arg, 4, a:000)
endfunction

function! vimside#util#IsFloat(arg, ...)
  return (a:0 == 0)
        \ ? s:CheckExpectedType(a:arg, 5)
        \ : s:CheckExpectedType(a:arg, 5, a:000)
endfunction

" return 1 if arg has type Number equal to expectedTypeNum
" return 0 if arg has type Number not equal to expectedTypeNum
"   and there is no additional argument
" throws exception if arg has type Number not equal to expectedTypeNum
"   and there is (any) additional argument
function! s:CheckExpectedType(arg, expectedTypeNum, ...)
  let l:atypeNum = type(a:arg)
  if l:atypeNum == a:expectedTypeNum
    return 1
  elseif a:0 == 0
    return 0
  else
    let l:argTName = vimside#util#TypeNameFromTypeNumber(l:atypeNum)
    let l:expectedTName = vimside#util#TypeNameFromTypeNumber(a:expectedTypeNum)
    throw "Wrong type: '". l:argTName ."' expected be '". l:expectedTName ."'"
  endif
endfunction

function! vimside#util#TypeName(arg)
  return vimside#util#TypeNameFromTypeNumber(type(a:arg))
endfunction

function! vimside#util#TypeNameFromTypeNumber(typeNum)
  if a:typeNum == 0
    return "Number"
  elseif a:typeNum == 1
    return "String"
  elseif a:typeNum == 2
    return "Funcref"
  elseif a:typeNum == 3
    return "List"
  elseif a:typeNum == 4
    return "Dictionary"
  elseif a:typeNum == 5
    return "Float"
  else
    throw "Unknown type Number '". a:typeNum ."'"
  endif
endfunction


function! vimside#util#Input(msg)
  call vimside#scheduler#HaltFeedKeys()
  try
    return input(a:msg)
  finally
    call vimside#scheduler#ResumeFeedKeys()
  endtry
endfunction


