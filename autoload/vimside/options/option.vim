" ============================================================================
" vimside#options#option.vim
"
" File:          vimside#options#option.vim
" Summary:       Options for Vimside
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2013
"
" ============================================================================
" Intro: {{{1




function! vimside#options#option#Load()
  " called just to make sure global variables are loaded
endfunction

" types
let g:OPTION_BOOLEAN_TYPE             = type(0)
let g:OPTION_NUMBER_TYPE              = type(0)
let g:OPTION_STRING_TYPE              = type('')
let g:OPTION_FLOAT_TYPE               = type(1.0)
let g:OPTION_LIST_TYPE                = type([])
let g:OPTION_DICTIONARY_TYPE          = type({})
let g:OPTION_LIST_OR_STRING_TYPE      = 10
let g:OPTION_BOOLEAN_OR_NUMBER_TYPE   = 11


" kinds
let g:OPTION_UNKNOWN_KIND                       = 0
let g:OPTION_FILE_NAME_KIND                     = 1
let g:OPTION_FILE_PATH_KIND                     = 2
let g:OPTION_DIR_PATH_KIND                      = 3
let g:OPTION_DIR_NAME_KIND                      = 4
let g:OPTION_HOST_NAME_KIND                     = 5
let g:OPTION_POSITIVE_NUMBER_KIND               = 6
let g:OPTION_ENUM_KIND                          = 7
let g:OPTION_FUNCTION_KIND                      = 8
let g:OPTION_TIME_KIND                          = 9
let g:OPTION_CHAR_COUNT_KIND                    = 10
let g:OPTION_COLOR_KIND                         = 11
let g:OPTION_URL_KIND                           = 12
let g:OPTION_KEY_KIND                           = 13
let g:OPTION_CMD_KIND                           = 14
let g:OPTION_HIGHLIGHT_KIND                     = 15
let g:OPTION_GROUP_NAME_KIND                    = 16
let g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND       = 17


" scope
let g:OPTION_STATIC_SCOPE  = 0 " default
let g:OPTION_DYNAMIC_SCOPE = 1

function! vimside#options#option#GetTypeName(type)
  if a:type == g:OPTION_BOOLEAN_TYPE
    return 'Boolean'
  elseif a:type == g:OPTION_NUMBER_TYPE
    return 'Number'
  elseif a:type == g:OPTION_STRING_TYPE
    return 'String'
  elseif a:type == g:OPTION_FLOAT_TYPE
    return 'Float'
  elseif a:type == g:OPTION_LIST_TYPE
    return 'List'
  elseif a:type == g:OPTION_DICTIONARY_TYPE
    return 'Dictionary'
  elseif a:type == g:OPTION_LIST_OR_STRING_TYPE
    return 'ListOrString'
  elseif a:type == g:OPTION_BOOLEAN_OR_NUMBER_TYPE
    return 'BooleanOrNumber'
  else
    return 'Unknown Type'
  endif
endfunction


function! vimside#options#option#GetTypeName(type)
  if a:type == g:OPTION_BOOLEAN_TYPE
    return 'Boolean'
  elseif a:type == g:OPTION_NUMBER_TYPE
    return 'Number'
  elseif a:type == g:OPTION_STRING_TYPE
    return 'String'
  elseif a:type == g:OPTION_FLOAT_TYPE
    return 'Float'
  elseif a:type == g:OPTION_LIST_TYPE
    return 'List'
  elseif a:type == g:OPTION_DICTIONARY_TYPE
    return 'Dictionary'
  elseif a:type == g:OPTION_LIST_OR_STRING_TYPE
    return 'ListOrString'
  elseif a:type == g:OPTION_BOOLEAN_OR_NUMBER_TYPE
    return 'BooleanOrNumber'
  else
    return 'Unknown Type'
  endif
endfunction

