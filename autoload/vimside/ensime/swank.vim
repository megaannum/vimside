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

  let [found, l:value] = g:vimside.GetOption('scheduler-not-expecting-anything-read-time-out')
  if found
    let s:rpc_not_expecting_read_timeout = l:value
  else
    call add(errors, ": Option not found: 'scheduler-not-expecting-anything-read-time-out'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-not-expecting-anything-update-time')
  if found
    let s:rpc_not_expecting_updatetime = l:value
  else
    call add(errors, ": Option not found: 'scheduler-not-expecting-anything-update-time'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-not-expecting-anything-char-count')
  if found
    let s:rpc_not_expecting_char_count = l:value
  else
    call add(errors, ": Option not found: 'scheduler-not-expecting-anything-char-count'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-rpc-response-read-time-out')
  if found
    let s:rpc_expecting_read_timeout = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-rpc-response-read-time-out'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-rpc-response-update-time')
  if found
    let s:rpc_expecting_updatetime = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-rpc-response-update-time'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-rpc-response-char-count')
  if found
    let s:rpc_expecting_char_count = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-rpc-response-char-count'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-events-read-time-out')
  if found
    let s:expecting_events_read_timeout = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-events-read-time-out'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-events-update-time')
  if found
    let s:expecting_events_updatetime = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-events-update-time'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-events-char-count')
  if found
    let s:expecting_events_char_count = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-events-char-count'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-many-events-read-time-out')
  if found
    let s:event_expecting_many_read_timeout = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-many-events-read-time-out'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-many-events-update-time')
  if found
    let s:event_expecting_many_updatetime = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-many-events-update-time'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-expecting-many-events-char-count')
  if found
    let s:event_expecting_many_char_count = l:value
  else
    call add(errors, ": Option not found: 'scheduler-expecting-many-events-char-count '")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-many-max-count-no-events')
  if found
    let s:many_max_count = l:value
  else
    call add(errors, ": Option not found: 'scheduler-many-max-count-no-events'")
  endif
  unlet l:value

  let [found, l:value] = g:vimside.GetOption('scheduler-events-max-count-no-events')
  if found
    let s:event_max_count = l:value
  else
    call add(errors, ": Option not found: 'scheduler-events-max-count-no-events'")
  endif
  unlet l:value

  let s:current_many_max_count = s:many_max_count
  let s:current_event_max_count = s:event_max_count

endfunction

function! vimside#ensime#swank#ping_info_set_not_expecting_anything()
call s:LOG("vimside#ensime#swank#ping_info_set_not_expecting_anything") 
  unlet g:vimside.swank.events
  let g:vimside.swank.events = 0
  
  " reset many and events max counters
  let s:current_many_max_count = s:many_max_count
  let s:current_event_max_count = s:event_max_count

  let g:vimside.ping.info.read_timeout = s:rpc_not_expecting_read_timeout
  let g:vimside.ping.info.updatetime = s:rpc_not_expecting_updatetime 
  let g:vimside.ping.info.char_count = s:rpc_not_expecting_char_count 

  call vimside#scheduler#SetUpdateTime(g:vimside.ping.info.updatetime)
endfunction

function! vimside#ensime#swank#ping_info_set_expecting_rpc_response()
call s:LOG("vimside#ensime#swank#ping_info_set_expecting_rpc_response") 

  let g:vimside.ping.info.read_timeout = s:rpc_expecting_read_timeout
  let g:vimside.ping.info.updatetime = s:rpc_expecting_updatetime 
  let g:vimside.ping.info.char_count = s:rpc_expecting_char_count 

  call vimside#scheduler#SetUpdateTime(g:vimside.ping.info.updatetime)

  call vimside#scheduler#ResetAuto()
  call vimside#scheduler#FeedKeys()
endfunction

function! vimside#ensime#swank#ping_info_set_expecting_events(nos_events)
call s:LOG("vimside#ensime#swank#ping_info_set_expecting_events") 
  unlet g:vimside.swank.events
  let g:vimside.swank.events = a:nos_events

  let g:vimside.ping.info.read_timeout = s:expecting_events_read_timeout
  let g:vimside.ping.info.updatetime = s:expecting_events_updatetime
  let g:vimside.ping.info.char_count = s:expecting_events_char_count

  call vimside#scheduler#SetUpdateTime(g:vimside.ping.info.updatetime)
