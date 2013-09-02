" ============================================================================
" symbol_designations.vim
"
" File:          vimside#swank#rpc#symbol_designations.vim
" Summary:       Vimside RPC symbol-designations
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" Request the semantic classes of symbols in the given range. These classes
"   are intended to be used for semantic highlighting.
"
" Arguments:
"   String:A source filename.
"   Int:The character offset of the start of the input range.
"   Int:The character offset of the end of the input range.
"   List of Symbol:The symbol classes in which we are interested.
"   Available classes are: var,val,varField,valField,functionCall,
"   operator,param,class,trait,object.
"
" Return:
"   SymbolDesignations
"
" Example:
"
" (:swank-rpc (swank:symbol-designations "SwankProtocol.scala" 0 46857
" (var val varField valField)) 42)
"
" (:return 
" (:ok 
" (:file "SwankProtocol.scala" :syms
" ((varField 33625 33634) (val 33657 33661) (val 33663 33668)
" (varField 34369 34378) (val 34398 34400))))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#symbol_designations#Run(...)
call s:LOG("symbol_designations TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-symbol-designations-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-symbol-designations-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

call s:LOG("symbol_designations BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:SymbolDesignationsCaller(args)
  let cmd = "swank:symbol-designations"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:SymbolDesignationsHandler()

  function! g:SymbolDesignationsHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:SymbolDesignationsHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("SymbolDesignationsHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']

    return 1
  endfunction

  return { 
    \ 'abort': function("g:SymbolDesignationsHandler_Abort"),
    \ 'ok': function("g:SymbolDesignationsHandler_Ok") 
    \ }
endfunction
