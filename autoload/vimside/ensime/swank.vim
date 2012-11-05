" ============================================================================
" swank.vim
"
" File:          swank.vim
" Summary:       Ensime Server Swank IO code
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Ensime Server socket io functions.  
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function! vimside#ensime#swank#load_handlers()
  " event counters
  let g:vimside.status.compiler_ready = 0
  let g:vimside.status.full_typecheck_finished = 0
  let g:vimside.status.indexer_ready = 0
  let g:vimside.status.scala_notes = 0
  let g:vimside.status.java_notes = 0
  let g:vimside.status.clear_all_scala_notes = 0
  let g:vimside.status.clear_all_java_notes = 0
  let g:vimside.status.debug_event = 0


  let g:vimside.event_handlers[':compiler-ready'] = function("g:CompilerReadyEventHandler")
  let g:vimside.event_handlers[':full-typecheck-finished'] = function("g:FullTypecheckFinishedEventHandler")
  let g:vimside.event_handlers[':indexer-ready'] = function("g:IndexerReadyEventHandler")
  let g:vimside.event_handlers[':scala-notes'] = function("g:ScalaNotesEventHandler")
  let g:vimside.event_handlers[':java-notes'] = function("g:JavaNotesEventHandler")
  let g:vimside.event_handlers[':clear-all-scala-notes'] = function("g:ClearAllScalaNotesEventHandler")
  let g:vimside.event_handlers[':clear-all-java-notes'] = function("g:ClearAllJavaNotesEventHandler")
  let g:vimside.event_handlers[':debug-event'] = function("g:DebugEventHandler")


  let g:vimside.debug_event_handlers['output'] = function("g:OutputDebugHandler")
  let g:vimside.debug_event_handlers['stop'] = function("g:StopDebugHandler")
  let g:vimside.debug_event_handlers['breakpoint'] = function("g:BreakpointDebugHandler")
  let g:vimside.debug_event_handlers['death'] = function("g:DeathDebugHandler")
  let g:vimside.debug_event_handlers['start'] = function("g:StartDebugHandler")
  let g:vimside.debug_event_handlers['disconnect'] = function("g:DisconnectDebugHandler")
  let g:vimside.debug_event_handlers['exception'] = function("g:ExceptionDebugHandler")
  let g:vimside.debug_event_handlers['threadStart'] = function("g:ThreadStartDebugHandler")
  let g:vimside.debug_event_handlers['threadDeath'] = function("g:ThreadDeathDebugHandler")

  let g:vimside['unknown_event_handler'] = function("g:UnknownEventHandler")
  let g:vimside['unknown_debug_handler'] = function("g:UnknownDebugHandler")
endfunction

