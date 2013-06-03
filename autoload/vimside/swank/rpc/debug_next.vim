" ============================================================================
" debug_next.vim
"
" File:          vimside#swank#rpc#debug_next.vim
" Summary:       Vimside RPC debug-next
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
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
function! vimside#swank#rpc#debug_next#Run(...)
call s:LOG("debug_next TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-next-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-next-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_next BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugNextCaller(args)
  let cmd = "swank:debug-next"
  let active_thread_id = a:args.active_thread_id

  return '('. cmd .' "'. active_thread_id .'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugNextHandler()

  function! g:DebugNextHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugNextHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugNextHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugNextHandler_Abort"),
    \ 'ok': function("g:DebugNextHandler_Ok") 
    \ }
endfunction
