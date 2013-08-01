" ============================================================================
" vimside.vim
"
" File:          vimside.vim
" Summary:       Vimside top level file
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
" Version:       See: autoload/vimside/version.vim
" Modifications:
"
" Tested on vim 7.3 on Linux
"
" Depends upon: NONE
"
" ============================================================================
" Intro: {{{1
" ============================================================================


function! vimside#version()
  return vimside#version#Str()
endfunction

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let g:vimside = {} 
let g:vimside.pre_started = 0
let g:vimside.started = 0
let g:vimside.errors = []
let g:vimside.warns = []

let g:vimside.ensime = {} 
let g:vimside.ensime.info = {} 

let g:vimside.plugins = {} 

" actions to be invoked on next ping (then cleared from list)
let g:vimside.ping = {}
" XXXXXXXXXXXXX
" let g:vimside.ping.actions = []
let g:vimside.ping.info = {}
" how long to wait on an ensime server socket read (milliseconds)
let g:vimside.ping.info.read_timeout = 0
" how long after last character typed before scheduler is invoked (milliseconds)
let g:vimside.ping.info.updatetime = 500
" how many characters type before scheduler is invoked
let g:vimside.ping.info.char_count = 10

" will hold
"   info
"   scala_notes
"   java_notes
let g:vimside.project = {} 
" will hold
"   name
"   source_roots
let g:vimside.project.info = {} 
" will hold
let g:vimside.project.scala_notes = []
let g:vimside.project.java_notes = []
" [bufnum, [0, lnum, col, offset]]
let g:vimside.project.positions = []


" waiting for a response
" ping-info: expecting/not-expecting rpc and/or event
let g:vimside.swank = {} 
let g:vimside.swank.rpc = {} 
" waiting = { id: rr }
let g:vimside.swank.rpc.waiting = {} 
" expected number of events from ensime server still not received
" legal values are numbers 0 ... n and string 'many'
let g:vimside.swank.events = 0
" holds 'read_timeout', 'updatetime' and 'char_count'
" set by command handler when it needs to override default
" behavior in swank s:PostHandle
let g:vimside.swank.ping_data = {}


" how often each event has been recieved
let g:vimside.status = {} 
" default handlers are in autoload/swank/rpc/
let g:vimside.event_handlers = {} 
let g:vimside.debug_event_handlers = {} 
let g:vimside.event_trigger = {} 
let g:vimside.debug_trigger = {} 

let g:vimside.os = {}
let g:vimside.os.name = 'unknown'
for osn in ["unix", 
          \ "win16", "win32", "win64", "win32unix", "win95", "dos32", 
          \ "mac", "macunix", "amiga", "os2", "qnx", "beos", "vms"]
  if has(osn)
    let g:vimside.os.name = osn
    break
  endif
endfor

let g:vimside.os.is_cygwin = 0
let g:vimside.os.is_unix = 0
let g:vimside.os.is_mswin = 0
let g:vimside.os.is_macunix = 0
let g:vimside.os.is_unknown = 0

if has("win32unix") && has("unix") 
  let g:vimside.os.kind = "cygwin"
  let g:vimside.os.is_cygwin = 1
elseif !has("win32unix") && has("unix") && !has("macunix")
  let g:vimside.os.kind = "unix"
  let g:vimside.os.is_unix = 1
elseif has('win16') || has('win32') || has('win64') || has('dos32')
  let g:vimside.os.kind = "mswin"
  let g:vimside.os.is_mswin = 1
elseif has('macunix')
  let g:vimside.os.kind = "macunix"
  let g:vimside.os.is_macunix = 1
else
  let g:vimside.os.kind = "unknown"
  let g:vimside.os.is_unknown = 1
endif

function! g:ResponsePending()
  return ! empty(g:vimside.rpc.waiting)
endfunction
let g:vimside.ResponsePending = function('g:ResponsePending')

function! g:CompilerReady()
  " defined in vimside/ensime/swank
  return g:vimside.status.compiler_ready
endfunction
let g:vimside.CompilerReady = function('g:CompilerReady')

function! g:IndexerReady()
  " defined in vimside/ensime/swank
  return g:vimside.status.indexer_ready
