" ============================================================================
" show_doc_symbol_at_point.vim
"
" File:          show_doc_symbol_at_point.vim
" Summary:       Vimside Show Documentation for Symbol At Point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:show_doc_map = {}


" When creating javadoc urls, use this mapping to replace scala
" types with java types.
let s:java_doc_type_replacements = {}
let s:java_doc_type_replacements["^scala.Any$"] = 'java.lang.Object'
let s:java_doc_type_replacements["^scala.Int$"] = 'int'
let s:java_doc_type_replacements["^scala.Double$"] = 'double'
let s:java_doc_type_replacements["^scala.Short$"] = 'short'
let s:java_doc_type_replacements["^scala.Byte$"] = 'byte'
let s:java_doc_type_replacements["^scala.Long$"] = 'long'
let s:java_doc_type_replacements["^scala.Float$"] = 'float'
let s:java_doc_type_replacements["^scala.Boolean$"] = 'boolean'
let s:java_doc_type_replacements["^scala.Char$"] = 'char'
let s:java_doc_type_replacements["^scala.Unit$"] = 'void'

function! s:JavaDocReplaceTypes(str)
  let str = a:str
call s:LOG("s:JavaDocReplaceTypes: TOP str=". str) 

  for key in keys(s:java_doc_type_replacements)
    let value = s:java_doc_type_replacements[key]
    let str = substitute(str, key, value, "g")
  endfor

call s:LOG("s:JavaDocReplaceTypes: BOTTOM str=". str) 
  return str
endfunction

function! s:JavaDocTypeName(tpe)
  let tpe = a:tpe
  let name = tpe[':name']
call s:LOG("s:JavaDocTypeName: name=". name) 
  if name == 'Array' && has_key(tpe, ':type-args')
    let type_args = tpe[':type-args']
call s:LOG("s:JavaDocTypeName: type_args=". string(type_args)) 
    let type_arg = type_args[0]
call s:LOG("s:JavaDocTypeName: type_arg=". string(type_arg)) 
    let full_name = type_arg[':full-name']
call s:LOG("s:JavaDocTypeName: full_name=". full_name) 
    return s:JavaDocReplaceTypes(full_name) . '[]'
  else
    let full_name = tpe[':full-name']
call s:LOG("s:JavaDocTypeName: full_name=". full_name) 
    return s:JavaDocReplaceTypes(full_name)
  endif
endfunction

" NOT USED
function! s:EscapeUrl(url)
  let url = a:url

  let escaped_url = ''
  for i in range(strlen(url))
    let c = url[i]
    if c =~# '^[A-Za-z0-9._~"-]$'
      let escaped_url .= c
    else
      let escaped_url .= printf("%%%02X", char2nr(c))
    endif
  endfor
  return escaped_url
endfunction

function! vimside#command#show_doc_symbol_at_point#MakeUrlJava(url_base, tpe, ...)
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: url_base=". a:url_base) 
  let tpe = a:tpe
  let full_type_name = has_key(tpe, ':arrow-type') ? tpe[':name'] : tpe[':full-name']
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: full_type_name=". full_type_name) 

  let without_dollar = substitute(full_type_name, "\\$", '', "g")
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: without_dollar=". without_dollar) 
  let with_slashes = substitute(without_dollar, "\\.", '/', "g")
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: with_slashes=". with_slashes) 
  let url = a:url_base . with_slashes . '.html'
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: url=". url) 

  if a:0 == 1
    let member_name = a:1[':name']
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: member_name=". member_name) 
    if member_name == 'this'
      let member_name = tpe[':name']
    endif
    let url = url .'#'. member_name

    let mtpe = a:1[':type']
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: mtpe=". string(mtpe)) 
    let param_sections = mtpe[':param-sections']
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: param_sections=". string(param_sections)) 
    let sec = param_sections[0]
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: sec=". string(sec)) 

    let param_str = ''
    if has_key(sec, ':params')
      let mparams = sec[':params']
  call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: mparams=". string(mparams)) 
      " let params = mparams[0]
  " call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: params=". string(params)) 

      for param in mparams
  call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: param=". string(param)) 
        if param_str != ''
          let param_str .= ', '
        endif
        let tname = s:JavaDocTypeName(param[1])
        let param_str .= tname
      endfor
    endif

    let url = url .'('. param_str .')'
  endif

  " let url = s:EscapeUrl(url)
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlJava: url=". url) 
  return  url
