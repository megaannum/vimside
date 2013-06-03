" ============================================================================
" debug_continue.vim
"
" File:          vimside#swank#rpc#debug_continue.vim
" Summary:       Vimside RPC debug-continue
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Resume execution of the VM.
"
" Arguments:
"   String:The thread-id to continue.
"
" Return: None
" 
" Example:
"
" (:swank-rpc (swank:debug-continue "1") 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_continue#Run(...)
call s:LOG("debug_continue TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-continue-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-continue-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_continue BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugContinueCaller(args)
  let cmd = "swank:debug-continue"
  let active_thread_id = a:args.active_thread_id

  return '('. cmd .' "'. active_thread_id .'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugContinueHandler()

  function! g:DebugContinueHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugContinueHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugContinueHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugContinueHandler_Abort"),
    \ 'ok': function("g:DebugContinueHandler_Ok") 
    \ }
endfunction
