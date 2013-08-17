" ============================================================================
" sbt.vim
"
" File:          sbt.vim
" Summary:       Vimside interface with SBT
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:subproc = {}
" off, starting, running, wait_results
let s:state = 'off'
let s:sbt_switch = 'sbt_switch'
let s:sbt_compile = 'sbt_compile'
let s:sbt_clean = 'sbt_clean'
let s:sbt_package = 'sbt_package'

let [found, longline] = g:vimside.GetOption('tailor-sbt-compile-error-long-line-quickfix')
if found
  let s:sbt_longline = longline
else
  let s:sbt_longline = 0
endif
let [found, read_size] = g:vimside.GetOption('tailor-sbt-error-read-size')
if found
  let s:sbt_read_size = read_size
else
  let s:sbt_read_size = 10000
endif
let [found, use_signs] = g:vimside.GetOption('tailor-sbt-use-signs')
if found
  let s:sbt_use_signs = use_signs
else
  let s:sbt_use_signs = 0
endif

let s:match_prompt = '^\(>\|scala>\|\[project_name\] \$\) $'
let s:match_info = '^\[info\]\([^\n]*\)$'
let s:match_warn = '^\[warn\]\([^\n]*\)$'
let s:match_error = '^\[error\] .\+$'
let s:match_error_compile = '^\[error\] Error running compile:'
let s:match_success = '^\[success\] \(.*\)$'
let s:match_compile = '^compile$'

let s:match_error_file = '^\[error\] \(.\+\)\.\(scala\|java\):\([0-9]\+\): \(.*\)$'
" [error]      ^
let s:match_error_column = '^\[error\] \( \+\)\^$'
let s:match_error_msg = '^\[error\] \([^\n]*\)$'

let s:max_counter = 0

function! s:cmdline_echo(echolines)
  if ! empty(a:echolines)
    let lines = ""
    let maxlen = 50
    let cnt = 1
    for line in a:echolines
      if maxlen < len(line)
        let cnt += 1
        " let maxlen = len(line)
      endif
      if lines == ""
        let lines = line
      else
        let lines .= "\n" . line
      endif
      let cnt += 1
    endfor
    let &cmdheight = cnt
    echo lines
    if cnt > 1
call s:LOG("s:cmdline_echo: adding motion job ResetCmdheight")
      let l:Func = function("g:ResetCmdheight")
      let charcnt = 0
      let repeat = 0
      call vimside#scheduler#AddMotionJob("sbt_rest_cmdheight", Func, charcnt, repeat)
      let s:max_counter = vimside#scheduler#GetMaxMotionCounter()
      call vimside#scheduler#SetMaxMotionCounter(0)

    endif
  endif
endfunction

function! g:ResetCmdheight()
call s:LOG("g:ResetCmdheight: TOP")
  let &cmdheight = 1
  call vimside#scheduler#SetMaxMotionCounter(s:max_counter)
endfunction

" mlist := [ mitem, ... ]
" mitem ;" [ regex, tag ]
" return [status, tag, line]
function! s:match(str, mlist)
  let str = a:str
  let mlist = a:mlist

  for [regex, tag] in mlist
    let m = matchstr(str, regex)
    if m != ""
      return [1, tag, m]
    endif
  endfor
  return [0, '', '']
endfunction

" Switch to the sbt shell.
"   If it is not already there, create it.
"   If already there but the process is dead, restart the SBT process.
function! vimside#command#sbt#Switch()
call s:LOG("vimside#command#sbt#Switch: TOP")
  if has_key(s:subproc, 'pid')
call s:LOG("sbt already running")
    return
  endif

  let cwd = getcwd()
  let [status, path] = s:find_sbt_project_path(cwd)
  if ! status
call s:ERROR("sbt project directory NOT FOUND")
    return
  endif
call s:LOG("sbt: path=" . path)

  let [status, out] = vimside#vimproc#ExistsExecutable('sbt')
  if ! status
call s:ERROR("sbt NOT FOUND")
    return
  endif

call s:LOG("sbt: out-" . out)
  let l:Func = function("g:SbtSwitchCB")
  let l:sec = 1
  let l:msec = 0
  let l:charcnt = 10
  let l:repeat = 1
  call vimside#scheduler#AddJob(s:sbt_switch, l:Func, l:sec, l:msec, l:charcnt, l:repeat) 

exec "lcd ". path
  let s:subproc = vimproc#popen3('sbt -Dsbt.log.noformat=true')
exec "lcd ". cwd 

  let s:state = 'starting'
if has_key(s:subproc, 'pid')
call s:LOG("sbt: pid=" . s:subproc.pid)
endif

  call vimside#scheduler#SetUpdateTime(300)
  call vimside#scheduler#ResetAuto()

