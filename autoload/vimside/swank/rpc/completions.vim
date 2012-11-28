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
" "/ensime/src/main/scala/org/ensime/protocol/SwankProtocol.scala"
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

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr fn
    return
  endif

  let offset = vimside#util#GetCurrentOffset()

  let l:args = { }
  let l:args['filename'] = fn
  let l:args['offset'] = offset
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("completions BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

" (:swank-rpc (swank:completions
" "/ensime/src/main/scala/org/ensime/protocol/SwankProtocol.scala
" 22626 0 t) 42)
function! g:CompletionsCaller(args)
  let cmd = "swank:completions"
  let fn = a:args.filename
  let offset = a:args.offset+1
  let max_return = 0
  let case = 't'
  let reload = 't'

  return '('. cmd .' "'. fn .'" '. offset .' '. max_return .' '. case .' '. reload .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:CompletionsHandler()

  function! g:CompletionsHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:CompletionsHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("CompletionsHandler_Ok dic=".  string(dic)) 

    let base = g:completions_base
    let base_len = len(base)

    let l:results = []

    if g:completions_in_process && has_key(dic, ':completions')
      let completions = dic[':completions']
      for comp in completions
        let word = comp[':name']
        if len(word) >= base_len && strpart(word, 0, base_len) == base
          let l:result = {}
          let l:result['word'] = word
          let l:result['menu'] = string(comp[':type-sig'])

          if has_key(comp, 'is_callable')
            let k = comp['is_callable']
            if k
              let l:result['kind'] = 'f'
            else
              let l:result['kind'] = 'v'
            endif
          endif

          call add(l:results, l:result)
        endif
      endfor

      function! s:ListSorter(e1, e2)
        let word1 = a:e1.word
        let word2 = a:e2.word
        return word1 > word2 ? 1 : -1
      endfunction

      let g:completions_results = sort(l:results, function("s:ListSorter"))
call s:LOG("CompletionsHandler_Ok g:completions_results=".  string(g:completions_results)) 

      " This triggers re-getting the completions
      " I did not think of this, this bit of cleverness 
      " was found in Envim.
      call feedkeys("\<c-x>\<c-o>", 'n')
    endif

    return 1

  endfunction

  return { 
    \ 'abort': function("g:CompletionsHandler_Abort"),
    \ 'ok': function("g:CompletionsHandler_Ok") 
    \ }
endfunction
