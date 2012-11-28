" ============================================================================
" format_source.vim
"
" File:          vimside#swank#rpc#format_source.vim
" Summary:       Vimside RPC format-source
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Run the source formatter the given source files. Writes the formatted
" sources to the disk. Note: the client is responsible for reloading the
" files from disk to display to user.
"
" Arguments:
"   List of String:Filenames, absolute or relative to the project.
"
" Return: None
"
" Example:
"
" (swank:format-source "file")
" (:return (:ok t) 4)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

"
" (swank:format-source "file")
" (:return (:ok t) 4)
"

" public API
function! vimside#swank#rpc#format_source#Run(...)
call s:LOG("FormatSource TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-format-source-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-format-source-caller')
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
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("FormatSource BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:FormatSourceCaller(args)
  let cmd = "swank:format-source"
  let fn = a:args.filename

  return '(' . cmd . ' ("' . fn . '"))'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:FormatSourceHandler()

  function! g:FormatSourceHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:FormatSourceHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("FormatSourceHandler_Ok diclist=".  string(dic)) 

    call feedkeys("\<CR>")
    call feedkeys(":e!\<CR>")

    return 1
  endfunction

  return { 
    \ 'abort': function("g:FormatSourceHandler_Abort"),
    \ 'ok': function("g:FormatSourceHandler_Ok") 
    \ }
endfunction
