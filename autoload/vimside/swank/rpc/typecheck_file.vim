" ============================================================================
" typecheck_file.vim
"
" File:          vimside#swank#rpc#typecheck_file.vim
" Summary:       Vimside RPC typecheck-file
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Request immediate load and check the given source file.

"
" Arguments:
"   String:A filename, absolute or relative to the project.
"
" Return: None
"
" Example:
"
" (swank:typecheck-file
"   "..../.vim/data/vimside/src/main/scala/com/megaanum/Foo.scala")
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
function! vimside#swank#rpc#typecheck_file#Run(...)
call s:LOG("TypecheckFile TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-typecheck-file-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-typecheck-file-caller')
  endif

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr fn
    return
  endif
call s:LOG("TypecheckFile fn=".fn) 

  let l:args = { }
  let l:args['filename'] = fn
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  let l:rr.events = 1
  call vimside#ensime#swank#dispatch(l:rr)

  call vimside#cmdline#Display("This may take a moment...")

call s:LOG("TypecheckFile BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:TypecheckFileCaller(args)
  let cmd = "swank:typecheck-file"
  let fn = a:args.filename

  return '(' . cmd . ' "' . fn . '")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypecheckFileHandler()

  function! g:TypecheckFileHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypecheckFileHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("TypechecFileHandler_Ok diclist=".  string(dic)) 
    return 1
  endfunction

  return { 
    \ 'abort': function("g:TypecheckFileHandler_Abort"),
    \ 'ok': function("g:TypecheckFileHandler_Ok") 
    \ }
endfunction
