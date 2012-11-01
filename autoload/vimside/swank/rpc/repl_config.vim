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

  function! g:ReplConfigHandler_Ok(okResp)
" call s:LOG("ReplConfigHandler_Ok " .  vimside#sexp#ToString(a:okResp)) 
    let [found, diclist] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:okResp) 
    if ! found 
      echoe "ReplConfig ok: Badly formed Response"
      call s:ERROR("ReplConfig ok: Badly formed Response: ". string(a:okResp)) 
      return 0
    endif

" call s:LOG("ReplConfigHandler_Ok diclist=".  string(diclist)) 
    let classpath = diclist[':classpath']
" call s:LOG("ReplConfigHandler_Ok classpath=".  string(classpath)) 

    " TODO: run Scala Repl in Vim Window
    " -classpath:
    
    " either works
    " let l:command_line = '/home/emberson/scala/scala-2.9.2/bin/scala'
    "let l:command_line = 'scala -i Test.scala'
    let l:command_line = 'scala -classpath '. classpath
    let &winwidth = 50

    try
      let args = vimproc#parser#split_args(command_line)
      let context = {
          \ 'has_head_spaces' : 0,
          \ 'is_interactive' : 0,
          \ 'is_single_command' : 1,
          \ 'fd' : { 'stdin' : '', 'stdout': '', 'stderr': ''},
          \}
      call vimshell#set_context(context)

" XXXXXXXXXXXXX
" call vimside#RemoveAutoCmds()
      call vimside#scheduler#StopAuto()

"sleep 1
      startinsert
      stopinsert

if 0
      let c = getchar(0)
call s:LOG("ReplConfigHandler_Ok c=".  string(c)) 
      while c != 0
        let c = getchar(0)
call s:LOG("ReplConfigHandler_Ok c=".  string(c)) 
      endwhile
endif

      let location = s:GetLocation()

      if location == 'same_window'
        let g:vimshell_split_command = 'edit!'
      elseif location == 'split_window'
        let g:vimshell_split_command = 'split!'
      elseif location == 'vsplit_window'
        let g:vimshell_split_command = 'vsplit!'
      elseif location == 'tab'
        let g:vimshell_split_command = 'tabnew!'
      endif

if 0 " XXXX
let s:bufnum = bufnr('%')
endif " XXXX
      let s:filetype = &filetype
      call vimshell#execute_internal_command('iexe', args, context)
      call vimshell#hook#set('postexit', [ function("g:ReplConfigVimShellCallback") ])

      let b:interactive.is_close_immediately = 1

    catch
      let message = (v:exception !~# '^Vim:')?
          \ v:exception : v:exception . ' ' . v:throwpoint
      call s:ERROR("ReplConfigHandler_Ok: ". printf('%s: %s', l:command_line, message))
      return 0
  endtry

    return 1
  endfunction

  return { 
    \ 'abort': function("g:ReplConfigHandler_Abort"),
    \ 'ok': function("g:ReplConfigHandler_Ok") 
    \ }
endfunction

function! s:GetLocation()
  let [found, location] = g:vimside.GetOption('swank-rpc-repl-config-location')
  if ! found
    call s:ERROR("Option not found 'swank-rpc-repl-config-location'") 
    let location = 'same_window'
  elseif location != 'same_window' 
      \ && location != 'split_window'
      \ && location != 'vsplit_window'
      \ && location != 'tab'
    call s:ERROR("Option 'swank-rpc-repl-config-location' has bad location value '". location ."'") 
    let location = 'same_window'

  endif
  return location
endfunction


function! g:ReplConfigVimShellCallbackAction()
call s:LOG("ReplConfigVimShellCallbackAction") 
  " let &filetype = 'scala'

  let &filetype = s:filetype
  syntax on
endfunction

function! g:ReplConfigVimShellCallback(context, cmdinfolist)
call s:LOG("ReplConfigVimShellCallback") 

" REMOVE
  " call vimshell#util#delete_buffer()

" XXXXXXXXXXXXX
"  call add(g:vimside.ping.actions, function("g:ReplConfigVimShellCallbackAction"))

  let l:Func = function("g:ReplConfigVimShellCallbackAction")
  let l:sec = 0
  let l:msec = 100
  let l:charcnt = 2
  let l:repeat = 0
  call vimside#scheduler#AddJob('repl_callback', l:Func, l:sec, l:msec, l:charcnt, l:repeat)

" XXXXXXXXXXXXX
" call vimside#SetAutoCmds()
  call vimside#scheduler#StartAuto()

  let location = s:GetLocation()
  if location == 'split_window'
    quit
  elseif location == 'vsplit_window'
    quit
  elseif location == 'tab'
    quit
  endif

if 0 " XXXX
let l:bufnum = bufnr('%')

execute 'buffer '. s:bufnum
unlet s:bufnum

  " let &filetype = 'scala'
  if exists('s:filetype')
call s:LOG("ReplConfigVimShellCallback: s:filetype=". s:filetype) 
    let &filetype = s:filetype
  endif
  syntax on

execute 'buffer '. l:bufnum
endif " XXXX

endfunction
