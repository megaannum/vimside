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
function! vimside#swank#rpc#debug_backtrace#Run(....)
call s:LOG("debug_backtrace TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-backtrace-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-backtrace-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_backtrace BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugBacktraceCaller(args)
  let cmd = "swank:debug-backtrace"
  let active_thread_id = a:args.active_thread_id
  let index = a:args.index
  let number_to_return = a:args.number_to_return

" (:swank-rpc (swank:debug-backtrace "23" 0 2) 42)
  return '('. cmd .' "'. active_thread_id .'" '.index.' '.number_to_return.')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugBacktraceHandler()

  function! g:DebugBacktraceHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugBacktraceHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugBacktraceHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugBacktraceHandler_Abort"),
    \ 'ok': function("g:DebugBacktraceHandler_Ok") 
    \ }
endfunction
