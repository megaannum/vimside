" ============================================================================
" debug.vim
"
" File:          debug.vim
" Summary:       Vimside Debut
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2013
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:is_debug_init = 0

" History of arguments passed to main class.
let s:default_main_args = ""

" History of main class to debugger.
let s:default_main_class = ""

" History of vm hostname.
let s:default_hostname = "localhost"

" History of vm port.
let s:default_port = "9999"

" History of argument lists passed to jdb."
let s:history = ""

" The unique id of the thread which is currently receiving debug commands.
let s:active_thread_id = ""

" Hook called whenever the debugger suspends a thread
let s:db_thread_suspended_hooks = []

" List of functions called when a ensime network connection closes.
" The functions are called with the process as their argument."
let s:db_net_process_close_hooks = []

" ==============================================
" Init
" ==============================================
function! s:debug_init()
  if ! s:is_debug_init 

    call s:InitSign()

    let s:is_debug_init = 1
  endif
endfunction

" ==============================================
" Sign
" ==============================================

function! s:InitSign()

  let [l:found, l:sign_debug_active_linehl] = g:vimside.GetOption('sign-debug-active-linehl')
  if ! found
    throw "Option not found: sign-debug-active-linehl"
  endif

  let [l:found, l:sign_debug_active_text] = g:vimside.GetOption('sign-debug-active-text')
  if ! found
    throw "Option not found: sign-debug-active-text"
  endif

  let [l:found, l:sign_debug_active_texthl] = g:vimside.GetOption('sign-debug-active-texthl')
  if ! found
    throw "Option not found: sign-debug-active-texthl"
  endif


  let [l:found, l:sign_debug_pending_linehl] = g:vimside.GetOption('sign-debug-pending-linehl')
  if ! found
    throw "Option not found: sign-debug-pending-linehl"
  endif

  let [l:found, l:sign_debug_pending_text] = g:vimside.GetOption('sign-debug-pending-text')
  if ! found
    throw "Option not found: sign-debug-pending-text"
  endif

  let [l:found, l:sign_debug_pending_texthl] = g:vimside.GetOption('sign-debug-pending-texthl')
  if ! found
    throw "Option not found: sign-debug-pending-texthl"
  endif

  let [l:found, l:sign_debug_marker_linehl] = g:vimside.GetOption('sign-debug-marker-linehl')
  if ! found
    throw "Option not found: sign-debug-marker-linehl"
  endif

  let [l:found, l:sign_debug_marker_text] = g:vimside.GetOption('sign-debug-marker-text')
  if ! found
    throw "Option not found: sign-debug-marker-text"
  endif

  let [l:found, l:sign_debug_marker_texthl] = g:vimside.GetOption('sign-debug-marker-texthl')
  if ! found
    throw "Option not found: sign-debug-marker-texthl"
  endif

  let name = 'Debug'
  let cdata = {}
  let cdata['name'] = name
  let cdata['abbreviation'] = 'db'
  let kinds = {}
  let cdata['kinds'] = kinds

  let kdata = {}
  let kdata['linehl'] = l:sign_debug_active_linehl
  let kdata['texthl'] = l:sign_debug_active_texthl
  let kdata['text'] = strpart(l:sign_debug_active_text, 0, 2)
  let kinds['active'] = kdata

  let kdata = {}
  let kdata['linehl'] = l:sign_debug_pending_linehl
  let kdata['texthl'] = l:sign_debug_pending_texthl
  let kdata['text'] = strpart(l:sign_debug_pending_text, 0, 2)
  let kinds['pending'] = kdata

  let kdata = {}
  let kdata['linehl'] = l:sign_debug_marker_linehl
  let kdata['texthl'] = l:sign_debug_marker_texthl
  let kdata['text'] = strpart(l:sign_debug_marker_text, 0, 2)
  let kinds['marker'] = kdata

  let cdata['ids'] = {}

  " let s:categories[name] = cdata
  call vimside#sign#AddCategory(name, cdata)
endfunction

" Face used for marking lines with breakpoints.
let s:breakpoint_face = {
                \ "background_dark": "DarkGreen"
                \ "background_light": "LightGreen"
                \ }

" Face used for marking lines with a pending breakpoints.
let s:pending_breakpoint_face = {
                \ "background_dark": "DarkGreen"
                \ "background_light": "LightGreen"
                \ }

