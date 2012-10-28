" ============================================================================
" debug_clear_break.vim
"
" File:          vimside#swank#rpc#debug_clear_break.vim
" Summary:       Vimside RPC debug-clear-break
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
" Version:       1.0
" Modifications:
"
" Tested on vim 7.3 on Linux
"
" Depends upon: NONE
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
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-debug-clear-break-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("debug_clear_break BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugClearBreakCaller(args)
  let cmd = "swank:debug-clear-break"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugClearBreakHandler()

  function! g:DebugClearBreakHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugClearBreakHandler_Ok(sexp_rval)
call s:LOG("DebugClearBreakHandler_Ok ".  vimside#sexp#ToString(a:sexp_rval)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:sexp_rval) 
    if ! found 
      echoe "DebugClearBreak ok: Badly formed Response"
      call s:ERROR("DebugClearBreak ok: Badly formed Response: ". string(a:sexp_rval)) 
      return 0
    endif
call s:LOG("DebugClearBreakHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:DebugClearBreakHandler_Abort"),
    \ 'ok': function("g:DebugClearBreakHandler_Ok") 
    \ }
endfunction
