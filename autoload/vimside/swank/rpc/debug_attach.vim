" ============================================================================
" debug_attach.vim
"
" File:          vimside#swank#rpc#debug_attach.vim
" Summary:       Vimside RPC debug-attach
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Start a new debug session on a target vm.
"
" Arguments:
"   String: The hostname of the vm
"   String: The debug port of the vm
"   Return: None
"
" Example:
"
" (:swank-rpc (swank:debug-attach "localhost" "9000") 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_attach#Run(...)
call s:LOG("debug_attach TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-attach-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-attach-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_attach BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugAttachCaller(args)
  let cmd = "swank:debug-attach"
  let hostname = a:args.hostname
  let port = a:args.port

  return '('. cmd .' "'. hostname .'" "'. port .'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugAttachHandler()

  function! g:DebugAttachHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugAttachHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugAttachHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugAttachHandler_Abort"),
    \ 'ok': function("g:DebugAttachHandler_Ok") 
    \ }
endfunction
