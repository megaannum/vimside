" ============================================================================
" log.vim
"
" File:          log.vim
" Summary:       Logger for Vimside
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================


if exists("g:vimside")

  let [s:found, s:log_file] = g:vimside.GetOption('vimside-log-file-path')
  if ! s:found
    echoerr "Option not found: " . 'vimside-log-file-path'
  endif
  let [s:found, s:log_file_use_pid] = g:vimside.GetOption('vimside-log-file-use-pid')
  if s:found
    if s:log_file_use_pid
      let s:log_file .= "_". getpid()
    endif
  else
    echoerr "Option not found: " . 'vimside-log-file-use-pid'
  endif

  let [s:found, s:log_enabled] = g:vimside.GetOption('vimside-log-enabled')
  if ! s:found
    echoerr "Option not found: " . 'vimside-log-enabled'
  endif

  function! vimside#log#log(msg)
    " TODO convert to load/optimize version of getting time
    if s:log_enabled
      let t = exists("*strftime")
          \ ? strftime("%Y%m%d-%H%M%S: ")    
          \ : "" . localtime() . ": "

      execute "redir >> " . s:log_file
      silent echo "INFO: ". t . a:msg
      execute "redir END"
    endif
  endfunction

  function! vimside#log#warn(msg)
    " TODO convert to load/optimize version of getting time
    if s:log_enabled
      let t = exists("*strftime")
          \ ? strftime("%Y%m%d-%H%M%S: ")    
          \ : "" . localtime() . ": "

      execute "redir >> " . s:log_file
      silent echo "WARN: ". t . a:msg
      execute "redir END"
    endif
  endfunction

  function! vimside#log#error(msg)
    " TODO convert to load/optimize version of getting time
    let t = exists("*strftime")
          \ ? strftime("%Y%m%d-%H%M%S: ")    
          \ : "" . localtime() . ": "
    execute "redir >> " . s:log_file
    silent echo "ERROR: ". t . a:msg
    execute "redir END"
  endfunction

else
  let s:CWD = getcwd()

  function! vimside#log#log(msg)
    execute "redir >> ". s:CWD ."/VS_LOG"
    silent echo "INFO: ". a:msg
    execute "redir END"
  endfunction

  function! vimside#log#warn(msg)
    execute "redir >> ". s:CWD ."/VS_LOG"
    silent echo "WARN: ". a:msg
    execute "redir END"
  endfunction

  function! vimside#log#error(msg)
    execute "redir >> ". s:CWD ."/VS_LOG"
    silent echo "ERROR: ". a:msg
    execute "redir END"
  endfunction
endif