function! vimside#options#option#GetKindName(kind)
  if a:kind == g:OPTION_UNKNOWN_KIND
    return 'Unknown Kind'
  elseif a:kind == g:OPTION_FILE_NAME_KIND
    return 'File Name'
  elseif a:kind == g:OPTION_FILE_PATH_KIND
    return 'File Path'
  elseif a:kind == g:OPTION_DIR_PATH_KIND
    return 'Directory Path'
  elseif a:kind == g:OPTION_DIR_NAME_KIND
    return 'Directory Name'
  elseif a:kind == g:OPTION_HOST_NAME_KIND
    return 'Host Name'
  elseif a:kind == g:OPTION_POSITIVE_NUMBER_KIND
    return 'Positive Number'
  elseif a:kind == g:OPTION_ENUM_KIND
    return 'Enum'
  elseif a:kind == g:OPTION_FUNCTION_KIND
    return 'Function'
  elseif a:kind == g:OPTION_TIME_KIND
    return 'Time'
  elseif a:kind == g:OPTION_CHAR_COUNT_KIND
    return 'Character Count'
  elseif a:kind == g:OPTION_COLOR_KIND
    return 'Color'
  elseif a:kind == g:OPTION_URL_KIND
    return 'URL'
  elseif a:kind == g:OPTION_KEY_KIND
    return 'Key'
  elseif a:kind == g:OPTION_CMD_KIND
    return 'Cmd'
  elseif a:kind == g:OPTION_HIGHLIGHT_KIND
    return 'Highlight'
  elseif a:kind == g:OPTION_GROUP_NAME_KIND
    return 'GroupName'
  elseif a:kind == g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND
    return 'HighlightOrGroupName'
  else
    return 'Unknown Kind'
  endif
endfunction

function! vimside#options#option#GetScopeName(scope)
  if a:scope == g:OPTION_STATIC_SCOPE
    return 'Static'
  elseif a:scope == g:OPTION_DYNAMIC_SCOPE
    return 'Dynamic'
  else
    return 'Unknown Scope'
  endif
endfunction

"
" 'type'        mandatory 
"                  The type of the Vim object
" 'kind'        optional  
"                  Used to determine what additional validation checks
"                  might be used.
" 'scope'       mandatory 
" 'parent'      optional 
" 'description' mandatory
"                  Used by the Option Form to help user understand the 
"                  purpose of the option.
"