call s:LOG("vimside#command#sbt#Switch: BOTTOM")
endfunction


function! g:SbtSwitchCB()
call s:LOG("g:SbtSwitchCB: TOP")
  if s:got_error()
" call s:LOG("g:SbtSwitchCB: got_error")
    return
  endif

  let echolines=[]

  let [status, output] = s:read_stdout()
  if status
    let lines = split(output, '\r\?\n', 1)
call s:LOG("g:SbtSwitchCB: lines=" . string(lines))
    for line in lines
      let mlist=[[s:match_info, 'info'], [s:match_prompt, 'prompt']]
      let [status, tag, line] = s:match(line, mlist)
      if status
call s:LOG("g:SbtSwitchCB: tag=" . tag)
        if tag == 'prompt'
          call vimside#scheduler#RemoveJob(s:sbt_switch)
          call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        elseif tag == 'info'
          call add(echolines, line)
        endif
      elseif line != ''
call s:ERROR("g:SbtSwitchCB: unknown line=" . line)
      endif
    endfor
  endif

  call s:cmdline_echo(echolines)

call s:LOG("g:SbtSwitchCB: BOTTOM")
endfunction

function! vimside#command#sbt#Compile()
call s:LOG("vimside#command#sbt#Compile: TOP")
  let l:Func = function("g:SbtCompileCB")
  let l:sec = 1
  let l:msec = 0
  let l:charcnt = 10
  let l:repeat = 1
  call vimside#scheduler#AddJob(s:sbt_compile, l:Func, l:sec, l:msec, l:charcnt, l:repeat) 
call vimside#scheduler#SetUpdateTime(300)
" call vimside#scheduler#ResetAuto()

  let g:vimside.project.scala_notes = []
  let g:vimside.project.java_notes = []
  call vimside#command#show_errors_and_warning#Close()

  " closes quickfix window (if its open, otherwise nothing)
  " cclose
  
  call s:send("compile")

call s:LOG("vimside#command#sbt#Compile: BOTTOM")
endfunction

function! g:SbtCompileCB()
call s:LOG("g:SbtCompileCB: TOP")
  call s:HandleCompilePackageCB(s:sbt_compile)
call s:LOG("g:SbtCompileCB: BOTTOM")
endfunction


function! vimside#command#sbt#Clean()
call s:LOG("vimside#command#sbt#Clean: TOP")
  let l:Func = function("g:SbtCleanCB")
  let l:sec = 1
  let l:msec = 0
  let l:charcnt = 10
  let l:repeat = 1
  call vimside#scheduler#AddJob(s:sbt_clean, l:Func, l:sec, l:msec, l:charcnt, l:repeat) 
call vimside#scheduler#SetUpdateTime(300)

  call s:send("clean")
call s:LOG("vimside#command#sbt#Clean: BOTTOM")
endfunction

function! g:SbtCleanCB()
call s:LOG("g:SbtCleanCB: TOP")
  if s:got_error()
    return
  endif

  let [status, output] = s:read_stdout()
  if status
    let lines = split(output, '\r\?\n', 1)
    let echolines=[]

call s:LOG("g:SbtCleanCB: lines=" . string(lines))
    for line in lines
call s:LOG("g:SbtCleanCB: line=" . line)
      let mlist=[ 
            \ [s:match_info, 'info'], 
            \ [s:match_success, 'success'], 
            \ [s:match_prompt, 'prompt']
            \ ]
      let [status, tag, line] = s:match(line, mlist)
      if status
call s:LOG("g:SbtCleanCB: tag=" . tag)
        if tag == 'prompt'
          call vimside#scheduler#RemoveJob(s:sbt_clean)
call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        elseif tag == 'success'
          call add(echolines, line)
        elseif tag == 'info'
          call add(echolines, line)
        endif
      elseif line != ''
call s:ERROR("g:SbtCleanCB: unknown line=" . line)
      endif
    endfor

    call s:cmdline_echo(echolines)

  endif
call s:LOG("g:SbtCleanCB: BOTTOM")
endfunction

function! vimside#command#sbt#Package()
call s:LOG("vimside#command#sbt#Package: TOP")
  let l:Func = function("g:SbtPackageCB")
  let l:sec = 1
  let l:msec = 0
  let l:charcnt = 10
  let l:repeat = 1
  call vimside#scheduler#AddJob(s:sbt_package, l:Func, l:sec, l:msec, l:charcnt, l:repeat) 
call vimside#scheduler#SetUpdateTime(300)

  call s:send("package")
call s:LOG("vimside#command#sbt#Package: BOTTOM")
endfunction

function! g:SbtPackageCB()
call s:LOG("g:SbtPackageCB: TOP")
  call s:HandleCompilePackageCB(s:sbt_package)
