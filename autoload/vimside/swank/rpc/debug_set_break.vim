" ============================================================================
" debug_set_break.vim
"
" File:          vimside#swank#rpc#debug_set_break.vim
" Summary:       Vimside RPC debug-set-break
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Add a breakpoint
"
" Arguments:
"   String:The file in which to set the breakpoint.
"   Int:The breakpoint line.
"
" Return: None
" 
" Example:
"
" (:swank-rpc (swank:debug-set-break "hello.scala" 12) 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_set_break#Run(...)
call s:LOG("debug_set_break TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-set-break-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-set-break-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_set_break BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugSetBreakCaller(args)
  let cmd = "swank:debug-set-break"
  let filename = a:args.filename
  let line = a:args.line

  return '('. cmd .' "'. filename .'" '. line .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugSetBreakHandler()

  function! g:DebugSetBreakHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugSetBreakHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugSetBreakHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugSetBreakHandler_Abort"),
    \ 'ok': function("g:DebugSetBreakHandler_Ok") 
    \ }
endfunction
