" ============================================================================
" peek_undo.vim
"
" File:          vimside#swank#rpc#peek_undo.vim
" Summary:       Vimside RPC peek-undo
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" The intention of this call is to preview the effect of an undo before
"  executing it.
"
" Arguments: None
"
" Return:
"   (
"   :id //Int:Id of this undo
"   :changes //List of Changes:Describes changes
"   this undo would effect.
"   :summary //String:Summary of action
"   this undo would revert.
"   )
"
" Example:
"
" (:swank-rpc (swank:peek-undo) 42)
"
" (:return 
" (:ok 
" (:id 1 
" :changes (
" (
" :file "/ensime/src/main/scala/org/ensime/server/RPCTarget.scala"
" :text "rpcInitProject" 
" :from 2280 :to 2284
" ) )
" :summary "Refactoring of type: 'rename")
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#peek_undo()
call s:LOG("peek_undo TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-peek-undo-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-peek-undo-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("peek_undo BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:PeekUndoCaller(args)
  let cmd = "swank:peek-undo"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:PeekUndoHandler()

  function! g:PeekUndoHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:PeekUndoHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("PeekUndoHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:PeekUndoHandler_Abort"),
    \ 'ok': function("g:PeekUndoHandler_Ok") 
    \ }
endfunction
