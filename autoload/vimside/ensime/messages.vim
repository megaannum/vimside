
if ! exists("g:ensime")
  let g:ensime = {}
  let g:ensime.protocol = {}
  let g:ensime.protocol.constants = {}

  let g:ensime.protocol.constants['101'] = ["Msg", "Compiler Unexpected Error"]
  let g:ensime.protocol.constants['102'] = ["Msg", "Initializing Analyzer"]
  let g:ensime.protocol.constants['103'] = ["Msg", "Building Entire Project"]
  let g:ensime.protocol.constants['104'] = ["Msg", "Build Complete"]
  let g:ensime.protocol.constants['105'] = ["Msg", "Misc"]

  let g:ensime.protocol.constants['200'] = ["Err", "Exception In Debugger"]
  let g:ensime.protocol.constants['201'] = ["Err", "Exception In RPC"]
  let g:ensime.protocol.constants['202'] = ["Err", "Malformed RPC"]
  let g:ensime.protocol.constants['203'] = ["Err", "Unrecognized Form"]
  let g:ensime.protocol.constants['204'] = ["Err", "Unrecognized RPC"]
  let g:ensime.protocol.constants['205'] = ["Err", "Exception In Builder"]
  
  let g:ensime.protocol.constants['206'] = ["Err", "Peek Undo Failed"]
  let g:ensime.protocol.constants['207'] = ["Err", "Exec Undo Failed"]

  let g:ensime.protocol.constants['208'] = ["Err", "Format Failed"]

  let g:ensime.protocol.constants['209'] = ["Err", "Analyzer Not Ready"]
  let g:ensime.protocol.constants['210'] = ["Err", "Exception In Analyzer"]
  
  let g:ensime.protocol.constants['211'] = ["Err", "File Does Not Exist"]

  let g:ensime.protocol.constants['211'] = ["Err", "Exception In Indexer"]
endif

" return [type, msg]
function! vimside#ensime#messages#GetProtocolConstant(code)
  let d = g:ensime.protocol.constants
  if has_key(d, "".a:code)
    return d[a:code]
  else
    return ["Unknown", "Error code not found"]
  endif
endfunction