endfunction

function! vimside#command#show_doc_symbol_at_point#MakeUrlScala(url_base, tpe, ...)
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlScala: url_base=". a:url_base) 
  let tpe = a:tpe
  let full_type_name = has_key(tpe, ':arrow-type') ? tpe[':name'] : tpe[':full-name']
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlScala: full_type_name=". full_type_name) 

  " I do not know why 'package$' has to have the '$' removed.
  if full_type_name =~# '^.*package\$$'
    let s = strpart(full_type_name, 0, len(full_type_name)-1)
  else
    let s = full_type_name
  endif
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlScala: s=". s) 
  let url = a:url_base .'#'.  s 
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlScala: url=". url) 

  if a:0 == 1
    let name = a:1[':name']
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlScala: name=". name) 
    " let url = url .'#'. full_type_name  .'#'. name
    let url = url .'#'. name
  endif

  " let url = s:EscapeUrl(url)
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrlScala: url=". url) 
  return  url
endfunction

function! g:ShowJavaDoc(url_base, tpe, ...)
  if a:0 == 0
    let url = vimside#command#show_doc_symbol_at_point#MakeUrlJava(a:url_base, a:tpe)
  else
    let url = vimside#command#show_doc_symbol_at_point#MakeUrlJava(a:url_base, a:tpe, a:1)
  endif
endfunction

function! s:Init()
  let [found, keys] = g:vimside.GetOption('tailor-show-doc-keys')
  if ! found
    throw "Option not found: "'tailor-show-doc-keys'"
  endif
  let [found, java_version] = g:vimside.GetOption('vimside-java-version')
  if ! found
    throw "Option not found: "'vimside-java-version'"
  endif
  let [found, scala_version] = g:vimside.GetOption('vimside-scala-version')
  if ! found
    throw "Option not found: "'vimside-scala-version'"
  endif

  let definitions = g:vimside.options.defined
  if ! has_key(definitions, 'tailor-show-doc-keys')
    throw "Option Definition not found: 'tailor-show-doc-keys'"
  endif
  let def = definitions['tailor-show-doc-keys']
  let templates = def.templates
call s:LOG("s:Init: templates=". string(templates))
  let url_base_template = templates.url_base
  let regex_template = templates.regex
  let funcref_template = templates.funcref

  for key in keys
call s:LOG("s:Init: key=". key)
    let map = {}

    let url_base_op = substitute(url_base_template, "{key}", key, "g")
    if key =~# '^java.*'
      let url_base_op = substitute(url_base_op, "{version}", java_version, "g")
    elseif key =~# '^scala.*'
      let url_base_op = substitute(url_base_op, "{version}", scala_version, "g")
    else
      let url_base_op = substitute(url_base_op, "{version}", '', "g")
    endif

call s:LOG("s:Init: url_base_op=". url_base_op)
    let [found, url_base] = g:vimside.GetOption(url_base_op)
    if ! found
      call s:LOG("Option not found: 'url_base_op'")
      continue
    endif
    let map['url_base'] = url_base

    let regex_op = substitute(regex_template, "{key}", key, "g")
call s:LOG("s:Init: regex_op=". regex_op)
    let [found, regex] = g:vimside.GetOption(regex_op)
    if ! found
      throw "Option not found: '". regex_op ."'"
    endif
    let map['regex'] = regex

    let funcref_op = substitute(funcref_template, "{key}", key, "g")
call s:LOG("s:Init: funcref_op=". funcref_op)
    let [found, Funcref] = g:vimside.GetOption(funcref_op)
    if ! found
      throw "Option not found: '". funcref_op ."'"
    endif
    let map['funcref'] = Funcref

    let s:show_doc_map[key] = map
  endfor

