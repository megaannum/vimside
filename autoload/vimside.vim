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
    return [0, {}, {}]
  endif

  if ! has_key(dic, ":root-dir")
    let dic[":root-dir"] = fnamemodify(a:filename, ":p:h")
  endif
  let g:vimside.ensime.config = dic
  return [1, sexp, dic]
endfunction

function! vimside#PreStart()
  if ! g:vimside.pre_started 
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
  endif
endfunction

function! vimside#StartEnsime()
  if ! g:vimside.started 
    let msg = "Starting Ensime Engine ..."
    call vimside#cmdline#Display(msg)

    call vimside#PreStart()

    call vimside#StartEnsimeServer()
    let g:vimside.started = 1

sleep 4

    call vimside#GetPortEnsime()

    let l:name = "ping_ensime_server"
    let l:Func = function("vimside#PingEnsimeServer")
    let l:sec = 1
    let l:msec = 0
    let l:charcnt = 200
    let l:repeat = 1
    call vimside#scheduler#AddJob(l:name, l:Func, l:sec, l:msec, l:charcnt, l:repeat)

sleep 2
call s:LOG("vimside#StartEnsime get connection") 
    let g:vimside['socket'] = vimside#GetConnectionSocketEnsime()

call s:LOG("vimside#StartEnsime call vimside#swank#rpc#connection_info#Run") 
    call vimside#swank#rpc#connection_info#Run()
call s:LOG("vimside#StartEnsime call vimside#swank#rpc#init_project#Run") 
    call vimside#swank#rpc#init_project#Run()

call s:LOG("vimside#StartEnsime call vimside#hooks#StartAutoCmd") 
    call vimside#hooks#StartAutoCmd()
  else
    let msg = "Ensime Engine Already Running ..."
    call vimside#cmdline#Display(msg)
  endif
endfunction


function! vimside#StopEnsime()
  if g:vimside.started
" XXXXXXXXXXXXX
    call vimside#hooks#StopAutoCmd()

    " call vimside#RemoveAutoCmds()
    vimside#scheduler#ClearAuto()
    call vimside#swank#rpc#shutdown_server#Run()

    call vimside#ensime#io#close()
    let g:vimside.started = 0
  endif
endfunction

function! vimside#StartEnsimeServer()
  let [found, portfile] = g:vimside.GetOption('ensime-port-file-path')
  if ! found
    echoerr "Option not found: "'ensime-port-file-path'"
  endif

call s:LOG("vimside#StartEnsimeServer portfile=" . portfile) 
  let [found, dpath] = g:vimside.GetOption('ensime-dist-path')
  if ! found
    echoerr "Option not found: "'ensime-dist-path'"
  endif

  let cmd = 'cd ' . dpath . ' && ./bin/server ' . shellescape(portfile)

  let [s:found, l:log_enabled] = g:vimside.GetOption('ensime-log-enabled')
  if ! s:found
    echoerr "Option not found: "'ensime-log-enabled'"
  endif

" echo "StartEnsimeServer: log_enabled=" . l:log_enabled
  if l:log_enabled
    let lines = [
      \ "##################################################################",
      \ "Title: Ensime Server log file",
      \ "Date: " . strftime("%Y%m%d %T"),
      \ "##################################################################"
      \ ]

    let [found, l:logfile] = g:vimside.GetOption('ensime-log-file-path')
    if ! found
      echoerr "Option not found: "'ensime-log-file-path'"
    endif

    call writefile(lines, l:logfile)

    execute "silent !" . cmd . " &>> " . l:logfile . " &"

  else
    " TODO remove
    " if has('win16') || has('win32') || has('win64')
    
    if g:vimside.os.is_mswin 
      " Note: do not know if this is correct
      let l:logfile = "NUL"
    else
      let l:logfile = "/dev/null"
    endif

    execute "silent !" . cmd . " &> " . l:logfile . " &"
  endif

endfunction

function! vimside#GetPortEnsime()
call s:LOG("vimside#GetPortEnsime TOP") 
  let [found, portfile] = g:vimside.GetOption('ensime-port-file-path')
  if ! found
    echoerr "Option not found: "'ensime-port-file-path'"
  endif

  " wait for port file to be created and written to
  let cnt = 0
  let [found, max_cnt] = g:vimside.GetOption('ensime-port-file-max-wait')
  if ! found
    echoerr "Option not found: "'ensime-port-file-max-wait'"
  endif

