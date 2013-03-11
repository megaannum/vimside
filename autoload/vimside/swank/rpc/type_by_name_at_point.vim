" ============================================================================
" type_by_name_at_point.vim
"
" File:          vimside#swank#rpc#type_by_name_at_point.vim
" Summary:       Vimside RPC type-by-name-at-point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Lookup a type by name, in a specific source context.
"
" Arguments:
"   String:The local or qualified name of the type.
"   String:A source filename.
"   Int:A character offset in the file.
"
" Return:
"   A TypeInfo
"
" Example:
"
" (:swank-rpc (swank:type-by-name-at-point "String" "SwankProtocol.scala" 31680) 42)
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
function! vimside#swank#rpc#type_by_name_at_point#Run(...)
call s:LOG("type_by_name_at_point TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-by-name_at_point-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-type-by-name_at_point-caller')
  endif

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr fn
    return
  endif
  
  let offset = vimside#util#GetCurrentOffset()

  let l:args = { }
  let l:args['filename'] = fn
  let l:args['offset'] = offset
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("type_by_name_at_point BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:TypeByNameAtPointCaller(args)
  let cmd = "swank:type-by-name-at-point"
  let type_name = a:args.type_name
  let fn = a:args.filename
  let offset = a:args.offset

  return '('. cmd .' "'. type_name .'" "'. fn .'" '. offset .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypeByNameAtPointHandler()

  function! g:TypeByNameAtPointHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypeByNameAtPointHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("TypeByNameAtPointHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:TypeByNameAtPointHandler_Abort"),
    \ 'ok': function("g:TypeByNameAtPointHandler_Ok") 
    \ }
endfunction
