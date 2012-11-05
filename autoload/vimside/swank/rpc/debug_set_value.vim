" ============================================================================
" debug_set_value.vim
"
" File:          vimside#swank#rpc#debug_set_value.vim
" Summary:       Vimside RPC debug-set-value
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Set the value at the given location.
"
" Arguments:
"   DebugLocation: Location to set value.
"   String: A string encoded value.
"
" Return:
"   Boolean: t on success, nil otherwise
" 
" Example:
"
" (:swank-rpc (swank:debug-set-stack-var (:type 'element
" :object-id "23" :index 2) "1") 42)
"
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_set_value#Run(...)
call s:LOG("debug_set_value TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-set-value-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-set-value-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-set-value-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("debug_set_value BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugSetValueCaller(args)
  let cmd = "swank:debug-set-value"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugSetValueHandler()

  function! g:DebugSetValueHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugSetValueHandler_Ok(sexp_rval)
call s:LOG("DebugSetValueHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "DebugSetValue ok: Badly formed Response"
      call s:ERROR("DebugSetValue ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("DebugSetValueHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:DebugSetValueHandler_Abort"),
    \ 'ok': function("g:DebugSetValueHandler_Ok") 
    \ }
endfunction
