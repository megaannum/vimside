" ============================================================================
" cancelc_refactor.vim
"
" File:          vimside#swank#rpc#cancelc_refactor.vim
" Summary:       Vimside RPC cancelc-refactor
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
" Cancel a refactor that's been performed but not executed.
" Arguments:
"   Int:Procedure Id of the refactoring.
" Return: None
" 
" Example:
"
" (:swank-rpc (swank:cancel-refactor 1) 42)
"
" (:return 
" (:ok r)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#cancelc_refactor#Run(...)
call s:LOG("cancelc_refactor TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-cancelc-refactor-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-cancelc-refactor-handler')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-cancelc-refactor-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("cancelc_refactor BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:CancelRefactorCaller(args)
  let cmd = "swank:cancelc-refactor"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:CancelRefactorHandler()

  function! g:CancelRefactorHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:CancelRefactorHandler_Ok(CancelRefactor)
call s:LOG("CancelRefactorHandler_Ok ".  vimside#sexp#ToString(a:CancelRefactor)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:CancelRefactor) 
    if ! found 
      echoe "CancelRefactor ok: Badly formed Response"
      call s:ERROR("CancelRefactor ok: Badly formed Response: ". string(a:CancelRefactor)) 
      return 0
    endif
call s:LOG("CancelRefactorHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:CancelRefactorHandler_Abort"),
    \ 'ok': function("g:CancelRefactorHandler_Ok") 
    \ }
endfunction