" Face used for marking the current point of execution
let s:marker_face = {
                \ "background_dark": "DarkGoldenrod4"
                \ "background_light": "DarkGoldenrod2"
                \ }

function! s:debug_create_breakpoint_overlays(bps, kind) 
call s:LOG("g:debug_create_breakpoint_overlays: TOP")
  let l:list = []
  for bp in a:bps
    let l:file = bp[":file"]
    let l:line = bp[":line"]
    call append(l:list, { "file": l:file, "line": l:line }}
  endfor
  call vimside#sign#PlaceMany(l:list, 'Debug', a:kind)

call s:LOG("g:debug_create_breakpoint_overlays: BOTTOM")
endfunction

" Clear all Debug signs
function! s:db_clear_all_overlays()
  call vimside#sign#ClearCategory('Debug')
endfunction

" Remove all overlays that ensime-debug has created
function! s:db_clear_breakpoint_overlays()
  call vimside#sign#ClearKind('Debug', 'active')
  call vimside#sign#ClearKind('Debug', 'pending')
endfunction

" Remove all overlays that ensime-debug has created
function! s:db_clear_marker_overlays()
  call vimside#sign#ClearKind('Debug', 'marker')
endfunction

" function! s:db_set_marker_overlays(line, file)
"   call vimside#sign#Place(line, file, 'Debug', 'marker')
" endfunction

function! s:debug_set_marker(line, file)
  call s:db_clear_marker_overlays()

  " TODO Option tailor
  let l:dic = { 
         \ "line": a:line, 
         \ "file": a:file,
         \ "location": "same_window"
         \ "edit_existing": 0
         \ }
  vimside#util#GotoSourceLocation(l:dic)

  call vimside#sign#Place(a:line, a:file, 'Debug', 'marker')
endfunction

" ==============================================
" Utils
" ==============================================

" Get the command needed to launch a debugger, including all
" the current project's dependencies. 
" Returns list of form [cmd [arg]*]
function! s:get_command_line()
  let l:prompt = "Qualified name of class to debug: "
  " NOTE: no command completion used currently see command-completion-custom
  let l:cmd_line = input(l:prompt, s:default_main_class)

  let l:prompt = "CommandLine arguements: "
  let l:debug_args = input(l:prompt, s:default_main_args)

  let s:default_main_class = l:cmd_line
  let s:default_main_args = l:debug_args

  return l:cmd_line ."  ". l:debug_args
endfunction


" Get the target hostname
function! s:debug_get_hostname()
  let l:prompt = "Hostname: "
  let l:hostname = input(l:prompt, s:default_hostname)
  let s:default_hostname = l:hostname
  return l:hostname
endfunction

" Get the target port
function! s:debug_get_port()
  let l:prompt = "Port: "
  let l:port = input(l:prompt, s:default_port)
  let s:default_port = l:port
  return l:port
endfunction

function! s:db_run_thread_suspended_hooks()
  for Hook in s:db_thread_suspended_hooks
    try
      call Hook()
    catch /.*/
      call s:ERROR("db_run_thread_suspended_hooks: ". v:exception ." at ". v:throwpoint)
    endtry
  endfor
endfunction

function! s:db_run_net_process_close_hooks(process)
  for Hook in s:db_net_process_close_hooks
    try
      call Hook(a:process)
    catch /.*/
      call s:ERROR("db_run_net_process_close_hooks: ". v:exception ." at ". v:throwpoint)
    endtry
  endfor
endfunction

" ==============================================
" Hooks
" ==============================================

function! g:db_update_backtraces()
  call  s:db_backtrace(1)
endfunction

" Show the backtrace for the current suspended thread.
"
function! s:db_backtrace(no_select)
  "String: The unique id of the thread.
  "Int: The index of the first frame to list. The 0th frame is the
  "  currently executing frame.
  "  Int: The number of frames to return. -1 denotes _all_ frames.
  let index = 0
  let number_to_return = -1
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_backtrace_success_callback"),
        \ },
        \ 'args': {
        \   "active_thread_id": s:active_thread_id
        \   "index": s:index
        \   "number_to_return": s:number_to_return
        \ }
        \ }
  call vimside#swank#rpc#debug_backtrace#Run(dic)
endfunction

function! g:debug_backtrace_success_callback(dic)
call s:LOG("g:debug_backtrace_success_callback: TOP")
  
