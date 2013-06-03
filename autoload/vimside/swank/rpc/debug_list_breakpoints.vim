" ============================================================================
" debug_list_breakpoints.vim
"
" File:          vimside#swank#rpc#debug_list_breakpoints.vim
" Summary:       Vimside RPC debug-list-breakpoints
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Get a list of all breakpoints set so far.
"
" Arguments: None
"
" Return:
"   List of Position:A list of positions
"
" Example:
"
" (:swank-rpc (swank:debug-list-breakpoints) 42)
"
" (:return 
" (:ok 
" (:file "hello.scala" :line 1)
" (:file "hello.scala" :line 23))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_list_breakpoints#Run(...)
call s:LOG("debug_list_breakpoints TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-list-breakpoints-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-list-breakpoints-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_list_breakpoints BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugListBreakpointsCaller(args)
  let cmd = "swank:debug-list-breakpoints"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugListBreakpointsHandler()

  function! g:DebugListBreakpointsHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugListBreakpointsHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugListBreakpointsHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugListBreakpointsHandler_Abort"),
    \ 'ok': function("g:DebugListBreakpointsHandler_Ok") 
    \ }
endfunction
