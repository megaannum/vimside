" ============================================================================
" repl_config.vim
"
" File:          vimside#swank#rpc#repl_config.vim
" Summary:       Vimside RPC repl-config
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Get information necessary to launch a scala repl for this project.
"
" Arguments: None
"
" Return:
"   (
"   :classpath //String:Classpath string formatted for passing to Scala.
"   )
"
"
" Example:
"
" (:swank-rpc (swank:repl-config) 42)
" (:return (:ok (:classpath "lib1.jar:lib2.jar:lib3.jar")) 42)
"
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#repl_config#Run(...)

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-repl-config-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-repl-config-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:ReplConfigCaller(args)
  let cmd = "swank:repl-config"

  return '(' . cmd . ')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:ReplConfigHandler()

  function! g:ReplConfigHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " The code in this function is basically a copy of the code
  "   found in the plugin/vimshell.vim function
  "   s:vimshell_interactive(args) with the addition of 
  "   window placement code and a postexit hook.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  function! g:ReplConfigHandler_Ok(dic, ...)
    let dic = a:dic

" call s:LOG("ReplConfigHandler_Ok dic=".  string(dic)) 
    let classpath = dic[':classpath']
" call s:LOG("ReplConfigHandler_Ok classpath=".  string(classpath)) 

    " TODO: run Scala Repl in Vim Window
    " -classpath:
    
    " either works
    " let l:command_line = '/home/emberson/scala/scala-2.9.2/bin/scala'
    "let l:command_line = 'scala -i Test.scala'
    let l:command_line = 'scala -usejavacp -classpath '. classpath
    let &winwidth = 50

    try
      let args = vimproc#parser#split_args(command_line)
      let context = {
          \ 'has_head_spaces' : 0,
          \ 'is_interactive' : 0,
          \ 'is_single_command' : 1,
          \ 'is_close_immediately' : 1,
          \ 'fd' : { 'stdin' : '', 'stdout': '', 'stderr': '' }
          \ }
      call vimshell#set_context(context)

      call vimside#scheduler#StopAuto()

      startinsert
      stopinsert

      let location = s:GetLocation()
" call s:LOG("ReplConfigHandler_Ok location=".  string(location)) 

      if location == 'same_window'
        let g:vimshell_split_command = 'edit!'
      elseif location == 'split_window'
        let g:vimshell_split_command = 'split!'
      elseif location == 'vsplit_window'
        let g:vimshell_split_command = 'vsplit!'
      elseif location == 'tab_window'
        let g:vimshell_split_command = 'tabnew!'
      endif

" call s:LOG("ReplConfigHandler_Ok args=".  string(args)) 
      let s:filetype = &filetype
      call vimshell#execute_internal_command('iexe', args, context)
      call vimshell#hook#set('postexit', [ function("g:ReplConfigVimShellCallback") ])

    catch
      let message = (v:exception !~# '^Vim:')?
          \ v:exception : v:exception . ' ' . v:throwpoint
      call s:ERROR("ReplConfigHandler_Ok: ". printf('%s: %s', l:command_line, message))
      return 0
    endtry

" call s:LOG("ReplConfigHandler_Ok BOTTOM") 
    return 1
  endfunction

  return { 
    \ 'abort': function("g:ReplConfigHandler_Abort"),
    \ 'ok': function("g:ReplConfigHandler_Ok") 
    \ }
endfunction

function! s:GetLocation()
  let l:option_name = 'tailor-repl-config-location'
  let l:default_location = 'tab_window'
  return vimside#util#GetLocation(l:option_name, l:default_location)
endfunction


function! g:ReplConfigVimShellCallbackAction()
" call s:LOG("ReplConfigVimShellCallbackAction: filetype=". s:filetype) 
"
  let location = s:GetLocation()
  if location == 'split_window'
    quit
  elseif location == 'vsplit_window'
    quit
  elseif location == 'tab_window'
    quit
  endif

  let &filetype = s:filetype
  syntax on
endfunction

function! g:ReplConfigVimShellCallback(context, cmdinfolist)
" call s:LOG("ReplConfigVimShellCallback") 


  let l:Func = function("g:ReplConfigVimShellCallbackAction")
  let l:sec = 0
  let l:msec = 100
  let l:charcnt = 2
  let l:repeat = 0
  call vimside#scheduler#AddJob('repl_callback', l:Func, l:sec, l:msec, l:charcnt, l:repeat)

  call vimside#scheduler#StartAuto()

endfunction