call s:LOG("g:debug_backtrace_success_callback: dic=". string(a:dic))

  if has_key(a:dic, ':frames')
call s:LOG("g:debug_backtrace_success_callback: frames=". string(a:dic[':frames']))
  endif
  if has_key(a:dic, ':thread-id')
call s:LOG("g:debug_backtrace_success_callback: thread-id=". string(a:dic[':thread-id']))
  endif
  if has_key(a:dic, ':thread-name')
call s:LOG("g:debug_backtrace_success_callback: thread-name=". string(a:dic[':thread-name']))
  endif

  " TODO display frames
call s:LOG("g:debug_backtrace_success_callback: BOTTOM")
endfunction


function! g:db_connection_closed(process)
  call s:db_clear_all_overlays()
endfunction

" ============================================================================
" API: {{{1
" ============================================================================

" ==============================================
" Start
" ==============================================

" Start and run the debugger.
function! vimside#command#debug#Start()
call s:LOG("vimside#command#debug#Start: TOP")
  let l:cmd_line = s:get_command_line()

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_start_success_callback"),
        \   'abort': function("g:debug_start_abort_callback")
        \ },
        \ 'args': {
        \   "cmd_line": l:cmd_line
        \ }
        \ }
  call vimside#swank#rpc#debug_start#Run(dic)
call s:LOG("vimside#command#debug#Start: BOTTOM")
endfunction

function! g:debug_start_success_callback(dic)
call s:LOG("g:debug_start_success_callback: TOP")
  let l:msg = "Starting debug VM..."
  call vimside#cmdline#Display(l:msg)

  call append(s:db_thread_suspended_hooks, g:db_update_backtraces)
  call append(s:db_net_process_close_hooks, g:db_connection_closed)

call s:LOG("g:debug_start_success_callback: BOTTOM")
endfunction

function! g:debug_start_abort_callback(code, details, ...)
call s:LOG("g:debug_start_abort_callback: TOP")
  let l:msg = "An error occured during starting debug VM: ". string(a:details)
  call vimside#cmdline#Display(l:msg)
call s:LOG("g:debug_start_abort_callback: BOTTOM")
endfunction

" ==============================================
" Attach
" ==============================================

function! vimside#command#debug#Attach()
call s:LOG("vimside#command#debug#Attach: TOP")
  let l:hostname = s:debug_get_hostname()
  let l:port = s:debug_get_port()

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_attach_success_callback"),
        \   'abort': function("g:debug_attach_abort_callback")
        \ },
        \ 'args': {
        \   "hostname": l:hostname,
        \   "port": l:port
        \ }
        \ }
  call vimside#swank#rpc#debug_start#Run(dic)

call s:LOG("vimside#command#debug#Attach: BOTTOM")
endfunction

function! g:debug_attach_success_callback(dic)
call s:LOG("g:debug_attach_success_callback: TOP")
  let l:msg = "Attaching to target VM..."
  call vimside#cmdline#Display(l:msg)

  call append(s:db_thread_suspended_hooks, g:db_update_backtraces)
  call append(s:db_net_process_close_hooks, g:db_connection_closed)

call s:LOG("g:debug_attach_success_callback: BOTTOM")
endfunction

function! g:debug_attach_abort_callback(code, details, ...)
call s:LOG("g:debug_attach_abort_callback: TOP")
  let l:msg = "An error occured during attaching to target VM: ". string(a:details)
  call vimside#cmdline#Display(l:msg)
call s:LOG("g:debug_attach_abort_callback: BOTTOM")
endfunction

" ==============================================
" Start and Run
" ==============================================

 " Start and run the debugger.
function! vimside#command#debug#Run()
call s:LOG("vimside#command#debug#Run: TOP")

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_active_vm_success_callback")
        \ }
        \ }
  call vimside#swank#rpc#debug_active_vm#Run(dic)
call s:LOG("vimside#command#debug#Run: BOTTOM")
endfunction

function! g:debug_active_vm_success_callback(dic)
call s:LOG("g:debug_active_vm_success_callback: TOP")
call s:LOG("g:debug_active_vm_success_callback: dic=". string(a:dic))
  if a:dic == "nil"
    call vimside#command#debug#Start()
  else
    call s:debug_run()
  endif
call s:LOG("g:debug_active_vm_success_callback: BOTTOM")
endfunction

