
" types
let g:OPTION_BOOLEAN_TYPE    = type(0)
let g:OPTION_NUMBER_TYPE     = type(0)
let g:OPTION_STRING_TYPE     = type('')
let g:OPTION_FLOAT_TYPE      = type(1.0)
let g:OPTION_LIST_TYPE       = type([])
let g:OPTION_DICTIONARY_TYPE = type({})

function! vimside#options#defined#GetTypeName(type)
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
  else
    return 'Unknown Type'
  endif
endfunction

" kinds
let g:OPTION_UNKNOWN_KIND         = 0
let g:OPTION_FILE_NAME_KIND       = 1
let g:OPTION_FILE_PATH_KIND       = 2
let g:OPTION_DIR_PATH_KIND        = 3
let g:OPTION_DIR_NAME_KIND        = 4
let g:OPTION_HOST_NAME_KIND       = 5
let g:OPTION_POSITIVE_NUMBER_KIND = 6
let g:OPTION_ENUM_KIND            = 7
let g:OPTION_FUNCTION_KIND        = 8
let g:OPTION_TIME_KIND            = 9
let g:OPTION_CHAR_COUNT_KIND      = 10
let g:OPTION_COLOR_KIND           = 11
let g:OPTION_URL_KIND             = 12
let g:OPTION_KEY_KIND             = 13

function! vimside#options#defined#GetKindName(kind)
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
  else
    return 'Unknown Kind'
  endif
endfunction

" scope
let g:OPTION_STATIC_SCOPE  = 0 " default
let g:OPTION_DYNAMIC_SCOPE = 1

function! vimside#options#defined#GetScopeName(scope)
  if a:scope == g:OPTION_STATIC_SCOPE
    return 'Static'
  elseif a:scope == g:OPTION_DYNAMIC_SCOPE
    return 'Dynamic'
  else
    return 'Unknown Scope'
  endif
endfunction


"
" 'name'        mandatory
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


function! vimside#options#defined#CheckValue(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  " first check type
  if type(value) != def.type
    " change Issue 19
    if def.type == g:OPTION_BOOLEAN_TYPE || def.type == g:OPTION_NUMBER_TYPE
      call add(errors, "Option '". def.name ."' not Bool/Int type: '". string(value) ."'")
    elseif def.type == g:OPTION_STRING_TYPE
      call add(errors, "Option '". def.name ."' not String type: '". string(value) ."'")
    elseif def.type == g:OPTION_FLOAT_TYPE
      call add(errors, "Option '". def.name ."' not Float type: '". string(value) ."'")
    elseif def.type == g:OPTION_LIST_TYPE
      call add(errors, "Option '". def.name ."' not List type: '". string(value) ."'")
    elseif def.type == g:OPTION_DICTIONARY_TYPE
      call add(errors, "Option '". def.name ."' not Directory type: '". string(value) ."'")
    else
      call add(errors, "Option '". def.name ."' has bad type: '". def.type ."'")
    endif
  else

if 0 " remove Issue 19
    if def.type == g:OPTION_BOOLEAN_TYPE
      if value != 0 && value != 1
        call add(errors, "Option '". def.name ."' has bad Bool value: '". string(value) ."'")
      endif
    endif
endif " remove Issue 19

    if has_key(def, "kind")
      if def.kind == g:OPTION_FILE_NAME_KIND
        call s:CheckFileNameKind(def, value, errors)
      elseif def.kind == g:OPTION_FILE_PATH_KIND 
        call s:CheckFilePathKind(def, value, errors)
      elseif def.kind == g:OPTION_DIR_PATH_KIND
        call s:CheckDirectoryPathKind(def, value, errors)
      elseif def.kind == g:OPTION_DIR_NAME_KIND
        call s:CheckDirectoryNameKind(def, value, errors)
      elseif def.kind == g:OPTION_HOST_NAME_KIND
        call s:CheckHostNameKind(def, value, errors)
      elseif def.kind == g:OPTION_POSITIVE_NUMBER_KIND
        call s:CheckPositiveKind(def, value, errors)
      elseif def.kind == g:OPTION_ENUM_KIND
        call s:CheckEnumKind(def, value, errors)
      elseif def.kind == g:OPTION_FUNCTION_KIND
        call s:CheckFunctionKind(def, value, errors)
      elseif def.kind == g:OPTION_TIME_KIND
        call s:CheckTimeKind(def, value, errors)
      elseif def.kind == g:OPTION_CHAR_COUNT_KIND
        call s:CheckCharCountKind(def, value, errors)
      elseif def.kind == g:OPTION_COLOR_KIND
        call s:CheckColorKind(def, value, errors)
      elseif def.kind == g:OPTION_URL_KIND
        call s:CheckUrlKind(def, value, errors)
      elseif def.kind == g:OPTION_KEY_KIND
        call s:CheckKeyKind(def, value, errors)
      else
        call add(errors, "Option '". def.name ."' unknown kind: '". string(def.kind) ."'")
      endif
    endif
  endif

endfunction

function! s:CheckFileNameKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  " TODO what is a valid file name
endfunction

function! s:CheckFilePathKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if ! filereadable(value)
    call add(errors, "Option '". def.name ."' is not a readable file: '" .value ."'")
  endif
endfunction

function! s:CheckDirectoryPathKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if ! isdirectory(value)
    call add(errors, "Option '". def.name ."' is not directory: '" .value ."'")
  endif

endfunction

function! s:CheckDirectoryNameKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  " TODO what is a valid directory name
  
endfunction

function! s:CheckHostNameKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  " TODO what is a valid host name

endfunction

function! s:CheckPositiveKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if a:value <= 0
    call add(errors, "Option '". def.name ."' is not positive Int: '" .value ."'")
  endif
endfunction

function! s:CheckEnumKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if has_key(def, 'enum')
    let enums = def.enum
    for e in enums
      if e == value
        return
      endif
    endfor
    call add(errors, "Option '". def.name ."' has bad enum value: '" .value ."', allowed values: '" . string(enums) . "'")
  else
    call add(errors, "Option Def '". def.name ."' of kind: Enum has no 'enum' key/value pair")
  endif
