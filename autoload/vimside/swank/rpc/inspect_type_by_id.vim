" ============================================================================
" inspect_type_by_id.vim
"
" File:          vimside#swank#rpc#inspect_type_by_id.vim
" Summary:       Vimside RPC inspect-type-by-id
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Lookup detailed type description by id
"
" Arguments:
"   Int:A type id.
"
" Return:
"   A TypeInspectInfo
"
" Example:
"
" (:swank-rpc (swank:inspect-type-by-id 232) 42)
"
" (:return 
" (:ok 
" (:type (:name "SExpList$" :type-id 1469 :full-name
" "org.ensime.util.SExpList$" :decl-as object :pos
" (:file "SExp.scala" :offset 1877))......)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#inspect_type_by_id#Run(...)
call s:LOG("inspect_type_by_id TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-inspect-type-by-id-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-inspect-type-by-id-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-inspect-type-by-id-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("inspect_type_by_id BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:InspectTypeByIdCaller(args)
  let cmd = "swank:inspect-type-by-id"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:InspectTypeByIdHandler()

  function! g:InspectTypeByIdHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:InspectTypeByIdHandler_Ok(sexp_rval)
call s:LOG("InspectTypeByIdHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "InspectTypeById ok: Badly formed Response"
      call s:ERROR("InspectTypeById ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("InspectTypeByIdHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:InspectTypeByIdHandler_Abort"),
    \ 'ok': function("g:InspectTypeByIdHandler_Ok") 
    \ }
endfunction