function! s:debug_run()
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_run_success_callback")
        \ }
        \ }
  call vimside#swank#rpc#debug_run#Run(dic)
endfunction

function! g:debug_run_success_callback(dic)
call s:LOG("g:debug_run_success_callback: TOP")
call s:LOG("g:debug_run_success_callback: dic=". string(a:dic))
call s:LOG("g:debug_run_success_callback: BOTTOM")
endfunction

" ==============================================
" Set Breakpoint
" ==============================================

" Set a breakpoint.
function! vimside#command#debug#SetBreakpoint()
call s:LOG("vimside#command#debug#SetBreakpoint: TOP")
  let [found, l:cfile] = vimside#util#GetCurrentFilename()
  if !found
    call s:LOG("vimside#command#debug#SetBreakpoint: no current file")
    return
  endif
  let l:line = line(".")

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_set_breakpoint_success_callback")
        \ },
        \ 'args': {
        \   "filename": l:cfile,
        \   "line": l:line
        \ }
        \ }
  call vimside#swank#rpc#debug_set_break#Run(dic)

call s:LOG("vimside#command#debug#SetBreakpoint: BOTTOM")
endfunction

function! g:debug_set_breakpoint_success_callback(dic)
call s:LOG("g:debug_set_breakpoint_success_callback: TOP")
call s:LOG("g:debug_set_breakpoint_success_callback: dic=". string(a:dic))
  call s:debug_refresh_breakpoints()
call s:LOG("g:debug_set_breakpoint_success_callback: BOTTOM")
endfunction

" Refresh all breakpoints from server.
function! s:debug_refresh_breakpoints()
  call s:db_clear_breakpoint_overlays()

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_list_breakpoints_success_callback")
        \ }
        \ }
  call vimside#swank#rpc#debug_list_breakpoints(dic)
endfunction

function! g:debug_list_breakpoints_success_callback(dic)
call s:LOG("g:debug_list_breakpoints_success_callback: TOP")
call s:LOG("g:debug_list_breakpoints_success_callback: dic=". string(a:dic))
  let active = a:dic[':active']
  let pending = a:dic[':pending']

  call s:debug_create_breakpoint_overlays(active, 'active')
  call s:debug_create_breakpoint_overlays(pending, 'pending')

call s:LOG("g:debug_list_breakpoints_success_callback: BOTTOM")
endfunction

" ==============================================
" Clear Breakpoint
" ==============================================

" Clear a breakpoint.
function! vimside#command#debug#ClearBreakpoint()
call s:LOG("vimside#command#debug#ClearBreakpoint: TOP")
  let [found, l:cfile] = vimside#util#GetCurrentFilename()
  if !found
    call s:LOG("vimside#command#debug#SetBreakpoint: no current file")
    return
  endif
  let l:line = line(".")

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_clear_breakpoint_success_callback")
        \ },
        \ 'args': {
        \   "filename": l:cfile,
        \   "line": l:line
        \ }
        \ }
  call vimside#swank#rpc#debug_clear_break#Run(dic)

call s:LOG("vimside#command#debug#ClearBreakpoint: BOTTOM")
endfunction

function! g:debug_clear_breakpoint_success_callback(dic)
call s:LOG("g:debug_clear_breakpoint_success_callback: TOP")
call s:LOG("g:debug_clear_breakpoint_success_callback: dic=". string(a:dic))
  call s:debug_refresh_breakpoints()
call s:LOG("g:debug_clear_breakpoint_success_callback: BOTTOM")
endfunction

" ==============================================
" Clear All Breaks
" ==============================================

" Clear all breaks
function! vimside#command#debug#ClearAllBreaks()
call s:LOG("vimside#command#debug#ClearAllBreaks: TOP")
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_clear_all_breaks_success_callback")
        \ },
        \ }
  call vimside#swank#rpc#debug_clear_all_breaks#Run(dic)

call s:LOG("vimside#command#debug#ClearAllBreaks: BOTTOM")
endfunction

function! g:debug_clear_all_breaks_success_callback(dic)
call s:LOG("g:debug_clear_all_breaks_success_callback: TOP")
call s:LOG("g:debug_clear_all_breaks_success_callback: dic=". string(a:dic))
  call s:debug_refresh_breakpoints()
