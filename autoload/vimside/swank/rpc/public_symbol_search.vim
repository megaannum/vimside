" ============================================================================
" public_symbol_search.vim
"
" File:          vimside#swank#rpc#public_symbol_search.vim
" Summary:       Vimside RPC public-symbol-search
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Search top-level symbols (types and methods) for names that contain ALL the
" given search keywords.
"
" Arguments:
"   List of Strings:Keywords that will be ANDed to form the query.
"   Int:Maximum number of results to return.
"
" Return:
"   List of SymbolSearchResults
"
" Example:
"
" (:swank-rpc (swank:public-symbol-search ("java" "io" "File") 50) 42)
"
" (:return 
" (:ok 
"  ((:name "java.io.File" :local-name "File" :decl-as class
"  :pos (:file "/Classes/classes.jar" :offset -1))
" 42)
"
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#public_symbol_search#Run(...)
call s:LOG("public_symbol_search TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-public-symbol-search-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-public-symbol-search-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-public-symbol-search-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("public_symbol_search BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:PublicSymbolSearchCaller(args)
  let cmd = "swank:public-symbol-search"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:PublicSymbolSearchHandler()

  function! g:PublicSymbolSearchHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:PublicSymbolSearchHandler_Ok(publicSymbolSearch)
call s:LOG("PublicSymbolSearchHandler_Ok ".  vimside#sexp#ToString(a:publicSymbolSearch)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:publicSymbolSearch) 
    if ! found 
      echoe "PublicSymbolSearch ok: Badly formed Response"
      call s:ERROR("PublicSymbolSearch ok: Badly formed Response: ". string(a:publicSymbolSearch)) 
      return 0
    endif
call s:LOG("PublicSymbolSearchHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:PublicSymbolSearchHandler_Abort"),
    \ 'ok': function("g:PublicSymbolSearchHandler_Ok") 
    \ }
endfunction