endfunction

function! vimside#ensime#swank#ping_info_set_expecting_many_events()
call s:LOG("vimside#ensime#swank#ping_info_set_expecting_many_events") 
  unlet g:vimside.swank.events
  let g:vimside.swank.events = 'many'

  let g:vimside.ping.info.read_timeout = s:event_expecting_many_read_timeout
  let g:vimside.ping.info.updatetime = s:event_expecting_many_updatetime
  let g:vimside.ping.info.char_count = s:event_expecting_many_char_count

  call vimside#scheduler#SetUpdateTime(g:vimside.ping.info.updatetime)
endfunction








" Called from a Ping
function! vimside#ensime#swank#handle(response)
call s:LOG("vimside#ensime#swank#handle response=". a:response) 
  let response = a:response
  let success = 0
  let got_event = 0

let l:start_time = reltime()
  let sexp = vimside#sexp#Parse(response)
call s:LOG("vimside#ensime#swank#handle time=". reltimestr(reltime(l:start_time)))

   
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
      let [success, got_event] = s:HandleResponse(children)
    else
      call s:ERROR("vimside#ensime#swank#handle child SExp List length > 3: ". string(response)) 
      let success = 0

    endif
  endif

  call s:PostHandle(success, got_event, 0)

  return success
endfunction

function! vimside#ensime#swank#handle_no_response()
"call s:LOG("vimside#ensime#swank#handle_no_response") 

  let l:events = g:vimside.swank.events
"call s:LOG("vimside#ensime#swank#handle_no_response l:events=" . l:events) 

  if l:events == 'many'
    if s:current_many_max_count > 0
      let s:current_many_max_count -= 1
    else
      call vimside#ensime#swank#ping_info_set_not_expecting_anything()
    endif
  elseif l:events > 0
    if s:current_event_max_count > 0
      let s:current_event_max_count -= 1
    else
      call vimside#ensime#swank#ping_info_set_not_expecting_anything()
    endif
  endif

endfunction

function! s:PostHandle(success, got_event, nos_events)
" call s:LOG("s:PostHandle TOP") 
" call s:LOG("s:PostHandle a:success=" . a:success) 
" call s:LOG("s:PostHandle a:got_event=" . a:got_event) 
" call s:LOG("s:PostHandle a:nos_events=" . a:nos_events) 
" call s:LOG("s:PostHandle waiting=" . string(g:vimside.swank.rpc.waiting)) 

  if type(g:vimside.swank.events) == type(0)
    " expecting number of events, add any new events
    let l:events = g:vimside.swank.events + a:nos_events
  else
    " expecting 'many' events, so still expect 'many'
    let l:events = g:vimside.swank.events
  endif
" call s:LOG("s:PostHandle l:events=". l:events) 

  " If we are waiting for a response and there is still an
  " outstanding response id, we are still waiting for a response,
  " then record event info and set ping timing for response expecting.
  if ! empty(g:vimside.swank.rpc.waiting)
    if l:events > 0 && s:current_event_max_count > 0
      let s:current_event_max_count -= 1
    endif

    call vimside#ensime#swank#ping_info_set_expecting_rpc_response()
    return
  endif

  " if nothing happened, check to see if we punt and set scheduler
  " to a 'not expecting anything' state
  if a:success == 0 && a:nos_events == 0
    if l:events == 'many'
      if s:current_many_max_count > 0
        let s:current_many_max_count -= 1
      else
        call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        return
      endif
    elseif l:events > 0
      if s:current_event_max_count > 0
        let s:current_event_max_count -= 1
      else
        call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        return
      endif
    endif
  endif

  if a:success 
" call s:LOG("s:PostHandle success") 
    if empty(g:vimside.swank.rpc.waiting)
" call s:LOG("s:PostHandle not waiting") 
      if empty(g:vimside.swank.ping_data)
