" ============================================================================
" conection_info.vim
"
" File:          vimside#swank#rpc#conection_info.vim
" Summary:       Vimside RPC conection-info
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Request connection information.
"
" Example:
"
" (:swank-rpc (swank:connection-info) 42)
"
" (:return 
" (:ok 
" (:pid nil :implementation (:name "ENSIME - Reference "Server") :version "0.7")
" ) 
" 42)
"
" with this version of Ensime, :pid is always nil
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#connection_info#Run(...)
call s:LOG("ConnectionInfo TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-connection-info-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-connection-info-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("ConnectionInfo BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ConnectionInfoCaller(args)
  let cmd = "swank:connection-info"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ConnectionInfoHandler()

  function! g:ConnectionInfoHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:ConnectionInfoHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("ConnectionInfoHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']
    let l:impl = dic[':implementation']
    let l:name = l:impl[':name']
    let l:version = dic[':version']

    let g:vimside.ensime.info['pid'] = l:pid
    let g:vimside.ensime.info['name'] = l:name
    let g:vimside.ensime.info['version'] = l:version

    let msg = l:name . ' ' . l:version
    call vimside#cmdline#Display(msg) 

    return 1

  endfunction

  return { 
    \ 'abort': function("g:ConnectionInfoHandler_Abort"),
    \ 'ok': function("g:ConnectionInfoHandler_Ok") 
    \ }
endfunction