function! vimside#options#option#CheckValue(key, def, value, errors)
  let l:value_type = type(a:value)
  let l:def_type = vimside#options#option#GetType(a:def)

  if l:def_type == g:OPTION_LIST_OR_STRING_TYPE
    if l:value_type != g:OPTION_STRING_TYPE && l:value_type != g:OPTION_LIST_TYPE
      call add(a:errors, "Option '". a:key ."' not String/List type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_BOOLEAN_OR_NUMBER_TYPE
    if l:value_type != g:OPTION_BOOLEAN_TYPE && l:value_type != g:OPTION_NUMBER_TYPE
      call add(a:errors, "Option '". a:key ."' not Bool/Int type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_BOOLEAN_TYPE
    if l:value_type != g:OPTION_BOOLEAN_TYPE && l:value_type != g:OPTION_NUMBER_TYPE
      call add(a:errors, "Option '". a:key ."' not Bool/Int type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_NUMBER_TYPE
    if l:value_type != g:OPTION_BOOLEAN_TYPE && l:value_type != g:OPTION_NUMBER_TYPE
      call add(a:errors, "Option '". a:key ."' not Bool/Int type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_STRING_TYPE
    if l:value_type != g:OPTION_STRING_TYPE 
      call add(a:errors, "Option '". a:key ."' not String type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_FLOAT_TYPE
    if l:value_type != g:OPTION_FLOAT_TYPE 
      call add(a:errors, "Option '". a:key ."' not Float type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_LIST_TYPE
    if l:value_type != g:OPTION_LIST_TYPE 
      call add(a:errors, "Option '". a:key ."' not List type: '". string(a:value) ."'")
      return
    endif

  elseif l:def_type == g:OPTION_DICTIONARY_TYPE
    if l:value_type != g:OPTION_DICTIONARY_TYPE 
      call add(a:errors, "Option '". a:key ."' not Dictionary type: '". string(a:value) ."'")
      return
    endif

  else
    call add(a:errors, "Option '". a:key ."' unknown type: '". string(a:value) ."'")
    return
  endif

if 0 " REMOVE Issue 19
  " first check type
  if type(a:value) != l:def_type
    " change Issue 19
    if l:def_type == g:OPTION_BOOLEAN_TYPE || l:def_type == g:OPTION_NUMBER_TYPE
      call add(a:errors, "Option '". a:key ."' not Bool/Int type: '". string(a:value) ."'")
    elseif l:def_type == g:OPTION_STRING_TYPE
      call add(a:errors, "Option '". a:key ."' not String type: '". string(a:value) ."'")
    elseif l:def_type == g:OPTION_FLOAT_TYPE
      call add(a:errors, "Option '". a:key ."' not Float type: '". string(a:value) ."'")
    elseif l:def_type == g:OPTION_LIST_TYPE
      call add(a:errors, "Option '". a:key ."' not List type: '". string(a:value) ."'")
    elseif l:def_type == g:OPTION_DICTIONARY_TYPE
      call add(a:errors, "Option '". a:key ."' not Directory type: '". string(a:value) ."'")
    else
      call add(a:errors, "Option '". a:key ."' has bad type: '". l:def_type ."'")
    endif
  endif
endif " REMOVE Issue 19

if 0 " remove Issue 19
    if l:def_type == g:OPTION_BOOLEAN_TYPE
      if a:value != 0 && a:value != 1
        call add(errors, "Option '". a:key ."' has bad Bool a:value: '". string(a:value) ."'")
      endif
    endif
endif " remove Issue 19

  let [l:found, l:kind] = vimside#options#option#GetKind(a:def)
  if l:found
    if l:kind == g:OPTION_FILE_NAME_KIND
      call s:CheckFileNameKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_FILE_PATH_KIND 
      call s:CheckFilePathKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_DIR_PATH_KIND
      call s:CheckDirectoryPathKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_DIR_NAME_KIND
      call s:CheckDirectoryNameKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_HOST_NAME_KIND
      call s:CheckHostNameKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_POSITIVE_NUMBER_KIND
      call s:CheckPositiveKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_ENUM_KIND
      call s:CheckEnumKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_FUNCTION_KIND
      call s:CheckFunctionKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_TIME_KIND
      call s:CheckTimeKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_CHAR_COUNT_KIND
      call s:CheckCharCountKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_COLOR_KIND
      call s:CheckColorKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_URL_KIND
      call s:CheckUrlKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_KEY_KIND
      call s:CheckKeyKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_CMD_KIND
      call s:CheckCmdKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_HIGHLIGHT_KIND
      call s:CheckHighlightKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_GROUP_NAME_KIND
      call s:CheckGroupNameKind(a:key, a:def, a:value, a:errors)
    elseif l:kind == g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND
      call s:CheckHiglightOrGroupNameKind(a:key, a:def, a:value, a:errors)
    else
      call add(a:errors, "Option '". a:key ."' unknown kind: '". string(l:kind) ."'")
    endif
  endif

endfunction

function! s:CheckFileNameKind(key, def, value, errors)
  " TODO what is a valid file name
endfunction

function! s:CheckFilePathKind(key, def, value, errors)
  if ! filereadable(a:value)
    call add(a:errors, "Option '". a:key ."' is not a readable file: '". a:value ."'")
  endif
endfunction

function! s:CheckDirectoryPathKind(key, def, value, errors)
  if ! isdirectory(a:value)
    call add(a:errors, "Option '". a:key ."' is not directory: '". a:value ."'")
  endif

endfunction

function! s:CheckDirectoryNameKind(key, def, value, errors)
  " TODO what is a valid directory name
endfunction

function! s:CheckHostNameKind(key, def, value, errors)
  " TODO what is a valid host name
endfunction

function! s:CheckPositiveKind(key, def, value, errors)
  if a:value <= 0
    call add(a:errors, "Option '". a:key ."' is not positive Int: '". a:value ."'")
  endif
endfunction

function! s:CheckEnumKind(key, def, value, errors)
  if has_key(a:def, 'enum')
    let enums = a:def.enum
    for e in enums
      if a:value =~ e
        return
      endif
    endfor
    call add(a:errors, "Option '". a:key ."' has bad enum value: '". a:value ."', allowed values: '" . string(enums) . "'")
  else
    call add(a:errors, "Option Def '". a:key ."' of kind: Enum has no 'enum' key/value pair")
  endif
endfunction

function! s:CheckFunctionKind(key, def, value, errors)
endfunction

function! s:CheckTimeKind(key, def, value, errors)
  if a:value < 0
    call add(a:errors, "Option Def '". a:key ."' of kind: Time '". a:value ."' is less than 0")
  endif
endfunction

function! s:CheckCharCountKind(key, def, value, errors)
  if a:value < 0
    call add(a:errors, "Option Def '". a:key ."' of kind: CharCount '". a:value ."' is less than 0")
  endif
endfunction

function! s:CheckColorKind(key, def, value, errors)
  if  g:vimside.plugins.forms
    if forms#color#util#ConvertName_2_RGB(value) == ''
      try
        call forms#color#util#ParseRGB(value)
      catch  /.*/
        call add(a:errors, "Option Def '". a:key ."' of kind: Color '". a:value ."' unknown color")
      endtry
    endif
  else
    " TODO How to check color value without forms library ?
  endif
endfunction

function! s:CheckUrlKind(key, def, value, errors)
  " TODO How to check a valid URL?
endfunction

function! s:CheckKeyKind(key, def, value, errors)
  " TODO How to check a valid KeyL?
endfunction

function! s:CheckCmdKind(key, def, value, errors)
  " TODO How to check a valid KeyL?
endfunction
function! s:CheckHighlightKind(key, def, value, errors)
  " TODO How to check that value are highlight arg pairs
  let [ok, a:dic] = vimside#color#util#ParseHighlight(value)
  if ! ok
    call add(a:errors, "Option Def '". a:key ."' of kind: Highlight '". a:value ."' ". dic)
  else
    let l:errorstr = vimside#color#util#AdjustHighlightArgs(a:dic)
    if l:errorstr != ""
      call add(a:errors, "Option Def '". a:key ."' of kind: Highlight '". a:value ."' ". l:errorstr)
    endif
  endif

endfunction
function! s:CheckGroupNameKind(key, def, value, errors)
  if ! hlexists(a:value)
    call add(a:errors, "Option Def '". a:key ."' of kind: GroupName '". a:value ."' unknown group")
  endif
endfunction

function! s:CheckHiglightOrGroupNameKind(key, def, value, errors)
  if ! hlexists(a:value)
    call s:CheckHighlightKind(a:key, a:def, a:value a:errors)
  endif
endfunction










" Option Accessors
" type
function! vimside#options#option#GetType(def)
  if has_key(a:def, 'type')
    return a:def.type
  elseif has_key(a:def, 'parent')
    return vimside#options#option#GetType(def.parent)
  else
    throw "Option Definition with no type: ". string(a:def)
  endif
endfunction

" Option Accessors
" kind
" return [0, -] or [1, kind]
function! vimside#options#option#GetKind(def)
  if has_key(a:def, 'kind')
    return [1, a:def.kind]
  elseif has_key(a:def, 'parent')
    return vimside#options#option#GetKind(a:def.parent)
  else
    return [0, "Option has not Kind"]
  endif
endfunction

" scope
function! vimside#options#option#GetScope(def)
  if has_key(a:def, 'scope')
    return a:def.scope
  elseif has_key(a:def, 'parent')
    return vimside#options#option#GetScope(def.parent)
  else
    throw "Option Definition with no scope: ". string(a:def)
  endif
endfunction

" description
function! vimside#options#option#GetDescription(def)
  if has_key(a:def, 'description')
    return a:def.description
  elseif has_key(a:def, 'parent')
    return vimside#options#option#GetDescription(def.parent)
  else
    throw "Option Definition with no description: ". string(a:def)
  endif
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
