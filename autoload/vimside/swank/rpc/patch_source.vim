" ============================================================================
" patch_source.vim
"
" File:          vimside#swank#rpc#patch_source.vim
" Summary:       Vimside RPC patch-source
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Request immediate load and check the given source file.
"
" Arguments:
"   String:A filename
"   String:A FilePatch
"
" Return: None
"
" Example:
"
" (swank:patch-source "Analyzer.scala" (("+" 6461 "Inc")
" ("-" 7127 7128)))
"
" (:return 
" (:ok  t)
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#patch_source#Run(...)
call s:LOG("patch_source TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-patch-source-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-patch-source-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)


call s:LOG("patch_source BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:PatchSourceCaller(args)
  let cmd = "swank:patch-source"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:PatchSourceHandler()

  function! g:PatchSourceHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:PatchSourceHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("PatchSourceHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:PatchSourceHandler_Abort"),
    \ 'ok': function("g:PatchSourceHandler_Ok") 
    \ }
endfunction
