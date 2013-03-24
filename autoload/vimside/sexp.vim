
let s:log_file = getcwd() . "/SEXP_LOG"
let s:log_enabled = 1
function! s:log(msg) 
  if s:log_enabled
    execute "redir >> " . s:log_file
    silent echo a:msg
    execute "redir END"
  endif
endfunction

let g:SEXP_BOOLEAN_TYPE_VALUE = 0
let g:SEXP_INT_TYPE_VALUE = 1
let g:SEXP_STRING_TYPE_VALUE = 2
let g:SEXP_SYMBOL_TYPE_VALUE = 3
let g:SEXP_KEYWORD_TYPE_VALUE = 4
let g:SEXP_LIST_TYPE_VALUE = 5

let g:SEXP_BOOLEAN_TYPE_NAME = 'boolean' 
let g:SEXP_INT_TYPE_NAME = 'int' 
let g:SEXP_STRING_TYPE_NAME = 'string' 
let g:SEXP_SYMBOL_TYPE_NAME = 'symbol' 
let g:SEXP_KEYWORD_TYPE_NAME = 'keyward' 
let g:SEXP_LIST_TYPE_NAME = 'list' 

let g:SEXP_VALUE_TO_NAME = [
    \ g:SEXP_BOOLEAN_TYPE_NAME,
    \ g:SEXP_INT_TYPE_NAME,
    \ g:SEXP_STRING_TYPE_NAME,
    \ g:SEXP_SYMBOL_TYPE_NAME,
    \ g:SEXP_KEYWORD_TYPE_NAME,
    \ g:SEXP_LIST_TYPE_NAME,
    \ ]

let g:SEXP_NAME_TO_VALUE = {}
let g:SEXP_NAME_TO_VALUE[g:SEXP_BOOLEAN_TYPE_NAME] = g:SEXP_BOOLEAN_TYPE_VALUE
let g:SEXP_NAME_TO_VALUE[g:SEXP_INT_TYPE_NAME] = g:SEXP_INT_TYPE_VALUE
let g:SEXP_NAME_TO_VALUE[g:SEXP_STRING_TYPE_NAME] = g:SEXP_STRING_TYPE_VALUE
let g:SEXP_NAME_TO_VALUE[g:SEXP_SYMBOL_TYPE_NAME] = g:SEXP_SYMBOL_TYPE_VALUE
let g:SEXP_NAME_TO_VALUE[g:SEXP_KEYWORD_TYPE_NAME] = g:SEXP_KEYWORD_TYPE_VALUE
let g:SEXP_NAME_TO_VALUE[g:SEXP_LIST_TYPE_NAME] = g:SEXP_LIST_TYPE_VALUE


function! vimside#sexp#Make_Boolean(value)
  if type(a:value) == type(0)
  return { 
    \ 'sexp_type': g:SEXP_BOOLEAN_TYPE_VALUE,
    \ 'value': (a:value == 0) ? 0 : 1
    \ }
  else
    throw "ERROR: "
  endif
endfunction

function! vimside#sexp#Make_Int(value) 
  if type(a:value) == type(0)
    return { 
      \ 'sexp_type': g:SEXP_INT_TYPE_VALUE,
      \ 'value': a:value
      \ }
  else
    throw "ERROR: "
  endif
endfunction

function! vimside#sexp#Make_String(value) 
  if type(a:value) == type("")
    return { 
      \ 'sexp_type': g:SEXP_STRING_TYPE_VALUE,
      \ 'value': a:value
      \ }
  else
    throw "ERROR: "
  endif
endfunction

"  [a-zA-Z][a-zA-Z0-9-:]*
function! vimside#sexp#Make_Symbol(value) 
  if type(a:value) == type("") && a:value =~? '[a-zA-Z][a-zA-Z0-9-:]*'
    return { 
      \ 'sexp_type': g:SEXP_SYMBOL_TYPE_VALUE,
      \ 'value': a:value
      \ }
  else
    throw "ERROR: "
  endif
