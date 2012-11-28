
let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

" :call vimside#browser#Open('http://www.yahoo.com/')
function! vimside#browser#Open(url)
  let BOFunc = s:GetBrowserOpenFunc()
  call BOFunc(a:url)
endfunction

function! vimside#browser#Reset()
  if exists("s:BrowserFuncRef")
    unlet s:BrowserFuncRef
  endif
endfunction

function! s:GetBrowserOpenFunc()
  if ! exists("s:BrowserFuncRef")
    let [browser_cmd, url_func_name] = g:BrowserGetCommandAndFunc()
    let funcname = 'g:VIMSIDE_BROWSER_OPEN'
    let l:fdef = "function! ". funcname ."(url) \n"
    let l:fdef .= "    let url = ". url_func_name ."(a:url) \n"
    let l:fdef .= "    let cmdline = '". browser_cmd ." '\. url\n"
    let l:fdef .= "    call system(cmdline) \n"
    let l:fdef .= "endfunction"
    execute l:fdef
    let s:BrowserFuncRef = function(funcname)
  endif
  return s:BrowserFuncRef
endfunction

function! s:GetBrowserCmd()
  for cmd in g:open_commands()
    if executable(cmd)
      return cmd
    endif
  endfor
  throw "Can not determine browser to use to view url"
endfunction

function! g:BrowserGetCommandAndFunc()
call s:LOG("g:BrowserGetCommandAndFunc: TOP")
  let key = g:BrowserGetPlatformKey()
call s:LOG("g:BrowserGetCommandAndFunc: key=". key)

  let definitions = g:vimside.options.defined
  if ! has_key(definitions, 'tailor-browser-keys-platform')
    throw "Option Definition not found: 'tailor-browser-keys-platform'"
  endif
  let def = definitions['tailor-browser-keys-platform']
  let templates = def.templates
call s:LOG("g:BrowserGetCommandAndFunc: templates=". string(templates))

  let cmds_template = templates.commands
  let cmds_op = substitute(cmds_template, "{key}", key, "g")
call s:LOG("g:BrowserGetCommandAndFunc: cmds_op=". cmds_op)
  let [found, cmds] = g:vimside.GetOption(cmds_op)
  if ! found
    throw "Option not found: '". cmds_op ."'"
  endif

  let url_funcs_template = templates.url_funcs
  let url_funcs_op = substitute(url_funcs_template, "{key}", key, "g")
call s:LOG("g:BrowserGetCommandAndFunc: url_funcs_op=". url_funcs_op)
  let [found, funcs] = g:vimside.GetOption(url_funcs_op)
  if ! found
    throw "Option not found: '". url_funcs_op ."'"
  endif

  if len(cmds) != len(funcs)
    throw "Length cmds not equal to length funcs: cmds=". string(cmds) .", funcs=". string(funcs)
  endif

  let cnt = 0
  while cnt < len(cmds)
    let cmd = cmds[cnt]
    let func = funcs[cnt]
call s:LOG("g:BrowserGetCommandAndFunc: cmd=". cmd)
call s:LOG("g:BrowserGetCommandAndFunc: func=". func)
    if executable(cmd)
      return [cmd, func] 
    endif

    let cnt += 1
  endwhile

  throw "Can not determine browser to use to view url"
endfunction

function! g:BrowserGetPlatformKey()
  let [found, keys] = g:vimside.GetOption('tailor-browser-keys-platform')
  if ! found
    throw "Option not found: 'tailor-browser-keys-platform'"
  endif
  " check os kinds
  for key in keys
    if key == g:vimside.os.kind
      return key
    endif
  endfor
  " check os name
  for key in keys
    if key == g:vimside.os.name
      return key
    endif
  endfor

  throw "Unknown Browser platform keys: ". string(keys)
endfunction