" call s:LOG("s:PostHandle no ping data") 
        if l:events == 0
          call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        elseif l:events == 'many'
          call vimside#ensime#swank#ping_info_set_expecting_many_events()
        elseif a:got_event
          if l:events == 1
            call vimside#ensime#swank#ping_info_set_not_expecting_anything()
          else
            let nos_events = l:events - 1
            call vimside#ensime#swank#ping_info_set_expecting_events(nos_events)
          endif
        endif
      else
        if has_key(g:vimside.swank.ping_data, 'read_timeout')
          let g:vimside.ping.info.read_timeout = g:vimside.swank.ping_data.read_timeout
        endif
        if has_key(g:vimside.swank.ping_data, 'char_count')
          let l:char_count = g:vimside.swank.ping_data.char_count
          let g:vimside.ping.info.char_count = l:char_count
          call vimside#scheduler#SetMaxMotionCounter(l:char_count)
        endif

        if has_key(g:vimside.swank.ping_data, 'updatetime')
          let l:updatetime = g:vimside.swank.ping_data.updatetime
          let g:vimside.ping.info.updatetime = l:updatetime
          call vimside#scheduler#SetUpdateTime(l:updatetime)
        endif
        " clear rpc handler specific data
        let g:vimside.swank.ping_data = {}
      endif
    else
" call s:LOG("s:PostHandle waiting") 
      if l:events == 'many'
        call vimside#ensime#swank#ping_info_set_expecting_many_events()
      elseif a:got_event
        if l:events == 0
          call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        else
          let nos_events = l:events - 1
          call vimside#ensime#swank#ping_info_set_expecting_events(nos_events)
        endif
      else
        if l:events == 0
          call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        else
          call vimside#ensime#swank#ping_info_set_expecting_events(l:events)
        endif
      endif

      if l:events == 0
        call vimside#ensime#swank#ping_info_set_not_expecting_anything()
      elseif l:events == 'many'
      elseif a:got_event
        if l:events == 1
          call vimside#ensime#swank#ping_info_set_not_expecting_anything()
        else
          let nos_events = l:events - 1
          call vimside#ensime#swank#ping_info_set_expecting_events(nos_events)
        endif
      endif
    endif
  else
" call s:LOG("s:PostHandle not success") 
    " not success, see if there are any new events
    if type(g:vimside.swank.events) == type(0)
      " expecting number of events, add any new events
      let g:vimside.swank.events += a:nos_events
    endif
  endif
" call s:LOG("s:PostHandle g:vimside.swank.events=". g:vimside.swank.events) 
" call s:LOG("s:PostHandle BOTTOM") 
endfunction

"
" rr = {
"   'caller': funcref
"   'args': {}
"   'handler': {
"     'ok': funcref,
"     'abort': funcref
"   }
"   'events': 0,1,...N or 'many'
"   'is_sync': {}
" }
"
"

" return status = {
"   'caller': funcref
" }
function! vimside#ensime#swank#dispatch(rr)
  let rr = a:rr

  let callmsg = rr.caller(rr.args)
call s:LOG("vimside#ensime#swank#dispatch callmsg=".callmsg) 
  let rr.id = vimside#ensime#io#write(callmsg)

  return has_key(rr, "is_sync") 
    \ ? vimside#ensime#swank#synchronous(rr)
    \ : vimside#ensime#swank#asynchronous(rr)

endfunction

function! vimside#ensime#swank#synchronous(rr)
  let rr = a:rr

  let timeout = 5000
  let rval = {}

  let success = 0
  let finished = 0
  let got_event = 0

  while ! finished

    let response = vimside#ensime#io#read(timeout)

call s:LOG("vimside#ensime#swank#synchronous response=".response) 
    if response == ''
      " read returned nothing 
call s:LOG("vimside#ensime#swank#synchronous failed for id=". rr.id) 
      " failed = { id: rr }
      let g:vimside.swank.rpc.failed[rr.id] = rr

      " rpc expecting ping info 
      call vimside#ensime#swank#ping_info_set_expecting_rpc_response()
      let rval.status = 0
      let rval.msg = 'response empty'
      let rval.value = {}
      let finished = 1

    else

      let sexp = vimside#sexp#Parse(response)
     
      let [found, children] =  vimside#sexp#Get_ListValue(sexp) 
      if ! found
        let rval.status = 0
        let rval.msg = 'response: not list'
        let rval.value = response
        let finished = 1

      else

        " It is a SExp List
        let len = len(children)
        
        if len == 0
          let rval.status = 0
          let rval.msg = 'response: child list length == 0'
          let rval.value = response
          let finished = 1

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
          let [success, got_event, msg, dic] = s:ValidateResponse(children)
          if success
            if got_event
              continue
            else
              let rval.status = 1
              let rval.msg = msg
              let rval.value = dic
              let finished = 1

            endif
          else
            let rval.status = 0
            let rval.msg = msg
            let rval.value = dic
            let finished = 1
          endif

        else

          let rval.status = 0
          let rval.msg = 'response: child list length > 3'
          let rval.value = response
          let finished = 1
        endif

      endif

    endif
  endwhile

  call s:PostHandle(success, got_event, rr.events)

  return rval

