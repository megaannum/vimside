" ============================================================================
" completions.vim
"
" File:          vimside#swank#rpc#completions.vim
" Summary:       Vimside RPC completions
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Find viable completions at given point.
"
" Arguments:
"   String:Source filename, absolute or relative to the project.
"   Int:Character offset within that file.
"   Int:Max number of completions to return. Value of zero denotes no limit.
"   Bool:If non-nil, only return prefixes that match the case of the prefix.
"   Bool:If non-nil, reload source from disk before computing completions.
"
"
" Example:
"
" (:swank-rpc (swank:completions
" "/ensime/src/main/scala/org/ensime/protocol/SwankProtocol.scala
" 22626 0 t) 42)
"
" (:return 
" (:ok 
" (:prefix "form" :completions
"  ((:name "form" :type-sig "SExp" :type-id 10)
"  (:name "format" :type-sig "(String, <repeated>[Any]) =>
"  String"
"  :type-id 11 :is-callable t)))
" 42))
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#completions#Run(...)
call s:LOG("completions TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-completions-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-completions-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-completions-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("completions BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:CompletionsCaller(args)
  let cmd = "swank:completions"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:CompletionsHandler()

  function! g:CompletionsHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:CompletionsHandler_Ok(completions)
call s:LOG("CompletionsHandler_Ok ".  vimside#sexp#ToString(a:completions)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:completions) 
    if ! found 
      echoe "Completions ok: Badly formed Response"
      call s:ERROR("Completions ok: Badly formed Response: ". string(a:completions)) 
      return 0
    endif
call s:LOG("CompletionsHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:CompletionsHandler_Abort"),
    \ 'ok': function("g:CompletionsHandler_Ok") 
    \ }
endfunction