call s:LOG("g:SbtPackageCB: BOTTOM")
endfunction

function! s:HandleCompilePackageCB(cb_name)
  if s:got_error()
    return
  endif

  let [status, output] = s:read_stdout()
  if status
    let lines = split(output, '\r\?\n', 1)
call s:LOG("s:HandleCompilePackageCB: lines=" . string(lines))
    " for quickfix
    let severity = ""
    let filename = ""
    let linenum = ""
    let colnum = ""
    let msg = ""

    let l:got_prompt = 0

    let echolines=[]

    for line in lines
call s:LOG("s:HandleCompilePackageCB: line=" . line)
      let mlist=[ 
            \ [s:match_info, 'info'], 
            \ [s:match_warn, 'warn'], 
            \ [s:match_error_compile, 'error_compile'], 
            \ [s:match_error, 'error'], 
            \ [s:match_compile, 'compile'],
            \ [s:match_success, 'success'],
            \ [s:match_prompt, 'prompt']
            \ ]
      let [status, tag, line] = s:match(line, mlist)
      if status
call s:LOG("s:HandleCompilePackageCB: tag=" . tag)
        if tag == 'prompt'
call s:LOG("s:HandleCompilePackageCB: PROMPT")
          call vimside#scheduler#RemoveJob(a:cb_name)
call vimside#ensime#swank#ping_info_set_not_expecting_anything()
          let l:got_prompt = 1
        elseif tag == 'warn'
let severity = "warn"
        elseif tag == 'error_compile'
        elseif tag == 'error'
let severity = "error"
" let s:match_error_file = '^\[error\] \(.\+\)\(scala\|java\):\([0-9]\+\): \(.*\)$'
" let s:match_error_column = '^\[error\] \( \+\)\^$'
          let ms = matchlist(line, s:match_error_file)
          if ! empty(ms)
call s:LOG("s:HandleCompilePackageCB: MATCH FILE")
            let filename = ms[1] .'.'. ms[2]
            let type = ms[2]
            let linenum = ms[3]
            let msg = ms[4]
          else
            let ms = matchlist(line, s:match_error_column)
            if ! empty(ms)
              let str = ms[1]
call s:LOG("s:HandleCompilePackageCB: str=\"" . str . "\"")
              let colnum = len(str)
call s:LOG("s:HandleCompilePackageCB: MATCH COLUMN: " . colnum)
              let nr = len(g:vimside.project.scala_notes)+1
              let snote = {
                \ 'filename': filename,
                \ 'lnum': linenum,
                \ 'col': colnum,
                \ 'text': severity .": ". msg,
                \ 'kind': severity,
                \ 'vcol': 1,
                \ 'type': 'a',
                \ 'nr': nr,
                \ }
              if type == 'java'
                call add(g:vimside.project.java_notes, snote)
              else
                call add(g:vimside.project.scala_notes, snote)
              endif
            else
              if s:sbt_longline 
                let extra_msg = matchlist(line, s:match_error_msg)
                if ! empty(extra_msg)
                  let msg = msg . extra_msg[1]
                endif
              endif
            endif
          endif
        elseif tag == 'compile'
        elseif tag == 'info'
          call add(echolines, line)
        elseif tag == 'success'
          call add(echolines, line)
        endif
      elseif line != ''
call s:ERROR("s:HandleCompilePackageCB: unknown line=" . line)
      endif
    endfor

    call s:cmdline_echo(echolines)

    if l:got_prompt
      call vimside#command#show_errors_and_warning#Run("c")
    endif

  endif
endfunction


function! vimside#command#sbt#Exit()
call s:LOG("vimside#command#sbt#Exit: TOP")
  call s:send('exit')
  let s:subproc = {}
  let s:state = 'off'
call s:LOG("vimside#command#sbt#Exit: BOTTOM")
endfunction

function! vimside#command#sbt#Invoke()
call s:LOG("vimside#command#sbt#Invoke: TOP")
  let cwd = getcwd()
  let [status, path] = s:find_sbt_project_path(cwd)
  if ! status
call s:ERROR("sbt project directory NOT FOUND")
    return
  endif
call s:LOG("sbt: path=" . path)

  let [status, out] = vimside#vimproc#ExistsExecutable('sbt')
  if ! status
call s:ERROR("sbt NOT FOUND")
    return
  endif

  let l:command_line = 'sbt'
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
" call s:LOG("SbtInvoke location=".  string(location)) 

    if location == 'same_window'
      let g:vimshell_split_command = 'edit!'
    elseif location == 'split_window'
      let g:vimshell_split_command = 'split!'
    elseif location == 'vsplit_window'
      let g:vimshell_split_command = 'vsplit!'
    elseif location == 'tab_window'
      let g:vimshell_split_command = 'tabnew!'
    endif

