" ============================================================================
" io.vim
"
" File:          io.vim
" Summary:       Ensime Server IO code
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Ensime Server socket io functions.  
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" ------------------------------------------------------------ 
" vimside#ensime#io#open {{{2
"  Open socket to host and port.
"  parameters: 
"    host  : String Ensime Server host name
"    port  : Number Ensime Server port number
" ------------------------------------------------------------ 
function! vimside#ensime#io#open(host, port)
" call s:LOG("vimside#ensime#io#open: host:port=" . a:host .":". a:port) 

  let l:socket = vimproc#socket_open(a:host, a:port)
" call s:LOG("vimside#ensime#io#open:  socket=" . string(l:socket)) 
  return l:socket
endfunction


" ------------------------------------------------------------ 
" vimside#ensime#io#ping {{{2
"  Ping the open socket, Any in comming data is handled.
"  Returns 1 if there was incoming data and it was processe successfully.
"  parameters: 
"    timeout : Number read timeout in milliseconds
" ------------------------------------------------------------ 
function! vimside#ensime#io#ping(timeout)
if 0 " XXXXXXXXXXXXXX
  if ! empty(g:vimside.ping.actions)
    for Action in g:vimside.ping.actions
      call Action()
    endfor
    let g:vimside.ping.actions = []
  endif
endif " XXXXXXXXXXXXXX

  let success = 0

  let response = vimside#ensime#io#read(a:timeout)
  if response != ''
" call s:LOG("vimside#ensime#io#ping: response=". response) 
    let success = vimside#ensime#swank#handle(response)
  else
    call vimside#ensime#swank#handle_no_response()
  endif

  return success
endfunction

" ------------------------------------------------------------ 
" vimside#ensime#io#read {{{2
"  Read a single Swank message if one is available
"  Returns message or ''
"  parameters: 
"    timeout : Number optional read timeout in milliseconds
" ------------------------------------------------------------ 
function! vimside#ensime#io#read(...)
  let l:socket = g:vimside['socket']
  let timeout = (a:0 > 0) ? a:1 : 100
" if timeout != 0
" call s:LOG("vimside#ensime#io#read Not 0 timeout=".timeout) 
" endif

  " read swank message byte count
  let nrStr = l:socket.read(6, timeout)
" call s:LOG("Read nrStr=".nrStr) 
  if nrStr == ''
    return ''
  else
    " its a swank message, read body
    let nr = str2nr(nrStr, 16)
" call s:LOG("Read nr=".nr) 
   let msg = l:socket.read(nr, 100)
" call s:LOG("Read msg=".msg) 
   return msg
  endif
endfunction

let s:msg_counter = 0

" ------------------------------------------------------------ 
" vimside#ensime#io#message_count {{{2
"  The current Swank message count value.
"  parameters: None
" ------------------------------------------------------------ 
function! vimside#ensime#io#message_count()
  return s:msg_counter
endfunction

" ------------------------------------------------------------ 
" vimside#ensime#io#write {{{2
"  Write Swank body do server. This pre-pends Swank byte count.
"  parameters: 
"    msg : the message to send
" ------------------------------------------------------------ 
function! vimside#ensime#io#write(msg)
  let msg = a:msg
  let s:msg_counter += 1
  let full_msg = "(:swank-rpc " .msg. " ". s:msg_counter . ")"
" call s:LOG("vimside#ensime#io#write full_msg=".full_msg) 

  let mlen = len(full_msg)
" call s:LOG("Write mlen=".mlen) 
  let mlen = printf("%06x", mlen)
" call s:LOG("Write mlen=".mlen) 

  let output = mlen . full_msg
  let l:socket = g:vimside['socket']
  let nleft = l:socket.write(output, 100)
" call s:LOG("Write BOTTOM nleft=".nleft) 
  return s:msg_counter
endfunction

" ------------------------------------------------------------ 
" vimside#ensime#io#close {{{2
"  Close socket to Ensime Server.
"  parameters: None
" ------------------------------------------------------------ 
function! vimside#ensime#io#close()
  let l:socket = g:vimside['socket']
  call l:socket.close()
endfunction


"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
