" ============================================================================
" expand_selection.vim
"
" File:          vimside#swank#rpc#expand_selection.vim
" Summary:       Vimside RPC expand-selection
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Given a start and end point in a file, expand the selection so that it spans
" the smallest syntactic scope that contains start and end.
"
" Arguments:
"   String:A source filename.
"   Int:The character offset of the start of the input range.
"   Int:The character offset of the end of the input range.
"
" Return:
"   A RangePosition:The expanded range.
" 
" Exmaple:
"
" (:swank-rpc (swank:expand-selection "Model.scala" 4648 4721) 42)
"
" (:return 
" (:ok 
" (:file "Model.scala" :start 4374 :end 14085))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#expand_selection#Run(...)
call s:LOG("expand_selection TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-expand-selection-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-expand-selection-caller')
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
  let l:args['start'] = offset
  let l:args['end'] = offset
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("expand_selection BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ExpandSelectionCaller(args)
  let cmd = "swank:expand-selection"
  let fn = a:args.filename
  let start_range = a:args.start
  let end_range = a:args.end

  return '('. cmd .' "'. fn .'" '. start_range .' '. end_range .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ExpandSelectionHandler()

  function! g:ExpandSelectionHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:ExpandSelectionHandler_Ok(dic, ...)
    let dic = a:dic
"call s:LOG("ExpandSelectionHandler_Ok dic=".  string(dic)) 

    let current_file = expand('%:p')
    let file = dic[':file']
    let start = dic[':start']
    let end = dic[':end']

    call vimside#command#selection#Add(file, start, end)

    return 1
  endfunction

  return { 
    \ 'abort': function("g:ExpandSelectionHandler_Abort"),
    \ 'ok': function("g:ExpandSelectionHandler_Ok") 
    \ }
endfunction
