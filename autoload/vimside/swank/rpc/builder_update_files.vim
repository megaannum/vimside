" ============================================================================
" builder_update_files.vim
"
" File:          vimside#swank#rpc#builder_update_files.vim
" Summary:       Vimside RPC builder-update-files
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
" Signal to the incremental builder that the given files have changed and
"   must be rebuilt. Triggers rebuild.
"
" Arguments: 
"   List of Strings:Filenames, absolute or relative to the project root.
"
" Example:
"
" (:swank-rpc (swank:builder-update-files
" ("/ensime/src/main/scala/org/ensime/server/Analyzer.scala"))
" 42)
"
"
" (:return 
" (:ok 
" ()
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#builder_update_files#Run(...)
call s:LOG("builder_update_files TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-update-files-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-update-files-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-builder-update-files-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("builder_update_files BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:BuilderUpdateFilesCaller(args)
  let cmd = "swank:builder-update-files"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:BuilderUpdateFilesHandler()

  function! g:BuilderUpdateFilesHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:BuilderUpdateFilesHandler_Ok(builderUpdateFiles)
call s:LOG("BuilderUpdateFilesHandler_Ok ".  vimside#sexp#ToString(a:builderUpdateFiles)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:builderUpdateFiles) 
    if ! found 
      echoe "BuilderUpdateFiles ok: Badly formed Response"
      call s:ERROR("BuilderUpdateFiles ok: Badly formed Response: ". string(a:builderUpdateFiles)) 
      return 0
    endif
call s:LOG("BuilderUpdateFilesHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:BuilderUpdateFilesHandler_Abort"),
    \ 'ok': function("g:BuilderUpdateFilesHandler_Ok") 
    \ }
endfunction
