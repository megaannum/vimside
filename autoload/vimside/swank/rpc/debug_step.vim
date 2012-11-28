" ============================================================================
" debug_step.vim
"
" File:          vimside#swank#rpc#debug_step.vim
" Summary:       Vimside RPC debug-step
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Step the given thread to the next line. Step out of the current function to
"   the calling frame if necessary.
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
function! vimside#swank#rpc#debug_step#Run(...)
call s:LOG("debug_step TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-step-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-step-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-step-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("debug_step BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugStepOutCaller(args)
  let cmd = "swank:debug-step"

  return '('. cmd .')'
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
