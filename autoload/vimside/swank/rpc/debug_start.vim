" ============================================================================
" debug_start.vim
"
" File:          vimside#swank#rpc#debug_start.vim
" Summary:       Vimside RPC debug-start
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Start a new debug session.
"
" Arguments:
"   String:The commandline to pass to the debugger. Of the form:
"   "package.ClassName arg1 arg2....."
"
" Return: None
"
" Example:
"
" (:swank-rpc (swank:debug-start "org.hello.HelloWorld arg") 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_start#Run(...)
call s:LOG("debug_start TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-start-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-start-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-start-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("debug_start BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugStartCaller(args)
  let cmd = "swank:debug-start"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugStartHandler()

  function! g:DebugStartHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugStartHandler_Ok(sexp_rval)
call s:LOG("DebugStartHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "DebugStart ok: Badly formed Response"
      call s:ERROR("DebugStart ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("DebugStartHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:DebugStartHandler_Abort"),
    \ 'ok': function("g:DebugStartHandler_Ok") 
    \ }
endfunction
