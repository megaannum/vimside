" ============================================================================
" util.vim
"
" File:          util.vim
" Summary:       Vimside swank rpc utilities
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 11/5/2012
" Version:       1.0
" Modifications:
"
" Tested on vim 7.3 on Linux
"
" Depends upon: NONE
"
" ============================================================================
" {{{1

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

" ------------------------------------------------------------ 
" vimside#swank#rpc#util#LoadFuncrefFromOption: {{{2
"  Returns a Funcref or those exception if 'on_name' is not the name
"    of an option or the option value is not the name of a Function.
"  parameters: 
"    op_name  : String option name
" ------------------------------------------------------------ 
function! vimside#swank#rpc#util#LoadFuncrefFromOption(op_name)
  let l:name = vimside#swank#rpc#util#GetOption(a:op_name)
  return function(l:name)
endfunction


" ------------------------------------------------------------ 
" vimside#swank#rpc#util#GetOption: {{{2
"  Returns [1, function_name] if op_name is the name of an opetion or
"    throws exception.
"  parameters: 
"    op_name  : String option name
" ------------------------------------------------------------ 
function! vimside#swank#rpc#util#GetOption(op_name)
call s:LOG("vimside#swank#rpc#util#GetOption TOP") 

  let [found, handler_name] = g:vimside.GetOption(a:op_name)
  if ! found
    throw "Option not found: " . a:op_name
  else
    return handler_name
  endif
endfunction

" ------------------------------------------------------------ 
" vimside#swank#rpc#util#MakeRPCEnds: {{{2
"  Build the RPC caller/handler Dictionary.
"  If replace_arg is an empty list (by far the most common case) then
"  what is retured is:
"   {
"      'caller': a:StdCaller,
"      'args': = a:args,
"      'handler': a:StdHandler()
"   }
"  where the 'handler' value is a Dictionary:
"   {
"      'abort': <Funcref for RPC abort reponse>,
"      'ok': <Funcref for RPC ok reponse>
"   }
"  parameters: 
"    StdCaller  : Funcref of RPC's Caller as defined by Option value.
"    args       : Dictionary of arguments to Caller.
"    StdHandler : Funcref of RPC's Handler as defined by Option value. 
"    replace_args : List with optional single Dictionary value.
"                   If one or more of the keys: 'caller', 'handler',
"                   the 'handler' subkeys 'ok' or 'abort' or 'args'
"                   is in the Dictionary then those are used in
"                   replacement to the corresponding ones associted 
"                   with the standard Caller, args and Handler.
"                   In the case of the replacement values: 'caller',
"                   'handler', 'ok' and/or 'abort' they maybe either
"                   Strings or Funcrefs.
" ------------------------------------------------------------ 
function! vimside#swank#rpc#util#MakeRPCEnds(StdCaller, args, StdHandler, replace_args)
call s:LOG("vimside#swank#rpc#util#MakeRPCEnds TOP") 
  let l:StdCaller = a:StdCaller
  let l:args = a:args
  let l:StdHandler = a:StdHandler
  let l:replace_args = a:replace_args
  let l:replace_args_len = len(l:replace_args)

  let l:rr = { }
  " default, no events generated
  let l:rr['events'] = '0'

  if l:replace_args_len == 0
    let rr['caller'] = l:StdCaller
    let rr['handler'] = l:StdHandler()

  elseif l:replace_args_len == 1
    let l:replace_arg = l:replace_args[0]
    call vimside#util#IsDictionary(l:replace_arg, 1)

    if has_key(l:replace_arg, 'caller') 
      let rr['caller'] = s:MakeFuncRef(l:replace_arg['caller'])
    else
      let rr['caller'] = l:StdCaller
    endif

    if has_key(l:replace_arg, 'handler') 
      let l:ReplaceHandlerValue = l:replace_arg['handler']
      if vimside#util#IsDictionary(l:ReplaceHandlerValue)
        let l:Replace_handler = l:ReplaceHandlerValue
      else
        let l:TmpArgHandler = s:MakeFuncRef(l:replace_arg['handler'])
        let l:Replace_handler = l:TmpArgHandler()
      endif

      call vimside#util#IsDictionary(l:Replace_handler, 1)

      let l:has_ok = has_key(l:Replace_handler, 'ok')
      let l:has_abort = has_key(l:Replace_handler, 'abort')

      if l:has_ok && l:has_abort
        let l:ReplacepArgOk = s:MakeFuncRef(l:Replace_handler['ok'])
        let l:ReplacepArgAbort = s:MakeFuncRef(l:Replace_handler['abort'])

        let rr['handler'] = {
                  \ 'abort':  l:ReplacepArgAbort,
                  \ 'ok': l:ReplacepArgOk
                  \ }

      elseif l:has_ok 
        let l:ReplacepArgOk = s:MakeFuncRef(l:Replace_handler['ok'])
        let l:Std_handler = l:StdHandler()

        let rr['handler'] = {
                  \ 'abort': l:Std_handler['abort'],
                  \ 'ok': l:ReplacepArgOk
                  \ }

      elseif l:has_abort 
        let l:ReplacepArgAbort = s:MakeFuncRef(l:Replace_handler['abort'])
        let l:Std_handler = l:StdHandler()

        let rr['handler'] = {
                  \ 'abort': l:ReplacepArgAbort,
                  \ 'ok': l:Std_handler['ok']
                  \ }

      else
        let rr['handler'] = l:StdHandler()
      endif
    else
      let rr['handler'] = l:StdHandler()
    endif

  else
    throw "Wrong number of arguments: '". a:0 ."' should be 0 or 1"
  endif


  call vimside#util#IsDictionary(l:args, 1)

  if exists("l:replace_arg") && has_key(l:replace_arg, 'args') 
    let l:other_replace_args = l:replace_arg['args']
    let l:adic = {}
    for key in keys(l:args)

      let l:adic[key] = has_key(l:other_replace_args)
                      \ ?  l:other_replace_args[key]
                      \ :  l:args[key]

    endfor
    let l:rr['args'] = l:adic

  else
    let l:rr['args'] = l:args
  endif

call s:LOG("vimside#swank#rpc#util#MakeRPCEnds l:rr=". string(l:rr)) 
  return l:rr
endfunction

function! s:MakeFuncRef(Arg)
  if vimside#util#IsString(a:Arg)
    return function(a:Arg)
  elseif vimside#util#IsFuncRef(a:Arg)
    return a:Arg
  else
    throw "Expecting Arg to be 'String' or 'Funcref', not ".
          \ vimside#util#TypeName(a:Arg)
  endif
endfunction

function! vimside#swank#rpc#util#Abort(code, details, ...)
  let msg = "Abort: " . vimside#util#CodeDetailsString(a:code, a:details)

  if a:0 > 0
      for m in a:000
        let msg .= string(m)
      endfor
  endif

  call vimside#error#record(msg)
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
