
" types
let g:OPTION_BOOLEAN_TYPE = type(0)
let g:OPTION_NUMBER_TYPE = type(0)
let g:OPTION_STRING_TYPE = type('')
let g:OPTION_FLOAT_TYPE = type(1.0)
let g:OPTION_LIST_TYPE = type([])
let g:OPTION_DICTIONARY_TYPE = type({})

" kinds
let g:OPTION_UNKNOWN_KIND = 0
let g:OPTION_FILE_NAME_KIND = 1
let g:OPTION_FILE_PATH_KIND = 2
let g:OPTION_DIR_PATH_KIND = 3
let g:OPTION_DIR_NAME_KIND = 4
let g:OPTION_HOST_NAME_KIND = 5
let g:OPTION_POSITIVE_NUMBER_KIND = 6
let g:OPTION_ENUM_KIND = 7
let g:OPTION_FUNCTION_KIND = 8
let g:OPTION_TIME_KIND = 9
let g:OPTION_CHAR_COUNT_KIND = 10


"
" 'name'        mandatory
" 'type'        mandatory 
"                  The type of the Vim object
" 'kind'        optional  
"                  Used to determine what additional validation checks
"                  might be used.
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
    if def.type == g:OPTION_BOOLEAN_TYPE
      call add(errors, "Option '". def.name ."' not Bool type: '". string(value) ."'")
    elseif def.type == g:OPTION_NUMBER_TYPE
      call add(errors, "Option '". def.name ."' not Int type: '". string(value) ."'")
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
    if def.type == g:OPTION_BOOLEAN_TYPE
      if value != 0 && value != 1
        call add(errors, "Option '". def.name ."' has bad Bool value: '". string(value) ."'")
      endif
    endif

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
      \ 'enum': ['cmdline', 'preview', 'tab', 'form' ],
endfunction

function! s:CheckFunctionKind(def, value, errors)
  let def = a:def
  let value = a:value
  let errors = a:errors

endfunction