call s:LOG("g:debug_clear_all_breaks_success_callback: BOTTOM")
endfunction

" ==============================================
" Next
" ==============================================

" Next.
" Cause debugger to go to next line, without stepping into
" method invocations."
function! vimside#command#debug#Next()
call s:LOG("vimside#command#debug#Next: TOP")
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_next_success_callback")
        \ },
        \ 'args': {
        \   "active_thread_id": s:active_thread_id
        \ }
        \ }
  call vimside#swank#rpc#debug_next#Run(dic)
call s:LOG("vimside#command#debug#Next: BOTTOM")
endfunction

function! g:debug_next_success_callback(dic)
call s:LOG("g:debug_next_success_callback: TOP")
call s:LOG("g:debug_next_success_callback: dic=". string(a:dic))
  " TODO go to new location
call s:LOG("g:debug_next_success_callback: BOTTOM")
endfunction

" ==============================================
" Step
" ==============================================

" Step.
"  Cause debugger to go to next line, stepping into
" method invocations."
function! vimside#command#debug#Step()
call s:LOG("vimside#command#debug#Step: TOP")
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_step_success_callback")
        \ },
        \ 'args': {
        \   "active_thread_id": s:active_thread_id
        \ }
        \ }
  call vimside#swank#rpc#debug_step#Run(dic)
call s:LOG("vimside#command#debug#Step: BOTTOM")
endfunction

function! g:debug_step_success_callback(dic)
call s:LOG("g:debug_step_success_callback: TOP")
call s:LOG("g:debug_step_success_callback: dic=". string(a:dic))
  " TODO go to new location
call s:LOG("g:debug_step_success_callback: BOTTOM")
endfunction


" ==============================================
" Step Out
" ==============================================

" Step out.
function! vimside#command#debug#StepOut()
call s:LOG("vimside#command#debug#StepOut: TOP")
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_step_out_success_callback")
        \ },
        \ 'args': {
        \   "active_thread_id": s:active_thread_id
        \ }
        \ }
  call vimside#swank#rpc#debug_step_out#Run(dic)
call s:LOG("vimside#command#debug#StepOut: BOTTOM")
endfunction

function! g:debug_step_out_success_callback(dic)
call s:LOG("g:debug_step_out_success_callback: TOP")
call s:LOG("g:debug_step_out_success_callback: dic=". string(a:dic))
  " TODO go to new location
call s:LOG("g:debug_step_out_success_callback: BOTTOM")
endfunction

" ==============================================
" Continue
" ==============================================

"  Continue from a breakpoint.
function! vimside#command#debug#Continue()
call s:LOG("vimside#command#debug#Continue: TOP")
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_continue_success_callback")
        \ },
        \ 'args': {
        \   "active_thread_id": s:active_thread_id
        \ }
        \ }
  call vimside#swank#rpc#debug_continue(dic)
call s:LOG("vimside#command#debug#Continue: BOTTOM")
endfunction

function! g:debug_continue_success_callback(dic)
call s:LOG("g:debug_continue_success_callback: TOP")
call s:LOG("g:debug_continue_success_callback: dic=". string(a:dic))
  " TODO go to new location
call s:LOG("g:debug_continue_success_callback: BOTTOM")
endfunction

" ==============================================
" Kill Session
" ==============================================

" Kill the debug session.
function! vimside#command#debug#Quit()
call s:LOG("vimside#command#debug#Quit: TOP")
  call s:db_clear_all_overlays()

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_quit_success_callback")
        \ }
        \ }
  call vimside#swank#rpc#debug_stop#Run(dic)
call s:LOG("vimside#command#debug#Quit: BOTTOM")
endfunction

function! g:debug_quit_success_callback(dic)
call s:LOG("g:debug_quit_success_callback: TOP")
call s:LOG("g:debug_quit_success_callback: dic=". string(a:dic))
call s:LOG("g:debug_quit_success_callback: BOTTOM")
endfunction

" ==============================================
" Inspect Local Variable
" ==============================================

" Inspect the local variable at cursor.
function! vimside#command#debug#InspectVariable()
call s:LOG("vimside#command#debug#InspectVariable: TOP")
  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_symbol_at_point_success_callback")
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)
call s:LOG("vimside#command#debug#InspectVariable: BOTTOM")
endfunction