endfunction
let g:vimside.IndexerReady = function('g:IndexerReady')


" return [ok, sexp, dic]
function! vimside#EnsimeConfigLoad(filename)
  let sexp = vimside#sexp#LoadFile(a:filename)

  let [ok, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(sexp)
  if ! ok
    echoe "Warning: bad config file: ". a:filename
    return [0, sexp, dic]
  endif

  if type(dic) != type({})
    echoe "Warning: bad config file: ". a:filename . " content"
    return [0, sexp, dic]
  endif

  if ! has_key(dic, ":root-dir")
    let dic[":root-dir"] = fnamemodify(a:filename, ":p:h")
  endif
  let g:vimside.ensime.config = dic
  return [1, sexp, dic]
endfunction

function! vimside#PreStart()
  if g:vimside.pre_started 
    return
  endif

  " Ok, are all of the plugins we need avaiable
  call vimside#vimplugins#Check()

  if len(g:vimside.errors) != 0
    throw "Plugin Error: ". string(g:vimside.errors)
  endif

  " Next, load options
  call vimside#options#manager#Load()

  if len(g:vimside.errors) != 0
    throw "Option Load Errors: ". string(g:vimside.errors)
  endif


  " Next, load event handlers
  call vimside#ensime#swank#load_handlers()

  if len(g:vimside.errors) != 0
    throw "Load Handlers Errors: ". string(g:vimside.errors)
  endif

  " Now, load rpc and event ping info
  call vimside#ensime#swank#load_ping_info()

  if len(g:vimside.errors) != 0
    throw "Load Ping Info Errors: ". string(g:vimside.errors)
  endif

  let g:vimside.pre_started = 1

endfunction

"
" Main entry point
"
function! vimside#StartEnsime()
  if g:vimside.started 
call s:LOG("vimside#StartEnsime Ensime Engine Already Running") 
    let msg = "Ensime Engine Already Running ..."
    call vimside#cmdline#Display(msg)
    return
  endif

  let msg = "Starting Ensime Engine ..."
  call vimside#cmdline#Display(msg)

  call vimside#PreStart()
call s:LOG("vimside#StartEnsime after vimside#PreStart") 

  " How long to sleep after starting Ensime Server before 
  " trying to read ther port file (written by server)
  " 2 to 4 seconds is about right
  let [found, wtime] = g:vimside.GetOption('vimside-port-file-wait-time')
  if found
    let l:wait_time = wtime
  else
    let l:wait_time = 4
  endif

  let l:try_again_attempts = 2
  let l:try_again = 1
  while l:try_again

    let l:try_again = 0

    let l:had_to_start = vimside#StartEnsimeServer()
call s:LOG("vimside#StartEnsime had_to_start=". l:had_to_start) 
    let g:vimside.started = 1

    execute "sleep ". l:wait_time

    call vimside#GetPortEnsime()

call s:LOG("vimside#StartEnsime get connection") 
    try 
      let [found, socket] = vimside#GetConnectionSocketEnsime()
      if found
" call s:LOG("vimside#StartEnsime set vimside socket") 
        let g:vimside['socket'] = socket
      endif
    catch /.*/
      call s:ERROR("vimside#StartEnsime socket connect:". v:exception) 
      if  ! l:had_to_start
        " maybe a bad port file
        let [found, portfile] = g:vimside.GetOption('ensime-port-file-path')
        if found
          call delete(portfile)
          if l:try_again_attempts > 0
            let l:try_again_attempts -= 1
            let l:try_again = 1
          endif
        endif
      endif
    endtry

  endwhile

  " Test to see if we shutdown Ensime when we exit Vim
  let [s:found, l:auto_shutdown] = g:vimside.GetOption('ensime-shutdown-on-vim-exit')
  if ! s:found
    echoerr "Option not found: "'ensime-shutdown-on-vim-exit'"
  elseif l:auto_shutdown
call s:LOG("vimside#StartEnsime Register vimside#StopEnsime") 
    call vimside#hooks#AddHook('VimLeave', function("vimside#StopEnsime"))

  endif


call s:LOG("vimside#StartEnsime register pinger") 
  let l:name = "ping_ensime_server"
  let l:Func = function("vimside#PingEnsimeServer")
  let l:sec = 1
  let l:msec = 0
  let l:charcnt = 200
  let l:repeat = 1
  call vimside#scheduler#AddJob(l:name, l:Func, l:sec, l:msec, l:charcnt, l:repeat)
" sleep 2


call s:LOG("vimside#StartEnsime call vimside#swank#rpc#connection_info#Run") 
  call vimside#swank#rpc#connection_info#Run()
  if l:had_to_start
call s:LOG("vimside#StartEnsime call vimside#swank#rpc#init_project#Run") 
    call vimside#swank#rpc#init_project#Run()
  endif

  " REMOVE
"call s:LOG("vimside#StartEnsime call vimside#hooks#StartAutoCmd") 
  " call vimside#hooks#StartAutoCmd()
" call s:LOG("vimside#StartEnsime call vimside#hooks#AssciateHooksAutoCmd") 
"  call vimside#hooks#AssciateHooksAutoCmd()

call s:LOG("vimside#StartEnsime call vimside#hooks#Run('PostStartUp')") 
  call vimside#hooks#Run('PostStartUp')

call s:LOG("vimside#StartEnsime BOTTOM") 
endfunction


function! vimside#StopEnsime()
  if ! g:vimside.started
  endif

  call vimside#hooks#Run('PreShutDown')

" XXXXXXXXXXXXX REMOVE
  " call vimside#hooks#StopAutoCmd()
  "call vimside#scheduler#StopAuto() 


  " call vimside#RemoveAutoCmds()
  " vimside#scheduler#ClearAuto()

  call vimside#swank#rpc#shutdown_server#Run()

  call vimside#ensime#io#close()

  let g:vimside.started = 0
endfunction

" return 0 port file already exists, so Ensime server already running
" return 1 port file does not exist, so start Ensime server 
function! vimside#StartEnsimeServer()
  let [found, portfile] = g:vimside.GetOption('ensime-port-file-path')
  if ! found
    echoerr "Option not found: "'ensime-port-file-path'"
    return 0
  endif

call s:LOG("vimside#StartEnsimeServer portfile=" . portfile) 
  let [found, dpath] = g:vimside.GetOption('ensime-dist-path')
  if ! found
    echoerr "Option not found: "'ensime-dist-path'"
    return0
  endif

  let portFileExists = filereadable(portfile)
call s:LOG("vimside#StartEnsimeServer portFileExists=". portFileExists) 

  if portFileExists
    return 0
  else

    let cmd = 'cd ' . dpath . ' && ./bin/server ' . shellescape(portfile)

    let [s:found, l:log_enabled] = g:vimside.GetOption('ensime-log-enabled')
    if ! s:found
      echoerr "Option not found: "'ensime-log-enabled'"
    endif

  " echo "StartEnsimeServer: log_enabled=" . l:log_enabled
    if l:log_enabled
      let [found, l:logfile] = g:vimside.GetOption('ensime-log-file-path')
      if ! found
        echoerr "Option not found: "'ensime-log-file-path'"
      else
        let [s:found, s:use_pid] = g:vimside.GetOption('ensime-log-file-use-pid')
        if s:found 
          if s:use_pid
            let l:logfile .= "_". getpid()
          endif
        else
          echoerr "Option not found: " . 'ensime-log-file-use-pid'
        endif
      endif


      let separator = repeat("-", 80)
      let l:lines = [
        \ separator,
        \ 'Title: Ensime Server log file',
        \ 'Date: ' . strftime("%Y%m%d %T"),
        \ separator
        \ ]
  
      for line in l:lines
        execute "silent !echo \"". line . "\" >> ". l:logfile 
      endfor

      " bash pre-4.0
      " cmd >> outfile 2>&1
      execute "silent !" . cmd . " >> " . l:logfile . " 2>&1 &"

      " bash post-4.0
      " execute "silent !" . cmd . " &>> " . l:logfile . " &"

    else
      
      if g:vimside.os.is_mswin 
        " Note: do not know if this is correct
        let l:logfile = "NUL"
      else
        let l:logfile = "/dev/null"
      endif

      execute "silent !" . cmd . " &> " . l:logfile . " &"
    endif
  endif

call s:LOG("vimside#StartEnsimeServer Ensime launched") 
  return  1

endfunction

function! vimside#GetPortEnsime()
call s:LOG("vimside#GetPortEnsime TOP") 
  let [found, portfile] = g:vimside.GetOption('ensime-port-file-path')
  if ! found
    let msg = "Option not found: "'ensime-port-file-path'"
    echoerr msg
    throw msg
  endif

  " wait for port file to be created and written to
  let cnt = 0
  let [found, max_cnt] = g:vimside.GetOption('ensime-port-file-max-wait')
  if ! found
    let msg = "Option not found: "'ensime-port-file-max-wait'"
    echoerr msg
    throw msg
  endif

call s:LOG("vimside#GetPortEnsime max_cnt=" . max_cnt) 
  while ! filereadable(portfile) && cnt < max_cnt
    sleep 1
    let cnt += 1
  endwhile

  if ! filereadable(portfile)
    let msg = "Vimside Failed to start Ensime Server port file does not exists"
    echoerr msg
    throw msg
  endif

  let portfile_lines = readfile(portfile)
  if len(portfile_lines) != 1
    let msg = "Vimside Ensime Server port file not single line: " . string(portfile_lines)
    echoerr msg
    throw msg
  endif

  let portstr = portfile_lines[0]
  let port = 0 + portstr
call s:LOG("vimside#GetPortEnsime port=". port) 
  call g:vimside.UpdateOption('ensime_port_number', port)
endfunction

function! vimside#GetConnectionSocketEnsime()
call s:LOG("vimside#GetConnectionSocketEnsime TOP") 

  let [found, port] = g:vimside.GetOption('ensime_port_number')
  if ! found
    echoerr "Option not found: "'ensime_port_number'"
    return [0, ""]
  endif

  let [found, host] = g:vimside.GetOption('ensime-host-name')
  if ! found
    echoerr "Option not found: "'ensime-host-name'"
    return [0, ""]
  endif

call s:LOG("vimside#GetConnectionSocketEnsime host:port=" . host .":". port) 

  let l:socket = vimside#ensime#io#open(host, port)
call s:LOG("socket=" . string(l:socket)) 
  return [1, l:socket]
endfunction

" ============================================================================
" Ping
" ============================================================================

function! vimside#PingEnsimeServer()
call s:LOG("vimside#PingEnsimeServer") 
  let timeout = g:vimside.ping.info.read_timeout
call s:LOG("vimside#PingEnsimeServer: timeout=". timeout) 
  let success = vimside#ensime#io#ping(timeout)
  while success
    let success = vimside#ensime#io#ping(timeout)
  endwhile
endfunction



" ============================================================================
" Signal an event. Send to testing harness if it exists.
" Used to drive asynchronous regression tests.
" event optional value
" ============================================================================
function! vimside#EventSignal(event, ...)
  if exists("g:vimside.test.signal")
    if if a:0 == 1
    call g:vimside.test.signal(a:event, a:1)
    else
    call g:vimside.test.signal(a:event)
    endif
  endif
endfunction

" ============================================================================
" Register Hooks
" ============================================================================

call vimside#hooks#AddHook('PostStartUp', function("vimside#hooks#AssciateHooksAutoCmd"))

call vimside#hooks#AddHook('PostBufferRead', function("vimside#command#TypecheckFileOnWrite"))
call vimside#hooks#AddHook('PostBufferWrite', function("vimside#command#TypecheckFileOnWrite"))
call vimside#hooks#AddHook('PostBufferWrite', function("vimside#command#BuilderTrackFile"))

" ---------------------------------
" these two pairs have some overlap
" ---------------------------------
call vimside#hooks#AddHook('PreShutDown', function("vimside#hooks#ClearHooksAutoCmd"))
call vimside#hooks#AddHook('PreShutDown', function("vimside#scheduler#StopAuto"))
call vimside#hooks#AddHook('VimLeave', function("vimside#hooks#ClearHooksAutoCmd"))
call vimside#hooks#AddHook('VimLeave', function("vimside#hooks#ClearHooksAutoCmd"))
call vimside#hooks#AddHook('VimLeave', function("vimside#scheduler#StopAuto"))
