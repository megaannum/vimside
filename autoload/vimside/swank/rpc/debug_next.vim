" ============================================================================
" debug_next.vim
"
" File:          vimside#swank#rpc#debug_next.vim
" Summary:       Vimside RPC debug-next
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
" Step the given thread to the next line. Do not step into function calls.
"
" Arguments:
"   String:The thread-id to step.
"
" Return: None
" 
"
" Example:
"
" (:swank-rpc (swank:debug-next "982398123") 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_next#Next()
call s:LOG("debug_next TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-next-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-next-handler')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-next-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("debug_next BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugNextCaller(args)
  let cmd = "swank:debug-next"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugNextHandler()

  function! g:DebugNextHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugNextHandler_Ok(sexp_rval)
call s:LOG("DebugNextHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "DebugNext ok: Badly formed Response"
      call s:ERROR("DebugNext ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("DebugNextHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:DebugNextHandler_Abort"),
    \ 'ok': function("g:DebugNextHandler_Ok") 
    \ }
endfunction
