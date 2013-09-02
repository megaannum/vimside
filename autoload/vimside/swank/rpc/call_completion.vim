" ============================================================================
" call_completion.vim
"
" File:          vimside#swank#rpc#call_completion.vim
" Summary:       Vimside RPC call-completion
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" 
" Lookup the type information of a specific method or function type. This is
"   used by ENSIME to retrieve detailed parameter and return type information
"   after the user has selected a method or function completion.
"
" Arguments:
"   Int:A type id, as returned by swank:scope-completion or swank:type-completion.
" Return:
"   A CallCompletionInfo
"
" Example:
"
" (:return 
" (:ok 
" (:result-type (:name "Unit" :type-id 7 :full-name
" "scala.Unit" :decl-as class) :param-sections ((:params (("id"
" (:name "Int" :type-id 74 :full-name "scala.Int" :decl-as class))
" ("callId" (:name "Int" :type-id 74 :full-name "scala.Int" 
" :decl-as class))))))
" 42))
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#call_completion#Run(...)
call s:LOG("call_completion TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-call-completion-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-call-completion-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("call_completion BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:CallCompletionCaller(args)
  let cmd = "swank:call-completion"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:CallCompletionHandler()

  function! g:CallCompletionHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:CallCompletionHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("CallCompletionHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:CallCompletionHandler_Abort"),
    \ 'ok': function("g:CallCompletionHandler_Ok") 
    \ }
endfunction
