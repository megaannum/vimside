" ============================================================================
" builder_init.vim
"
" File:          vimside#swank#rpc#builder_init.vim
" Summary:       Vimside RPC builder-init
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Initialize the incremental builder and kick off a full rebuild.
"
" Arguments: None
"
" Example:
"
" (:swank-rpc (swank:builder-init) 42)
"
" (:return 
" (:ok 
" (t)
" 42))
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

"

" public API
function! vimside#swank#rpc#builder_init#Run(...)
call s:LOG("builder_init TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-init-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-builder-init-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-builder-init-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("builder_init BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:BuilderInitCaller(args)
  let cmd = "swank:builder-init"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:BuilderInitHandler()

  function! g:BuilderInitHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:BuilderInitHandler_Ok(builderInit)
call s:LOG("BuilderInitHandler_Ok ".  vimside#sexp#ToString(a:builderInit)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:builderInit) 
    if ! found 
      echoe "BuilderInit ok: Badly formed Response"
      call s:ERROR("BuilderInit ok: Badly formed Response: ". string(a:builderInit)) 
      return 0
    endif
call s:LOG("BuilderInitHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:BuilderInitHandler_Abort"),
    \ 'ok': function("g:BuilderInitHandler_Ok") 
    \ }
endfunction