endfunction


function! vimside#ensime#swank#asynchronous(rr)
  let rr = a:rr

  let success = 0
  let got_event = 0

  while ! success
    let response = vimside#ensime#io#read()

call s:LOG("vimside#ensime#swank#asynchronous response=".response) 
    if response == ''
      " read returned nothing 
call s:LOG("vimside#ensime#swank#asynchronous waiting for id=". rr.id) 
      " waiting = { id: rr }
      let g:vimside.swank.rpc.waiting[rr.id] = rr

      " rpc expecting ping info 
      call vimside#ensime#swank#ping_info_set_expecting_rpc_response()
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
        call s:ERROR("vimside#ensime#swank#asynchronous Not List: ". string(response)) 
      else
        " It is a SExp List
        let len = len(children)
        
        if len == 0
          call s:ERROR("vimside#ensime#swank#asynchronous child SExp List length 0: ". string(response)) 
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
          let [success, got_event, msg, result] = s:ValidateResponse(children)
          if success
            if got_event
              continue
            else
" call s:LOG("vimside#ensime#swank#asynchronous msg=". msg) 
              if msg == 'ok'
                if has_key(rr, 'data')
                  call rr.handler.ok(result.dic, rr.data)
                else
                  call rr.handler.ok(result.dic)
                endif
              elseif msg == 'abort'
                call rr.handler.abort(result.code, result.details, result.rest)
              else
                let rval.status = 1
                let rval.msg = msg
                let rval.value = result.dic
                let finished = 1
              endif

            endif
          else
            call s:ERROR(msg . string(dic)) 
          endif

        else
          call s:ERROR("vimside#ensime#swank#asynchronous child SExp List length > 3: ". string(response)) 

        endif

      endif

    endif
  endwhile

  call s:PostHandle(success, got_event, rr.events)

  return {}

endfunction

" :compiler-ready
" :full-typecheck-finished
" :indexer-ready
" :clear-all-scala-notes
" :clear-all-java-notes
function! s:HandleSimpleEvent(sexp)
  let sexp = a:sexp
call s:LOG("HandleSimpleEvent ".string(sexp)) 

  let [found, event] = vimside#sexp#Get_KeywordValue(sexp) 
  if found
    let Ehandler = get(g:vimside.event_handlers, event, g:vimside.unknown_event_handler)
    call Ehandler(event)
    call vimside#EventSignal(event)
  else
    call s:ERROR("HandleSimpleEvent: ". event) 
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
    call vimside#EventSignal(value1, child2)
  else
    let [found, value2] =  vimside#sexp#Get_KeywordValue(child2) 
    if found
      let Ehandler = get(g:vimside.event_handlers, value2, g:vimside.unknown_event_handler)
      call Ehandler(value2, child1)
      call vimside#EventSignal(value2, child1)
    else
      call s:ERROR("HandleComplexEvent: No Keyword: ". string(children)) 
    endif
  endif

endfunction

" returns 
"   on error:        [0, 0, msg, data_dic]
"   on event:        [1, 1, _, _]
"   on return abort: [1, 0, 'abort', {'code': code, 
"                                     'details': details, 
"                                     'rest': rest}]"
"   on return ok:    [1, 0, 'ok', {'dic': dic, 'data': rr.data}]
"   on return ok:    [1, 0, 'ok', {'dic': dic}]
"
function! s:ValidateResponse(children)
  let children = a:children
