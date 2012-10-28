" ============================================================================
" debug_backtrace.vim
"
" File:          vimside#swank#rpc#debug_backtrace.vim
" Summary:       Vimside RPC debug-backtrace
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Get a detailed backtrace for the given thread
"
" Arguments:
"   String: The unique id of the thread.
"   Int: The index of the first frame to list. The 0th frame is the
"     currently executing frame.
"   Int: The number of frames to return. -1 denotes _all_ frames.
"
" Return:
"   A DebugBacktrace
" 
"
" Example:
"
" (:swank-rpc (swank:debug-backtrace "23" 0 2) 42)
"
" (:return 
" (:ok
" (:frames () :thread-id "23" :thread-name "main")) 
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_backtrace#Backtrace()
call s:LOG("debug_backtrace TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-backtrace-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-backtrace-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-backtrace-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("debug_backtrace BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugBacktraceCaller(args)
  let cmd = "swank:debug-backtrace"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugBacktraceHandler()

  function! g:DebugBacktraceHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugBacktraceHandler_Ok(sexp_rval)
call s:LOG("DebugBacktraceHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "DebugBacktrace ok: Badly formed Response"
      call s:ERROR("DebugBacktrace ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("DebugBacktraceHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:DebugBacktraceHandler_Abort"),
    \ 'ok': function("g:DebugBacktraceHandler_Ok") 
    \ }
endfunction
