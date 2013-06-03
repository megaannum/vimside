" ============================================================================
" debug_run.vim
"
" File:          vimside#swank#rpc#debug_run.vim
" Summary:       Vimside RPC debug-run
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Resume execution of the VM.
"
" Arguments: None
"
" Return: None
" 
" Example:
"
" (:swank-rpc (swank:debug-run) 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_run#Run(...)
call s:LOG("debug_run TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-run-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-run-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_run BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugRunCaller(args)
  let cmd = "swank:debug-run"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugRunHandler()

  function! g:DebugRunHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugRunHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugRunHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugRunHandler_Abort"),
    \ 'ok': function("g:DebugRunHandler_Ok") 
    \ }
endfunction