endfunction


" :[a-zA-Z][a-zA-Z0-9-:]*
function! vimside#sexp#Make_Keyword(value) 
  if type(a:value) == type("") && a:value =~? ':[a-zA-Z][a-zA-Z0-9-:]*'
    return { 
      \ 'sexp_type': g:SEXP_KEYWORD_TYPE_VALUE,
      \ 'value': a:value
      \ }
  else
    throw "ERROR: "
  endif
endfunction

function! vimside#sexp#Make_List(...) 
  if a:0 == 0 
    let children = []
  elseif a:0 == 1 && type(a:1) == type([])
    let children = a:1[:]
  else
    let children = a:000
  endif

  for child in children
    if type(child) != type({}) || ! has_key(child, "sexp_type")
      throw "ERROR: "
    endif
  endfor
  return { 
    \ 'sexp_type': g:SEXP_LIST_TYPE_VALUE,
    \ 'value': children
    \ }
endfunction

function! vimside#sexp#AddTo_List(list_sexp, ...) 
  if a:0 == 0 
    let children = []
  elseif a:0 == 1 && type(a:1) == type([])
    let children = a:1[:]
  else
    let children = a:000
  endif

  for child in children
    if type(child) != type({}) || ! has_key(child, "sexp_type")
      throw "ERROR: "
    endif
  endfor

  let existing_children = a:list_sexp['value']
  let a:list_sexp['value'] = existing_children + children
endfunction

" return [found value]
function! vimside#sexp#Get_BoolValue(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
          \ && a:sexp.sexp_type == g:SEXP_BOOLEAN_TYPE_VALUE
      return [1, a:sexp.value]
    else
      return [0, "Not a Bool SExp"]
    endif
  else
    return [0, "Not a SExp"]
  endif
endfunction

" return [found value]
function! vimside#sexp#Get_IntValue(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
          \ && a:sexp.sexp_type == g:SEXP_INT_TYPE_VALUE
      return [1, a:sexp.value]
    else
      return [0, "Not a Int SExp"]
    endif
  else
    return [0, "Not a SExp"]
  endif
endfunction

" return [found value]
function! vimside#sexp#Get_KeywordValue(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
          \ && a:sexp.sexp_type == g:SEXP_KEYWORD_TYPE_VALUE
      return [1, a:sexp.value]
    else
      return [0, "Not a Keyword SExp"]
    endif
  else
    return [0, "Not a SExp"]
  endif
endfunction

" return [found value]
function! vimside#sexp#Get_SymbolValue(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
          \ && a:sexp.sexp_type == g:SEXP_SYMBOL_TYPE_VALUE
      return [1, a:sexp.value]
    else
      return [0, "Not a Symbol SExp"]
    endif
  else
    return [0, "Not a SExp"]
  endif
endfunction

" return [found value]
function! vimside#sexp#Get_StringValue(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
          \ && a:sexp.sexp_type == g:SEXP_STRING_TYPE_VALUE
      return [1, a:sexp.value]
    else
      return [0, "Not a String SExp"]
    endif
  else
    return [0, "Not a SExp"]
  endif
endfunction

" return [found value]
function! vimside#sexp#Get_ListValue(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
          \ && a:sexp.sexp_type == g:SEXP_LIST_TYPE_VALUE
      return [1, a:sexp.value]
    else
      return [0, "Not a List SExp"]
    endif
  else
    return [0, "Not a SExp"]
  endif
endfunction


