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
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-step-out-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("debug_step_out BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugStepCaller(args)
  let cmd = "swank:debug-step-out"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugStepHandler()

  function! g:DebugStepHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugStepHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugStepHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugStepHandler_Abort"),
    \ 'ok': function("g:DebugStepHandler_Ok") 
    \ }
endfunction
