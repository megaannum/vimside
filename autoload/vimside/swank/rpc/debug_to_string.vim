" ============================================================================
" debug_to_string.vim
"
" File:          vimside#swank#rpc#debug_to_string.vim
" Summary:       Vimside RPC debug-to-string
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Returns the result of calling toString on the value at the given location
"
" Arguments:
"   DebugLocation: The location from which to load the value.
"
" Return:
"   A DebugValue
" 
" Example:
"
" (:swank-rpc (swank:debug-to-string (:type 'element
"  :object-id "23" :index 2)) 42)
"
"
" (:return 
" (:ok 
" "A little lamb")
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_to_string#Run(...)
call s:LOG("debug_to_string TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-to-string-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-to-string-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)


call s:LOG("debug_to_string BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugToStringCaller(args)
  let cmd = "swank:debug-to-string"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugToStringHandler()

  function! g:DebugToStringHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugToStringHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugToStringHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugToStringHandler_Abort"),
    \ 'ok': function("g:DebugToStringHandler_Ok") 
    \ }
endfunction
