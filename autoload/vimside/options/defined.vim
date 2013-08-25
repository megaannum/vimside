
call vimside#options#option#Load()

function! s:MakeOptions()
  let l:options = {}

  " supported java and scala versions
  let l:options['vimside-java-version'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['1.5', '1.6', '1.7'],
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "1.6",
        \ 'description': [
            \ 'Supported Java versions.'
        \ ]
      \ }
  let l:options['vimside-scala-version'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['2.9.2', '2.10.*', '2.11.*' ],
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "2.10.2",
        \ 'description': [
            \ 'Supported Scala versions.'
        \ ]
      \ }

  let l:options['vimside-project-options-enabled'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE,
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0, 
        \ 'description': [
            \ 'Load a project-local user options file.'
        \ ]
      \ }
  let l:options['vimside-project-properties-enabled'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE,
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 1, 
        \ 'description': [
            \ 'Load a project-local user properties file.'
        \ ]
      \ }
  let l:options['vimside-project-options-file-name'] = {
        \ 'type': g:OPTION_STRING_TYPE,
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "options_project.vim",
        \ 'description': [
            \ 'File name of a project-local options file.'
        \ ]
      \ }
  let l:options['vimside-project-properties-file-name'] = {
        \ 'type': g:OPTION_STRING_TYPE,
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "project.properties",
        \ 'description': [
            \ 'File name of a project-local property file.'
        \ ]
      \ }

  let l:options['vimside-log-enabled'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ 'Used to enable/disable Vimside logging.'
        \ ]
      \ }
  let l:options['vimside-log-file-path'] = {
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "VIMSIDE_LOG",
        \ 'description': [
            \ 'File name of Vimside Log File.',
            \ 'If "vimside_log_file_path" is set, then this option',
            \ 'is ignored.'
          \ ]
      \ }
  let l:options['vimside-log-file-use-pid'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ 'The Vim log file has the current process id (pid) as a prefix.'
          \ ]
      \ }
  let l:options['vimside-port-file-wait-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 4,
        \ 'description': [
            \ "How long to wait after starting the Ensime Server before",
            \ "attempting to read the file containing the port number."
          \ ]
      \ }

  let l:options['vimside-use-cwd-as-output-dir'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ 'If the option "vimside_log_file_path", then if true (1),',
            \ 'the Current Working Directory is used and if false (0), then',
            \ 'the Directory containing the Ensime Config File is used.'
          \ ]
      \ }




  let l:ensime_install_path = ''
  let l:ensime_config_file_name = ''
  if g:vimside.os.is_mswin 
    let l:tmp =  $HOME . "/vimfiles/vim-addons/ensime"
    if isdirectory(l:tmp)
      let l:ensime_install_path =  l:tmp
    endif

    let l:ensime_config_file_name = '_ensime'
  else
    let l:tmp = $HOME . "/.vim/vim-addons/ensime"
    if isdirectory(l:tmp)
      let l:ensime_install_path =  l:tmp
    endif

    let l:ensime_config_file_name = '.ensime'
  endif

  let l:options['ensime-config-file-name'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': l:ensime_config_file_name,
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value':  l:ensime_install_path,
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ensime_2.9.2-0.9.8.9",
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_DIR_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'This is the full path to File where Ensime will write',
            \ 'its socket server port number. There is no default value.'
          \ ]
      \ }
  let l:options['ensime-port-file-name'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '_ensime_port',
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HOST_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "localhost",
        \ 'description': [
            \ 'The host name of the machine where the Ensime Server is.',
            \ 'running. The default value is "localhost".'
          \ ]
      \ }
  let l:options['ensime-shutdown-on-vim-exit'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ 'If set to true (1), then when Vim stops, a call is made',
            \ 'to shutdown its associated Ensime Server. If set to false (0),',
            \ 'the default, then the Ensime Server is not shutdown when',
            \ 'Vim exits.'
          \ ]
      \ }
  let l:options['ensime-port-file-max-wait'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 5,
        \ 'description': [
            \ 'How long in seconds will Vimside wait for the Ensime',
            \ 'Server. to write its socket server port number to',
            \ 'the port file.'
          \ ]
      \ }
  let l:options['ensime-log-enabled'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ 'Will the standard and error output of the Ensime Server',
            \ 'process be captured in a log file.'
          \ ]
      \ }
  let l:options['ensime-log-file-path'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_PATH_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Full path to Ensime Server log file.'
          \ ]
      \ }
  let l:options['ensime-log-file-use-pid'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ 'The Ensime log file has the process id (pid) as a prefix',
            \ 'of the Vim process that started it.'
          \ ]
      \ }
  let l:options['ensime-log-file-name'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FILE_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ENSIME_LOG",
        \ 'description': [
            \ 'If the option "ensime_log_file_path" is not set, then this',
            \ 'is the name of the file where Ensime output will be written.',
            \ 'Either the Current Working Directory or the Ensime Config',
            \ 'Directory will be used as the location of this file.',
            \ 'depending on the setting of "use_cwd_as_default_output_dir".'
          \ ]
      \ }
  let l:options['tailor-information'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['cmdline', 'preview', 'tab_window', 'form' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 'preview',
        \ 'description': [
            \ 'If an Ensime RPC call returns values than can be displayed',
            \ 'as text information and the particular RPC call does not',
            \ 'have an "information" option set, then the value of this',
            \ 'option is used to determine what display mechanism to use.'
          \ ]
      \ }
  let l:options['tailor-location-same-file'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 'same_window',
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 'same_window',
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
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ "Not expecting anything RPC socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-not-expecting-anything-update-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 10000,
        \ 'description': [
            \ "Not expecting anything CursorHold updatetime before ping."
          \ ]
      \ }
  let l:options['scheduler-not-expecting-anything-char-count'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value':  100,
        \ 'description': [
            \ "Not expecting anything CursorMoved number of characters",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-rpc-response-read-time-out'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value':  200,
        \ 'description': [
            \ "Expecting RPC response socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-expecting-rpc-response-update-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 200,
        \ 'description': [
            \ "Expecting RPC response CursorHold updatetime before ping"
          \ ]
      \ }
  let l:options['scheduler-expecting-rpc-response-char-count'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 100,
        \ 'description': [
            \ "Expecting RPC response CursorMoved number of characters",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-events-read-time-out'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 50,
        \ 'description': [
            \ "Expecting known number of events socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-expecting-events-update-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 500,
        \ 'description': [
            \ "Expecting known number of events CursorHold updatetime",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-events-char-count'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 10,
        \ 'description': [
            \ "Expecting known number of events CursorMoved number of",
            \ "characters before ping."
          \ ]
      \ }
  let l:options['scheduler-expecting-many-events-read-time-out'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 200,
        \ 'description': [
            \ "Expecting many events socket read timeout."
          \ ]
      \ }
  let l:options['scheduler-expecting-many-events-update-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 2000,
        \ 'description': [
            \ "Expecting many events CursorHold updatetime before ping"
          \ ]
      \ }
  let l:options['scheduler-expecting-many-events-char-count'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 20,
        \ 'description': [
            \ "Expecting many events CursorMoved number of characters",
            \ "before ping."
          \ ]
      \ }
  let l:options['scheduler-many-max-count-no-events'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 50,
        \ 'description': [
            \ 'If events is set to many, how many ping occur without',
            \ 'any events being received before events is set to 0.'
          \ ]
      \ }
  let l:options['scheduler-events-max-count-no-events'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 50,
        \ 'description': [
            \ 'If events is set to number of events expected,',
            \ 'how many pings occur without any events being',
            \ 'received before events is set to 0.'
          \ ]
      \ }

  
  " Start Swank RPC
  let l:options['swank-rpc-builder-add-files-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderAddFilesHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:builder-add-files'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-add-files-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderAddFilesCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:builder-add-files'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-init-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderInitHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:builder-init'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-init-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderInitCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:builder-init'."
          \ ]
      \ }

  let l:options['swank-rpc-builder-remove-files-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderRemoveFilesHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:builder-remove-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-builder-remove-files-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderRemoveFilesCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:builder-remove-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-builder-update-files-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderUpdateFilesHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:builder-update-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-builder-update-files-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:BuilderUpdateFilesCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:builder-update-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-call-completion-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:CallCompletionHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:call-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-call-completion-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:CallCompletionCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:call-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-cancel-refactor-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:CancelRefactorHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:cancel-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-cancel-refactor-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:CancelRefactorCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:cancel-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-completions-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:CompletionsHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:completions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-completions-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:CompletionsCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:completions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-connection-info-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ConnectionInfoHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:connection-info'."
          \ ]
      \ }
  
  let l:options['swank-rpc-connection-info-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ConnectionInfoCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:connection-info'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-active-vm-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugActiveVMHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-active-vm'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-active-vm-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugActiveVMCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-active-vm'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-attach-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugAttachHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-attach'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-attach-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugAttachCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-attach'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-backtrace-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugBacktraceHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-backtrace'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-backtrace-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugBacktraceCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-backtrace'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-all-breaks-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugClearAllBreaksHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-clear-all-breaks'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-all-breaks-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugClearAllBreaksCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-clear-all-breaks'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-break-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugClearBreakHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-clear-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-clear-break-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugClearBreakCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-clear-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-continue-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugContinueHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-continue'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-continue-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugContinueCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-continue'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-list-breakpoints-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugListBreakpointsHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-list-breakpoints'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-list-breakpoints-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugListBreakpointsCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-list-breakpoints'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-locate-name-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugLocateNameHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-locate-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-locate-name-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugLocateNameCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-locate-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-next-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugNextHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-next'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-next-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugNextCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-next'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-run-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugRunHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-run'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-run-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugRunCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-run'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-break-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugSetBreakHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-set-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-break-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugSetBreakCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-set-break'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-value-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugSetValueHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-set-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-set-value-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugSetValueCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-set-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-start-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStartHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-start'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-start-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStartCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-start'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-out-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStepOutHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-step-out'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-out-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStepOutCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-step-out'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStepHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-step'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-step-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStepCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-step'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-stop-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStopHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-stop'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-stop-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugStopCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-stop'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-to-string-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugToStringHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-to-string'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-to-string-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugToStringCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-to-string'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-value-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugValueHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:debug-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-debug-value-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:DebugValueCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:debug-value'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-refactor-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ExecRefactorHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:exec-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-refactor-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ExecRefactorCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:exec-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-undo-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ExecUndoHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:exec-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-exec-undo-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ExecUndoCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:exec-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-expand-selection-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ExpandSelectionHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:expand-selection'."
          \ ]
      \ }
  
  let l:options['swank-rpc-expand-selection-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ExpandSelectionCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:expand-selection'."
          \ ]
      \ }
  
  let l:options['swank-rpc-format-source-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:FormatSourceHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:format-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-format-source-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:FormatSourceCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:format-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-import-suggestions-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ImportSuggestionsHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:import-suggestions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-import-suggestions-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ImportSuggestionsCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:import-suggestions'."
          \ ]
      \ }
  
  let l:options['swank-rpc-init-project-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InitProjectHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:init-project'."
          \ ]
      \ }
  
  let l:options['swank-rpc-init-project-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InitProjectCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:init-project'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-package-by-path-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InspectPackageByPathHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:inspect-package-by-path'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-package-by-path-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InspectPackageByPathCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:inspect-package-by-path'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-at-point-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InspectTypeAtPointHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:inspect-type-at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-at-point-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InspectTypeAtPointCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:inspect-type-at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-by-id-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InspectTypeByIdHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:inspect-type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-inspect-type-by-id-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:InspectTypeByIdCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:inspect-type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-method-bytecode-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:MethodBytecodeHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:method-bytecode'."
          \ ]
      \ }
  
  let l:options['swank-rpc-method-bytecode-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:MethodBytecodeCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:method-bytecode'."
          \ ]
      \ }
  
  let l:options['swank-rpc-package-member-completion-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PackageMemberCompletionHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:package-member-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-package-member-completion-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PackageMemberCompletionCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:package-member-completion'."
          \ ]
      \ }
  
  let l:options['swank-rpc-patch-source-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PatchSourceHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:patch-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-patch-source-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PatchSourceCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:patch-source'."
          \ ]
      \ }
  
  let l:options['swank-rpc-peek-undo-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PeekUndoHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:peek-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-peek-undo-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PeekUndoCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:peek-undo'."
          \ ]
      \ }
  
  let l:options['swank-rpc-prepare-refactor-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PrepareRefactorHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:prepare-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-prepare-refactor-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PrepareRefactorCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:prepare-refactor'."
          \ ]
      \ }
  
  let l:options['swank-rpc-public-symbol-search-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PublicSymbolSearchHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:public-symbol-search'."
          \ ]
      \ }
  
  let l:options['swank-rpc-public-symbol-search-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:PublicSymbolSearchCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:public-symbol-search'."
          \ ]
      \ }
  
  let l:options['swank-rpc-remove-file-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:RemoveFileHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:remove-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-remove-file-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:RemoveFileCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:remove-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-repl-config-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ReplConfigHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:repl-config'."
          \ ]
      \ }
  
  let l:options['swank-rpc-repl-config-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ReplConfigCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:repl-config'."
          \ ]
      \ }
  
  let l:options['swank-rpc-shutdown-server-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ShutdownServerHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:shutdown-server'."
          \ ]
      \ }
  
  let l:options['swank-rpc-shutdown-server-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:ShutdownServerCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:shutdown-server'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-at-point-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:SymbolAtPointHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:symbol-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-at-point-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:SymbolAtPointCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:symbol-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-designations-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:SymbolDesignationsHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:symbol-designations'."
          \ ]
      \ }
  
  let l:options['swank-rpc-symbol-designations-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:SymbolDesignationsCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:symbol-designations'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-at-point-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeAtPointHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:type-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-at-point-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeAtPointCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:type-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-id-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeByIdHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-id-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeByIdCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:type-by-id'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name_at_point-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeByNameAtPointHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:type-by-name_at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name_at_point-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeByNameAtPointCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:type-by-name_at_point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeByNameHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:type-by-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-type-by-name-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypeByNameCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:type-by-name'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-all-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypecheckAllHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:typecheck-all'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-all-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypecheckAllCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:typecheck-all'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-files-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypecheckFilesHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:typecheck-files'."
          \ ]
      \ }

  let l:options['swank-rpc-typecheck-files-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypecheckFilesCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:typecheck-files'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-file-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypecheckFileHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:typecheck-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-typecheck-file-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:TypecheckFileCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:typecheck-file'."
          \ ]
      \ }
  
  let l:options['swank-rpc-uses-of-symbol-at-point-handler'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:UsesOfSymbolAtPointHandler',
        \ 'description': [
            \ "RPC Handler for 'swank:uses-of-symbol-at-point'."
          \ ]
      \ }
  
  let l:options['swank-rpc-uses-of-symbol-at-point-caller'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'g:UsesOfSymbolAtPointCaller',
        \ 'description': [
            \ "RPC Caller for 'swank:uses-of-symbol-at-point'."
          \ ]
      \ }
  
  
  
  " End Swank RPC
  
  



  let l:options['tailor-symbol-search-close-empty-display'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ "For 'swank:public-symbol-search' close quickfix window",
            \ "if there are no search results."
          \ ]
      \ }
  let l:options['tailor-symbol-search-do-incremental'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ "For 'swank:public-symbol-search' do incremental search.",
            \ "As search terms are entered, search results are displayed."
          \ ]
      \ }
  let l:options['tailor-symbol-search-maximum-return'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 50,
        \ 'description': [
            \ "For 'swank:public-symbol-search' do incremental search.",
            \ "Maximum search results returned by Ensime."
          \ ]
      \ }

  let l:options['tailor-expand-selection-information'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['visual', 'highlight' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 'highlight',
        \ 'description': [
            \ "RPC handler for 'swank:expand-selection' information.",
            \ "Use either Vim visual mode or highlighting."
          \ ]
      \ }
  let l:options['tailor-expand-selection-highlight-color-dark'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': '5fffff',
        \ 'description': [
            \ "RPC handler for 'swank:expand-selection' highlight color.",
            \ "when background is dark."
          \ ]
      \ }
  let l:options['tailor-expand-selection-highlight-color-light'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': '5fffff',
        \ 'description': [
            \ "RPC handler for 'swank:expand-selection' highlight color.",
            \ "when background is light."
          \ ]
      \ }


  let l:options['tailor-repl-config-location'] = {
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
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Display all of the compiler error messages in quickfix window",
            \ "if set to true. If false, then for each error, only first",
            \ "line of the compiler error message is shown."
          \ ]
      \ }
  let l:options['tailor-sbt-error-read-size'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_POSITIVE_NUMBER_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 10000,
        \ 'description': [
            \ 'Size of Ensime socket read buffer when getting the results',
            \ 'of an SBT compiliation. This should be large because there',
            \ 'might be a lot of errors and a partial read may fail when',
            \ 'when converting errors to Quickfix window entries.'
          \ ]
      \ }
  let l:options['tailor-sbt-error-use-signs'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Whether or not to use signs when SBT is displaying compile errors.'
          \ ]
      \ }
  
  let l:options['tailor-full-typecheck-finished-use-signs'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ 'Whether or not to use signs when type check finished is displaying compile errors.'
          \ ]
      \ }


  let l:options['tailor-symbol-at-point-information'] = {
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
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to jump to symbol-at-point different file and pos.'
          \ ]
      \ }

  "-------------------------------------------------------
  " ActWin Display Enable Options
  let l:options['tailor-actwin-display-scala-sign-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'Scala code augmented with sign enabled.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'Scala code augmented with color-line enabled.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'Scala code augmented with color-column enabled.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'ActWin line augmented with cursor-line enabled.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'ActWin line augmented with highlight-line enabled.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'ActWin line augmented with sign enabled.'
          \ ]
      \ }

  " ActWin Display On Options
  let l:options['tailor-actwin-display-scala-sign-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'Scala code augmented with sign on at start-up.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'Scala code augmented with color-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'Scala code augmented with color-column on at start-up.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'ActWin line augmented with cursor-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'ActWin line augmented with highlight-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '0',
        \ 'description': [
            \ 'Is the base ActWin display of',
            \ 'ActWin line augmented with sign on at start-up.'
          \ ]
      \ }
  
  " ActWin Command Options
  let l:options['tailor-actwin-cmds-scala-cmd-first'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cr",
        \ 'description': [
            \ 'Goto the first line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-cmd-last'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cl",
        \ 'description': [
            \ 'Goto the last line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-cmd-previous'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cp",
        \ 'description': [
            \ 'Goto the previous line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-cmd-next'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cn",
        \ 'description': [
            \ 'Goto the next line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-cmd-enter'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ce",
        \ 'description': [
            \ 'Command to enter ActWin from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-cmd-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ccd",
        \ 'description': [
            \ 'Delete current line in ActWin. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-cmd-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ccl",
        \ 'description': [
            \ 'Close ActWin. Command called from Scala window'
          \ ]
      \ }

  let l:options['tailor-actwin-cmds-scala-map-first'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>cr",
        \ 'description': [
            \ 'Goto the first line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-map-last'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>cl",
        \ 'description': [
            \ 'Goto the last line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-map-previous'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>cp",
        \ 'description': [
            \ 'Goto the previous line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-map-next'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>cn",
        \ 'description': [
            \ 'Goto the next line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-map-enter'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>ce",
        \ 'description': [
            \ 'Key mapping to enter ActWin from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-map-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>ccd",
        \ 'description': [
            \ 'Delete current line in ActWin. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-scala-map-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<Leader>ccl",
        \ 'description': [
            \ 'Close ActWin. Key mapping called from Scala window'
          \ ]
      \ }

  let l:options['tailor-actwin-cmds-actwin-map-actwin-map-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<F2>",
        \ 'description': [
            \ 'Show the current key mappings for the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-scala-cmd-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<F3>",
        \ 'description': [
            \ 'Mapping to show the current commands for Scala windows.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-scala-map-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<F4>",
        \ 'description': [
            \ 'Mapping to show the current key mappings for Scala windows.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-help'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<F1>",
        \ 'description': [
            \ 'Mapping to invoke help for the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-select'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': [ "<CR>", "<2-LeftMouse>"],
        \ 'description': [
            \ 'Mapping to select the action associated with the current line.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-enter-mouse'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "<LeftMouse> <LeftMouse>",
        \ 'description': [
            \ 'Maping for mouse action to goto a new line current line.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-top'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': [ "gg", "1G", "<PageUp>"],
        \ 'description': [
            \ 'Mapping to goto the first line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-bottom'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': [ "G", "<PageDown>"],
        \ 'description': [
            \ 'Mapping to goto the last line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-down'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': [ "j", "<Down>"],
        \ 'description': [
            \ 'Mapping to goto the next line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-up'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': [ "k", "<Up>"],
        \ 'description': [
            \ 'Mapping to goto the previous line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "dd",
        \ 'description': [
            \ 'Mapping to delete the current line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-actwin-cmds-actwin-map-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "q",
        \ 'description': [
            \ 'Mapping to close the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }

  " ActWin Display Toggle Options
  let l:options['tailor-actwin-display-scala-sign-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ts",
        \ 'description': [
            \ 'Mapping to toggle Scala Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TS",
        \ 'description': [
            \ 'Command to toggle Scala Window sign markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TS",
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ts",
        \ 'description': [
            \ 'Mapping to toggle Scala Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TS",
        \ 'description': [
            \ 'Command to toggle Scala Window sign markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TS",
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcl",
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TCL",
        \ 'description': [
            \ 'Command to toggle Scala Window color-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcl",
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcl",
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TCL",
        \ 'description': [
            \ 'Command to toggle Scala Window color-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcl",
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcc",
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-column markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TCC",
        \ 'description': [
            \ 'Command to toggle Scala Window color-column markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcc",
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-column markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcc",
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-column markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "TCC",
        \ 'description': [
            \ 'Command to toggle Scala Window color-column markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-column-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "tcc",
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-column markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wc",
        \ 'description': [
            \ 'Mapping to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "WC",
        \ 'description': [
            \ 'Command to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wc",
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wc",
        \ 'description': [
            \ 'Mapping to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "WC",
        \ 'description': [
            \ 'Command to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-cursor-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wc",
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wh",
        \ 'description': [
            \ 'Mapping to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "WH",
        \ 'description': [
            \ 'Command to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wh",
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wh",
        \ 'description': [
            \ 'Mapping to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "WH",
        \ 'description': [
            \ 'Command to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-highlight-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "wh",
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ws",
        \ 'description': [
            \ 'Mapping to toggle ActWin Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "WS",
        \ 'description': [
            \ 'Command to toggle ActWin Window sign markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ws",
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ws",
        \ 'description': [
            \ 'Mapping to toggle ActWin Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "WS",
        \ 'description': [
            \ 'Command to toggle ActWin Window sign markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ws",
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }


  " ActWin Display Color Options
  let l:options['tailor-actwin-display-scala-sign-kinds-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "E>",
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Todo",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Error",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "error".'
          \ ]
      \ }

  let l:options['tailor-actwin-display-scala-sign-kinds-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "W>",
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "warn.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Todo",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "warn.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "StatusLine",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "warn.'
          \ ]
      \ }

  let l:options['tailor-actwin-display-scala-sign-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "I>",
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "DiffAdd",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ColorColumn",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-actwin-display-scala-sign-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "M>",
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Search",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-sign-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Ignore",
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "marker".'
          \ ]
      \ }


  let l:options['tailor-actwin-display-scala-color-line-kinds-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "E>",
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Error",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Error",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "W>",
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Search",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "SpellCap",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "warn".'
          \ ]
      \ }

  let l:options['tailor-actwin-display-scala-color-line-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "II",
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "DiffAdd",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ColorColumn",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "MM",
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Search",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-scala-color-line-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Search",
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "marker".'
          \ ]
      \ }

  let l:options['tailor-actwin-display-scala-color-column-color-column'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cterm=reverse",
        \ 'description': [
            \ 'Scala highlight definition for ColorColumn group.'
          \ ]
      \ }

  let l:options['tailor-actwin-display-actwin-cursor-line-highlight'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cterm=bold ctermfg=DarkYellow ctermbg=Cyan",
        \ 'description': [
            \ 'ActWin highlight definition for CursorLine group.'
          \ ]
      \ }

  let l:options['tailor-actwin-display-actwin-highlight-line-highlight'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "cterm=bold ctermfg=87",
        \ 'description': [
            \ 'ActWin highlight definition for highlight line group.'
          \ ]
      \ }

  let l:options['tailor-actwin-display-actwin-sign-kinds-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "E>",
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Todo",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Error",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "error".'
          \ ]
      \ }

  let l:options['tailor-actwin-display-actwin-sign-kinds-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "W>",
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "warn.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Todo",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "warn.'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "StatusLine",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "warn.'
          \ ]
      \ }

  let l:options['tailor-actwin-display-actwin-sign-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "I>",
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "DiffAdd",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "ColorColumn",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-actwin-display-actwin-sign-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "M>",
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Search",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-actwin-display-actwin-sign-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': "Ignore",
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "marker".'
          \ ]
      \ }


  " ------------------------------------------------------
  " uses-of-symbol-at-point Options
  let l:options['tailor-uses-of-symbol-at-point-location'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to jump to uses-of-symbol-at-point file and pos.'
          \ ]
      \ }

  " TODO use \ 'parent': 'parent option',
  let l:options['tailor-uses-of-symbol-at-point-window'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['actwin', 'quickfix' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 'actwin',
        \ 'description': [
            \ 'Whether to use the quickfix window to display uses or if all',
            \ 'of the uses are in the same window use the locationlist ',
            \ 'window.',
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-use-signs'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Whether or not to use signs when displaying uses.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-use-sign-kind-marker'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Whether or not to use sign kind "marker" for current line.'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-actwin-display-scala-sign-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with sign enabled.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-scala-color-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-line enabled.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-scala-color-column-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-column enabled.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-actwin-cursor-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with cursor-line enabled.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-actwin-highlight-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with highlight-line enabled.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-actwin-sign-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with sign enabled.'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-actwin-display-scala-sign-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with sign on at start-up.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-scala-color-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-scala-color-column-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-column on at start-up.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-actwin-cursor-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with cursor-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-actwin-highlight-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with highlight-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-display-actwin-sign-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with sign on at start-up.'
          \ ]
      \ }
  

  " uses-of-symbol-at-point Command Options
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-first'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-first',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the first line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-last'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-last',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the last line. Command called from Scala window'
          \ ]
      \ }
if 0 " XXXXXXXXXX
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-previous'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-previous',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the previous line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-next'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-next',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the next line. Command called from Scala window'
          \ ]
      \ }
endif " XXXXXXXXXX
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-previous'] = {
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-previous'
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-next'] = {
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-next'
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-enter'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-enter',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to enter ActWin from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-delete',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Delete current line in ActWin. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-close',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Close ActWin. Command called from Scala window'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-first'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-first',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the first line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-last'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-last',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the last line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-previous'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-previous',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the previous line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-next'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-next',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the next line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-enter'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-enter',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Key mapping to enter ActWin from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-delete',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Delete current line in ActWin. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-close',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Close ActWin. Key mapping called from Scala window'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-actwin-map-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-actwin-map-show',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Show the current key mappings for the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-scala-cmd-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-scala-cmd-show',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Show the current commands for Scala windows.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-scala-map-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-scala-map-show',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Show the current key mappings for Scala windows.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-help'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-help',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Invoke help for the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-select'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-select',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Select the action associated with the current line.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-enter-mouse'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-enter-mouse',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mouse action to goto a new line current line.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-top'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-top',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the first line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-bottom'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-bottom',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the last line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-down'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-down',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the next line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-up'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-up',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the previous line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-delete',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Delete the current line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-close',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Close the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }

  " uses-of-symbol-at-point Display Toggle Options
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window sign markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window sign markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-column markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-column markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-column markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-column markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-column markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-column markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window sign markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window sign markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  
  " uses-of-symbol-at-point Display Color Options
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-info-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-info-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-info-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-marker-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-marker-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-sign-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-marker-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "marker".'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-info-text',
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-info-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-info-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-marker-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-marker-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-marker-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "marker".'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-scala-color-column-color-column'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-color-column',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition for ColorColumn group.'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-actwin-cursor-line-highlight'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-highlight',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition for CursorLine group.'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-actwin-highlight-line-highlight'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-highlight',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition for highlight line group.'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-info-text',
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-info-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-info-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-marker-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-marker-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-marker-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "marker".'
          \ ]
      \ }
  
  " ------------------------------------------------------
  " show-errors-and_warning Options
  let l:options['tailor-show-errors-and-warnings-use-signs'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ 'Whether or not to use signs when compiler is displaying compile errors.'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-location'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['same_window', 'split_window', 'vsplit_window', 'tab_window' ],
        \ 'parent': 'tailor-location-diff-file',
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'description': [
            \ 'How to jump to show-errors-and-warning file and pos.'
          \ ]
      \ }

  " TODO use \ 'parent': 'parent option',
  let l:options['tailor-show-errors-and-warning-window'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_ENUM_KIND, 
        \ 'enum': ['actwin', 'quickfix' ],
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 'actwin',
        \ 'description': [
            \ 'Whether to use the quickfix window to display uses or if all',
            \ 'of the uses are in the same window use the locationlist ',
            \ 'window.',
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-use-signs'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Whether or not to use signs when displaying uses.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-use-sign-kind-marker'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': '1',
        \ 'description': [
            \ 'Whether or not to use sign kind "marker" for current line.'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-actwin-display-scala-sign-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with sign enabled.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-scala-color-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-line enabled.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-scala-color-column-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-column enabled.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-actwin-cursor-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with cursor-line enabled.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-actwin-highlight-line-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with highlight-line enabled.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-actwin-sign-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-enable',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with sign enabled.'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-actwin-display-scala-sign-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with sign on at start-up.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-scala-color-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-scala-color-column-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'Scala code augmented with color-column on at start-up.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-actwin-cursor-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with cursor-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-actwin-highlight-line-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with highlight-line on at start-up.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-display-actwin-sign-on'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-on',
        \ 'description': [
            \ 'Is the Use Of Symbol At Point ActWin display of',
            \ 'ActWin line augmented with sign on at start-up.'
          \ ]
      \ }


  " show-errors-and_warning Command Options
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-first'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-first',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the first line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-last'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-last',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the last line. Command called from Scala window'
          \ ]
      \ }
if 0 " XXXXXXXXXX
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-previous'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-previous',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the previous line. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-next'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-next',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the next line. Command called from Scala window'
          \ ]
      \ }
endif " XXXXXXXXXX
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-previous'] = {
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-previous'
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-next'] = {
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-next'
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-enter'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-enter',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to enter ActWin from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-delete',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Delete current line in ActWin. Command called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-cmd-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-cmd-close',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Close ActWin. Command called from Scala window'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-first'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-first',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the first line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-last'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-last',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the last line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-previous'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-previous',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the previous line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-next'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-next',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the next line. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-enter'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-enter',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Key mapping to enter ActWin from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-delete',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Delete current line in ActWin. Key mapping called from Scala window'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-scala-map-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-scala-map-close',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Close ActWin. Key mapping called from Scala window'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-actwin-map-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-actwin-map-show',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Show the current key mappings for the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-scala-cmd-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-scala-cmd-show',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Show the current commands for Scala windows.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-scala-map-show'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-scala-map-show',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Show the current key mappings for Scala windows.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-help'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-help',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Invoke help for the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-select'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-select',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Select the action associated with the current line.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-enter-mouse'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-enter-mouse',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mouse action to goto a new line current line.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-top'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-top',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the first line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-bottom'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-bottom',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the last line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-down'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-down',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the next line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-up'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-up',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Goto the previous line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-delete'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-delete',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Delete the current line in the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-actwin-cmds-actwin-map-close'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-cmds-actwin-map-close',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Close the ActWin.',
            \ 'Called from ActWin.'
          \ ]
      \ }
  
  " show-errors-and_warning Display Toggle Options
  let l:options['tailor-show-errors-and-warning-display-scala-sign-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window sign markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window sign markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-column-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-column markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-column-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-column markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-column-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-column markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-column-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle Scala Window color-column markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-column-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle Scala Window color-column markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-column-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle Scala Window color-column markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window cursor-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window cursor-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window highlight-line markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window highlight-line markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-toggle-actwin-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-actwin-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-toggle-actwin-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-actwin-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window sign markings.',
            \ 'Called from ActWin. First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-toggle-actwin-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-actwin-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window sign markings.',
            \ 'Called from ActWin.',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-toggle-scala-map'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-scala-map',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Mapping to toggle ActWin Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses nnoremap and nunmap.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-toggle-scala-cmd'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-scala-cmd',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Command to toggle ActWin Window sign markings.',
            \ 'Called from Scala First letter must be upper case.',
            \ 'Uses command and delcommand.'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-toggle-scala-abbr'] = {
        \ 'type': g:OPTION_LIST_OR_STRING_TYPE, 
        \ 'kind': g:OPTION_CMD_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-toggle-scala-abbr',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Abbreviation to toggle ActWin Window sign markings.',
            \ 'Called from Scala',
            \ 'Uses cabbrev and cunabbrev.'
          \ ]
      \ }
  
  " show-errors-and_warning Display Color Options
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-error-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-error-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-error-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-warn-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-warn-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-warn-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "warn".'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-info-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-info-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-info-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-marker-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for sign text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-marker-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-sign-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-sign-kinds-marker-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for sign linehl',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-error-text',
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-error-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-error-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-warn-text',
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-warn-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-warn-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "warn".'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-info-text',
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-info-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-info-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-marker-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala two charcters text used for color-line text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-marker-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-scala-color-line-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-line-kinds-marker-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition or group name for color-line linehl',
            \ 'of kind "marker".'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-scala-color-column-color-column'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'parent': 'tailor-actwin-display-scala-color-column-color-column',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'Scala highlight definition for ColorColumn group.'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-actwin-cursor-line-highlight'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-cursor-line-highlight',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition for CursorLine group.'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-actwin-highlight-line-highlight'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-highlight-line-highlight',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition for highlight line group.'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-error-text',
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-error-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-error-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "error".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-warn-text',
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-warn-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "warn".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-warn-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "warn".'
          \ ]
      \ }


  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-info-text',
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-info-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl',
            \ 'of kind "info".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-info-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "info".'
          \ ]
      \ }

  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-marker-text',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin two charcters text used for sign text',
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-marker-texthl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign texthl'.
            \ 'of kind "marker".'
          \ ]
      \ }
  let l:options['tailor-show-errors-and-warning-display-actwin-sign-kinds-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_HIGHLIGHT_OR_GROUP_NAME_KIND, 
        \ 'parent': 'tailor-actwin-display-actwin-sign-kinds-marker-linehl',
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'description': [
            \ 'ActWin highlight definition or group name for sign linehl',
            \ 'of kind "marker".'
          \ ]
      \ }

  " Sign
  let l:options['sign-quickfix-error-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Error',
        \ 'description': [
            \ 'Quickfix Error linehl.'
          \ ]
      \ }
  
  let l:options['sign-quickfix-error-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'E>',
        \ 'description': [
            \ 'Quickfix Error text'
          \ ]
      \ }

  let l:options['sign-quickfix-error-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Todo',
        \ 'description': [
            \ 'Quickfix Error texthl.'
          \ ]
      \ }

  let l:options['sign-quickfix-warn-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'StatusLine',
        \ 'description': [
            \ 'Quickfix Warn linehl.'
          \ ]
      \ }

  let l:options['sign-quickfix-warn-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'W>',
        \ 'description': [
            \ 'Quickfix Warn text'
          \ ]
      \ }

  let l:options['sign-quickfix-warn-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Todo',
        \ 'description': [
            \ 'Quickfix Warn texthl'
          \ ]
      \ }

  let l:options['sign-quickfix-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'DiffAdd',
        \ 'description': [
            \ 'Quickfix Info linehl.'
          \ ]
      \ }

  let l:options['sign-quickfix-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'I>',
        \ 'description': [
            \ 'Quickfix Info text'
          \ ]
      \ }

  let l:options['sign-quickfix-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'TODO',
        \ 'description': [
            \ 'Quickfix Info texthl.'
          \ ]
      \ }

  let l:options['sign-quickfix-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Search',
        \ 'description': [
            \ 'Quickfix Marker linehl.'
          \ ]
      \ }

  let l:options['sign-quickfix-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'M>',
        \ 'description': [
            \ 'Quickfix Marker text'
          \ ]
      \ }

  let l:options['sign-quickfix-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Ignore',
        \ 'description': [
            \ 'Quickfix Marker texthl.'
          \ ]
      \ }

  let l:options['sign-locationlist-info-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'DiffAdd',
        \ 'description': [
            \ 'LocationList Info linehl.'
          \ ]
      \ }

  let l:options['sign-locationlist-info-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'I>',
        \ 'description': [
            \ 'LocationList Info text'
          \ ]
      \ }

  let l:options['sign-locationlist-info-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'TODO',
        \ 'description': [
            \ 'LocationList Info texthl.'
          \ ]
      \ }

  let l:options['sign-locationlist-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Search',
        \ 'description': [
            \ 'LocationList Marker linehl.'
          \ ]
      \ }

  let l:options['sign-locationlist-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'M>',
        \ 'description': [
            \ 'LocationList Marker text'
          \ ]
      \ }

  let l:options['sign-locationlist-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Ignore',
        \ 'description': [
            \ 'LocationList Marker texthl'
          \ ]
      \ }

  let l:options['sign-debug-active-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'DiffText',
        \ 'description': [
            \ 'Debug Active linehl.'
          \ ]
      \ }

  let l:options['sign-debug-active-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'A>',
        \ 'description': [
            \ 'Debug Active text'
          \ ]
      \ }

  let l:options['sign-debug-active-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'SpellCap',
        \ 'description': [
            \ 'Debug Active texthl'
          \ ]
      \ }

  let l:options['sign-debug-pending-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'DiffAdd',
        \ 'description': [
            \ 'Debug Pending linehl.'
          \ ]
      \ }

  let l:options['sign-debug-pending-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'P>',
        \ 'description': [
            \ 'Debug Pending text'
          \ ]
      \ }

  let l:options['sign-debug-pending-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'DiffDelete',
        \ 'description': [
            \ 'Debug Pending texthl'
          \ ]
      \ }

  let l:options['sign-debug-marker-linehl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Search',
        \ 'description': [
            \ 'Debug Marker linehl.'
          \ ]
      \ }

  let l:options['sign-debug-marker-text'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'M>',
        \ 'description': [
            \ 'Debug Marker text'
          \ ]
      \ }

  let l:options['sign-debug-marker-texthl'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'Ignore',
        \ 'description': [
            \ 'Debug Marker texthl'
          \ ]
      \ }

  let l:options['sign-start-place-id'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 2656,
        \ 'description': [
            \ 'The value of the first sign id. Each subsequent sign',
            \ 'id has a value one more than its predecessor'
          \ ]
      \ }


  " Event Trigger
  let l:options['swank-event-trigger-compiler-ready'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#compiler_ready#Handle',
        \ 'description': [
            \ "RPC event trigger for ':compiler-ready'."
        \ ]
      \ }
  let l:options['swank-event-trigger-full-typecheck-finished'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#full_typecheck_finished#Handle',
        \ 'description': [
            \ "RPC event trigger for ':full:typecheck-finished'."
        \ ]
      \ }
  let l:options['swank-event-trigger-indexer-ready'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#full_typecheck_finished#Handle',
        \ 'description': [
            \ "RPC event trigger for ':indexer-ready'."
        \ ]
      \ }
  let l:options['swank-event-trigger-scala-notes'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#scala_notes#Handle',
        \ 'description': [
            \ "RPC event trigger for ':scala-notes'."
        \ ]
      \ }
  let l:options['swank-event-trigger-java-notes'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#java_notes#Handle',
        \ 'description': [
            \ "RPC event trigger for ':java-notes'."
        \ ]
      \ }
  let l:options['swank-event-trigger-clear-all-scala-notes'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#clear_all_scala_notes#Handle',
        \ 'description': [
            \ "RPC event trigger for ':clear-all-scala-notes'."
        \ ]
      \ }
  let l:options['swank-event-trigger-clear-all-java-notes'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#swank#event#clear_all_java_notes#Handle',
        \ 'description': [
            \ "RPC event trigger for ':clear-all-java-notes'."
        \ ]
      \ }

  " Debug Trigger
  let l:options['swank-debug-trigger-output'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#OutputEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == output'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-stop'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#StopEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == stop'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-breakpoint'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#BreakPointEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == breakpoint'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-death'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#DeathEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == death'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-start'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#StartEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == start'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-disconnect'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#DisconnectEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == disconnect'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-exception'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#ExceptionEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == exception'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-thread-start'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#ThreadStartEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == threadStart'."
        \ ]
      \ }
  let l:options['swank-debug-trigger-thread-death'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_FUNCTION_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 'vimside#command#debug#ThreadDeathEvent',
        \ 'description': [
            \ "RPC debut trigger for ':type == threadDeath'."
        \ ]
      \ }

  " Hover
  let l:options['tailor-hover-updatetime'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 600,
        \ 'description': [
            \ "How long in milliseconds before Hover CursorHold event called."
        \ ]
      \ }
  let l:options['tailor-hover-max-char-mcounter'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_CHAR_COUNT_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ "How many characters entered before Hover CurosrMoved",
            \ "event called."
        \ ]
      \ }
  let l:options['vimside-hover-balloon-enabled'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Is the GVim Symbol-name balloon enabled."
        \ ]
      \ }
  let l:options['tailor-hover-cmdline-job-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 300,
        \ 'description': [
            \ "Job time in milliseconds for Hover Command Line execution."
        \ ]
      \ }
  let l:options['vimside-hover-term-balloon-enabled'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Is the Vim Symbol-name term balloon enabled."
        \ ]
      \ }
  let l:options['tailor-hover-term-balloon-fg'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': "red",
        \ 'description': [
            \ "Foreground color for term balloon (symbolic name",
            \ "or hex-value)."
        \ ]
      \ }
  let l:options['tailor-hover-term-balloon-bg'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'kind': g:OPTION_COLOR_KIND, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': "white",
        \ 'description': [
            \ "Background color for term balloon (symbolic name",
            \ "or hex-value)."
        \ ]
      \ }
  let l:options['tailor-hover-term-job-time'] = {
        \ 'type': g:OPTION_NUMBER_TYPE, 
        \ 'kind': g:OPTION_TIME_KIND, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': 300,
        \ 'description': [
            \ "Job time in milliseconds for Hover Term execution."
        \ ]
      \ }
  
  " Browser
  let l:options['tailor-browser-keys-platform'] = {
        \ 'type': g:OPTION_LIST_TYPE, 
        \ 'kind': g:OPTION_KEY_KIND, 
        \ 'templates': {
                \ 'commands': 'tailor-browser-{key}-commands',
                \ 'url_funcs': 'tailor-browser-{key}-url-funcname'
                \ }, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': ['unix', 'cygwin', 'mswin', 'macunix'],
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
        \ 'type': g:OPTION_LIST_TYPE, 
        \ 'kind': g:OPTION_KEY_KIND, 
        \ 'templates': {
                \ 'url_base': 'tailor-show-doc-{key}{version}-url-base',
                \ 'regex': 'tailor-show-doc-{key}-regex',
                \ 'funcref': 'tailor-show-doc-{key}-func-ref'
                \ }, 
        \ 'scope': g:OPTION_STATIC_SCOPE, 
        \ 'value': ['java', 'scala', 'scala-compiler', 'scala-reflect', 'android'],
        \ 'description': [
            \ "Keys for generating Browser Component Options."
        \ ]
      \ }
  
  " Forms
  let l:options['forms-use'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ "When there are multiple implementations, use the",
            \ "Forms-based one if available otherwise use the",
            \ "Vim-based implementation."
        \ ]
      \ }

  let l:options['tailor-forms-sourcebrowser-open-in-tab'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Open the Forms sourcebrowser in its own tab."
        \ ]
      \ }
  
  " Typecheck file on write
  let l:options['tailor-type-check-file-on-write'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 0,
        \ 'description': [
            \ "Typecheck a file when it is written."
        \ ]
      \ }
  
  " Refactor Rename
  let l:options['tailor-refactor-rename-pattern-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Refactor rename identifier matching pattern enable."
        \ ]
      \ }
  let l:options['tailor-refactor-rename-pattern'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': '[^ =:;()[\]]\+',
        \ 'description': [
            \ "Refactor rename identifier matching pattern."
        \ ]
      \ }
  
  " Refactor Extract Local
  let l:options['tailor-refactor-extract-local-pattern-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Refactor extract local identifier matching pattern enable."
        \ ]
      \ }
  let l:options['tailor-refactor-extract-local-pattern'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': '[^ =:;()[\]]\+',
        \ 'description': [
            \ "Refactor extract local identifier matching pattern."
        \ ]
      \ }
  
  " Refactor Extract Method
  let l:options['tailor-refactor-extract-method-pattern-enable'] = {
        \ 'type': g:OPTION_BOOLEAN_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': 1,
        \ 'description': [
            \ "Refactor extract method identifier matching pattern enable."
        \ ]
      \ }
  let l:options['tailor-refactor-extract-method-pattern'] = {
        \ 'type': g:OPTION_STRING_TYPE, 
        \ 'scope': g:OPTION_DYNAMIC_SCOPE, 
        \ 'value': '[^ =:;()[\]]\+',
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

function! vimside#options#defined#SetUndefined(options)
  let l:FuncrefJava = function("vimside#command#show_doc_symbol_at_point#MakeUrlJava")
  let l:FuncrefScala = function("vimside#command#show_doc_symbol_at_point#MakeUrlScala")


  let a:options["tailor-browser-unix-commands"] = ['xdg-open', 'firefox', 'opera']
  let a:options["tailor-browser-unix-url-funcname"] = ['shellescape', 'shellescape', 'shellescape']
  let a:options["tailor-browser-cygwin-commands"] = ['cygstart']
  let a:options["tailor-browser-cygwin-url-funcname"] = ['shellescape']
  let a:options["tailor-browser-mswin-commands"] = ['cmd.exe', 'firefox']
  let a:options["tailor-browser-mswin-url-funcname"] = ['shellescape', 'shellescape']
  let a:options["tailor-browser-macunix-commands"] = ['open']
  let a:options["tailor-browser-macunix-url-funcname"] = ['shellescape']

  let a:options['tailor-show-doc-java1.5-url-base'] = "http://docs.oracle.com/javase/5/docs/api/"
  let a:options['tailor-show-doc-java1.6-url-base'] = "http://docs.oracle.com/javase/6/docs/api/"
  let a:options['tailor-show-doc-java1.7-url-base'] = "http://docs.oracle.com/javase/7/docs/api/"
  let a:options['tailor-show-doc-java-regex'] = '^java.'
  let a:options['tailor-show-doc-java-func-ref'] = l:FuncrefJava


  let a:options['tailor-show-doc-scala2.9.2-url-base'] = 'http://www.scala-lang.org/api/current/index.html'
  let a:options['tailor-show-doc-scala2.10.0-url-base'] = 'http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/library/index.html'
  let a:options['tailor-show-doc-scala-regex'] = '^scala.'
  let a:options['tailor-show-doc-scala-func-ref'] = l:FuncrefScala
  let a:options['tailor-show-doc-scala-compiler2.10.0-url-base'] = 'http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/compiler/index.html'
  let a:options['tailor-show-doc-scala-compiler-regex'] = '^scala.tools.'
  let a:options['tailor-show-doc-scala-compiler-func-ref'] = l:FuncrefScala
  let a:options['tailor-show-doc-scala-reflect2.10.0-url-base'] = 'http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/compiler/index.html'
  let a:options['tailor-show-doc-scala-reflect-regex'] = '^scala.reflect.'
  let a:options['tailor-show-doc-scala-reflect-func-ref'] = l:FuncrefScala
  let a:options['tailor-show-doc-android-url-base'] = "http://developer.android.com/reference/"
  let a:options['tailor-show-doc-android-regex'] = '^android.'
  let a:options['tailor-show-doc-android-func-ref'] = l:FuncrefJava
  let a:options['tailor-sbt-use-signs'] = 1

endfunction
