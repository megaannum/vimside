" ============================================================================
" type_by_name.vim
"
" File:          vimside#swank#rpc#type_by_name.vim
" Summary:       Vimside RPC type-by-name
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Lookup a type description by name.
"
" Arguments:
"   String:The fully qualified name of a type.
"
" Return:
"   A TypeIfo
"
" Example:
"
" (:swank-rpc (swank:type-by-name "java.lang.String") 42)
"
" (:return 
" (:ok 
" (:name "String" :type-id 1188 
" :full-name "java.lang.String" :decl-as class))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#type_by_name#Run(...)
call s:LOG("type_by_name TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-by-name-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-by-name-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("type_by_name BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:TypeByNameCaller(args)
  let cmd = "swank:type-by-name"
  let name = a:args.name

  return '('. cmd .' "'. name .'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypeByNameHandler()

  function! g:TypeByNameHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypeByNameHandler_Ok(dic, ...)
call s:LOG("TypeByNameHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:TypeByNameHandler_Abort"),
    \ 'ok': function("g:TypeByNameHandler_Ok") 
    \ }
endfunction
