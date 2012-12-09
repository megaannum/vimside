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
" (:ok (
" (:name "java.io.File" 
"  :local-name "File" 
"  :decl-as class
"  :pos (:file "/Classes/classes.jar" :offset -1)
"  optional :owner-name "some class/object name"
" )
" ))
" 42)
"
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#public_symbol_search#Run(...)
"call s:LOG("public_symbol_search TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-public-symbol-search-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-public-symbol-search-caller')
  endif

  let l:args = { }
  " let l:args['terms'] = ["java", "io", "File"]
  let l:args['terms'] = ["Foo"]
  let l:args['maximum'] = 50
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)

  call vimside#ensime#swank#dispatch(l:rr)

"call s:LOG("public_symbol_search BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:PublicSymbolSearchCaller(args)
  let cmd = "swank:public-symbol-search"
  let terms = a:args.terms
"call s:LOG("g:PublicSymbolSearchCaller: terms=". string(terms)) 
  let max = a:args.maximum

  let tlen = len(terms)
  let cnt = 0
  let ts = '('
  while cnt < tlen
    let ts .= '"'
    let ts .= terms[cnt]
    let ts .= '"'
    if cnt+1 != tlen
      let ts .= ' '
    endif

    let cnt += 1
  endwhile
  let ts .= ')'

  return '('. cmd .' '. ts .' '. max  .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:PublicSymbolSearchHandler()

  function! g:PublicSymbolSearchHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:PublicSymbolSearchHandler_Ok(dic, ...)
    let dic = a:dic
"call s:LOG("PublicSymbolSearchHandler_Ok dic=".  string(dic)) 

    if type(dic) != type([])
      echoe "PublicSymbolSearch ok: Bad Response type: ". type(dic)
      call s:ERROR("PublicSymbolSearch ok: Bad Response type: ". type(dic)) 
      return 0
    endif

    call vimside#command#search#ProcessSymbolSearchResults(dic)

if 0
    let records = []
    let cnt = 0
    for item in dic
      let pos = item[':pos']
      let file = pos[':file']
      let offset = pos[':offset']
      let name = item[':name']
call s:LOG("PublicSymbolSearchHandler_Ok name=".  string(name)) 
      let decl_as = item[':decl-as']
      let local_name = item[':local-name']
      let [line, column] = vimside#util#GetLineColumnFromOffset(offset, file)
      let text = ''. decl_as .':'. name
      if has_key(item, ':owner-name')
        let text .= ':'. item[':owner-name']
      endif

      let record = {}
      let record['filename'] = file
      let record['lnum'] = line
      let record['col'] = column
      let record['vcol'] = 1
      let record['text'] = text
      let record['type'] = 'r'
      let record['nr'] = cnt

      call add(records, record)

      let cnt += 1
    endfor

    call vimside#command#search#AddRecords(records)
endif

    return 1
  endfunction

  return { 
    \ 'abort': function("g:PublicSymbolSearchHandler_Abort"),
    \ 'ok': function("g:PublicSymbolSearchHandler_Ok") 
    \ }
endfunction
