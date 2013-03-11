" ============================================================================
" inspect_type_at_point.vim
"
" File:          vimside#swank#rpc#inspect_type_at_point.vim
" Summary:       Vimside RPC inspect-type-at-point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Lookup detailed type of thing at given position.
"
" Arguments:
"   String:A source filename.
"   Int:A character offset in the file.
"
" Return:
"   A TypeInspectInfo
"
" Example:
"
" (:swank-rpc (swank:inspect-type-at-point "SwankProtocol.scala" 32736) 42)
"
" (:return 
" (:ok 
" (:type (:name "SExpList$" :type-id 1469 :full-name
" "org.ensime.util.SExpList$" :decl-as object :pos
" (:file "SExp.scala" :offset 1877))......))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#inspect_type_at_point#Run(...)
call s:LOG("inspect_type_at_point TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-inspect-type-at-point-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-inspect-type-at-point-caller')
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

call s:LOG("inspect_type_at_point BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:InspectTypeAtPointCaller(args)
  let cmd = "swank:inspect-type-at-point"
  let fn = a:args.filename
  let offset = a:args.offset

  return '('. cmd .' "'. fn .'" '. offset .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:InspectTypeAtPointHandler()

  function! g:InspectTypeAtPointHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:InspectTypeAtPointHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("InspectTypeAtPointHandler_Ok dic=".  string(dic)) 

    " let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:InspectTypeAtPointHandler_Abort"),
    \ 'ok': function("g:InspectTypeAtPointHandler_Ok") 
    \ }
endfunction
