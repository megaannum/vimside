" ============================================================================
" builder_update_files.vim
"
" File:          vimside#swank#rpc#builder_update_files.vim
" Summary:       Vimside RPC builder-update-files
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
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
  let l:args['files'] = []
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("builder_update_files BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:BuilderUpdateFilesCaller(args)
  let cmd = "swank:builder-update-files"
  let files = a:args.files
call s:LOG("g:BuilderUpdateFilesCaller: files=". string(files)) 

  let flen = len(files)
  let cnt = 0
  let fs = '('
  while cnt < flen
    let fs .= '"'
    let fs .= files[cnt]
    let fs .= '"'
    if cnt+1 != flen
      let fs .= ' '
    endif

    let cnt += 1
  endwhile
  let fs .= ')'

  return '('. cmd .' '. fs .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:BuilderUpdateFilesHandler()

  function! g:BuilderUpdateFilesHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:BuilderUpdateFilesHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("BuilderUpdateFilesHandler_Ok dic=".  string(dic)) 

    return 1
  endfunction

  return { 
    \ 'abort': function("g:BuilderUpdateFilesHandler_Abort"),
    \ 'ok': function("g:BuilderUpdateFilesHandler_Ok") 
    \ }
endfunction