endfunction

call s:Init()

function! vimside#command#show_doc_symbol_at_point#Run()
  let offset = vimside#util#GetCurrentOffset()
  let dic = {
        \ 'handler': {
        \ 'ok': function("vimside#command#show_doc_symbol_at_point#Handler_Ok")
        \ },
        \ 'args': {
        \   'offset': offset
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)
endfunction

function! vimside#command#show_doc_symbol_at_point#Handler_Ok(dic, ...)
  let dic = a:dic
call s:LOG("vimside#command#show_doc_symbol_at_point#Handler_Ok ". string(dic)) 
  call s:Process(dic)
  return 1
endfunction

function! s:Process(sym)
call s:LOG("s:Process ". string(a:sym)) 
  let sym = a:sym
  if vimside#util#IsDictionary(sym)
    if has_key(sym, ":type")
      let tpe = sym[':type']
    else
      " error
    endif
    if has_key(sym, ':owner-type-id')
      let owner_type_id = sym[':owner-type-id']
    endif
    if has_key(sym, ':is-callable')
      let is_callable = sym[':is-callable']
    endif
    let is_member = exists("is_callable") && exists("owner_type_id")
call s:LOG("s:Process is_member=". is_member) 

    if is_member
      call s:LaunchBrowserWithMemberInfo(owner_type_id, sym)
    else
      call s:LaunchBrowser(tpe)
    endif

  endif
endfunction

function! vimside#command#show_doc_symbol_at_point#TypeBuIdHandler_Ok(dic, ...)
  let dic = a:dic
call s:LOG("vimside#command#show_doc_symbol_at_point#TypeBuIdHandler_Ok dic=".  string(dic))

  let l:tpe = dic

  if a:0 == 1
call s:LOG("vimside#command#show_doc_symbol_at_point#TypeBuIdHandler_Ok a:1=".  string(a:1))
    call s:LaunchBrowser(tpe, a:1)
  else
    throw "Expected data vararg"
  endif

  return 1
endfunction

function! s:LaunchBrowserWithMemberInfo(owner_type_id, sym)
  let dic = {
        \ 'handler': {
        \ 'ok': function("vimside#command#show_doc_symbol_at_point#TypeBuIdHandler_Ok")
        \ },
        \ 'args': {
        \   'id': a:owner_type_id
        \ },
        \ 'data': a:sym
        \ }
  call vimside#swank#rpc#type_by_id#Run(dic)
endfunction

" type member_symbol
function! s:LaunchBrowser(tpe, ...)
  let [found, url] = (a:0 == 0) 
        \ ? vimside#command#show_doc_symbol_at_point#MakeUrl(tpe)
        \ : vimside#command#show_doc_symbol_at_point#MakeUrl(tpe, a:1)

  " If not found, then maybe its not a java/scala/android type
  if found
call s:LOG("s:LaunchBrowser found url=". url) 
    call vimside#browser#Open(url)
  endif
endfunction

function! vimside#command#show_doc_symbol_at_point#MakeUrl(tpe, ...)
  let tpe = a:tpe

  if has_key(tpe, ':arrow-type')
    let full_name = tpe[':name']
  else
    let full_name = tpe[':full-name']
  endif
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrl full_name=". full_name) 

  let found = 0
  let url = ""
  for key in keys(s:show_doc_map)
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrl key='". key ."'") 
    let map = s:show_doc_map[key]
    let re = map.regex
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrl re='". re ."'") 
    if full_name =~# re
      let url_base = map.url_base
      let Func_ref = map.funcref
call s:LOG("vimside#command#show_doc_symbol_at_point#MakeUrl url_base=". url_base) 
      if a:0 == 0
        let url = Func_ref(url_base, tpe)
      elseif a:0 == 1
        let url = Func_ref(url_base, tpe, a:1)
      else
        " error
      endif
      let found = 1
      break
    endif
  endfor
  return [found, url]
endfunction
