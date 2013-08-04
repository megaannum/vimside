" ============================================================================
" uses_of_symbol_at_point.vim
"
" File:          vimside#swank#rpc#uses_of_symbol_at_point.vim
" Summary:       Vimside RPC uses-of-symbol-at-point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Request all source locations where indicated symbol is used in this project.
"
" Arguments:
" String:A Scala source filename, absolute or relative to the project.
" Int:Character offset of the desired symbol within that file.
"
" Return:
" List of RangePosition:Locations where the symbol is reference.
"
" Example:
"
" (:swank-rpc (swank:uses-of-symbol-at-point "Test.scala" 11334) 42)
"
" (:return (:ok ((:file "RichPresentationCompiler.scala"
" :offset 11442
" :start 11428 :end 11849) (:file
" "RichPresentationCompiler.scala"
" :offset 11319 :start 11319 :end 11339))) 42)
" 
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

" public API
function! vimside#swank#rpc#uses_of_symbol_at_point#Run(...)
" call s:LOG("UsesOfSymbolAtPoint TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-uses-of-symbol-at-point-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-uses-of-symbol-at-point-caller')
  endif

  let l:args = { }
  let l:args['filename'] = ""
  let l:args['offset'] = ""
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

" call s:LOG("UsesOfSymbolAtPoint BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:UsesOfSymbolAtPointCaller(args)
  let cmd = "swank:uses-of-symbol-at-point"
  let fn = a:args.filename
  let offset = a:args.offset

  return '(' . cmd . ' "' . fn . '" ' . offset . ')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:UsesOfSymbolAtPointHandler()

  function! g:UsesOfSymbolAtPointHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:UsesOfSymbolAtPointHandler_Ok(diclist, ...)
    return 1
  endfunction

  return { 
    \ 'abort': function("g:UsesOfSymbolAtPointHandler_Abort"),
    \ 'ok': function("g:UsesOfSymbolAtPointHandler_Ok") 
    \ }
endfunction
