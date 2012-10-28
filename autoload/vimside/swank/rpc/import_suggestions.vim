" ============================================================================
" import_suggestions.vim
"
" File:          vimside#swank#rpc#import_suggestions.vim
" Summary:       Vimside RPC import-suggestions
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
" 
" Search top-level types for qualified names similar to the given type names.
" This call can service requests for many typenames at once, but this isn't
" currently used in ENSIME.
"
" Arguments:
"   String:Source filename, absolute or relative to the project.
"   Int:Character offset within that file where type name is referenced.
"   List of String:Type names (possibly partial) for which to suggest.
"   Int:The maximum number of results to return.
"
" Return:
"   List of Lists of SymbolSearchResults:Each list corresponds to one of the
"    type name arguments.
"
" Example:
"
" (:swank-rpc (swank:import-suggestions
"  "/ensime/src/main/scala/org/ensime/server/Analyzer.scala"
"  2300 (Actor) 10) 42)
"
" (:return 
" (:ok 
" (((:name "scala.actors.Actor" :local-name "Actor"
" :decl-as trait :pos (:file "/lib/scala-library.jar" :offset -1))))
" 42)
"
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#import_suggestions#Run(...)
call s:LOG("import_suggestions TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-import-suggestions-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-import-suggestions-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-import-suggestions-handler'
  call s:Error(msg)
  echoerr msg

call s:LOG("import_suggestions BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ImportSuggestionsCaller(args)
  let cmd = "swank:import-suggestions"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ImportSuggestionsHandler()

  function! g:ImportSuggestionsHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:ImportSuggestionsHandler_Ok(importSuggestions)
call s:LOG("ImportSuggestionsHandler_Ok ".  vimside#sexp#ToString(a:importSuggestions)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:importSuggestions) 
    if ! found 
      echoe "ImportSuggestions ok: Badly formed Response"
      call s:ERROR("ImportSuggestions ok: Badly formed Response: ". string(a:importSuggestions)) 
      return 0
    endif
call s:LOG("ImportSuggestionsHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:ImportSuggestionsHandler_Abort"),
    \ 'ok': function("g:ImportSuggestionsHandler_Ok") 
    \ }
endfunction
