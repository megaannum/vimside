" ============================================================================
" debug_value.vim
"
" File:          vimside#swank#rpc#debug_value.vim
" Summary:       Vimside RPC debug-value
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Get the value at the given location.
"
" Arguments:
"   DebugLocation: The location from which to load the value.
"
" Return:
"   A DebugValue
"
" Example:
"
" (:swank-rpc (swank:debug-value (:type 'element
" :object-id "23" :index 2)) 42)
"
" (:return 
" (:ok
" (:val-type 'prim :summary "23"
"          :type-name "Integer"))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_value#Run(...)
call s:LOG("debug_value TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-value-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-value-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_value BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugValueCaller(args)
  let cmd = "swank:debug-value"
  let type = a:args.type

  if type == 'reference'
    let object_id = a:args.object_id
    return '('. cmd .' :type '. type .' :object-id '. object_id .')'
  elseif type == 'field'
    let object_id = a:args.object_id
    let field = a:args.field
    return '('. cmd .' :type '. type .' :object-id '. object_id .' :field "'. field .'")'
  elseif type == 'element'
    let object_id = a:args.object_id
    let index = a:args.index
    return '('. cmd .' :type '. type .' :object-id '. object_id .' :index '. index .')'
  elseif type == 'slot'
    let thread_id = a:args.thread_id
    let frame = a:args.frame
    let offset = a:args.offset
    return '('. cmd .' :type '. type .' :thread-id "'. thread_id .'" :frame '. frame .' :offset '. offset .')'
  else
    throw "Bad DebugValue type: ". type
  endif
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugValueHandler()

  function! g:DebugValueHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugValueHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugValueHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugValueHandler_Abort"),
    \ 'ok': function("g:DebugValueHandler_Ok") 
    \ }
endfunction
