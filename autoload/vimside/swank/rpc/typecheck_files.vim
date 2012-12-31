" ============================================================================
" typecheck_files.vim
"
" File:          vimside#swank#rpc#typecheck_files.vim
" Summary:       Vimside RPC typecheck-files
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Request immediate load and check the given source files.
"
" Arguments:
"   List of String:Filenames, absolute or relative to the project.
"
" Return: None
"
" Example:
"
" (:swank-rpc (swank:typecheck-files ("Analyzer.scala")) 42)
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
function! vimside#swank#rpc#typecheck_files#Run(...)
call s:LOG("TypecheckFiles TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-typecheck-files-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-typecheck-files-caller')
  endif

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr fn
    return
  endif

  let l:args = { }
  let l:args['filename'] = fn
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  let l:rr.events = 1
  call vimside#ensime#swank#dispatch(l:rr)

  call vimside#cmdline#Display("This may take a moment...")

call s:LOG("TypecheckFiles BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================


function! g:TypecheckFilesCaller(args)
  let cmd = "swank:typecheck-files"
  let fn = a:args.filename

  return '(' . cmd . ' "' . fn . '")'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:TypecheckFilesHandler()

  function! g:TypecheckFilesHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:TypecheckFilesHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("TypechecFilesHandler_Ok diclist=".  string(dic)) 

    return 1
  endfunction

  return { 
    \ 'abort': function("g:TypecheckFilesHandler_Abort"),
    \ 'ok': function("g:TypecheckFilesHandler_Ok") 
    \ }
endfunction
