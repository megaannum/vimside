" ============================================================================
" expand_selection.vim
"
" File:          vimside#swank#rpc#expand_selection.vim
" Summary:       Vimside RPC expand-selection
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
" 
" Given a start and end point in a file, expand the selection so that it spans
" the smallest syntactic scope that contains start and end.
"
" Arguments:
"   String:A source filename.
"   Int:The character offset of the start of the input range.
"   Int:The character offset of the end of the input range.
"
" Return:
"   A RangePosition:The expanded range.
" 
" Exmaple:
"
" (:swank-rpc (swank:expand-selection "Model.scala" 4648 4721) 42)
"
" (:return 
" (:ok 
" (:file "Model.scala" :start 4374 :end 14085))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#expand_selection#Run(...)
call s:LOG("expand_selection TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-expand-selection-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-expand-selection-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-expand-selection-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("expand_selection BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ExpandSelectionCaller(args)
  let cmd = "swank:expand-selection"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ExpandSelectionHandler()

  function! g:ExpandSelectionHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:ExpandSelectionHandler_Ok(ExpandSelection)
call s:LOG("ExpandSelectionHandler_Ok ".  vimside#sexp#ToString(a:ExpandSelection)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:ExpandSelection) 
    if ! found 
      echoe "ExpandSelection ok: Badly formed Response"
      call s:ERROR("ExpandSelection ok: Badly formed Response: ". string(a:ExpandSelection)) 
      return 0
    endif
call s:LOG("ExpandSelectionHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:ExpandSelectionHandler_Abort"),
    \ 'ok': function("g:ExpandSelectionHandler_Ok") 
    \ }
endfunction