function! vimside#ensime#swank#load_ping_info()
  let errors = g:vimside.errors

  let [found, l:value] = g:vimside.GetOption('swank-rpc-expecting-read-timeout')
  if found
    let s:rpc_expecting_read_timeout = l:value
  else
    call add(errors, ": Option not found: 'swank-rpc-expecting-read-timeout'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-rpc-expecting-updatetime')
  if found
    let s:rpc_expecting_updatetime = l:value
  else
    call add(errors, ": Option not found: 'swank-rpc-expecting-updatetime'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-rpc-expecting-char-count')
  if found
    let s:rpc_expecting_char_count = l:value
  else
    call add(errors, ": Option not found: 'swank-rpc-expecting-char-count'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-rpc-not-expecting-read-timeout')
  if found
    let s:rpc_not_expecting_read_timeout = l:value
  else
    call add(errors, ": Option not found: 'swank-rpc-not-expecting-read-timeout'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-rpc-not-expecting-updatetime')
  if found
    let s:rpc_not_expecting_updatetime = l:value
  else
    call add(errors, ": Option not found: 'swank-rpc-not-expecting-updatetime'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-rpc-not-expecting-char-count')
  if found
    let s:rpc_not_expecting_char_count = l:value
  else
    call add(errors, ": Option not found: 'swank-rpc-not-expecting-char-count'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-event-expecting-one-updatetime')
  if found
    let s:event_expecting_one_updatetime = l:value
  else
    call add(errors, ": Option not found: 'swank-event-expecting-one-updatetime'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-event-expecting-one-char-count')
  if found
    let s:event_expecting_one_char_count = l:value
  else
    call add(errors, ": Option not found: 'swank-event-expecting-one-char-count'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-event-expecting-many-updatetime')
  if found
    let s:event_expecting_many_updatetime = l:value
  else
    call add(errors, ": Option not found: 'swank-event-expecting-many-updatetime'"
  endif

  let [found, l:value] = g:vimside.GetOption('swank-event-expecting-many-char-count')
  if found
    let s:event_expecting_many_char_count = l:value
  else
    call add(errors, ": Option not found: 'swank-event-expecting-many-char-count'"
  endif
endfunction

function! vimside#ensime#swank#ping_info_set_rpc_expecting()
call s:LOG("vimside#ensime#swank#ping_info_set_rpc_expecting") 
  let g:vimside.ping.info.read_timeout = s:rpc_expecting_read_timeout
  let g:vimside.ping.info.updatetime = s:rpc_expecting_updatetime 
  let g:vimside.ping.info.char_count = s:rpc_expecting_char_count 

" XXXXXXXXXXXXX
"   call vimside#ResetAutoCmds()
  call vimside#scheduler#ResetAuto()
  if mode() == 'i'
    call feedkeys("a\<BS>")
  elseif mode() == 'c'
    call feedkeys("\<SPACE>")
  else
    call feedkeys("f\e")
  endif
endfunction

function! vimside#ensime#swank#ping_info_set_rpc_not_expecting()
call s:LOG("vimside#ensime#swank#ping_info_set_rpc_not_expecting") 
  let g:vimside.swank.events = '0'

  let g:vimside.ping.info.read_timeout = s:rpc_not_expecting_read_timeout
  let g:vimside.ping.info.updatetime = s:rpc_not_expecting_updatetime 
  let g:vimside.ping.info.char_count = s:rpc_not_expecting_char_count 
endfunction

function! vimside#ensime#swank#ping_info_set_event_expecting_one()
call s:LOG("vimside#ensime#swank#ping_info_set_event_expecting_one") 
  let g:vimside.ping.info.read_timeout = s:rpc_not_expecting_read_timeout
  let g:vimside.ping.info.updatetime = s:event_expecting_one_updatetime
  let g:vimside.ping.info.char_count = s:event_expecting_one_char_count
endfunction

function! vimside#ensime#swank#ping_info_set_event_expecting_many()
call s:LOG("vimside#ensime#swank#ping_info_set_event_expecting_many") 
  let g:vimside.ping.info.read_timeout = s:rpc_not_expecting_read_timeout
  let g:vimside.ping.info.updatetime = s:event_expecting_many_updatetime
  let g:vimside.ping.info.char_count = s:event_expecting_many_char_count
endfunction

function! vimside#ensime#swank#handle(response)
  let response = a:response
  let success = 0
  let got_event = 0

  let sexp = vimside#sexp#Parse(response)
   
  let [found, children] =  vimside#sexp#Get_ListValue(sexp) 
  if ! found
    call s:ERROR("vimside#ensime#swank#handle Not List: ". string(response)) 
  else
    " It is a SExp List
    let len = len(children)
    
    if len == 0
      call s:ERROR("vimside#ensime#swank#handle child SExp List length 0: ". string(response)) 
    elseif len == 1
      " It is a simple event
      call s:HandleSimpleEvent(children[0])
      let success = 1
      let got_event = 1

    elseif len == 2
      " It is a complex event
      call s:HandleComplexEvent(children)
      let success = 1
      let got_event = 1

    elseif len == 3
      " Call return or abort
      let success = s:HandleResponse(children)
    else
      call s:ERROR("vimside#ensime#swank#handle child SExp List length > 3: ". string(response)) 
      let success = 0

    endif
  endif

  call s:PostHandle(success, got_event)

  return success
endfunction

function! s:PostHandle(success, got_event)
  if a:success && empty(g:vimside.swank.rpc.waiting)
    let l:events = g:vimside.swank.events
    if l:events == '0'
      call vimside#ensime#swank#ping_info_set_rpc_not_expecting()
    elseif l:events == 'many'
      call vimside#ensime#swank#ping_info_set_event_expecting_many()
    elseif a:got_event
      if l:events == '1'
        call vimside#ensime#swank#ping_info_set_rpc_not_expecting()
      else
        call vimside#ensime#swank#ping_info_set_event_expecting_many()
      endif
    endif
  endif
endfunction

"
" rr = {
"   'caller': funcref
"   'args': {}
"   'handler': {
"     'ok': funcref,
"     'abort': funcref
"   }
"   'events': '0','1','many'
" }
"
"
function! vimside#ensime#swank#dispatch(rr)
  let rr = a:rr
  let g:vimside.swank.events = rr.events

  let callmsg = rr.caller(rr.args)
call s:LOG("vimside#ensime#swank#dispatch callmsg=".callmsg) 
  let rr.id = vimside#ensime#io#write(callmsg)

  let success = 0
  let got_event = 0

  while ! success
    let response = vimside#ensime#io#read()

call s:LOG("vimside#ensime#swank#dispatch response=".response) 
    if response == ''
      " read returned nothing 
call s:LOG("vimside#ensime#swank#dispatch waiting for id=". rr.id) 
      " waiting = { id: rr }
      let g:vimside.swank.rpc.waiting[rr.id] = rr

      " rpc expecting ping info 
      call vimside#ensime#swank#ping_info_set_rpc_expecting()
      break
    else
      " Ought to be a SExp List
      " (:full-typecheck-finished)
      " (:scala-notes notes //List of Note )
      " (:debug-event
      "   (:type //Symbol: output :body //String: A chunk of output text))
      " (:return (:ok ()) 42)
      " (:return (:ok (:id 1 :touched-files
      "   ("/src/main/scala/org/ensime/server/RPCTarget.scala"))) 42)
      let sexp = vimside#sexp#Parse(response)
     
      let [found, children] =  vimside#sexp#Get_ListValue(sexp) 
      if ! found
        call s:ERROR("vimside#ensime#swank#dispatch Not List: ". string(response)) 
      else
        " It is a SExp List
        let len = len(children)
        
        if len == 0
          call s:ERROR("vimside#ensime#swank#dispatch child SExp List length 0: ". string(response)) 
        elseif len == 1
          " It is a simple event
          call s:HandleSimpleEvent(children[0])
          let got_event = 1

        elseif len == 2
          " It is a complex event
          call s:HandleComplexEvent(children)
          let got_event = 1

        elseif len == 3
          " Call return or abort
          let g:vimside.swank.rpc.waiting[rr.id] = rr
          let success = s:HandleResponse(children)

        else
          call s:ERROR("vimside#ensime#swank#dispatch child SExp List length > 3: ". string(response)) 

        endif

      endif

    endif
  endwhile

  call s:PostHandle(success, got_event)

endfunction

" :compiler-ready
" :full-typecheck-finished
" :indexer-ready
" :clear-all-scala-notes
" :clear-all-java-notes
function! s:HandleSimpleEvent(sexp)
  let sexp = a:sexp
call s:LOG("HandleSimpleEvent ".string(sexp)) 

  let [found, kword] = vimside#sexp#Get_KeywordValue(sexp) 
  if found
    let Ehandler = get(g:vimside.event_handlers, kword, g:vimside.unknown_event_handler)
    call Ehandler(kword)
  else
    call s:ERROR("HandleSimpleEvent: ". kword) 
  endif
endfunction

"
" list of 2 SExps (Keyword and list)
" (:scala-notes notes //List of Note)
" (:java-notes notes //List of Note)
" (:debug-event (:type ....))
"
function! s:HandleComplexEvent(children)
  let children = a:children
call s:LOG("HandleComplexEvent ".string(children)) 
  " Note that the first child really ought to be the keyword
  " children is a list of sexp
  let child1 = children[0]
  let child2 = children[1]

  let [found, value1] =  vimside#sexp#Get_KeywordValue(child1) 

  if found
    let Ehandler = get(g:vimside.event_handlers, value1, g:vimside.unknown_event_handler)
    call Ehandler(value1, child2)
  else
    let [found, value2] =  vimside#sexp#Get_KeywordValue(child2) 
    if found
      let Ehandler = get(g:vimside.event_handlers, value2, g:vimside.unknown_event_handler)
      call Ehandler(value2, child1)
    else
      call s:ERROR("HandleComplexEvent: No Keyword: ". string(children)) 
    endif
  endif

endfunction

"
" list of 3 SExps (Keyword list Int)
"
" (:return (:ok ()) 42)
" (:return (:ok (:id 1 :touched-files
"   ("/src/main/scala/org/ensime/server/RPCTarget.scala"))) 42)
" (:return (:abort code detatil) 42)
"
" (:return (:ok inner) 42)
" (:return (:abort code detatil) 42)
" 
" (:background-message 105 "Initializing Analyzer. Please wait...")
"
" return 0 or 1 if id matches rr.id
function! s:HandleResponse(children)
  let children = a:children

" call s:LOG("HandleResponse ". string(children))

  " Note that the first child really ought to be the keyword
  let top_kw_sexp = children[0]

  let [found, top_kw] =  vimside#sexp#Get_KeywordValue(top_kw_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Keyword not first sexp: ". string(children)) 
    return 0
  endif

  if top_kw == ':background-message'
    let eventcode_sexp = children[1]
    let msg_sexp = children[2]
    call s:HandleBackgroundMessage(eventcode_sexp, msg_sexp)
    return 1
  endif

  if top_kw != ':return'
    call s:ERROR("HandleResponse: Keyword not ':return': ". string(children)) 
    return 0
  endif

  let content_sexp = children[1]
  let id_sexp = children[2]

  let [found, id] =  vimside#sexp#Get_IntValue(id_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Id not third sexp: ". string(children)) 
    return 0
  endif

  if ! has_key(g:vimside.swank.rpc.waiting, id)
    return 0
  endif

  let rr = g:vimside.swank.rpc.waiting[id]
  " remove response waiting data
  unlet  g:vimside.swank.rpc.waiting[id]

  let [found, content] =  vimside#sexp#Get_ListValue(content_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Protocol error second sexp not List: ". string(children)) 
    return 1
  endif

  let len = len(content)

  if len < 2
    call s:ERROR("HandleResponse: Protocol error Content List less than 2: ". string(children)) 
    return 1
  endif

  let kind_kw_sexp = content[0]
  let body_sexp = content[1]

  let [found, kind_kw] =  vimside#sexp#Get_KeywordValue(kind_kw_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Kind Keyword not first sexp: ". string(children)) 
    return 1
  endif
  if kind_kw == ':ok'
    " return 0 or 1
    call rr.handler.ok(body_sexp)

  elseif kind_kw == ':abort'
    let [found, body_list] =  vimside#sexp#Get_ListValue(body_sexp) 
    if ! found
      call s:ERROR("HandleResponse: Body ':abort' not List: ". string(children)) 
      return 1
    endif

if 0
    if len(body_list) != 2
      call s:ERROR("HandleResponse: Body ':abort' not List length 2: ". string(children)) 
      return 1
    endif
endif

    let code_sexp = body_list[0]
    let detail_sexp = body_list[1]
    let rest = body_list[2:]
    let [found, code] =  vimside#sexp#Get_IntValue(code_sexp) 
    if ! found
      call s:ERROR("HandleResponse: Body ':abort' code not Int: ". string(children)) 
      return 1
    endif
    let [found, detail] =  vimside#sexp#Get_StringValue(string_sexp) 
    if ! found
      call s:ERROR("HandleResponse: Body ':abort' detail not String: ". string(children)) 
      return 1
    endif

    " ignore return value
    call rr.handler.abort(code, details, rest)
  else
    call s:ERROR("HandleResponse: kind Keyword not ':ok' or ':abort': ". string(children)) 
  endif
  return 1
endfunction


function! s:HandleBackgroundMessage(eventcode_sexp, msg_sexp)
  let eventcode_sexp = a:eventcode_sexp
  let msg_sexp = a:msg_sexp
  let eventcode = eventcode_sexp.value
  let msg = msg_sexp.value
call s:LOG("HandleBackgroundMessage ". string(eventcode) ." ". msg)

  let [etype, emsg] = vimside#ensime#messages#GetProtocolConstant(eventcode)
  if etype == "Msg" && emsg == "Misc"
    call vimside#cmdline#Display(msg) 
  else
    let bmsg = emsg .' ('. etype .'): '. msg
    call vimside#cmdline#Display(bmsg) 
  endif

endfunction

" ============================================================================
"  Event Handlers
" ============================================================================

" Signal that the compiler has finished its initial compilation and 
"   the server is ready to accept RPC calls.
" (:compiler-ready)
function! g:CompilerReadyEventHandler(keyword, ...)
  let g:vimside.status.compiler_ready += 1

  if a:0 != 0
    call s:ERROR("CompilerReadyEventHandler: has additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.comiler_ready")
    let g:vimside.event_trigger.compiler_ready = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-compiler-ready')
  endif

  call g:vimside.event_trigger.compiler_ready()
endfunction



" Signal that the compiler has finished compilation of the entire project.
" (:full-typecheck-finished)
function! g:FullTypecheckFinishedEventHandler(keyword, ...)
  let g:vimside.status.full_typecheck_finished += 1

  if a:0 != 0
    call s:ERROR("FullTypecheckFinishedEventHandler: has additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.full_typecheck_finished")
    let g:vimside.event_trigger.full_typecheck_finished = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-full-typecheck-finished')
  endif

  call g:vimside.event_trigger.full_typecheck_finished()
endfunction



" Signal that the indexer has finished indexing the classpath.
" (:indexer-ready)
function! g:IndexerReadyEventHandler(keyword, ...)
call s:LOG("IndexerReadyEventHandler ") 
  let g:vimside.status.indexer_ready += 1

  if a:0 != 0
    call s:ERROR("IndexerReadyEventHandler: has additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.indexer_ready")
    let g:vimside.event_trigger.indexer_ready = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-indexer-ready')
  endif

  call g:vimside.event_trigger.indexer_ready()
endfunction



" Notify client when Scala compiler generates errors,warnings or other notes.
" (:scala-notes notes //List of Note)
function! g:ScalaNotesEventHandler(keyword, ...)
  let g:vimside.status.scala_notes += 1

  if a:0 != 1
    call s:ERROR("ScalaNotesEventHandler: wrong number of additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.scala_notes")
    let g:vimside.event_trigger.scala_notes = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-scala-notes')
  endif

  call g:vimside.event_trigger.scala_notes(a:1)
endfunction



" Notify client when Java compiler generates errors,warnings or other notes.
" (:java-notes notes //List of Note)
function! g:JavaNotesEventHandler(keyword, ...)
  let g:vimside.status.java_notes += 1

  if a:0 != 1
    call s:ERROR("JavaNotesEventHandler: wrong number of additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.java_notes")
    let g:vimside.event_trigger.java_notes = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-java-notes')
  endif

  call g:vimside.event_trigger.java_notes(a:1)
endfunction



" Notify client when Scala notes have become invalidated. 
" Editor should consider all Scala related notes to be stale at this point.
" (:clear-all-scala-notes)
function! g:ClearAllScalaNotesEventHandler(keyword, ...)
  let g:vimside.status.clear_all_scala_notes += 1

  if a:0 != 0
    call s:ERROR("ClearAllScalaNotesEventHandler: has additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.clear_all_scala_notes")
    let g:vimside.event_trigger.clear_all_scala_notes = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-clear-all-scala-notes')
  endif

  call g:vimside.event_trigger.clear_all_scala_notes()
endfunction


" Notify client when Java notes have become invalidated. 
" Editor should consider all Java related notes to be stale at this point.
" (:clear-all-java-notes)
function! g:ClearAllJavaNotesEventHandler(keyword, ...)
  let g:vimside.status.clear_all_java_notes += 1

  if a:0 != 0
    call s:ERROR("ClearAllJavaNotesEventHandler: has additional args=". string(a:000))
    return
  endif

  if ! exists("g:vimside.event_trigger.clear_all_java_notes")
    let g:vimside.event_trigger.clear_all_java_notes = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-event-trigger-clear-all-java-notes')
  endif

  call g:vimside.event_trigger.clear_all_java_notes(a:000)
endfunction

" ============================================================================
"  Debug Event Handlers
" ============================================================================


" (:debug-event (:type ....))
function! g:DebugEventHandler(keyword, ...)
  let g:vimside.status.debug_event += 1
  " call g:vimside.trigger.debug_event(a:000)

  if a:0 == 0
    call s:ERROR("DebugEventHandler No arguments". string(a:keyword)) 

  elseif a:0 == 1
    let [ok, kw_dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:1) 
    if !ok
      call s:ERROR("DebugEventHandler failure to create kw dict ". kw_dic) 
    else
      let db_handler = get(g:vimside.debug_event_handlers, ':type', g:vimside.unknown_debug_handler)
      call db_handler(kw_dic)
    endif
  else
    call s:ERROR("DebugEventHandler Too may arguments". string(a:keyword) . ", args=" . string(a:000)) 

  endif
endfunction




" Communicates stdout/stderr of debugged VM to client.
"  (:debug-event
"    (:type //Symbol: output
"     :body //String: A chunk of output text
"  ))
function! g:OutputDebugHandler(kw_dic)
  if ! has_key(a:kw_dic, ":body")
    call s:ERROR("OutputDebugHandler No :body ". string(a:kw_dict)) 
    return
  endif

  if ! exists("g:vimside.debug_trigger.output")
    let g:vimside.debug_trigger.output = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-output')
  endif

  let body = a:kw_dic[':body']
  call g:vimside.debug_trigger.output(body)
endfunction



" Signals that the debugged VM has stepped to a new location and 
" is now paused awaiting control.
"  (:debug-event
"    (:type //Symbol: step
"     :thread-id //String: The unique thread id of the paused thread.
"     :thread-name //String: The informal name of the paused thread.
"     :file //String: The source file the VM stepped into.
"     :line //Int: The source line the VM stepped to.
"  ))
function! g:StopDebugHandler(kw_dic)
  if ! has_key(a:kw_dic, ":thread-id")
    call s:ERROR("StopDebugHandler No :thread-id ". string(a:kw_dict)) 
    return
  endif

  if ! exists("g:vimside.debug_trigger.stop")
    let g:vimside.debug_trigger.stop = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-stop')
  endif

  let thread_id = a:kw_dic[':thread-id']
  let thread_name = a:kw_dic[':thread-name']
  let file = a:kw_dic[':file']
  let line = a:kw_dic[':line']
  call g:vimside.debug_trigger.stop(thread_id, thread_name, file, line)
endfunction



" Signals that the debugged VM has stopped at a breakpoint.
"  (:debug-event
"    (:type //Symbol: breakpoint
"     :thread-id //String: The unique thread id of the paused thread.
"     :thread-name //String: The informal name of the paused thread.
"     :file //String: The source file the VM stepped into.
"     :line //Int: The source line the VM stepped to.
"  ))
function! g:BreakpointDebugHandler(kw_dic)
  if ! has_key(a:kw_dic, ":thread-id")
    call s:ERROR("BreakpointDebugHandler No :thread-id ". string(a:kw_dict)) 
    return
  endif

  if ! exists("g:vimside.debug_trigger.breakpoint")
    let g:vimside.debug_trigger.breakpoint = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-breakpoint')
  endif

  let thread_id = a:kw_dic[':thread-id']
  let thread_name = a:kw_dic[':thread-name']
  let file = a:kw_dic[':file']
  let line = a:kw_dic[':line']
  call g:vimside.debug_trigger.breakpoint(thread_id, thread_name, file, line)
endfunction



" Signals that the debugged VM has exited.
"  (:debug-event
"    (:type //Symbol: death
"  ))
function! g:DeathDebugHandler(kw_dic)
  if ! exists("g:vimside.debug_trigger.death")
    let g:vimside.debug_trigger.death = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-death')
  endif

  call g:vimside.debug_trigger.death()
endfunction



" Signals that the debugged VM has started.
"  (:debug-event
"    (:type //Symbol: start
"  ))
function! g:StartDebugHandler(kw_dic)
  if ! exists("g:vimside.debug_trigger.start")
    let g:vimside.debug_trigger.start = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-start')
  endif

  call g:vimside.debug_trigger.start()
endfunction




function! g:DisconnectDebugHandler(kw_dic)
  if ! exists("g:vimside.debug_trigger.disconnect")
    let g:vimside.debug_trigger.disconnect = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-disconnect')
  endif

  call g:vimside.debug_trigger.disconnect()
endfunction


" Signals that the debugged VM has thrown an exception and 
" is now paused waiting for control.
"  (:debug-event
"    (:type //Symbol: exception
"     :exception //String: The unique object id of the exception.
"     :thread-id //String: The unique thread id of the paused thread.
"     :thread-name //String: The informal name of the paused thread.
"     :file //String: The source file where the exception was caught,
"       or nil if no location is known.
"     :line //Int: The source line where the exception was thrown,
"       or nil if no location is known.
"  ))
function! g:ExceptionDebugHandler(kw_dic)
  if ! has_key(a:kw_dic, ":exception")
    call s:ERROR("ExceptionDebugHandler No :exception". string(a:kw_dict)) 
    return
  endif

  if ! exists("g:vimside.debug_trigger.exception")
    let g:vimside.debug_trigger.exception = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-exception')
  endif

  let exception = a:kw_dic[':exception']
  let thread_id = a:kw_dic[':thread-di']
  let thread_name = a:kw_dic[':thread-name']
  let file = a:kw_dic[':file']
  let line = a:kw_dic[':line']
  call g:vimside.debug_trigger.exception(exception, thread_id, thread_name, file, line)
endfunction



" Signals that a new thread has started.
"  (:debug-event
"    (:type //Symbol: threadStart
"     :thread-id //String: The unique thread id of the new thread.
"  ))
function! g:ThreadStartDebugHandler(kw_dic)
  if ! has_key(a:kw_dic, ":thread-id")
    call s:ERROR("ThreadStartDebugHandler No :thread-id". string(a:kw_dict)) 
    return
  endif

  if ! exists("g:vimside.debug_trigger.thread_start")
    let g:vimside.debug_trigger.thread_start = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-thread-start')
  endif

  let thread_id = a:kw_dic[':thread-id']
  call g:vimside.debug_trigger.threadStart(thread_id)
endfunction



" Signals that a new thread has died.
"  (:debug-event
"    (:type //Symbol: threadDeath
"     :thread-id //String: The unique thread id of the new thread.
"  ))
function! g:ThreadDeathDebugHandler(kw_dic)
  if ! has_key(a:kw_dic, ":thread-id")
    call s:ERROR("ThreadDeathDebugHandler No :thread-id". string(a:kw_dict)) 
    return
  endif

  if ! exists("g:vimside.debug_trigger.thread_death")
    let g:vimside.debug_trigger.thread_death = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-thread-death')
  endif

  let thread_id = a:kw_dic[':thread-id']
  call g:vimside.debug_trigger.threadDeath(thread_id)
endfunction


function! g:UnknownEventHandler(keyword, ...)
call s:LOG("g:UnknownEventHandler keyword=". a:keyword) 
endfunction


function! g:UnknownDebugHandler(keyword, ...)
call s:LOG("g:UnknownDebugHandler keyword=". a:keyword) 
endfunction

