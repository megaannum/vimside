" ============================================================================
" import_suggestions.vim
"
" File:          vimside#swank#rpc#import_suggestions.vim
" Summary:       Vimside RPC import-suggestions
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
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
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("import_suggestions BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ImportSuggestionsCaller(args)
  let cmd = "swank:import-suggestions"

  let fn = a:args.filename
  let offset = a:args.offset
  let names = a:args.names
  let max = a:args.maximum

  let nlen = len(names)
  let cnt = 0
  let ns = '('
  while cnt < nlen
    let ns .= '"'
    let ns .= names[cnt]
    let ns .= '"'
    if cnt+1 != nlen
      let ns .= ' '
    endif

    let cnt += 1
  endwhile
  let ns .= ')'

  return '('. cmd .' "'. fn .'" '. offset .' '. ns .' '. max .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ImportSuggestionsHandler()

  function! g:ImportSuggestionsHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:ImportSuggestionsHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("ImportSuggestionsHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:ImportSuggestionsHandler_Abort"),
    \ 'ok': function("g:ImportSuggestionsHandler_Ok") 
    \ }
endfunction
