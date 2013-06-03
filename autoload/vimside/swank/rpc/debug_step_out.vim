" ============================================================================
" debug_step_out.vim
"
" File:          vimside#swank#rpc#debug_step_out.vim
" Summary:       Vimside RPC debug-step-out
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Step the given thread to the next line. Step into function calls.
"
" Arguments:
"   String:The thread-id to step.
"
" Return: None
"
" Example:
"
" (:swank-rpc (swank:debug-step-out "982398123") 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_step_out#Run(...)
call s:LOG("debug_step_out TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-step-out-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-step-out-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_step_out BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugStepOutCaller(args)
  let cmd = "swank:debug-step-out"
  let active_thread_id = a:args.active_thread_id

  return '('. cmd .' "'. active_thread_id .'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugStepOutHandler()

  function! g:DebugStepOutHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugStepOutHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugStepOutHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugStepOutHandler_Abort"),
    \ 'ok': function("g:DebugStepOutHandler_Ok") 
    \ }
endfunction
