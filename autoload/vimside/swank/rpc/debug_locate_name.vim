" ============================================================================
" debug_locate_name.vim
"
" File:          vimside#swank#rpc#debug_locate_name.vim
" Summary:       Vimside RPC debug-locate-name
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Get the binding location for the given name at this point in the program's
"   execution.
"
" Arguments:
"   String: The thread-id in which to search.
"   String: The name to search for.
"
" Return:
"   A DebugLocation
" 
" Example:
"
" (:swank-rpc (swank:debug-locate-name "thread-2" "apple") 42)
"
" (:return 
" (:ok 
"  (:slot :thread-id "thread-2" :frame 2 :offset 0))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#debug_locate_name#Run(...)
call s:LOG("debug_locate_name TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-locate-name-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-debug-locate-name-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("debug_locate_name BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:DebugLocateNameCaller(args)
  let cmd = "swank:debug-locate-name"
  let thread_id = a:args.thread_id
  let name = a:args.name

  return '('. cmd '"'. thread_id .'" "'.name.'")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:DebugLocateNameHandler()

  function! g:DebugLocateNameHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:DebugLocateNameHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("DebugLocateNameHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:DebugLocateNameHandler_Abort"),
    \ 'ok': function("g:DebugLocateNameHandler_Ok") 
    \ }
endfunction