function! g:debug_symbol_at_point_success_callback(dic)
call s:LOG("g:debug_symbol_at_point_success_callback: TOP")
call s:LOG("g:debug_symbol_at_point_success_callback: dic=". string(a:dic))
  if has_key(a:dic, ":name")
    let l:name = a:dic[':name']
  else
    let l:name = 'this'
  endif

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_location_name_success_callback")
        \ },
        \ 'args': {
        \   "active_thread_id": s:active_thread_id
        \   "name": l:name
        \ }
        \ }
  call vimside#swank#rpc#debug_locate_name#Run(dic)
call s:LOG("vimside#command#debug#InspectVariable: BOTTOM")
endfunction

function! g:debug_location_name_success_callback(dic)
call s:LOG("g:debug_location_name_success_callback: TOP")
call s:LOG("g:debug_location_name_success_callback: dic=". string(a:dic))

  " TODO fix
  call vimside#preview#Display(string(a:dic))

call s:LOG("g:debug_location_name_success_callback: BOTTOM")
endfunction

" ==============================================
" Show Backtrace
" ==============================================

" Show backtrace.
function! vimside#command#debug#ShowBacktrace()
call s:LOG("vimside#command#debug#ShowBacktrace: TOP")
  call g:db_update_backtraces()
call s:LOG("vimside#command#debug#ShowBacktrace: BOTTOM")
endfunction



" ==============================================
" Events
" ==============================================

" ====================
" BreakPoint Event
" ====================

" (:debug-event
"   (:type //Symbol: breakpoint
"    :thread-id //String: The unique thread id of the paused thread.
"    :thread-name //String: The informal name of the paused thread.
"    :file //String: The source file the VM stepped into.
"    :line //Int: The source line the VM stepped to.
" ))
function! vimside#command#debug#BreakPointEvent(dic)
call s:LOG("vimside#command#debug#BreakPointEvent: TOP")
  if ! has_key(a:dic, ":thread-id")
    call s:ERROR("vimside#command#debug#BreakPointEvent No :thread-id ". string(a:kw_dict)) 
    return
  endif
  if ! has_key(a:dic, ":thread-name")
    call s:ERROR("vimside#command#debug#BreakPointEvent No :thread-name ". string(a:kw_dict)) 
    return
  endif
  if ! has_key(a:dic, ":file")
    call s:ERROR("vimside#command#debug#BreakPointEvent No :file ". string(a:kw_dict)) 
    return
  endif
  if ! has_key(a:dic, ":line")
    call s:ERROR("vimside#command#debug#BreakPointEvent No :line ". string(a:kw_dict)) 
    return
  endif

  let l:thread_id = a:dic[':thread-id']
  let l:thread_name = a:dic[':thread-name']
  let l:file = a:dic[':file']
  let l:line = a:dic[':line']

  let s:active_thread_id = l:thread_id

  call s:debug_set_marker(l:line, l:file)

  let l:msg = "Thread '". l:thread_name ." hit breakpoint at ". l:file ." : ". l:line
  call vimside#cmdline#Display(l:msg)


call s:LOG("vimside#command#debug#BreakPointEvent: BOTTOM")
endfunction

" ====================
" Death Event
" ====================

" (:debug-event
"   (:type //Symbol: death
" ))
function! vimside#command#debug#DeathEvent(dic)
call s:LOG("vimside#command#debug#DeathEvent: TOP")
  call s:debug_handle_shutdown(a:dic)
call s:LOG("vimside#command#debug#DeathEvent: BOTTOM")
endfunction

function! s:debug_handle_shutdown(dic)
  let l:msg = "Debug VM Quit"
  call vimside#cmdline#Display(l:msg)

  call s:db_clear_all_overlays()

  let s:active_thread_id = ""
endfunction

" ====================
" Disconnect Event
" ====================

" (:debug-event
"   (:type //Symbol: disconnect
" ))
function! vimside#command#debug#DisconnectEvent(dic)
call s:LOG("vimside#command#debug#DisconnectEvent: TOP")
  call s:debug_handle_shutdown(a:dic)
call s:LOG("vimside#command#debug#DisconnectEvent: BOTTOM")
endfunction

" ====================
" Exception Event
" ====================

