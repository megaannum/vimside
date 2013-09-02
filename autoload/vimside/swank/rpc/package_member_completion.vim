" ============================================================================
" package_member_completion.vim
"
" File:          vimside#swank#rpc#package_member_completion.vim
" Summary:       Vimside RPC package-member-completion
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Find possible completions for a given package path.
"
" Arguments:
"   String:A package path: such as "org.ensime" or "com".
"   String:The prefix of the package member name we are looking for.
"
" Return:
"   List of PackageMemberInfoLight: List of possible completions.
"
" Example:
"
" (:swank-rpc (swank:package-member-completion org.ensime.server Server) 42)
"
"
" (:return 
" (:ok 
" ((:name "Server$") (:name "Server"))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#package_member_completion#Run(...)
call s:LOG("package_member_completion TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-package-member-completion-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-package-member-completion-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("package_member_completion BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:PackageMemberCompletionCaller(args)
  let cmd = "swank:package-member-completion"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:PackageMemberCompletionHandler()

  function! g:PackageMemberCompletionHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:PackageMemberCompletionHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("PackageMemberCompletionHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:PackageMemberCompletionHandler_Abort"),
    \ 'ok': function("g:PackageMemberCompletionHandler_Ok") 
    \ }
endfunction