" call s:LOG("SbtInvoke args=".  string(args)) 
    let s:filetype = &filetype
    call vimshell#execute_internal_command('iexe', args, context)
    call vimshell#hook#set('postexit', [ function("g:SbtInvokeCallback") ])

    " let b:interactive.is_close_immediately = 1

  catch
    let message = (v:exception !~# '^Vim:')?
        \ v:exception : v:exception . ' ' . v:throwpoint
    call s:ERROR("SbtInvoke: ". printf('%s: %s', l:command_line, message))
    return 0
  endtry


call s:LOG("vimside#command#sbt#Invoke: BOTTOM")
endfunction

function! g:SbtInvokeCallbackAction()
" call s:LOG("SbtInvokeCallbackAction: filetype=". s:filetype) 

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

function! g:SbtInvokeCallback(context, cmdinfolist)
" call s:LOG("SbtInvokeCallback") 

  let l:Func = function("g:SbtInvokeCallbackAction")
  let l:sec = 0
  let l:msec = 300
  let l:charcnt = 2
  let l:repeat = 0
  call vimside#scheduler#AddJob('sbt_callback', l:Func, l:sec, l:msec, l:charcnt, l:repeat)

  call vimside#scheduler#StartAuto()

endfunction



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" return [status, ""]
"    [1, line]
"    [0, '']
function! s:read_stdout()
  if has_key(s:subproc, 'stdout') && !s:subproc.stdout.eof
    let output = s:subproc.stdout.read(s:sbt_read_size, 10)
call s:LOG("sbt: read_stdout output=" . output)
    if output == ''
      return [0, '']
    else
      return [1, output]
    endif

  else
call s:LOG("sbt: read_stdout eof")
    return [0, '']
  endif
endfunction

function! s:read_stderr()
  if has_key(s:subproc, 'stderr') && !s:subproc.stderr.eof
    let output = s:subproc.stderr.read(1000, 10)
" call s:LOG("sbt: read_stderr output=" . output)
    if output == ''
      return [0, '']
    else
      return [1, output]
    endif
  else
" call s:LOG("sbt: read_stderr eof")
    return [0, '']
  endif
endfunction

function! s:send(action)
call s:LOG("vimside#command#sbt s:send: TOP " . a:action)
  let action = a:action . "\n"
  if ! has_key(s:subproc, 'pid')
    call vimside#command#sbt#Switch()
  endif
  let nleft = s:subproc.stdin.write(action, 100)
call s:LOG("vimside#command#sbt s:send: bottom " . nleft)
endfunction

" return 1 if a stderr was read, 0 if all ok
function! s:got_error()
  let [status, lines] = s:read_stderr()
" call s:LOG("s:got_error: status=" . status)
  if status
    for line in lines
call s:LOG("s:got_error: stderr=" . line)
      let mlist=[['.\+', 'ERROR' ]]
      let [status, tag, line] = s:match(line, mlist)
      if status
call s:LOG("s:got_error: tag=" . tag)
      endif
      call vimside#scheduler#RemoveJob(s:sbt_switch)
      call vimside#command#sbt#Exit()
      return 1
    endfor
  else
    return 0
  endif
endfunction

" path related functions
function! s:is_sbt_project_directory(path)
  let path=a:path

  let list = split(globpath(path, "*.sbt"), "\n")
  if ! empty(list)
    return 1
  elseif filereadable(path . "/project/Build.scala")
    return 1
  elseif filereadable(path . "/project/boot")
    return 1
  elseif filereadable(path . "/project/build.properties")
    return 1
  else
    return 0
  endif
endfunction

function! s:get_parent_directory(path)
  return resolve(a:path . "/..")
endfunction

function! s:is_root_directory(path)
  return a:path == resolve(a:path . "/..")
endfunction

" return [status, path]
function! s:find_sbt_project_path(path)
  let path = a:path
  while ! s:is_root_directory(path)
    if s:is_sbt_project_directory(path)
      return [1, path]
    endif
    let path = s:get_parent_directory(path)
  endwhile
  return [0, '']
endfunction

" return [status, path]
function! s:find_sbt_parent_project_path(path)
  let [status, path] = s:find_sbt_project_path(a:path)
  if status
    let path = s:get_parent_directory(path)
    " assumes current path is not the root path
    if s:is_sbt_project_directory(path)
      return [1, path]
    endif
  endif
  return [0, '']
endfunction

function! s:GetLocation()
  let l:option_name = 'tailor-sbt-config-location'
  let l:default_location = 'tab_window'
  return vimside#util#GetLocation(l:option_name, l:default_location)
endfunction