" Signals that the debugged VM has thrown an exception and is now paused
"    waiting for control.
" 
" (:debug-event
"   (:type //Symbol: exception
"    :exception //String: The unique object id of the exception.
"    :thread-id //String: The unique thread id of the paused thread.
"    :thread-name //String: The informal name of the paused thread.
"    :file //String: The source file where the exception was caught,
"       or nil if no location is known.
"    :line //Int: The source line where the exception was thrown,
"       or nil if no location is known.
" ))
function! vimside#command#debug#ExceptionEvent(dic)
call s:LOG("vimside#command#debug#ExceptionEvent: TOP")
  let s:active_thread_id = a:dic[':thread-id']

  let l:msg = "Exception on thread " s:active_thread_id
  call vimside#cmdline#Display(l:msg)

  let l:file = a:dic[':file']
  let l:line = a:dic[':line']
  if l:file != "" && l:line != ""
    call s:debug_set_marker(l:line, l:file)
  endif

  let dic = {
        \ 'handler': {
        \   'ok': function("g:debug_exception_success_callback")
        \ },
        \ 'args': {
        \   "type": 'reference',
        \   "object_id": a:dic[":exception"]
        \ }
        \ }
  call vimside#swank#rpc#debug_value#Run(dic)

call s:LOG("vimside#command#debug#ExceptionEvent: BOTTOM")
endfunction

function! s:debug_exception_success_callback(dic)
call s:LOG("s:debug_exception_success_callback: TOP")
call s:LOG("s:debug_exception_success_callback: dic=". string(a:dic))
  " TODO fix
  call vimside#preview#Display(string(a:dic))
call s:LOG("s:debug_exception_success_callback: BOTTOM")
endfunction

" ===================
" Output Event
" ====================

" (:debug-event
"   (:type //Symbol: output
"   :body //String: A chunk of output text
" ))
function! vimside#command#debug#OutputEvent(dic)
call s:LOG("vimside#command#debug#OutputEvent: TOP")
  " TODO fix
  let l:body = a:dic[":body"]
  call vimside#preview#Display(l:body)
call s:LOG("vimside#command#debug#OutputEvent: BOTTOM")
endfunction

" ====================
" Start Event
" ====================

" (:debug-event
"   (:type //Symbol: start
" ))
function! vimside#command#debug#StartEvent(dic)
call s:LOG("vimside#command#debug#StartEvent: TOP")
  " TODO fix
  let l:msg = "Debug VM started. Set breakpoints and then execute vimside#command#debug#Run"
  call vimside#preview#Display(l:msg)
call s:LOG("vimside#command#debug#StartEvent: BOTTOM")
endfunction

" ====================
" Step Event
" ====================

" (:debug-event
"   (:type //Symbol: step
"    :thread-id //String: The unique thread id of the paused thread.
"    :thread-name //String: The informal name of the paused thread.
"    :file //String: The source file the VM stepped into.
"    :line //Int: The source line the VM stepped to.
" ))
function! vimside#command#debug#StepEvent(dic)
call s:LOG("vimside#command#debug#StepEvent: TOP")

  let s:active_thread_id = a:dic[":thread-id"]

  let l:line = a:dic[":line"]
  let l:file = a:dic[":file"]
  call s:debug_set_marker(l:line, l:file)

  let l:thread_name = a:dic[":thread-name"]

  let l:msg = "Thread ". l:thread_name .' suspended at ' . l:file .':'. l:line
  call vimside#preview#Display(l:msg)

  call s:db_run_thread_suspended_hooks()

call s:LOG("vimside#command#debug#StepEvent: BOTTOM")
endfunction

" ====================
" Thread Start Event
" ====================

" (:debug-event
"   (:type //Symbol: threadStart
"    :thread-id //String: The unique thread id of the new thread.
" ))
function! vimside#command#debug#ThreadStartEvent(dic)
call s:LOG("vimside#command#debug#ThreadStartEvent: TOP")
 " do nothing
call s:LOG("vimside#command#debug#ThreadStartEvent: BOTTOM")
endfunction

" ====================
" Thread Death Event
" ====================

" (:debug-event
"   (:type //Symbol: threadDeath
"    :thread-id //String: The unique thread id of the dead thread.
" ))
function! vimside#command#debug#ThreadDeathEvent(dic)
call s:LOG("vimside#command#debug#ThreadDeathEvent: TOP")
 " do nothing
call s:LOG("vimside#command#debug#ThreadDeathEvent: BOTTOM")
endfunction



" Initialize debug module
call s:debug_init()









