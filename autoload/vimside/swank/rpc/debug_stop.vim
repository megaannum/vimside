" ============================================================================
" debug_stop.vim
"
" File:          vimside#swank#rpc#debug_stop.vim
" Summary:       Vimside RPC debug-stop
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Stop the debug session
"
" Arguments: None
"
" Return: None
"
" Example:
"
" (:swank-rpc (swank:debug-stop) 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_stop#Run(...)
call s:LOG("debug_stop TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-stop-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-stop-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_stop BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugStopCaller(args)
  let cmd = "swank:debug-stop"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugStopHandler()

  function! g:DebugStopHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugStopHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugStopHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugStopHandler_Abort"),
    \ 'ok': function("g:DebugStopHandler_Ok") 
    \ }
endfunction
