" ============================================================================
" exec_undo.vim
"
" File:          vimside#swank#rpc#exec_undo.vim
" Summary:       Vimside RPC exec-undo
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Execute a specific, server-side undo operation.
"
" Arguments:
"   An integer undo id. See swank:peek-undo for how to learn this id.
"
" Return:
"
" (
" :id //Int:Id of this undo
" :touched-files //List of Strings:Filenames of touched files,
" )
"
" Example:
"
"(:swank-rpc (swank:exec-undo 1) 42)
"
" (:return 
" (:ok 
" (:id 1 
" :touched-files ("/src/main/scala/org/ensime/server/RPCTarget.scala")
" )
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#exec_undo()
call s:LOG("exec_undo TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-exec-undo-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-exec-undo-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("exec_undo BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ExecUndoCaller(args)
  let cmd = "swank:exec-undo"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ExecUndoHandler()

  function! g:ExecUndoHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:ExecUndoHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("ExecUndoHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:ExecUndoHandler_Abort"),
    \ 'ok': function("g:ExecUndoHandler_Ok") 
    \ }
endfunction