function! s:MakeOptions()
  let s:options = {}

  let s:options['vimside-log-enabled'] = {
          \ 'name': 'vimside-log-enabled', 
          \ 'type': g:OPTION_BOOLEAN_TYPE, 
          \ 'description': [
            \ 'Used to enable/disable Vimside logging.'
          \ ]
      \ }
  let s:options['vimside-log-file-path'] = {
        \ 'name': 'vimside-log-file-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_PATH_KIND, 
        \ 'description': [
            \ 'Full path name of Vimside Log File.',
            \ 'Both the parent Directory and File must be writeable.',
            \ 'If not set, then either the Ensime Config File Directory is used or.',
            \ 'or the Current Working Directory (CWD). The CWD is used if.',
            \ '"use_cwd_as_default_output_dir" to true (1).'
          \ ]
      \ }
  let s:options['vimside-log-file-name'] = {
        \ 'name': 'vimside-log-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'description': [
            \ 'File name of Vimside Log File.',
            \ 'If "vimside_log_file_path" is set, then this option is ignored.'
          \ ]
      \ }
  let s:options['test-ensime-file-use'] = {
        \ 'name': 'test-ensime-file-use',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'description': [
            \ 'If true, then the test Ensime Config File located, generally, in',
            \ 'the "data/vimside" Directory is used to initialize Ensime.'
          \ ]
      \ }
  let s:options['test-ensime-file-dir'] = {
        \ 'name': 'test-ensime-file-dir',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'description': [
            \ 'The Directory of the test Ensime Config File, generally, in',
          \  'the "data/vimside" Directory.'
          \ ]
      \ }
  let s:options['use-cwd-as-default-output-dir'] = {
        \ 'name': 'use-cwd-as-default-output-dir',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'description': [
            \ 'If the option "vimside_log_file_path", then if true (1), the',
            \ 'Current Working Directory is used and if false (0), then',
            \ 'the Directory containing the Ensime Config File is used.'
          \ ]
      \ }
  let s:options['ensime-config-file-name'] = {
        \ 'name': 'ensime-config-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'description': [
            \ 'The name of the Ensime Config File.',
            \ 'Generally, the name will be: "\.ensime", "_ensime", or',
            \ '"ensime_config.vim". The first two names will have SExp definitions',
            \ 'of the Ensime configuration while the last name will contain,',
            \ 'a Vim script definition of the Ensime configuration.'
          \ ]
      \ }
  let s:options['ensime-install-path'] = {
        \ 'name': 'ensime-install-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'description': [
            \ 'Directory where Ensime is installed.',
            \ 'Vimside provides default values, assuming VAM is used, of: ',
            \ '$HOME . "/vimfiles/vim-addons/ensime',
            \ 'or',
            \ '$HOME . "/.vim/vim-addons/ensime',
            \ 'depending upon OS.'
          \ ]
      \ }
  let s:options['ensime-dist-dir'] = {
        \ 'name': 'ensime-dist-dir',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_NAME_KIND, 
        \ 'description': [
            \ 'Name of SubDirectory of the Option "ensime_path" Directory value.',
            \ 'This Directory name will generally indicate which Scale version',
            \ 'Ensime was built with and possible the Ensime version.',
            \ 'For example, ',
            \ '"dist_2.9.2" or "ensime_2.9.2-0.9.8.1" or',
            \ '"ensime_2.10.0-SNAPSHOT-0.9.7"'
          \ ]
      \ }
  let s:options['ensime-dist-path'] = {
        \ 'name': 'ensime-dist-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'description': [
            \ 'This is the full path to the Ensime distribution.',
            \ 'This Directory name will generally indicate which Scale version',
            \ 'If "ensime_path" is not set, then this option is used.'
          \ ]
      \ }
  let s:options['ensime-port-file-path'] = {
        \ 'name': 'ensime-port-file-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'description': [
            \ 'This is the full path to File where Ensime will write',
            \ 'its socket server port number.'
          \ ]
      \ }
  let s:options['ensime-port-file-name'] = {
        \ 'name': 'ensime-port-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'description': [
            \ 'If the option "ensime_port_file_path" is not set, then this is',
            \ 'the name of the file where Ensime will write its',
            \ 'socket server port number.',
            \ 'Either the Current Working Directory or the Ensime Config',
            \ 'Directory will be used as the location of this file.',
            \ 'depending on the setting of "use_cwd_as_default_output_dir".'
          \ ]
      \ }
  let s:options['ensime-host-name'] = {
        \ 'name': 'ensime-host-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HOST_NAME_KIND, 
        \ 'description': [
            \ 'The host name of the machine where the Ensime Server is running.',
            \ 'The default value is "localhost".'
          \ ]
      \ }
  let s:options['ensime-port-file-max-wait'] = {
        \ 'name': 'ensime-port-file-max-wait',
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'description': [
            \ 'How long in seconds will Vimside wait for the Ensime Server.',
            \ 'to write its socket server port number to the port file.'
          \ ]
      \ }
  let s:options['ensime-log-enabled'] = {
        \ 'name': 'ensime-log-enabled',
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'description': [
            \ 'Will the standard and error output of the Ensime Server process',
            \ 'be captured in a log file.'
          \ ]
      \ }
  let s:options['ensime-log-file-path'] = {
        \ 'name': 'ensime-log-file-path',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_PATH_KIND, 
        \ 'description': [
            \ 'Full path to Ensime Server log file.'
          \ ]
      \ }
  let s:options['ensime-log-file-name'] = {
        \ 'name': 'ensime-log-file-name',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'description': [
            \ 'If the option "ensime_log_file_path" is not set, then this is',
            \ 'the name of the file where Ensime output will be written.',
            \ 'Either the Current Working Directory or the Ensime Config',
            \ 'Directory will be used as the location of this file.',
            \ 'depending on the setting of "use_cwd_as_default_output_dir".'
          \ ]
      \ }
  let s:options['swank-information'] = {
        \ 'name': 'swank-information',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['cmdline', 'preview', 'tab', 'form' ],
        \ 'description': [
            \ 'If an Ensime RPC call returns values than can be displayed',
            \ 'as text information and the particular RPC call does not have',
            \ 'an "information" option set, then the value of this option',
            \ 'is used to determine what display mechanism to use.'
          \ ]
      \ }
  let s:options['swank-location-same-file'] = {
        \ 'name': 'swank-location-same-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window' ],
        \ 'description': [
            \ 'If an Ensime RPC call returns values with file/position values',
            \ 'that would allow the user to go-to the specific location',
            \ 'in the same (current) file to "see" the requested "information",',
            \ 'then this is used to determine how the user position in the',
            \ 'file is specified: same window simply jumping to a new location or',
            \ 'the window on the file is split showing the new location in the',
            \ 'new sub-window.'
          \ ]
      \ }
  let s:options['swank-location-diff-file'] = {
        \ 'name': 'swank-location-diff-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab' ],
        \ 'description': [
            \ 'If an Ensime RPC call returns values with file/position values',
            \ 'that would allow the user to go-to the specific location',
            \ 'in a different file to "see" the requested "information",',
            \ 'then this is used to determine how the user sees in the',
            \ 'different file: same window simply jumping to a new file/position',
            \ 'or the window is split showing the new file/position in the',
            \ 'new sub-window, or in a new tab.'
          \ ]
      \ }

  " Swank RPC Event Ping Info
  let s:options['swank-rpc-expecting-read-timeout'] = {
        \ 'name': 'swank-rpc-expecting-read-timeout',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
            \ 'description': [
            \ "Expecting response RPC socket read timeout."
          \ ]
      \ }
  let s:options['swank-rpc-expecting-updatetime'] = {
        \ 'name': 'swank-rpc-expecting-updatetime',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
            \ 'description': [
            \ "Expecting response CurosrHold updatetime before ping."
          \ ]
      \ }
  let s:options['swank-rpc-expecting-char-count'] = {
        \ 'name': 'swank-rpc-expecting-char-count',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
            \ 'description': [
            \ "Expecting response CursorMoved number of characters before ping."
          \ ]
      \ }
  let s:options['swank-rpc-not-expecting-read-timeout'] = {
        \ 'name': 'swank-rpc-not-expecting-read-timeout',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
            \ 'description': [
            \ "Not expecting RPC socket read timeout."
          \ ]
      \ }
  let s:options['swank-rpc-not-expecting-updatetime'] = {
        \ 'name': 'swank-rpc-not-expecting-updatetime',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
            \ 'description': [
            \ "Not expecting CurosrHold updatetime before ping."
          \ ]
      \ }
  let s:options['swank-rpc-not-expecting-char-count'] = {
        \ 'name': 'swank-rpc-not-expecting-char-count',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
            \ 'description': [
            \ "Not expecting CursorMoved number of characters before ping."
          \ ]
      \ }
  let s:options['swank-event-expecting-one-updatetime'] = {
        \ 'name': 'swank-event-expecting-one-updatetime',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
            \ 'description': [
            \ "Expecting one event CurosrHold updatetime before ping."
          \ ]
      \ }
  let s:options['swank-event-expecting-one-char-count'] = {
        \ 'name': 'swank-event-expecting-one-char-count',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
            \ 'description': [
            \ "Expecting one event CursorMoved number of characters before ping."
          \ ]
      \ }
  let s:options['swank-event-expecting-many-updatetime'] = {
        \ 'name': 'swank-event-expecting-many-updatetime',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
            \ 'description': [
            \ "Expecting many events CurosrHold updatetime before ping."
          \ ]
      \ }
  let s:options['swank-event-expecting-many-char-count'] = {
        \ 'name': 'swank-event-expecting-many-char-count',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
            \ 'description': [
            \ "Expecting many events CursorMoved number of characters before ping."
          \ ]
      \ }
  
  " Swank RPC
  let s:options['swank-rpc-completions-caller'] = {
        \ 'name': 'swank-rpc-completions-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:completions'."
          \ ]
      \ }
  let s:options['swank-rpc-completions-handler'] = {
        \ 'name': 'swank-rpc-completions-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:completions'."
          \ ]
      \ }

  let s:options['swank-rpc-connection-info-caller'] = {
        \ 'name': 'swank-rpc-connection-info-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:connection-info'."
          \ ]
      \ }
  let s:options['swank-rpc-connection-info-handler'] = {
        \ 'name': 'swank-rpc-connection-info-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:connection-info'."
          \ ]
      \ }

  let s:options['swank-rpc-format-source-caller'] = {
        \ 'name': 'swank-rpc-format-source-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:format-source'."
          \ ]
      \ }
  let s:options['swank-rpc-format-source-handler'] = {
        \ 'name': 'swank-rpc-format-source-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:format-source'."
          \ ]
      \ }

  let s:options['swank-rpc-init-project-caller'] = {
        \ 'name': 'swank-rpc-init-project-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:init-project'."
          \ ]
      \ }
  let s:options['swank-rpc-init-project-handler'] = {
        \ 'name': 'swank-rpc-init-project-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:init-project'."
          \ ]
      \ }

  let s:options['swank-rpc-repl-config-caller'] = {
        \ 'name': 'swank-rpc-repl-config-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:repl-config'."
          \ ]
      \ }
  let s:options['swank-rpc-repl-config-handler'] = {
        \ 'name': 'swank-rpc-repl-config-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:repl-config'."
          \ ]
      \ }
  let s:options['swank-rpc-repl-config-location'] = {
        \ 'name': 'swank-rpc-repl-config-location',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab' ],
        \ 'parent': 'swank-location-diff-file',
        \ 'description': [
            \ 'How to display Scala Repl.'
          \ ]
      \ }

  let s:options['swank-rpc-shutdown-server-caller'] = {
        \ 'name': 'swank-rpc-shutdown-server-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:shutdown-server'."
          \ ]
      \ }
  let s:options['swank-rpc-shutdown-server-handler'] = {
        \ 'name': 'swank-rpc-shutdown-server-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:shutdown-server'."
          \ ]
      \ }

  let s:options['swank-rpc-symbol-at-point-caller'] = {
        \ 'name': 'swank-rpc-symbol-at-point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:symbol-at-point'."
          \ ]
      \ }
  let s:options['swank-rpc-symbol-at-point-handler'] = {
        \ 'name': 'swank-rpc-symbol-at-point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:symbol-at-point'."
          \ ]
      \ }
  let s:options['swank-rpc-symbol-at-point-information'] = {
        \ 'name': 'swank-rpc-symbol-at-point-information',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['cmdline', 'preview', 'tab', 'form' ],
        \ 'parent': 'swank-information',
            \ 'description': [
            \ 'How to display the symbol-at-point information.'
          \ ]
      \ }
  let s:options['swank-rpc-symbol-at-point-location-same-file'] = {
        \ 'name': 'swank-rpc-symbol-at-point-location-same-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window' ],
        \ 'parent': 'swank-location-same-file',
        \ 'description': [
            \ 'How to jump to symbol-at-point same file different pos.'
          \ ]
      \ }
  let s:options['swank-rpc-symbol-at-point-location-diff-file'] = {
        \ 'name': 'swank-rpc-symbol-at-point-location-diff-file',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab' ],
        \ 'parent': 'swank-location-diff-file',
        \ 'description': [
            \ 'How to jump to symbol-at-point different file and pos.'
          \ ]
      \ }

  let s:options['swank-rpc-typecheck-all-caller'] = {
        \ 'name': 'swank-rpc-typecheck-all-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:typecheck-all'."
          \ ]
      \ }
  let s:options['swank-rpc-typecheck-all-handler'] = {
        \ 'name': 'swank-rpc-typecheck-all-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:typecheck-all'."
          \ ]
      \ }

  let s:options['swank-rpc-typecheck-file-caller'] = {
        \ 'name': 'swank-rpc-typecheck-file-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC caller for 'swank:typecheck-file'."
          \ ]
      \ }
  let s:options['swank-rpc-typecheck-file-handler'] = {
        \ 'name': 'swank-rpc-typecheck-file-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:typecheck-file'."
          \ ]
      \ }

  let s:options['swank-rpc-uses-of-symbol-at-point-caller'] = {
        \ 'name': 'swank-rpc-uses-of-symbol-at-point-caller',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC caller for 'swank:uses-of-symbol-at-point'."
        \ ]
      \ }
  let s:options['swank-rpc-uses-of-symbol-at-point-handler'] = {
        \ 'name': 'swank-rpc-uses-of-symbol-at-point-handler',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
            \ 'description': [
            \ "RPC handler for 'swank:uses-of-symbol-at-point'."
          \ ]
      \ }
  let s:options['swank-rpc-uses-of-symbol-at-point-location'] = {
        \ 'name': 'swank-rpc-uses-of-symbol-at-point-location',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab' ],
        \ 'parent': 'swank-location-diff-file',
        \ 'description': [
            \ 'How to jump to uses-of-symbol-at-point file and pos.'
          \ ]
      \ }

  " Event Trigger
  let s:options['swank-event-trigger-compiler-ready'] = {
        \ 'name': 'swank-event-trigger-compiler-ready',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':compiler-ready'."
        \ ]
      \ }
  let s:options['swank-event-trigger-full-typecheck-finished'] = {
        \ 'name': 'swank-event-trigger-full-typecheck-finished',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':full:typecheck-finished'."
        \ ]
      \ }
  let s:options['swank-event-trigger-indexer-ready'] = {
        \ 'name': 'swank-event-trigger-indexer-ready',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':indexer-ready'."
        \ ]
      \ }
  let s:options['swank-event-trigger-scala-notes'] = {
        \ 'name': 'swank-event-trigger-scala-notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':scala-notes'."
        \ ]
      \ }
  let s:options['swank-event-trigger-java-notes'] = {
        \ 'name': 'swank-event-trigger-java-notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':java-notes'."
        \ ]
      \ }
  let s:options['swank-event-trigger-clear-all-scala--notes'] = {
        \ 'name': 'swank-event-trigger-clear-all-scala--notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':clear-all-scala--notes'."
        \ ]
      \ }
  let s:options['swank-event-trigger-clear-all-java--notes'] = {
        \ 'name': 'swank-event-trigger-clear-all-java--notes',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC event trigger for ':clear-all-java--notes'."
        \ ]
      \ }

  " Debug Trigger
  let s:options['swank-debug-trigger-output'] = {
        \ 'name': 'swank-debug-trigger-output',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == output'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-stop'] = {
        \ 'name': 'swank-debug-trigger-stop',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == stop'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-breakpoint'] = {
        \ 'name': 'swank-debug-trigger-breakpoint',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == breakpoint'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-death'] = {
        \ 'name': 'swank-debug-trigger-death',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == death'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-start'] = {
        \ 'name': 'swank-debug-trigger-start',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == start'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-disconnect'] = {
        \ 'name': 'swank-debug-trigger-disconnect',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == disconnect'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-exception'] = {
        \ 'name': 'swank-debug-trigger-exception',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == exception'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-thread-start'] = {
        \ 'name': 'swank-debug-trigger-thread-start',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == threadStart'."
        \ ]
      \ }
  let s:options['swank-debug-trigger-thread-death'] = {
        \ 'name': 'swank-debug-trigger-thread-death',
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'description': [
            \ "RPC debut trigger for ':type == threadDeath'."
        \ ]
      \ }
endfunction

function! vimside#options#defined#Load(options)
  call s:MakeOptions()
  let a:options['defined'] = s:options
endfunction
