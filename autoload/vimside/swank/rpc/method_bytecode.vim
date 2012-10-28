" ============================================================================
" method_bytecode.vim
"
" File:          vimside#swank#rpc#method_bytecode.vim
" Summary:       Vimside RPC method-bytecode
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
" Version:       1.0
" Modifications:
"
" Tested on vim 7.3 on Linux
"
" Depends upon: NONE
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
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-method-bytecode-handler'
  call s:Error(msg)
  echoerr msg

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

  function! g:MethodBytecodeHandler_Ok(MethodBytecode)
call s:LOG("MethodBytecodeHandler_Ok ".  vimside#sexp#ToString(a:MethodBytecode)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:MethodBytecode) 
    if ! found 
      echoe "MethodBytecode ok: Badly formed Response"
      call s:ERROR("MethodBytecode ok: Badly formed Response: ". string(a:MethodBytecode)) 
      return 0
    endif
call s:LOG("MethodBytecodeHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:MethodBytecodeHandler_Abort"),
    \ 'ok': function("g:MethodBytecodeHandler_Ok") 
    \ }
endfunction