"call s:LOG("ValidateResponse ". string(children))

  " Note that the first child really ought to be the keyword
  let top_kw_sexp = children[0]

  let [found, top_kw] =  vimside#sexp#Get_KeywordValue(top_kw_sexp) 
  if ! found
    return [0, 0, "Keyword not first sexp:", children]
  endif

  if top_kw == ':background-message'
    let eventcode_sexp = children[1]
    let msg_sexp = children[2]
    call s:HandleBackgroundMessage(eventcode_sexp, msg_sexp)
    return [1, 1, "" , {}]
  endif

  if top_kw != ':return'
    return [0, 0, "Keyword not ':return':", children]
  endif

  let content_sexp = children[1]
  let id_sexp = children[2]

  let [found, id] =  vimside#sexp#Get_IntValue(id_sexp) 
  if ! found
    return [0, 0, "Id not third sexp", children]
  endif

  if ! has_key(g:vimside.swank.rpc.waiting, id)
    return [0, 0, "Not a valid Id", children]
  endif

  let rr = g:vimside.swank.rpc.waiting[id]
  " remove response waiting data
  unlet  g:vimside.swank.rpc.waiting[id]

  let [found, content] =  vimside#sexp#Get_ListValue(content_sexp) 
  if ! found
    return [0, 0, "Protocol error second sexp not List", children]
  endif

  let len = len(content)

  if len < 2
    return [0, 0, "Protocol error Content List length < 2", children]
  endif

  let kind_kw_sexp = content[0]
  let body_sexp = content[1]

  let [found, kind_kw] =  vimside#sexp#Get_KeywordValue(kind_kw_sexp) 
  if ! found
    return [0, 0, "Kind Keyword not first sexp", children]
  endif

  if kind_kw == ':ok'
    " maybe Dictionary or List of value(s)
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(body_sexp)
    if ! found
      return [0, 0, "Badly formed Response", body_sexp]
    endif

    " return 0 or 1
    if has_key(rr, 'data')
      return [1, 0, "ok", {'dic': dic, 'data': rr.data}]
    else
      return [1, 0, "ok", {'dic': dic}]
    endif

  elseif kind_kw == ':abort'
    let [found, body_list] =  vimside#sexp#Get_ListValue(body_sexp) 
    if ! found
      return [0, 0, "Badly ':abort' not List", children]
    endif

    let code_sexp = body_list[0]
    let detail_sexp = body_list[1]
    let rest = body_list[2:]
    let [found, code] =  vimside#sexp#Get_IntValue(code_sexp) 
    if ! found
      return [0, 0, "Body ':abort' code not Int", children]
    endif
    let [found, detail] =  vimside#sexp#Get_StringValue(string_sexp) 
    if ! found
      return [0, 0, "Body ':abort' detail not String", children]
    endif

    " on return abort: [1, 0, 'abort', ]
    return [1, 0, "abort", {'code': code, 'details': details, 'rest': rest}]

  else
    return [0, 0, "Kind Keyword not ':ok' or ':abort'", children]
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
" return [0, got_event] or [1, got_event] if id matches rr.id
function! s:HandleResponse(children)
  let children = a:children

"call s:LOG("HandleResponse ". string(children))

  " Note that the first child really ought to be the keyword
  let top_kw_sexp = children[0]

  let [found, top_kw] =  vimside#sexp#Get_KeywordValue(top_kw_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Keyword not first sexp: ". string(children)) 
    return [0, 0]
  endif

  if top_kw == ':background-message'
    let eventcode_sexp = children[1]
    let msg_sexp = children[2]
    call s:HandleBackgroundMessage(eventcode_sexp, msg_sexp)
    return [1, 1]
  endif

  if top_kw != ':return'
    call s:ERROR("HandleResponse: Keyword not ':return': ". string(children)) 
    return [0, 0]
  endif

  let content_sexp = children[1]
  let id_sexp = children[2]

  let [found, id] =  vimside#sexp#Get_IntValue(id_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Id not third sexp: ". string(children)) 
    return [0, 0]
  endif

  if ! has_key(g:vimside.swank.rpc.waiting, id)
    return [0, 0]
  endif

  let rr = g:vimside.swank.rpc.waiting[id]
  " remove response waiting data
  unlet  g:vimside.swank.rpc.waiting[id]

  let [found, content] =  vimside#sexp#Get_ListValue(content_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Protocol error second sexp not List: ". string(children)) 
    return [1, 0]
  endif

  let len = len(content)

  if len < 2
    call s:ERROR("HandleResponse: Protocol error Content List less than 2: ". string(children)) 
    return [1, 0]
  endif

  let kind_kw_sexp = content[0]
  let body_sexp = content[1]

  let [found, kind_kw] =  vimside#sexp#Get_KeywordValue(kind_kw_sexp) 
  if ! found
    call s:ERROR("HandleResponse: Kind Keyword not first sexp: ". string(children)) 
    return [1, 0]
  endif
  if kind_kw == ':ok'
    " maybe Dictionary or List of value(s)
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(body_sexp)
    if ! found
      echoe "HandleResponse: Badly formed Response"
      call s:ERROR("HandleResponse: Badly formed Response: ". string(body_sexp))
      return [1, 0]
    endif

    " return 0 or 1
    if has_key(rr, 'data')
      call rr.handler.ok(dic, rr.data)
    else
      call rr.handler.ok(dic)
    endif

  elseif kind_kw == ':abort'
    let [found, body_list] =  vimside#sexp#Get_ListValue(body_sexp) 
    if ! found
      call s:ERROR("HandleResponse: Body ':abort' not List: ". string(children)) 
      return [1, 0]
    endif

    let code_sexp = body_list[0]
    let detail_sexp = body_list[1]
    let rest = body_list[2:]
    let [found, code] =  vimside#sexp#Get_IntValue(code_sexp) 
    if ! found
      call s:ERROR("HandleResponse: Body ':abort' code not Int: ". string(children)) 
      return [1, 0]
    endif
    let [found, detail] =  vimside#sexp#Get_StringValue(string_sexp) 
    if ! found
      call s:ERROR("HandleResponse: Body ':abort' detail not String: ". string(children)) 
      return [1, 0]
    endif

    " ignore return value
    call rr.handler.abort(code, details, rest)
  else
    call s:ERROR("HandleResponse: kind Keyword not ':ok' or ':abort': ". string(children)) 
  endif
  
  return [1, 0]
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
call s:LOG("g:DebugEventHandler a:keyword=". a:keyword) 
  let g:vimside.status.debug_event += 1
  " call g:vimside.trigger.debug_event(a:000)

  if a:0 == 0
    call s:ERROR("DebugEventHandler No arguments". string(a:keyword)) 

  elseif a:0 == 1
