" ============================================================================
" typecheck_all.vim
"
" File:          vimside#swank#rpc#typecheck_all.vim
" Summary:       Vimside RPC typecheck-all
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Request immediate load and typecheck of all known sources.
"
" Arguments: None
"
" Return: None
"
" Example:
"
" (swank:typecheck-all)
"
"
" (:clear-all-scala-notes)
"
" Always returns this (bug: unless there are ony Java files)
" (:return (:ok t) 3)
"
" (:scala-notes (:is-full nil :notes ((:severity error :msg "not found: type FOO" :beg 227 :end 227 :line 20 :col 20 :file "/home/emberson/.vim/data/vimside/src/main/scala/com/megaanum/Bar.scala"))))
" and java-notes
"
" (:full-typecheck-finished)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#typecheck_all#Run(...)
call s:LOG("TypecheckAll TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-typecheck-all-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-typecheck-all-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  let l:rr.events = 1
  call vimside#ensime#swank#dispatch(l:rr)

  call vimside#cmdline#Display("This may take a moment...")

call s:LOG("TypecheckAll BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:TypecheckAllCaller(args)
  let cmd = "swank:typecheck-all"

  return '(' . cmd . ')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypecheckAllHandler()

  function! g:TypecheckAllHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypecheckAllHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("TypechecAllHandler_Ok diclist=".  string(dic)) 
    return 1
  endfunction

  return { 
    \ 'abort': function("g:TypecheckAllHandler_Abort"),
    \ 'ok': function("g:TypecheckAllHandler_Ok") 
    \ }
endfunction
