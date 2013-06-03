" ============================================================================
" debug_clear_all_breaks.vim
"
" File:          vimside#swank#rpc#debug_clear_all_breaks.vim
" Summary:       Vimside RPC debug-clear-all-breaks
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Clear all breakpoints
"
" Arguments: None
"
" Return: None
"
" Example:
"
" (:swank-rpc (swank:debug-clear-all-breaks) 42)
"
" (:return 
" (:ok t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_clear_all_breaks#Run(...)
call s:LOG("debug_clear_all_breaks TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-clear-all-breaks-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-clear-all-breaks-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_clear_all_breaks BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugClearAllBreaksCaller(args)
  let cmd = "swank:debug-clear-all-breaks"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugClearAllBreaksHandler()

  function! g:DebugClearAllBreaksHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugClearAllBreaksHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugClearAllBreaksHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugClearAllBreaksHandler_Abort"),
    \ 'ok': function("g:DebugClearAllBreaksHandler_Ok") 
    \ }
endfunction
