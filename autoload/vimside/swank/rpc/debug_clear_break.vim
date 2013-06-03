" ============================================================================
" debug_clear_break.vim
"
" File:          vimside#swank#rpc#debug_clear_break.vim
" Summary:       Vimside RPC debug-clear-break
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Clear a breakpoint
"
" Arguments:
"   String:The file from which to clear the breakpoint.
"   Int:The breakpoint line.
"
" Return: None
" 
"
" Example:
"
" (:swank-rpc (swank:debug-clear "hello.scala" 12) 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")



" public API
function! vimside#swank#rpc#debug_clear_break#Run(...)
call s:LOG("debug_clear_break TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-clear-break-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-clear-break-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_clear_break BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugClearBreakCaller(args)
  let cmd = "swank:debug-clear-break"
  let filename = a:args.filename
  let line = a:args.line

  return '('. cmd .' "'. filename .'" '. line .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugClearBreakHandler()

  function! g:DebugClearBreakHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugClearBreakHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugClearBreakHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugClearBreakHandler_Abort"),
    \ 'ok': function("g:DebugClearBreakHandler_Ok") 
    \ }
endfunction
