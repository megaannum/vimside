" ============================================================================
" remove_file.vim
"
" File:          vimside#swank#rpc#remove_file.vim
" Summary:       Vimside RPC remove-file
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Remove a file from consideration by the ENSIME analyzer.
"
" Arguments:
"   String:A filename, absolute or relative to the project.
"
" Return: None
"
" Example:
"
" (:swank-rpc (swank:remove-file "Analyzer.scala") 42)
"
" (:return 
" (:ok 
" t
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#remove_file#Run(...)
call s:LOG("remove_file TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-remove-file-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-remove-file-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)


call s:LOG("remove_file BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:RemoveFileCaller(args)
  let cmd = "swank:remove-file"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:RemoveFileHandler()

  function! g:RemoveFileHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:RemoveFileHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("RemoveFileHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:RemoveFileHandler_Abort"),
    \ 'ok': function("g:RemoveFileHandler_Ok") 
    \ }
endfunction
