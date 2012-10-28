" ============================================================================
" type_by_id.vim
"
" File:          vimside#swank#rpc#type_by_id.vim
" Summary:       Vimside RPC type-by-id
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
" Request description of the type with given type id.
"
" Arguments:
"   Int:A type id.
" Return:
"   A TypeIfo
"
" Example:
"
" (:swank-rpc (swank:type-by-id 1381) 42)
"
" (:return 
" (:ok 
" (:name "Option" :type-id 1381 :full-name "scala.Option"
"  :decl-as class :type-args ((:name "Int" :type-id 1129 :full-name
"  "scala.Int"
"  :decl-as class)))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#type_by_id#Run(...)
call s:LOG("type_by_id TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-by-id-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-by-id-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-type-by-id-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("type_by_id BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:TypeByIdCaller(args)
  let cmd = "swank:type-by-id"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypeByIdHandler()

  function! g:TypeByIdHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypeByIdHandler_Ok(sexp_rval)
call s:LOG("TypeByIdHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "TypeById ok: Badly formed Response"
      call s:ERROR("TypeById ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("TypeByIdHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:TypeByIdHandler_Abort"),
    \ 'ok': function("g:TypeByIdHandler_Ok") 
    \ }
endfunction
