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
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_start BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugStartCaller(args)
  let cmd = "swank:debug-start"
  let cmd_line = a:args.cmd_line

  return '('. cmd .' "'. cmd_line .'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugStartHandler()

  function! g:DebugStartHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugStartHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugStartHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugStartHandler_Abort"),
    \ 'ok': function("g:DebugStartHandler_Ok") 
    \ }
endfunction
