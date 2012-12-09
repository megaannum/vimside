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
        execute "sp ". file
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
      execute "sp ". file
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


