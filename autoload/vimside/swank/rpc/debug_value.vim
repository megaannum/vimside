" ============================================================================
" debug_value.vim
"
" File:          vimside#swank#rpc#debug_value.vim
" Summary:       Vimside RPC debug-value
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
" Get the value at the given location.
"
" Arguments:
"   DebugLocation: The location from which to load the value.
"
" Return:
"   A DebugValue
"
" Example:
"
" (:swank-rpc (swank:debug-value (:type 'element
" :object-id "23" :index 2)) 42)
"
" (:return 
" (:ok
" (:val-type 'prim :summary "23"
"          :type-name "Integer"))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_value#Value()
call s:LOG("debug_value TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-value-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-value-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-value-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("debug_value BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugValueCaller(args)
  let cmd = "swank:debug-value"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugValueHandler()

  function! g:DebugValueHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugValueHandler_Ok(sexp_rval)
call s:LOG("DebugValueHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "DebugValue ok: Badly formed Response"
      call s:ERROR("DebugValue ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("DebugValueHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:DebugValueHandler_Abort"),
    \ 'ok': function("g:DebugValueHandler_Ok") 
    \ }
endfunction
