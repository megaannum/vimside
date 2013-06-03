" ============================================================================
" debug_active_vm.vim
"
" File:          vimside#swank#rpc#debug_active_vm.vim
" Summary:       Vimside RPC debug-active-vm
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Is a there an active vm? if so return a description.
"
" Arguments: None
"
" Return:
"   Nil | A short description of the current vm.
" 
" Example:
"
" (:swank-rpc (swank:debug-active-vm) 42)
"
" (:return 
" (:ok 
" nil or "a description")
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_active_vm#Run(...)
call s:LOG("debug_active_vm TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-active-vm-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-active-vm-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_active_vm BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugActiveVMCaller(args)
  let cmd = "swank:debug-active-vm"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugActiveVMHandler()

  function! g:DebugActiveVMHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugActiveVMHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugActiveVMHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugActiveVMHandler_Abort"),
    \ 'ok': function("g:DebugActiveVMHandler_Ok") 
    \ }
endfunction
