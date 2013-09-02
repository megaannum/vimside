" ============================================================================
" method_bytecode.vim
"
" File:          vimside#swank#rpc#method_bytecode.vim
" Summary:       Vimside RPC method-bytecode
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Get bytecode for method at file and line.
"
" Arguments:
"   String:The file in which the method is defined.
"   Int:A line within the method's code.
"
" Return:
"   A MethodBytecode
" 
" Example:
"
" (:swank-rpc (swank:method-bytecode "hello.scala" 12) 42)
"
" (:return 
" (:ok (
" :class-name "SomeClassName"
" :name "SomeMethodName"
" :signature ??
" :bytcode ("opName" "opDescription" ...
" )
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#method_bytecode#Run(...)
call s:LOG("method_bytecode TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-method-bytecode-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-method-bytecode-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("method_bytecode BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:MethodBytecodeCaller(args)
  let cmd = "swank:method-bytecode"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:MethodBytecodeHandler()

  function! g:MethodBytecodeHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:MethodBytecodeHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("MethodBytecodeHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:MethodBytecodeHandler_Abort"),
    \ 'ok': function("g:MethodBytecodeHandler_Ok") 
    \ }
endfunction
