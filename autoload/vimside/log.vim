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


let [s:found, s:log_file] = g:vimside.GetOption('vimside-log-file-path')
if ! s:found
  echoerr "Option not found: " . 'vimside-log-file-path'
endif

let [s:found, s:log_enabled] = g:vimside.GetOption('vimside-log-enabled')
if ! s:found
  echoerr "Option not found: " . 'vimside-log-enabled'
endif

function! vimside#log#log(msg)
  if s:log_enabled
    let t = exists("*strftime")
        \ ? strftime("%Y%m%d-%H%M%S: ")    
        \ : "" . localtime() . ": "

    execute "redir >> " . s:log_file
    silent echo "INFO: ". t . a:msg
    execute "redir END"
  endif
endfunction

function! vimside#log#error(msg)
  let t = exists("*strftime")
        \ ? strftime("%Y%m%d-%H%M%S: ")    
        \ : "" . localtime() . ": "
  execute "redir >> " . s:log_file
  silent echo "ERROR: ". t . a:msg
  execute "redir END"
endfunction