" Converts a Swank protocol keyword_sexp/value_sexp list into a Vim Dictionary
"   of the keyword and Vim value. If an sexp_value is a SExp List, then
"   it is also converted, recursing through SExp data strucuture.
" Note that this assumes that EACH of the SExp Lists are either
"  keyword/value pairs, a list of simple values or a list of lists.
"
" return [1 ,  kw_dic_value] or [1, list_of_value(s)]
" return [0 ,  reason]
function! vimside#sexp#Convert_KeywordValueList2Dictionary(sexp) 
  if type(a:sexp) == type({})
    if has_key(a:sexp, "sexp_type") 
      if a:sexp.sexp_type == g:SEXP_LIST_TYPE_VALUE
        let children = a:sexp.value
        let len = len(children)

        if len == 0
          return [1, []]
        else
          " Is first child a keyword, then its a Dictionary
          " else its a list of simple values or list of lists
          let child = children[0]
          if child.sexp_type == g:SEXP_KEYWORD_TYPE_VALUE

            let kw_dic = {}
            let cnt = 0
            while cnt < len
              let kw_sexp = children[cnt]
              let cnt += 1
              if kw_sexp.sexp_type != g:SEXP_KEYWORD_TYPE_VALUE
                return [0, "Not a Keyword SExp: " . kw]
              endif
              let kw = kw_sexp.value

              let value_sexp = children[cnt]
              let cnt += 1

              if value_sexp.sexp_type == g:SEXP_LIST_TYPE_VALUE
                let [ok, value] = vimside#sexp#Convert_KeywordValueList2Dictionary(value_sexp) 
                if ok
                  let kw_dic[kw] = value
                else
                  return [0, value]
                endif
              else
                let value = value_sexp.value
                let kw_dic[kw] = value
              endif
              unlet value

            endwhile

            return [1, kw_dic]

          else
            " its a list of simple values or list of lists
            let list = []

            let cnt = 0
            while cnt < len
              let value_sexp = children[cnt]
              let cnt += 1

              if value_sexp.sexp_type == g:SEXP_LIST_TYPE_VALUE
                let [ok, value] = vimside#sexp#Convert_KeywordValueList2Dictionary(value_sexp) 
                if ok
                  call add(list, value)
                else
                  return [0, value]
                endif
              else
                let value = value_sexp.value
                call add(list, value)
              endif
              unlet value

            endwhile

            return [1, list]

          endif
        endif
      elseif a:sexp.sexp_type == g:SEXP_BOOLEAN_TYPE_VALUE
        let value = a:sexp.value
        return [1, [value]]
      elseif a:sexp.sexp_type == g:SEXP_INT_TYPE_VALUE
        let value = a:sexp.value
        return [1, [value]]
      elseif a:sexp.sexp_type == g:SEXP_STRING_TYPE_VALUE
        let value = a:sexp.value
        return [1, [value]]
      else
        return [0, "Not a List, Int, Bool, String SExp"]
      endif
    else
      return [0, "Not a SExp"]
    endif
  else
    return [0, "Not a Dictionary"]
  endif
endfunction


"---------------------
" ToString
"---------------------
function! s:SExp_ToString_Boolean(sexp) 
  return a:sexp.value ? 't' : 'nil' 
endfunction
function! s:SExp_ToString_Int(sexp) 
  return "" . a:sexp.value 
endfunction
function! s:SExp_ToString_String(sexp) 
  return a:sexp.value 
endfunction
function! s:SExp_ToString_List(sexp) 
  let rval = "("
  let children = a:sexp.value
  let len = len(children)
  let cnt = 0
  while cnt < len
    if cnt > 0
      let rval .= " "
    endif
    let rval .= vimside#sexp#ToString(children[cnt])

    let cnt += 1
  endwhile
  let rval .= ")"
  return rval
endfunction