call s:LOG("vimside#GetPortEnsime max_cnt=" . max_cnt) 
  while ! filereadable(portfile) && cnt < max_cnt
    sleep 1
    let cnt += 1
  endwhile

  if ! filereadable(portfile)
    echoerr "Vimside Failed to start Ensime Server port file does not exists"
  endif

  let portfile_lines = readfile(portfile)
  if len(portfile_lines) != 1
    echoerr "Vimside Ensime Server port file not single line: " . string(portfile_lines)
  endif

  let portstr = portfile_lines[0]
  let port = 0 + portstr
  call g:vimside.SetOption('ensime_port_number', port)
call s:LOG("vimside#GetPortEnsime BOTTOM") 
endfunction

function! vimside#GetConnectionSocketEnsime()
call s:LOG("vimside#GetConnectionSocketEnsime TOP") 

  let [found, port] = g:vimside.GetOption('ensime_port_number')
  if ! found
    echoerr "Option not found: "'ensime_port_number'"
  endif

  let [found, host] = g:vimside.GetOption('ensime-host-name')
  if ! found
    echoerr "Option not found: "'ensime-host-name'"
  endif

call s:LOG("host:port=" . host .":". port) 

  let l:socket = vimside#ensime#io#open(host, port)
" call s:LOG("socket=" . string(l:socket)) 
  return l:socket
endfunction

" ============================================================================
" Ping
" ============================================================================

function! vimside#PingEnsimeServer()
call s:LOG("vimside#PingEnsimeServer") 
  let timeout = g:vimside.ping.info.read_timeout
  let success = vimside#ensime#io#ping(timeout)
  while success
    let success = vimside#ensime#io#ping(timeout)
  endwhile
endfunction

if 0 " YYYYYYYYYYYYYYY
" ============================================================================
" Completion code
" ============================================================================
"
" 1) get completions
"   GetCompletions
" 2) display completions
"   DisplayCompletions
"
"

let s:completions_phase = 0
let g:completions_in_process = 0
let s:completions_start = 0
let g:completions_base = ''
let g:completions_results = []

function!  vimside#Completions(findstart, base)
" call s:LOG("vimside#Completions findstart=". a:findstart .", base=". a:base) 
  if ! g:vimside.started
    return
  endif
" call s:LOG("vimside#Completions completions_phase=". s:completions_phase) 

  if s:completions_phase == 0
    " Get Completions
    if a:findstart 
      let g:completions_in_process = 1
      w
      let line = getline('.')
      let pos = col('.') -1
      let bc = strpart(line,0,pos)
      let match_text = matchstr(bc, '\zs[^ \t#().[\]{}\''\";: ]*$')
" call s:LOG("vimside#Completions match_text=". match_text) 
      let s:completions_start = len(bc)-len(match_text)
" call s:LOG("vimside#Completions completions_start=". s:completions_start) 
      call vimside#StartAutoCmdCompletions()
      return s:completions_start 
    elseif ! g:completions_in_process
      return []
    else
      if len(a:base) > 0
        let g:completions_base = a:base
        let g:completions_results = []
        call vimside#swank#rpc#completions#Run()
        let s:completions_phase = 1
      else
        let s:completions_phase = 0
      endif
" call s:LOG("vimside#Completions return []")
      return []
    endif
  elseif ! g:completions_in_process
    if a:findstart 
      return ''
    else
      return []
    endif
  else
    " Display Completions
    if a:findstart 
" call s:LOG("vimside#Completions completions_start=". s:completions_start) 
      return s:completions_start
    else
      let s:completions_phase = 0
      let g:completions_base = ''
" call s:LOG("vimside#Completions g:completions_results=". string(g:completions_results))
      let g:completions_in_process = 0
      call vimside#StopAutoCmdCompletions()
      return g:completions_results
    endif

  endif
endfunction

function!  vimside#AbortCompletions()
" call s:LOG("vimside#AbortCompletions") 
  if pumvisible() == 0
    let s:completions_phase = 0
    let g:completions_in_process = 0
    call vimside#StopAutoCmdCompletions()
  endif
endfunction

function!  vimside#StartAutoCmdCompletions()
  augroup VIMSIDE_COMPLETIONS
    au!
    autocmd CursorMovedI,InsertLeave *.scala call vimside#AbortCompletions()
  augroup end
endfunction
function!  vimside#StopAutoCmdCompletions()
  augroup VIMSIDE_COMPLETIONS
    au!
  augroup END
endfunction
endif " YYYYYYYYYYYYYYY
