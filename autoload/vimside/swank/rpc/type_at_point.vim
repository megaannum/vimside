" ============================================================================
" type_at_point.vim
"
" File:          vimside#swank#rpc#type_at_point.vim
" Summary:       Vimside RPC type-at-point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Lookup type of thing at given position.
"
" Arguments:
"   String:A source filename.
"   Int:A character offset in the file.
"
" Return:
"   A TypeInfo
"
" Example:
"
" (:swank-rpc (swank:type-at-point "SwankProtocol.scala" 32736) 42)
"
" (:return 
" (:ok 
" (:name "String" :type-id 1188 :full-name
" "java.lang.String" :decl-as class)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#type_at_point#Run(...)
call s:LOG("type_at_point TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-at-point-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-at-point-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("type_at_point BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:TypeAtPointCaller(args)
  let cmd = "swank:type-at-point"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypeAtPointHandler()

  function! g:TypeAtPointHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypeAtPointHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("TypeAtPointHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:TypeAtPointHandler_Abort"),
    \ 'ok': function("g:TypeAtPointHandler_Ok") 
    \ }
endfunction