let g:SEXP_TO_STRING = [
    \ function("s:SExp_ToString_Boolean"),
    \ function("s:SExp_ToString_Int"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_List")
    \ ]

function! vimside#sexp#ToString(sexp) 
  if type(a:sexp) == type({}) && has_key(a:sexp, "sexp_type")
    return g:SEXP_TO_STRING[a:sexp.sexp_type](a:sexp)
  else
    throw "ERROR: Not an SExp: " . string(a:sexp)
  endif
endfunction

"---------------------
" ToReadableString
"---------------------

function! s:SExp_ToReadableString_String(sexp) 
  let rval = a:sexp.value
  let rval = substitute(rval, "\\", "\\\\", "g") 
  let rval = substitute(rval, "\"", "\\\"", "g") 
  return "\"" . rval . "\""
endfunction

function! s:SExp_ToReadableString_List(sexp) 
  let rval = "("
  let children = a:sexp.value
  let len = len(children)
  let cnt = 0
  while cnt < len
    if cnt > 0
      let rval .= " "
    endif
    let rval .= vimside#sexp#ToReadableString(children[cnt])

    let cnt += 1
  endwhile
  let rval .= ")"
  return rval
endfunction

let g:SEXP_TO_READABLE_STRING = [
    \ function("s:SExp_ToString_Boolean"),
    \ function("s:SExp_ToString_Int"),
    \ function("s:SExp_ToReadableString_String"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToReadableString_List")
    \ ]

function! vimside#sexp#ToReadableString(sexp) 
  if type(a:sexp) == type({}) && has_key(a:sexp, "sexp_type")
    return g:SEXP_TO_READABLE_STRING[a:sexp.sexp_type](a:sexp)
  else
    throw "ERROR: Not an SExp"
  endif
endfunction

"---------------------
" ToWireString
"---------------------

function! vimside#sexp#ToWireString(sexp) 
  if type(a:sexp) == type({}) && has_key(a:sexp, "sexp_type")
    return vimside#sexp#ToReadableString(a:sexp)
  else
    throw "ERROR: Not an SExp"
  endif
endfunction

"---------------------
" ToVim
"---------------------

function! s:SExp_ToVim_Boolean(sexp) 
  return a:sexp.value 
endfunction

function! s:SExp_ToVim_Int(sexp) 
  return a:sexp.value 
endfunction

let g:SEXP_TO_VIM = [
    \ function("s:SExp_ToVim_Boolean"),
    \ function("s:SExp_ToVim_Int"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_String"),
    \ function("s:SExp_ToString_List")
    \ ]

function! vimside#sexp#ToVim(sexp) 
  if type(a:sexp) == type({}) && has_key(a:sexp, "sexp_type")
    return g:SEXP_TO_VIM[a:sexp.sexp_type](a:sexp)
  else
    throw "ERROR: Not an SExp"
  endif
endfunction


"---------------------
" ToDebug
"---------------------

function! s:SExp_ToDebug_Boolean(sexp) 
  return (a:sexp.value) ? "TruthAtom: t"  : "NilAtom: nil"
endfunction

function! s:SExp_ToDebug_Int(sexp) 
  return "IntAtom: " a:sexp.value
endfunction

function! s:SExp_ToDebug_String(sexp) 
  return "StringAtom: " a:sexp.value
endfunction

function! s:SExp_ToDebug_Symbol(sexp) 
  return "SymbolAtom: " a:sexp.value
endfunction

function! s:SExp_ToDebug_Keyword(sexp) 
  return "KeywordAtom: " a:sexp.value
endfunction

function! s:SExp_ToDebug_List(sexp) 
  let rval = "SExpList: (" . "\n"
  let children = a:sexp.value
  let len = len(children)
  let cnt = 0
  while cnt < len
    if cnt > 0
      let rval .= " "
    endif
    let rval .= ToDebug(children[cnt])

    let cnt += 1
  endwhile
  let rval .= "\n"
  let rval .= ")"
  return rval
endfunction

let g:SEXP_TO_DEBUG = [
    \ function("s:SExp_ToDebug_Boolean"),
    \ function("s:SExp_ToDebug_Int"),
    \ function("s:SExp_ToDebug_String"),
    \ function("s:SExp_ToDebug_Symbol"),
    \ function("s:SExp_ToDebug_Keyword"),
    \ function("s:SExp_ToDebug_List")
    \ ]

function! vimside#sexp#ToDebug(sexp) 
  if type(a:sexp) == type({}) && has_key(a:sexp, "sexp_type")
    return g:SEXP_TO_DEBUG[a:sexp.sexp_type](a:sexp)
  else
    throw "ERROR: "
  endif
endfunction


"---------------------
" SExp List Functions
"---------------------

" let s:LOG = function("vimside#log#log")

" replaces toKeywordMap()
" returns [1, value]
" returns [0, "Key not found: " ]
function! vimside#sexp#ValueOfKey(sexplist, key) 
" call s:LOG("ValueOfKey key= ". string(a:key)) 

  if type(a:sexplist) == type({}) 
      \ && has_key(a:sexplist, "sexp_type")
      \ && a:sexplist.sexp_type == g:SEXP_LIST_TYPE_VALUE
      \ && type(a:key) == type("") 

    let children = a:sexplist.value
    let len = len(children)
    let cnt = 0
    while cnt < len
      let child = children[cnt]
      if child.sexp_type == g:SEXP_KEYWORD_TYPE_VALUE && child.value == a:key
        return [1, children[cnt+1].value]
      endif

      let cnt += 2
    endwhile
    return [0, "Key not found: " . a:key]
  else
    throw "ERROR: Bad sexplist=" . string(a:sexplist)
  endif
endfunction

" replaces toSymbolMap()
" returns [1, value]
" returns [0, "Key not found: " ]
function! vimside#sexp#VimValueOfKey(sexplist, key) 
  if type(a:sexplist) == type([]) 
      \ && has_key(a:sexplist, "sexp_type")
      \ && a:sexplist.sexp_type == g:SEXP_LIST_TYPE_VALUE
      \ && type(a:key) == type("") 

    let children = a:sexplist.value
    let len = len(children)
    let cnt = 0
    while cnt < len
      let child = children[cnt]
      if child.sexp_type == g:SEXP_KEYWORD_TYPE_VALUE && child.value == a:key
        return [1, ToVim(children[cnt+1])]
      endif

      let cnt += 2
    endwhile
    return [0, "Key not found: " . a:key]
  else
    throw "ERROR: Bad sexplist=" . string(a:sexplist)
  endif
endfunction




"---------------------
" Parser: WireToSExp
"---------------------
function! vimside#sexp#LoadFile(filepath)
  let ext = fnamemodify(a:filepath, ":e")
  if ext == "vim"
    return vimside#sexp#SourceFile(a:filepath)
  elseif ext == ""
    return vimside#sexp#ParseFile(a:filepath)
  else
  endif
endfunction

function! vimside#sexp#SourceFile(filepath)
" echo "SourceFile: filepath=" . a:filepath

  if ! filereadable(a:filepath)
      throw "Vimside Vim Ensime Config file can not be read: " . a:filepath
  endif
  if exists("g:ensime_config")
    let l:ec = g:ensime_config
    unlet g:ensime_config
  endif

  if exists("*g:Bool")
    let l:Bool_save = function("g:Bool")
  endif
  if exists("*g:Int")
    let l:Int_save = function("g:Int")
  endif
  if exists("*g:Str")
    let l:Str_save = function("g:Str")
  endif
  if exists("*g:Sym")
    let l:Sym_save = function("g:Sym")
  endif
  if exists("*g:Key")
    let l:Key_save = function("g:Key")
  endif
  if exists("*g:SExp")
    let l:SExp_save = function("g:SExp")
  endif

  try
    let g:Bool = function("vimside#sexp#Make_Boolean")
    let g:Int = function("vimside#sexp#Make_Int")
    let g:Str = function("vimside#sexp#Make_String")
    let g:Sym = function("vimside#sexp#Make_Symbol")
    let g:Key = function("vimside#sexp#Make_Keyword")
    let g:SExp = function("vimside#sexp#Make_List")
    execute ":source " . a:filepath

    if ! exists("g:ensime_config")
      throw "Vimside Vim Ensime Config file did not define g:ensime_config: " . a:filepath
    endif

    return g:ensime_config
  finally
    if exists("*l:Bool_save")
      let g:Bool = function("l:Bool_save")
    endif
    if exists("*l:Int_save")
      let g:Int = function("l:Int_save")
    endif
    if exists("*l:Str_save")
      let g:Str = function("l:Str_save")
    endif
    if exists("*l:Sym_save")
      let g:Sym = function("l:Sym_save")
    endif
    if exists("*l:Key_save")
      let g:Key = function("l:Key_save")
    endif
    if exists("*l:SExp_save")
      let g:SExp = function("l:SExp_save")
    endif

    if exists("l:ec")
      let g:ensime_config = l:ec
    endif
  endtry


endfunction

function! vimside#sexp#ParseFile(filepath)
  if ! filereadable(a:filepath)
    throw "Error: vimside#sexp#ParseFile file not readable: ". a:filepath
  endif

  let lines = readfile(a:filepath)
  let in = join(lines, "\n")

  return vimside#sexp#Parse(in)
endfunction


if 0 " XXXXX

function! vimside#sexp#Parse(in)
" call s:log("s:Parse: TOP in=". a:in)
  let slist = s:SubParse(a:in, 0, len(a:in))
"call s:log("s:Parse: len(slist)=".len(slist))
"call s:log("s:Parse: slist=".  vimside#sexp#ToString(slist))
"call s:log("s:Parse: BOTTOM")
" call s:log("s:Parse: slist=" . vimside#sexp#ToWireString(slist))
  return slist.value[0]
endfunction

function! s:SubParse(in, pos, len)
" call s:log("s:SubParse: TOP")
  let in = a:in
  let len = a:len
"call s:log("s:SubParse: len=".len)
  let pos = s:ConsumeWhiteSpace(in, a:pos, len)
"call s:log("s:SubParse: pos=".pos)

  let token_start = -1
  let sexps = []

  while pos < len
    let c = in[pos]
" call s:log("s:SubParse: pos=".pos)
" call s:log("s:SubParse: c=".c)
    if c == ';'
      " parse to end of file or endofline
      let end = s:ConsumeComment(in, pos+1, len)
      let pos = end
"call s:log("s:SubParse: after comment pos=".pos)
    elseif c == '('
      let [found, end] = s:FindMatchingParen(in, pos, len)
" call s:log("s:SubParse: found=".found)
      if found
" call s:log("s:SubParse: end=".end)
        let sexp = s:SubParse(in, pos+1, end)
        call add(sexps, sexp)
        let pos = end + 1
      else
        throw "ERROR: could not find matching paren pos=" . pos
      endif

    elseif c == '"'
      let [found, end] = s:FindMatchingDoubleQuote(in, pos+1, len)
      if found
        let sexp = vimside#sexp#Make_String(in[pos+1 : end-1])
        call add(sexps, sexp)
        let pos = end + 1
      else
        throw "ERROR: could not find matching double quote pos=" . pos
      endif
    elseif c == ' ' || c == "\n" || c == "\t"
" call s:log("s:SubParse: WS")
      if token_start != -1
        let token = in[token_start : pos-1]
        let sexp = s:MakeSExp(token)
        call add(sexps, sexp)
        let token_start = -1
      endif
      let pos += 1
    else
      if token_start == -1
        let token_start = pos
      endif
      let pos += 1

    endif

  endwhile

  if token_start != -1
    let token = in[token_start : pos-1]
    let sexp = s:MakeSExp(token)
    call add(sexps, sexp)
  endif

"call s:log("s:SubParse: BOTTOM")
  return vimside#sexp#Make_List(sexps) 
endfunction

function! s:MakeSExp(s)
  let s = a:s
" call s:log("s:MakeSExp: s=<".s.">")

  if s == 'nil'
    return vimside#sexp#Make_Boolean(0)
  elseif s == 't'
    return vimside#sexp#Make_Boolean(1)
  elseif s =~ '^-\?\d\+$'
    return vimside#sexp#Make_Int(0+s)
  elseif s =~ '^:[a-zA-Z][a-zA-Z0-9-_:]*$'
    return vimside#sexp#Make_Keyword(s)
  elseif s =~ '^[a-zA-Z][a-zA-Z0-9-:]*$'
    return vimside#sexp#Make_Symbol(s)
  elseif s[0] == "'" && s[1:] =~ '^[a-zA-Z][a-zA-Z0-9-:]*$'
    return vimside#sexp#Make_Symbol(s[1:])
  else
    throw "Error: s:MakeSExp: <" .s. ">"
  endif

endfunction

" return pos just after end of comment
function! s:ConsumeComment(in, pos, len)
  let in = a:in
  let pos = a:pos
  let len = a:len

  while pos < len
    let c = in[pos]
    let pos += 1

    if c == "\n"
      break
    endif
  endwhile

  return pos
endfunction

" return [1, pos] or [0, _]
function! s:FindMatchingParen(in, pos, len)
  let in = a:in
  let pos = a:pos
  let len = a:len

  let in_double_quote = 0
  let paren_depth = 0

  while pos < len
    let c = in[pos]
" call s:log("s:FindMatchingParen: pos=".pos)
" call s:log("s:FindMatchingParen: c=".c)
    if c == '"'
      let in_double_quote = in_double_quote ? 0 : 1
    elseif c == "\\"
      " skip next character
      let pos += 1
    elseif ! in_double_quote && c == '('
      let paren_depth += 1
    elseif ! in_double_quote && c == ')'
      let paren_depth -= 1
      if paren_depth == 0
        return [1, pos]
      endif
    endif

    let pos += 1
  endwhile

  return [0, -1]
endfunction

" return [1, pos] or [0, _]
function! s:FindMatchingDoubleQuote(in, pos, len)
  let in = a:in
  let pos = a:pos
  let len = a:len

  while pos < len
    let c = in[pos]
    if c == '"'
      return [1, pos]
    elseif c == "\\"
      " skip next character
      let pos += 1
    endif

    let pos += 1
  endwhile

  return [0, -1]
endfunction

function! s:ConsumeWhiteSpace(in, pos, len)
  let in = a:in
  let pos = a:pos
  let len = a:len
  while pos < len 
    let c = in[pos]
    if c =~ '\s'
      " FIX
    elseif c == ';'
      let pos += 1
      while pos < len 
        let c = in[pos]
        if c == "\n"
          break
        endif

        let pos += 1
      endwhile
    else
      break
    endif

    let pos += 1
  endwhile

  return pos
endfunction

endif " 0 XXXXX

function! vimside#sexp#Parse(in)
" echo "Parse TOP in=". a:in
  let slist = s:SubParser(a:in)
" echo "Parse MID slist=". string(slist)
  return slist.value[0]
endfunction

" return
function! s:SubParser(in)
  let in = a:in
  let len = len(in)
  let pos = 0
" echo "s:SubParser TOP in=". in

  let sexps = []
  let token_start = -1

  while pos < len
    let c = in[pos]

    if c == ' ' || c == "\n" || c == "\t"
      " whitespace
      if token_start != -1
        let token = in[token_start : pos-1]
        let sexp = s:MakeSExp(token)
        call add(sexps, sexp)
        let token_start = -1
      endif

    elseif c == ';'
      " consume commnet
      let pos += 1
      while pos < len && in[pos] != "\n"
        let pos += 1
      endwhile

    elseif c == '"'
      " its a string
      let end = s:FindMatchingDoubleQuote(in, pos+1, len)
      let sexp = vimside#sexp#Make_String(in[pos+1 : end-1])
      call add(sexps, sexp)
      let pos = end + 1

    elseif c == '('
      " parse the list
      let [sexp, end] = s:ParseList(in, pos+1, len)
" echo "s:SubParser list sexp=". string(sexp)
      call add(sexps, sexp)
      let pos = end + 1

    elseif token_start == -1
      " its a token
      let token_start = pos

    endif

    let pos += 1
  endwhile

  if token_start != -1
    let token = in[token_start : pos-1]
    let sexp = s:MakeSExp(token)
    call add(sexps, sexp)
  endif

" echo "s:SubParser BOTTOM sexps=". string(sexps)
  return vimside#sexp#Make_List(sexps[0])
endfunction

" return [sexp_list, end] 
function! s:ParseList(in, pos, len)
  let in = a:in
  let pos = a:pos
  let len = a:len
" echo "s:ParseList TOP in=". in[pos :]

  let sexps = []
  let token_start = -1

  while pos < len
    let c = in[pos]

    if c == ' ' || c == "\n" || c == "\t"
      " whitespace
      if token_start != -1
        let token = in[token_start : pos-1]
        let sexp = s:MakeSExp(token)
" echo "s:ParseList token sexp=". string(sexp)
        call add(sexps, sexp)
        let token_start = -1
      endif

    elseif c == ';'
      " consume commnet
      let pos += 1
      while pos < len && in[pos] != "\n"
        let pos += 1
      endwhile

    elseif c == '"'
      " its a string
      let end = s:FindMatchingDoubleQuote(in, pos+1, len)
      let sexp = vimside#sexp#Make_String(in[pos+1 : end-1])
      call add(sexps, sexp)
      let pos = end

    elseif c == '('
      " parse the list
      let [sexp, end] = s:ParseList(in, pos+1, len)
" echo "s:ParseList list sexp=". string(sexp)
      call add(sexps, sexp)
      let pos = end

    elseif c == ')'
      if token_start != -1
        let token = in[token_start : pos-1]
        let sexp = s:MakeSExp(token)
" echo "s:ParseList token sexp=". string(sexp)
        call add(sexps, sexp)
      endif
      return [vimside#sexp#Make_List(sexps), pos]

    elseif token_start == -1
      " its a token
      let token_start = pos

    endif

    let pos += 1
  endwhile

  throw "ERROR: could not find matching list ')' pos=" . pos

endfunction


" return pos
function! s:FindMatchingDoubleQuote(in, pos, len)
  let in = a:in
  let pos = a:pos
  let len = a:len

  while pos < len
    let c = in[pos]
    if c == '"'
      return pos
    elseif c == "\\"
      " skip next character
      let pos += 1
    endif

    let pos += 1
  endwhile

  throw "ERROR: could not find matching double quote pos=" . pos

endfunction

function! s:MakeSExp(s)
  let s = a:s
  if s == 'nil'
    return { 'sexp_type': g:SEXP_BOOLEAN_TYPE_VALUE, 'value': 0 }
  elseif s == 't'
    return { 'sexp_type': g:SEXP_BOOLEAN_TYPE_VALUE, 'value': 1 }

  elseif s =~ '^-\?\d\+$'
    return { 'sexp_type': g:SEXP_INT_TYPE_VALUE, 'value': 0+s }

  elseif s =~ '^:[a-zA-Z][a-zA-Z0-9-_:]*$'
    return { 'sexp_type': g:SEXP_KEYWORD_TYPE_VALUE, 'value': s }

  elseif s =~ '^[a-zA-Z][a-zA-Z0-9-:]*$'
    return { 'sexp_type': g:SEXP_SYMBOL_TYPE_VALUE, 'value': s }

  elseif s[0] == "'" 
    let sym = s[1:]
    if sym =~ '^[a-zA-Z][a-zA-Z0-9-:]*$'
      return { 'sexp_type': g:SEXP_SYMBOL_TYPE_VALUE, 'value': sym }
    endif
  endif

  throw "Error: s:MakeSExp: <" .s. ">"

endfunction