endfunction

function! s:CheckFunctionKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors
endfunction

function! s:CheckTimeKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if value < 0
    call add(errors, "Option Def '". def.name ."' of kind: Time '". value ."' is less than 0")
  endif
endfunction

function! s:CheckCharCountKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if value < 0
    call add(errors, "Option Def '". def.name ."' of kind: CharCount '". value ."' is less than 0")
  endif
endfunction

function! s:CheckColorKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

  if  g:vimside.plugins.forms
    if forms#color#util#ConvertName_2_RGB(value) == ''
      try
        call forms#color#util#ParseRGB(value)
      catch  /.*/
        call add(errors, "Option Def '". def.name ."' of kind: Color '". value ."' unknown color")
      endtry
    endif
  else
    " TODO How to check color value without forms library ?
  endif
endfunction

function! s:CheckUrlKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors
  " TODO How to check a valid URL?
endfunction

function! s:CheckKeyKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors
  " TODO How to check a valid KeyL?
endfunction


function! s:MakeOptions()
  let l:options = {}

  " supported java and scala versions
  let l:options['vimside-java-version'] = {
        \ 'name': 'vimside-java-version', 
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['1.5', '1.6', '1.7'],
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Supported Java versions.'
        \ ]
      \ }
  let l:options['vimside-scala-version'] = {
        \ 'name': 'vimside-scala-version', 
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['2.9.2', '2.10.0', '2.10.1'],
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Supported Scala versions.'
        \ ]
      \ }

  let l:options['vimside-project-options--enabled'] = {
        \ 'name': 'vimside-project-options--enabled', 
        \ 'type': g:OPTION_BOOLEAN_TYPE,
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Load a project-local user options file.'
        \ ]
      \ }
  let l:options['vimside-project-options-file-name'] = {
        \ 'name': 'vimside-project-options-file-name', 
        \ 'type': g:OPTION_STRING_TYPE,
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'File name of a project-local options file.'
        \ ]
      \ }

  let l:options['vimside-log-enabled'] = {
        \ 'name': 'vimside-log-enabled', 
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Used to enable/disable Vimside logging.'
        \ ]
      \ }
  let l:options['vimside-log-file-path'] = {
        \ 'name': 'vimside-log-file-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Full path name of Vimside Log File.',
            \ 'Both the parent Directory and File must be writeable.',
            \ 'If not set, then either the Ensime Config File Directory is.',
            \ 'is used or the Current Working Directory (CWD). The CWD is',
            \ 'used if "use_cwd_as_default_output_dir" to true (1).'
          \ ]
      \ }
  let l:options['vimside-log-file-name'] = {
        \ 'name': 'vimside-log-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'File name of Vimside Log File.',
            \ 'If "vimside_log_file_path" is set, then this option',
            \ 'is ignored.'
          \ ]
      \ }
  let l:options['vimside-log-file-use-pid'] = {
        \ 'name': 'vimside-log-file-use-pid',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'The Vim log file has the current process id (pid) as a prefix.'
          \ ]
      \ }
  let l:options['vimside-port-file-wait-time'] = {
        \ 'name': 'vimside-port-file-wait-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "How long to wait after starting the Ensime Server before",
            \ "attempting to read the file containing the port number."
          \ ]
      \ }

  let l:options['vimside-use-cwd-as-output-dir'] = {
        \ 'name': 'vimside-use-cwd-as-output-dir',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'If the option "vimside_log_file_path", then if true (1),',
            \ 'the Current Working Directory is used and if false (0), then',
            \ 'the Directory containing the Ensime Config File is used.'
          \ ]
      \ }
  let l:options['ensime-config-file-name'] = {
        \ 'name': 'ensime-config-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'The name of the Ensime Config File.',
            \ 'Generally, the name will be: "\.ensime", "_ensime", or',
            \ '"ensime_config.vim". The first two names will have SExp ',
            \ 'definitions of the Ensime configuration while the last',
            \ 'name will contain a Vim script definition of the Ensime',
            \ 'configuration.'
          \ ]
      \ }
  let l:options['ensime-install-path'] = {
        \ 'name': 'ensime-install-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Directory where Ensime is installed.',
            \ 'Vimside provides default values, assuming VAM is used, of: ',
            \ '$HOME . "/vimfiles/vim-addons/ensime',
            \ 'or',
            \ '$HOME . "/.vim/vim-addons/ensime',
            \ 'depending upon OS.'
          \ ]
      \ }
  let l:options['ensime-dist-dir'] = {
        \ 'name': 'ensime-dist-dir',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Name of SubDirectory of the Option "ensime_path" Directory',
            \ 'values, This Directory name will generally indicate which',
            \ 'Scala version Ensime was built with and possible the Ensime.',
            \ 'version. For example, ',
            \ '  "dist_2.9.2" or "ensime_2.9.2-0.9.8.9" or',
            \ '  "ensime_2.10.0-0.9.8.9"'
          \ ]
      \ }
  let l:options['ensime-dist-path'] = {
        \ 'name': 'ensime-dist-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'This is the full path to the Ensime distribution.',
            \ 'This Directory name will generally indicate which Scale',
            \ 'version, If "ensime_path" is not set, then this option',
            \ 'is used.'
          \ ]
      \ }
  let l:options['ensime-port-file-path'] = {
        \ 'name': 'ensime-port-file-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'This is the full path to File where Ensime will write',
            \ 'its socket server port number. There is no default value.'
          \ ]
      \ }
  let l:options['ensime-port-file-name'] = {
        \ 'name': 'ensime-port-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'If the option "ensime_port_file_path" is not set, then this',
            \ 'is the name of the file where Ensime will write its',
            \ 'socket server port number.',
            \ 'Either the Current Working Directory or the Ensime Config',
            \ 'Directory will be used as the location of this file.',
            \ 'depending on the setting of "use_cwd_as_default_output_dir".'
          \ ]
      \ }
  let l:options['ensime-host-name'] = {
        \ 'name': 'ensime-host-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HOST_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'The host name of the machine where the Ensime Server is.',
            \ 'running. The default value is "localhost".'
          \ ]
      \ }
  let l:options['ensime-shutdown-on-vim-exit'] = {
        \ 'name': 'ensime-shutdown-on-vim-exit',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'If set to true (1), then when Vim stops, a call is made',
            \ 'to shutdown its associated Ensime Server. If set to false (0),',
            \ 'the default, then the Ensime Server is not shutdown when',
            \ 'Vim exits.'
          \ ]
      \ }
  let l:options['ensime-port-file-max-wait'] = {
        \ 'name': 'ensime-port-file-max-wait',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'How long in seconds will Vimside wait for the Ensime',
            \ 'Server. to write its socket server port number to',
            \ 'the port file.'
          \ ]
      \ }
  let l:options['ensime-log-enabled'] = {
        \ 'name': 'ensime-log-enabled',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Will the standard and error output of the Ensime Server',
            \ 'process be captured in a log file.'
          \ ]
      \ }
  let l:options['ensime-log-file-path'] = {
        \ 'name': 'ensime-log-file-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Full path to Ensime Server log file.'
          \ ]
      \ }
  let l:options['ensime-log-file-use-pid'] = {
        \ 'name': 'ensime-log-file-use-pid',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'The Ensime log file has the process id (pid) as a prefix',
            \ 'of the Vim process that started it.'
          \ ]
      \ }
  let l:options['ensime-log-file-name'] = {
        \ 'name': 'ensime-log-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'If the option "ensime_log_file_path" is not set, then this',
            \ 'is the name of the file where Ensime output will be written.',
            \ 'Either the Current Working Directory or the Ensime Config',
            \ 'Directory will be used as the location of this file.',
            \ 'depending on the setting of "use_cwd_as_default_output_dir".'
          \ ]
      \ }
  let l:options['tailor-information'] = {
        \ 'name': 'tailor-information',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['cmdline', 'preview', 'tab_window', 'form' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'If an Ensime RPC call returns values than can be displayed',
            \ 'as text information and the particular RPC call does not',
            \ 'have an "information" option set, then the value of this',
            \ 'option is used to determine what display mechanism to use.'
          \ ]
      \ }
  let l:options['tailor-location-same-file'] = {
        \ 'name': 'tailor-location-same-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'If an Ensime RPC call returns values with file/position',
            \ 'values that would allow the user to go-to the specific',
            \ 'location in the same (current) file to "see" the requested',
            \ '"information", then this is used to determine how the user',
            \ 'position in the file is specified: same window simply jumping',
            \ 'to a new location or the window on the file is split showing',
            \ 'the new location in the new sub-window.'
          \ ]
      \ }
  let l:options['tailor-location-diff-file'] = {
        \ 'name': 'tailor-location-diff-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'If an Ensime RPC call returns values with file/position values',
            \ 'that would allow the user to go-to the specific location',
            \ 'in a different file to "see" the requested "information",',
            \ 'then this is used to determine how the user sees in the',
            \ 'different file: same window simply jumping to a new',
            \ 'file/position or the window is split showing the new',
            \ 'file/position in the new sub-window, or in a new tab.'
          \ ]
      \ }


  " Swank RPC Event Ping Info
  let l:options['scheduler-not-expecting-anything-read-time-out'] = {
        \ 'name': 'scheduler-not-expecting-anything-read-time-out',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Not expecting anything RPC socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-not-expecting-anything-update-time'] = {
        \ 'name': 'scheduler-not-expecting-anything-update-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Not expecting anything CursorHold updatetime before ping."
          \ ]
      \ }
  let l:options['scheduler-not-expecting-anything-char-count'] = {
        \ 'name': 'scheduler-not-expecting-anything-char-count',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Not expecting anything CursorMoved number of characters",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-rpc-response-read-time-out'] = {
        \ 'name': 'scheduler-expecting-rpc-response-read-time-out',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting RPC response socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-expecting-rpc-response-update-time'] = {
        \ 'name': 'scheduler-expecting-rpc-response-update-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting RPC response CursorHold updatetime before ping"
          \ ]
      \ }
  let l:options['scheduler-expecting-rpc-response-char-count'] = {
        \ 'name': 'scheduler-expecting-rpc-response-char-count',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting RPC response CursorMoved number of characters",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-events-read-time-out'] = {
        \ 'name': 'scheduler-expecting-events-read-time-out',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting known number of events socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-expecting-events-update-time'] = {
        \ 'name': 'scheduler-expecting-events-update-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting known number of events CursorHold updatetime",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-events-char-count'] = {
        \ 'name': 'scheduler-expecting-events-char-count',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting known number of events CursorMoved number of",
            \ "characters before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-many-events-read-time-out'] = {
        \ 'name': 'scheduler-expecting-many-events-read-time-out',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting many events socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-expecting-many-events-update-time'] = {
        \ 'name': 'scheduler-expecting-many-events-update-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting many events CursorHold updatetime before ping"
          \ ]
      \ }
  let l:options['scheduler-expecting-many-events-char-count'] = {
        \ 'name': 'scheduler-expecting-many-events-char-count',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Expecting many events CursorMoved number of characters",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-many-max-count-no-events'] = {
        \ 'name': 'scheduler-many-max-count-no-events',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'If events is set to many, how many ping occur without',
            \ 'any events being received before events is set to 0.'
          \ ]
      \ }
  let l:options['scheduler-events-max-count-no-events'] = {
        \ 'name': 'scheduler-events-max-count-no-events',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'If events is set to number of events expected,',
            \ 'how many pings occur without any events being',
            \ 'received before events is set to 0.'
          \ ]
      \ }

  
  " Start Swank RPC
  let l:options['swank-rpc-builder-add-files-handler'] = {
        \ 'name': 'swank-rpc-builder-add-files-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:builder-add-files'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-add-files-caller'] = {
        \ 'name': 'swank-rpc-builder-add-files-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:builder-add-files'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-init-handler'] = {
        \ 'name': 'swank-rpc-builder-init-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:builder-init'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-init-caller'] = {
        \ 'name': 'swank-rpc-builder-init-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:builder-init'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-remove-files-handler'] = {
        \ 'name': 'swank-rpc-builder-remove-files-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:builder-remove-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-builder-remove-files-caller'] = {
        \ 'name': 'swank-rpc-builder-remove-files-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:builder-remove-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-builder-update-files-handler'] = {
        \ 'name': 'swank-rpc-builder-update-files-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:builder-update-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-builder-update-files-caller'] = {
        \ 'name': 'swank-rpc-builder-update-files-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:builder-update-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-call-completion-handler'] = {
        \ 'name': 'swank-rpc-call-completion-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:call-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-call-completion-caller'] = {
        \ 'name': 'swank-rpc-call-completion-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:call-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-cancel-refactor-handler'] = {
        \ 'name': 'swank-rpc-cancel-refactor-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:cancel-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-cancel-refactor-caller'] = {
        \ 'name': 'swank-rpc-cancel-refactor-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:cancel-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-completions-handler'] = {
        \ 'name': 'swank-rpc-completions-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:completions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-completions-caller'] = {
        \ 'name': 'swank-rpc-completions-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:completions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-connection-info-handler'] = {
        \ 'name': 'swank-rpc-connection-info-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:connection-info'."
          \ ]
      \ }
  
  let l:options['swank-rpc-connection-info-caller'] = {
        \ 'name': 'swank-rpc-connection-info-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:connection-info'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-active-vm-handler'] = {
        \ 'name': 'swank-rpc-debug-active-vm-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-active-vm'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-active-vm-caller'] = {
        \ 'name': 'swank-rpc-debug-active-vm-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-active-vm'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-attach-handler'] = {
        \ 'name': 'swank-rpc-debug-attach-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-attach'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-attach-caller'] = {
        \ 'name': 'swank-rpc-debug-attach-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-attach'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-backtrace-handler'] = {
        \ 'name': 'swank-rpc-debug-backtrace-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-backtrace'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-backtrace-caller'] = {
        \ 'name': 'swank-rpc-debug-backtrace-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-backtrace'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-all-breaks-handler'] = {
        \ 'name': 'swank-rpc-debug-clear-all-breaks-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-clear-all-breaks'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-all-breaks-caller'] = {
        \ 'name': 'swank-rpc-debug-clear-all-breaks-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-clear-all-breaks'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-break-handler'] = {
        \ 'name': 'swank-rpc-debug-clear-break-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-clear-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-break-caller'] = {
        \ 'name': 'swank-rpc-debug-clear-break-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-clear-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-continue-handler'] = {
        \ 'name': 'swank-rpc-debug-continue-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-continue'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-continue-caller'] = {
        \ 'name': 'swank-rpc-debug-continue-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-continue'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-list-breakpoints-handler'] = {
        \ 'name': 'swank-rpc-debug-list-breakpoints-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-list-breakpoints'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-list-breakpoints-caller'] = {
        \ 'name': 'swank-rpc-debug-list-breakpoints-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-list-breakpoints'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-locate-name-handler'] = {
        \ 'name': 'swank-rpc-debug-locate-name-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-locate-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-locate-name-caller'] = {
        \ 'name': 'swank-rpc-debug-locate-name-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-locate-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-next-handler'] = {
        \ 'name': 'swank-rpc-debug-next-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-next'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-next-caller'] = {
        \ 'name': 'swank-rpc-debug-next-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-next'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-run-handler'] = {
        \ 'name': 'swank-rpc-debug-run-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-run'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-run-caller'] = {
        \ 'name': 'swank-rpc-debug-run-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-run'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-break-handler'] = {
        \ 'name': 'swank-rpc-debug-set-break-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-set-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-break-caller'] = {
        \ 'name': 'swank-rpc-debug-set-break-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-set-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-value-handler'] = {
        \ 'name': 'swank-rpc-debug-set-value-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-set-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-value-caller'] = {
        \ 'name': 'swank-rpc-debug-set-value-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-set-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-start-handler'] = {
        \ 'name': 'swank-rpc-debug-start-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-start'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-start-caller'] = {
        \ 'name': 'swank-rpc-debug-start-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-start'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-out-handler'] = {
        \ 'name': 'swank-rpc-debug-step-out-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-step-out'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-out-caller'] = {
        \ 'name': 'swank-rpc-debug-step-out-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-step-out'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-handler'] = {
        \ 'name': 'swank-rpc-debug-step-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-step'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-caller'] = {
        \ 'name': 'swank-rpc-debug-step-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-step'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-stop-handler'] = {
        \ 'name': 'swank-rpc-debug-stop-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-stop'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-stop-caller'] = {
        \ 'name': 'swank-rpc-debug-stop-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-stop'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-to-string-handler'] = {
        \ 'name': 'swank-rpc-debug-to-string-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-to-string'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-to-string-caller'] = {
        \ 'name': 'swank-rpc-debug-to-string-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-to-string'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-value-handler'] = {
        \ 'name': 'swank-rpc-debug-value-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:debug-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-value-caller'] = {
        \ 'name': 'swank-rpc-debug-value-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:debug-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-refactor-handler'] = {
        \ 'name': 'swank-rpc-exec-refactor-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:exec-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-refactor-caller'] = {
        \ 'name': 'swank-rpc-exec-refactor-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:exec-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-undo-handler'] = {
        \ 'name': 'swank-rpc-exec-undo-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:exec-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-undo-caller'] = {
        \ 'name': 'swank-rpc-exec-undo-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:exec-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-expand-selection-handler'] = {
        \ 'name': 'swank-rpc-expand-selection-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:expand-selection'."
          \ ]
      \ }
  
  let l:options['swank-rpc-expand-selection-caller'] = {
        \ 'name': 'swank-rpc-expand-selection-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:expand-selection'."
          \ ]
      \ }
  
  let l:options['swank-rpc-format-source-handler'] = {
        \ 'name': 'swank-rpc-format-source-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:format-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-format-source-caller'] = {
        \ 'name': 'swank-rpc-format-source-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:format-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-import-suggestions-handler'] = {
        \ 'name': 'swank-rpc-import-suggestions-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:import-suggestions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-import-suggestions-caller'] = {
        \ 'name': 'swank-rpc-import-suggestions-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:import-suggestions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-init-project-handler'] = {
        \ 'name': 'swank-rpc-init-project-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:init-project'."
          \ ]
      \ }
  
  let l:options['swank-rpc-init-project-caller'] = {
        \ 'name': 'swank-rpc-init-project-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:init-project'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-package-by-path-handler'] = {
        \ 'name': 'swank-rpc-inspect-package-by-path-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:inspect-package-by-path'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-package-by-path-caller'] = {
        \ 'name': 'swank-rpc-inspect-package-by-path-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:inspect-package-by-path'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-at-point-handler'] = {
        \ 'name': 'swank-rpc-inspect-type-at-point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:inspect-type-at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-at-point-caller'] = {
        \ 'name': 'swank-rpc-inspect-type-at-point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:inspect-type-at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-by-id-handler'] = {
        \ 'name': 'swank-rpc-inspect-type-by-id-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:inspect-type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-by-id-caller'] = {
        \ 'name': 'swank-rpc-inspect-type-by-id-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:inspect-type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-method-bytecode-handler'] = {
        \ 'name': 'swank-rpc-method-bytecode-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:method-bytecode'."
          \ ]
      \ }
  
  let l:options['swank-rpc-method-bytecode-caller'] = {
        \ 'name': 'swank-rpc-method-bytecode-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:method-bytecode'."
          \ ]
      \ }
  
  let l:options['swank-rpc-package-member-completion-handler'] = {
        \ 'name': 'swank-rpc-package-member-completion-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:package-member-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-package-member-completion-caller'] = {
        \ 'name': 'swank-rpc-package-member-completion-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:package-member-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-patch-source-handler'] = {
        \ 'name': 'swank-rpc-patch-source-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:patch-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-patch-source-caller'] = {
        \ 'name': 'swank-rpc-patch-source-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:patch-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-peek-undo-handler'] = {
        \ 'name': 'swank-rpc-peek-undo-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:peek-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-peek-undo-caller'] = {
        \ 'name': 'swank-rpc-peek-undo-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:peek-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-prepare-refactor-handler'] = {
        \ 'name': 'swank-rpc-prepare-refactor-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:prepare-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-prepare-refactor-caller'] = {
        \ 'name': 'swank-rpc-prepare-refactor-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:prepare-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-public-symbol-search-handler'] = {
        \ 'name': 'swank-rpc-public-symbol-search-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:public-symbol-search'."
          \ ]
      \ }
  
  let l:options['swank-rpc-public-symbol-search-caller'] = {
        \ 'name': 'swank-rpc-public-symbol-search-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:public-symbol-search'."
          \ ]
      \ }
  
  let l:options['swank-rpc-remove-file-handler'] = {
        \ 'name': 'swank-rpc-remove-file-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:remove-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-remove-file-caller'] = {
        \ 'name': 'swank-rpc-remove-file-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:remove-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-repl-config-handler'] = {
        \ 'name': 'swank-rpc-repl-config-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:repl-config'."
          \ ]
      \ }
  
  let l:options['swank-rpc-repl-config-caller'] = {
        \ 'name': 'swank-rpc-repl-config-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:repl-config'."
          \ ]
      \ }
  
  let l:options['swank-rpc-shutdown-server-handler'] = {
        \ 'name': 'swank-rpc-shutdown-server-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:shutdown-server'."
          \ ]
      \ }
  
  let l:options['swank-rpc-shutdown-server-caller'] = {
        \ 'name': 'swank-rpc-shutdown-server-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:shutdown-server'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-at-point-handler'] = {
        \ 'name': 'swank-rpc-symbol-at-point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:symbol-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-at-point-caller'] = {
        \ 'name': 'swank-rpc-symbol-at-point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:symbol-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-designations-handler'] = {
        \ 'name': 'swank-rpc-symbol-designations-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:symbol-designations'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-designations-caller'] = {
        \ 'name': 'swank-rpc-symbol-designations-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:symbol-designations'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-at-point-handler'] = {
        \ 'name': 'swank-rpc-type-at-point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:type-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-at-point-caller'] = {
        \ 'name': 'swank-rpc-type-at-point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:type-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-id-handler'] = {
        \ 'name': 'swank-rpc-type-by-id-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-id-caller'] = {
        \ 'name': 'swank-rpc-type-by-id-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name_at_point-handler'] = {
        \ 'name': 'swank-rpc-type-by-name_at_point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:type-by-name_at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name_at_point-caller'] = {
        \ 'name': 'swank-rpc-type-by-name_at_point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:type-by-name_at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name-handler'] = {
        \ 'name': 'swank-rpc-type-by-name-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:type-by-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name-caller'] = {
        \ 'name': 'swank-rpc-type-by-name-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:type-by-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-all-handler'] = {
        \ 'name': 'swank-rpc-typecheck-all-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:typecheck-all'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-all-caller'] = {
        \ 'name': 'swank-rpc-typecheck-all-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:typecheck-all'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-files-handler'] = {
        \ 'name': 'swank-rpc-typecheck-files-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:typecheck-files'."
          \ ]
      \ }

  let l:options['swank-rpc-typecheck-files-caller'] = {
        \ 'name': 'swank-rpc-typecheck-files-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:typecheck-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-file-handler'] = {
        \ 'name': 'swank-rpc-typecheck-file-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:typecheck-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-file-caller'] = {
        \ 'name': 'swank-rpc-typecheck-file-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:typecheck-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-uses-of-symbol-at-point-handler'] = {
        \ 'name': 'swank-rpc-uses-of-symbol-at-point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Handler for 'swank:uses-of-symbol-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-uses-of-symbol-at-point-caller'] = {
        \ 'name': 'swank-rpc-uses-of-symbol-at-point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC Caller for 'swank:uses-of-symbol-at-point'."
          \ ]
      \ }
  
  
  
  " End Swank RPC
  
  



  let l:options['tailor-symbol-search-close-empty-display'] = {
        \ 'name': 'tailor-symbol-search-close-empty-display',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "For 'swank:public-symbol-search' close quickfix window",
            \ "if there are no search results."
          \ ]
      \ }
  let l:options['tailor-symbol-search-do-incremental'] = {
        \ 'name': 'tailor-symbol-search-do-incremental',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "For 'swank:public-symbol-search' do incremental search.",
            \ "As search terms are entered, search results are displayed."
          \ ]
      \ }
  let l:options['tailor-symbol-search-maximum-return'] = {
        \ 'name': 'tailor-symbol-search-maximum-return',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "For 'swank:public-symbol-search' do incremental search.",
            \ "Maximum search results returned by Ensime."
          \ ]
      \ }

  let l:options['tailor-expand-selection-information'] = {
        \ 'name': 'tailor-expand-selection-information',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['visual', 'highlight' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "RPC handler for 'swank:expand-selection' information.",
            \ "Use either Vim visual mode or highlighting."
          \ ]
      \ }
  let l:options['tailor-expand-selection-highlight-color-dark'] = {
        \ 'name': 'tailor-expand-selection-highlight-color-dark',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "RPC handler for 'swank:expand-selection' highlight color.",
            \ "when background is dark."
          \ ]
      \ }
  let l:options['tailor-expand-selection-highlight-color-light'] = {
        \ 'name': 'tailor-expand-selection-highlight-color-light',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "RPC handler for 'swank:expand-selection' highlight color.",
            \ "when background is light."
          \ ]
      \ }


  let l:options['tailor-repl-config-location'] = {
        \ 'name': 'tailor-repl-config-location',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to display Scala Repl.'
          \ ]
      \ }

  let l:options['tailor-sbt-config-location'] = {
        \ 'name': 'tailor-sbt-config-location',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to display Scala Simple Build Tool (SBT).'
          \ ]
      \ }
  let l:options['tailor-sbt-compile-error-long-line-quickfix'] = {
        \ 'name': 'tailor-sbt-compile-error-multiline-quickfix',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Display all of the compiler error messages in quickfix window",
            \ "if set to true. If false, then for each error, only first",
            \ "line of the compiler error message is shown."
          \ ]
      \ }
  let l:options['tailor-sbt-error-read-size'] = {
        \ 'name': 'tailor-sbt-error-read-size',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Size of Ensime socket read buffer when getting the results',
            \ 'of an SBT compiliation. This should be large because there',
            \ 'might be a lot of errors and a partial read may fail when',
            \ 'when converting errors to Quickfix window entries.'
          \ ]
      \ }
  let l:options['tailor-sbt-error-use-signs'] = {
        \ 'name': 'tailor-sbt-error-use-signs',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Whether or not to use signs when SBT is displaying compile errors.'
          \ ]
      \ }
  
  let l:options['tailor-show-errors-and-warnings-use-signs'] = {
        \ 'name': 'tailor-show-errors-and-warnings-use-signs',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Whether or not to use signs when compiler is displaying compile errors.'
          \ ]
      \ }
  let l:options['tailor-full-typecheck-finished-use-signs'] = {
        \ 'name': 'tailor-full-typecheck-finished-use-signs',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Whether or not to use signs when type check finished is displaying compile errors.'
          \ ]
      \ }


  let l:options['tailor-symbol-at-point-information'] = {
        \ 'name': 'tailor-symbol-at-point-information',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['cmdline', 'preview', 'tab_window', 'form' ],
        \ 'parent': 'tailor-information',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to display the symbol-at-point information.'
          \ ]
      \ }
  let l:options['tailor-symbol-at-point-location-same-file'] = {
        \ 'name': 'tailor-symbol-at-point-location-same-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window' ],
        \ 'parent': 'tailor-location-same-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to jump to symbol-at-point same file different pos.'
          \ ]
      \ }
  let l:options['tailor-symbol-at-point-location-diff-file'] = {
        \ 'name': 'tailor-symbol-at-point-location-diff-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to jump to symbol-at-point different file and pos.'
          \ ]
      \ }



  let l:options['tailor-uses-of-symbol-at-point-location'] = {
        \ 'name': 'tailor-uses-of-symbol-at-point-location',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to jump to uses-of-symbol-at-point file and pos.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-window'] = {
        \ 'name': 'tailor-uses-of-symbol-at-point-window',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['quickfix', 'mixed' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'Whether to use the quickfix window to display uses or if all',
            \ 'of the uses are in the same window use the locationlist ',
            \ 'window.',
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-use-signs'] = {
        \ 'name': 'tailor-uses-of-symbol-at-point-use-signs',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Whether or not to use signs when displaying uses.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-use-sign-kind-marker'] = {
        \ 'name': 'tailor-uses-of-symbol-at-point-use-sign-kind-marker',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Whether or not to use sign kind "marker" for current line.'
          \ ]
      \ }
  
  " Sign
  let l:options['sign-quickfix-error-linehl'] = {
        \ 'name': 'sign-quickfix-error-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Error linehl.'
          \ ]
      \ }
  
  let l:options['sign-quickfix-error-text'] = {
        \ 'name': 'sign-quickfix-error-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Error text'
          \ ]
      \ }

  let l:options['sign-quickfix-error-texthl'] = {
        \ 'name': 'sign-quickfix-error-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Error texthl.'
          \ ]
      \ }

  let l:options['sign-quickfix-warn-linehl'] = {
        \ 'name': 'sign-quickfix-warn-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Warn linehl.'
          \ ]
      \ }

  let l:options['sign-quickfix-warn-text'] = {
        \ 'name': 'sign-quickfix-warn-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Warn text'
          \ ]
      \ }

  let l:options['sign-quickfix-warn-texthl'] = {
        \ 'name': 'sign-quickfix-warn-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Warn texthl'
          \ ]
      \ }

  let l:options['sign-quickfix-info-linehl'] = {
        \ 'name': 'sign-quickfix-info-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Info linehl.'
          \ ]
      \ }

  let l:options['sign-quickfix-info-text'] = {
        \ 'name': 'sign-quickfix-info-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Info text'
          \ ]
      \ }

  let l:options['sign-quickfix-info-texthl'] = {
        \ 'name': 'sign-quickfix-info-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Info texthl.'
          \ ]
      \ }

  let l:options['sign-quickfix-marker-linehl'] = {
        \ 'name': 'sign-quickfix-marker-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Marker linehl.'
          \ ]
      \ }

  let l:options['sign-quickfix-marker-text'] = {
        \ 'name': 'sign-quickfix-marker-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Marker text'
          \ ]
      \ }

  let l:options['sign-quickfix-marker-texthl'] = {
        \ 'name': 'sign-quickfix-marker-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Quickfix Marker texthl.'
          \ ]
      \ }

  let l:options['sign-locationlist-info-linehl'] = {
        \ 'name': 'sign-locationlist-info-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'LocationList Info linehl.'
          \ ]
      \ }

  let l:options['sign-locationlist-info-text'] = {
        \ 'name': 'sign-locationlist-info-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'LocationList Info text'
          \ ]
      \ }

  let l:options['sign-locationlist-info-texthl'] = {
        \ 'name': 'sign-locationlist-info-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'LocationList Info texthl.'
          \ ]
      \ }

  let l:options['sign-locationlist-marker-linehl'] = {
        \ 'name': 'sign-locationlist-marker-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'LocationList Marker linehl.'
          \ ]
      \ }

  let l:options['sign-locationlist-marker-text'] = {
        \ 'name': 'sign-locationlist-marker-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'LocationList Marker text'
          \ ]
      \ }

  let l:options['sign-locationlist-marker-texthl'] = {
        \ 'name': 'sign-locationlist-marker-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'LocationList Marker texthl'
          \ ]
      \ }

  let l:options['sign-debug-active-linehl'] = {
        \ 'name': 'sign-debug-active-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Active linehl.'
          \ ]
      \ }

  let l:options['sign-debug-active-text'] = {
        \ 'name': 'sign-debug-active-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Active text'
          \ ]
      \ }

  let l:options['sign-debug-active-texthl'] = {
        \ 'name': 'sign-debug-active-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Active texthl'
          \ ]
      \ }

  let l:options['sign-debug-pending-linehl'] = {
        \ 'name': 'sign-debug-pending-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Pending linehl.'
          \ ]
      \ }

  let l:options['sign-debug-pending-text'] = {
        \ 'name': 'sign-debug-pending-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Pending text'
          \ ]
      \ }

  let l:options['sign-debug-pending-texthl'] = {
        \ 'name': 'sign-debug-pending-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Pending texthl'
          \ ]
      \ }

  let l:options['sign-debug-marker-linehl'] = {
        \ 'name': 'sign-debug-marker-linehl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Marker linehl.'
          \ ]
      \ }

  let l:options['sign-debug-marker-text'] = {
        \ 'name': 'sign-debug-marker-text',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Marker text'
          \ ]
      \ }

  let l:options['sign-debug-marker-texthl'] = {
        \ 'name': 'sign-debug-marker-texthl',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Debug Marker texthl'
          \ ]
      \ }

  let l:options['sign-start-place-id'] = {
        \ 'name': 'sign-start-place-id',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'The value of the first sign id. Each subsequent sign',
            \ 'id has a value one more than its predecessor'
          \ ]
      \ }


  " Event Trigger
  let l:options['swank-event-trigger-compiler-ready'] = {
        \ 'name': 'swank-event-trigger-compiler-ready',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':compiler-ready'."
        \ ]
      \ }
  let l:options['swank-event-trigger-full-typecheck-finished'] = {
        \ 'name': 'swank-event-trigger-full-typecheck-finished',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':full:typecheck-finished'."
        \ ]
      \ }
  let l:options['swank-event-trigger-indexer-ready'] = {
        \ 'name': 'swank-event-trigger-indexer-ready',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':indexer-ready'."
        \ ]
      \ }
  let l:options['swank-event-trigger-scala-notes'] = {
        \ 'name': 'swank-event-trigger-scala-notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':scala-notes'."
        \ ]
      \ }
  let l:options['swank-event-trigger-java-notes'] = {
        \ 'name': 'swank-event-trigger-java-notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':java-notes'."
        \ ]
      \ }
  let l:options['swank-event-trigger-clear-all-scala-notes'] = {
        \ 'name': 'swank-event-trigger-clear-all-scala-notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':clear-all-scala-notes'."
        \ ]
      \ }
  let l:options['swank-event-trigger-clear-all-java-notes'] = {
        \ 'name': 'swank-event-trigger-clear-all-java-notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC event trigger for ':clear-all-java-notes'."
        \ ]
      \ }

  " Debug Trigger
  let l:options['swank-debug-trigger-output'] = {
        \ 'name': 'swank-debug-trigger-output',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == output'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-stop'] = {
        \ 'name': 'swank-debug-trigger-stop',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == stop'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-breakpoint'] = {
        \ 'name': 'swank-debug-trigger-breakpoint',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == breakpoint'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-death'] = {
        \ 'name': 'swank-debug-trigger-death',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == death'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-start'] = {
        \ 'name': 'swank-debug-trigger-start',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == start'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-disconnect'] = {
        \ 'name': 'swank-debug-trigger-disconnect',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == disconnect'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-exception'] = {
        \ 'name': 'swank-debug-trigger-exception',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == exception'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-thread-start'] = {
        \ 'name': 'swank-debug-trigger-thread-start',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == threadStart'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-thread-death'] = {
        \ 'name': 'swank-debug-trigger-thread-death',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "RPC debut trigger for ':type == threadDeath'."
        \ ]
      \ }

  " Hover
  let l:options['tailor-hover-updatetime'] = {
        \ 'name': 'tailor-hover-updatetime',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "How long in milliseconds before Hover CursorHold event called."
        \ ]
      \ }
  let l:options['tailor-hover-max-char-mcounter'] = {
        \ 'name': 'tailor-hover-max-char-mcounter',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "How many characters entered before Hover CurosrMoved",
            \ "event called."
        \ ]
      \ }
  let l:options['vimside-hover-balloon-enabled'] = {
        \ 'name': 'vimside-hover-balloon-enabled',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Is the GVim Symbol-name balloon enabled."
        \ ]
      \ }
  let l:options['tailor-hover-cmdline-job-time'] = {
        \ 'name': 'tailor-hover-cmdline-job-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "Job time in milliseconds for Hover Command Line execution."
        \ ]
      \ }
  let l:options['vimside-hover-term-balloon-enabled'] = {
        \ 'name': 'vimside-hover-term-balloon-enabled',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Is the Vim Symbol-name term balloon enabled."
        \ ]
      \ }
  let l:options['tailor-hover-term-balloon-fg'] = {
        \ 'name': 'tailor-hover-term-balloon-fg',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Foreground color for term balloon (symbolic name",
            \ "or hex-value)."
        \ ]
      \ }
  let l:options['tailor-hover-term-balloon-bg'] = {
        \ 'name': 'tailor-hover-term-balloon-bg',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Background color for term balloon (symbolic name",
            \ "or hex-value)."
        \ ]
      \ }
  let l:options['tailor-hover-term-job-time'] = {
        \ 'name': 'tailor-hover-term-job-time',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "Job time in milliseconds for Hover Term execution."
        \ ]
      \ }
  
  " Browser
  let l:options['tailor-browser-keys-platform'] = {
        \ 'name': 'tailor-browser-keys-platform',
        \ 'type': g:OPTION_LIST_TYPE, 
        \ 'kind': g:OPTION_KEY_KIND, 
        \ 'templates': {
                \ 'commands': 'tailor-browser-{key}-commands',
                \ 'url_funcs': 'tailor-browser-{key}-url-funcname'
                \ }, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "Keys for generating Browser Component Options."
        \ ]
      \ }

  " Show Doc Url
  " For each {key} and {version} value if the 'url-base' template is
  " defined in default.vim, then the 'regex' and 'func-ref' templates
  " MUST also be defined in default.vim.
  " It is ok for a 'url-base' to exists for some {key}/{version}
  " combinations and not for other combinations.
  let l:options['tailor-show-doc-keys'] = {
        \ 'name': 'tailor-show-doc-keys',
        \ 'type': g:OPTION_LIST_TYPE, 
        \ 'kind': g:OPTION_KEY_KIND, 
        \ 'templates': {
                \ 'url_base': 'tailor-show-doc-{key}{version}-url-base',
                \ 'regex': 'tailor-show-doc-{key}-regex',
                \ 'funcref': 'tailor-show-doc-{key}-func-ref'
                \ }, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ "Keys for generating Browser Component Options."
        \ ]
      \ }
  
  " Forms
  let l:options['forms-use'] = {
        \ 'name': 'forms-use',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "When there are multiple implementations, use the",
            \ "Forms-based one if available otherwise use the",
            \ "Vim-based implementation."
        \ ]
      \ }

  let l:options['tailor-forms-sourcebrowser-open-in-tab'] = {
        \ 'name': 'tailor-forms-sourcebrowser-open-in-tab',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Open the Forms sourcebrowser in its own tab."
        \ ]
      \ }
  
  " Typecheck file on write
  let l:options['tailor-type-check-file-on-write'] = {
        \ 'name': 'tailor-type-check-file-on-write',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Typecheck a file when it is written."
        \ ]
      \ }
  
  " Refactor Rename
  let l:options['tailor-refactor-rename-pattern-enable'] = {
        \ 'name': 'tailor-refactor-rename-pattern-enable',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Refactor rename identifier matching pattern enable."
        \ ]
      \ }
  let l:options['tailor-refactor-rename-pattern'] = {
        \ 'name': 'tailor-refactor-rename-pattern',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Refactor rename identifier matching pattern."
        \ ]
      \ }
  
  " Refactor Extract Local
  let l:options['tailor-refactor-extract-local-pattern-enable'] = {
        \ 'name': 'tailor-refactor-extract-local-pattern-enable',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Refactor extract local identifier matching pattern enable."
        \ ]
      \ }
  let l:options['tailor-refactor-extract-local-pattern'] = {
        \ 'name': 'tailor-refactor-extract-local-pattern',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Refactor extract local identifier matching pattern."
        \ ]
      \ }
  
  " Refactor Extract Method
  let l:options['tailor-refactor-extract-method-pattern-enable'] = {
        \ 'name': 'tailor-refactor-extract-method-pattern-enable',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Refactor extract method identifier matching pattern enable."
        \ ]
      \ }
  let l:options['tailor-refactor-extract-method-pattern'] = {
        \ 'name': 'tailor-refactor-extract-method-pattern',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ "Refactor extract method identifier matching pattern."
        \ ]
      \ }
  

  return l:options
endfunction

function! vimside#options#defined#Load(options)
  if ! has_key(a:options, 'defined') || empty(a:options.defined)
    if ! exists("s:defined_options")
      let s:defined_options = s:MakeOptions()
    endif
    let a:options['defined'] = s:defined_options
  endif
endfunction