call s:LOG("g:DebugEventHandler a:1=". string(a:1)) 
if 0 " XXXX
    let [found, value2] =  vimside#sexp#Get_ListValue(a:1) 
    if found
call s:LOG("g:DebugEventHandler value2=". string(value2)) 
      let [ok, kw_dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(value2) 
call s:LOG("g:DebugEventHandler kw_dic=". string(kw_dic)) 
      if !ok
        call s:ERROR("DebugEventHandler failure to create kw dict ". kw_dic) 
      else
        let DB_handler = get(g:vimside.debug_event_handlers, ':type', g:vimside.unknown_debug_handler)
        call DB_handler(kw_dic)
      endif

call s:LOG("g:DebugEventHandler return") 
return
    else
      call s:ERROR("DebugEventHandler: getting a:1 ". string(a:1)) 
    endif
endif " XXXX

    let [ok, kw_dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:1) 
call s:LOG("g:DebugEventHandler kw_dic=". string(kw_dic)) 
    if !ok
      call s:ERROR("DebugEventHandler failure to create kw dict ". string(kw_dic)) 
    else
      let l:type = kw_dic[':type']
      let l:DB_handler = get(g:vimside.debug_event_handlers, l:type, g:vimside.unknown_debug_handler)
      call l:DB_handler(kw_dic)
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
  if ! exists("g:vimside.debug_trigger.breakpoint")
    let g:vimside.debug_trigger.breakpoint = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-breakpoint')
  endif

  call g:vimside.debug_trigger.breakpoint(a:kw_dic)
endfunction



" Signals that the debugged VM has exited.
"  (:debug-event
"    (:type //Symbol: death
"  ))
function! g:DeathDebugHandler(kw_dic)
  if ! exists("g:vimside.debug_trigger.death")
    let g:vimside.debug_trigger.death = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-death')
  endif

  call g:vimside.debug_trigger.death(a:kw_dic)
endfunction



" Signals that the debugged VM has started.
"  (:debug-event
"    (:type //Symbol: start
"  ))
function! g:StartDebugHandler(kw_dic)
  if ! exists("g:vimside.debug_trigger.start")
    let g:vimside.debug_trigger.start = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-start')
  endif

  call g:vimside.debug_trigger.start(a:kw_dic)
endfunction




function! g:DisconnectDebugHandler(kw_dic)
  if ! exists("g:vimside.debug_trigger.disconnect")
    let g:vimside.debug_trigger.disconnect = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-debug-trigger-disconnect')
  endif

  call g:vimside.debug_trigger.disconnect(a:kw_dic)
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

