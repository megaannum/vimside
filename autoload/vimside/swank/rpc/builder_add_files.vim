" ============================================================================
" builder_add_files.vim
"
" File:          vimside#swank#rpc#builder_add_files.vim
" Summary:       Vimside RPC builder-add-files
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Signal to the incremental builder that the given files should be added to
"   the build. Triggers rebuild.
"
" Arguments:
"   List of Strings:Filenames, absolute or relative to the project root.
"
" Example:
"
" (:swank-rpc (swank:builder-add-files
" ("/ensime/src/main/scala/org/ensime/server/Analyzer.scala")) 42)
"
" (:return 
" (:ok 
" (t)
" 42))
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#builder_add_files#Run(...)
call s:LOG("builder_add_files TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-add-files-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-add-files-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("builder_add_files BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:BuilderAddFilesCaller(args)
  let cmd = "swank:builder-add-files"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

" List of
" ()

function! g:BuilderAddFilesHandler()

  function! g:BuilderAddFilesHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:BuilderAddFilesHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("BuilderAddFilesHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:BuilderAddFilesHandler_Abort"),
    \ 'ok': function("g:BuilderAddFilesHandler_Ok") 
    \ }
endfunction
