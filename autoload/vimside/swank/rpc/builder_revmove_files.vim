" ============================================================================
" builder_remove_files.vim
"
" File:          vimside#swank#rpc#builder_remove_files.vim
" Summary:       Vimside RPC builder-remove-files
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Signal to the incremental builder that the given files should be removed
"   from the build. Triggers rebuild.
"
" Arguments:
"   List of Strings:Filenames, absolute or relative to the project root.
"
" Example:
"
" (:swank-rpc (swank:builder-remove-files
" ("/ensime/src/main/scala/org/ensime/server/Analyzer.scala")) 42)
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
function! vimside#swank#rpc#builder_remove_files#Run(...)
call s:LOG("builder_remove_files TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-remove-files-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-remove-files-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-builder-remove-files-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("builder_remove_files BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:BuilderRemoveFilesCaller(args)
  let cmd = "swank:builder-remove-files"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:BuilderRemoveFilesHandler()

  function! g:BuilderRemoveFilesHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:BuilderRemoveFilesHandler_Ok(builderRemoveFiles)
call s:LOG("BuilderRemoveFilesHandler_Ok ".  vimside#sexp#ToString(a:builderRemoveFiles)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:builderRemoveFiles) 
    if ! found 
      echoe "BuilderRemoveFiles ok: Badly formed Response"
      call s:ERROR("BuilderRemoveFiles ok: Badly formed Response: ". string(a:builderRemoveFiles)) 
      return 0
    endif
call s:LOG("BuilderRemoveFilesHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:BuilderRemoveFilesHandler_Abort"),
    \ 'ok': function("g:BuilderRemoveFilesHandler_Ok") 
    \ }
endfunction
