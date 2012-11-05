" ============================================================================
" vimside#option#default.vim
"
" File:          vimside#option#default.vim
" Summary:       Default Options for VimSIde
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"   Default options for VimSIde - and nothing else
"   Options:
"     ensime-install-path
"     TODO: make following a user option or search for it
"     ensime-dist-dir
"     ensime-log-file-name
"     ensime-port-file-max-wait
" ============================================================================

" default location of Ensime files/directories
function! vimside#options#default#Load(option)
  call a:option.Set("test-ensime-file-use", 0)

  if  has('win16') || has('win32') || has('win64')
    call a:option.Set("ensime-install-path", $HOME . "/vimfiles/vim-addons/ensime")
    call a:option.Set("ensime-config-file-name", "_ensime")
  else
    call a:option.Set("ensime-install-path", $HOME . "/.vim/vim-addons/ensime")
    call a:option.Set("ensime-config-file-name", ".ensime")
  endif
  call a:option.Set("use-cwd-as-default-output-dir", 0)

  " call a:option.Set("ensime-dist-dir", "dist_2.9.2")
  call a:option.Set("ensime-dist-dir", "ensime_2.9.2-0.9.8.1")
  
  call a:option.Set("ensime-log-enabled", 0)
  call a:option.Set("ensime-log-file-name", "ENSIME_LOG")
  call a:option.Set("ensime-port-file-max-wait", 5)
  call a:option.Set("ensime-host-name", "localhost")

  call a:option.Set("vimside-log-enabled", 0)
  call a:option.Set("vimside-log-file-name", "VIMSIDE_LOG")

  call a:option.Set("swank-information", 'preview')
  call a:option.Set("swank-location-same-file", 'same_window')
  call a:option.Set("swank-location-diff-file", 'same_window')

  " add default swank rpc and event ping info
  call a:option.Set('swank-rpc-expecting-read-timeout', 200)
  call a:option.Set('swank-rpc-expecting-updatetime', 100)
  call a:option.Set('swank-rpc-expecting-char-count', 10)
  call a:option.Set('swank-rpc-not-expecting-read-timeout', 0)
  call a:option.Set('swank-rpc-not-expecting-updatetime', 10000)
  call a:option.Set('swank-rpc-not-expecting-char-count', 50)
  call a:option.Set('swank-event-expecting-one-updatetime', 500)
  call a:option.Set('swank-event-expecting-one-char-count', 10)
  call a:option.Set('swank-event-expecting-many-updatetime', 2000)
  call a:option.Set('swank-event-expecting-many-char-count', 20)

  " add default swank rpc callers and handlers
  call a:option.Set("swank-rpc-completions-caller", 'g:CompletionsCaller')
  call a:option.Set("swank-rpc-completions-handler", 'g:CompletionsHandler')
  call a:option.Set("swank-rpc-connection-info-caller", 'g:ConnectionInfoCaller')
  call a:option.Set("swank-rpc-connection-info-handler", 'g:ConnectionInfoHandler')

  call a:option.Set("swank-rpc-format-source-caller", 'g:FormatSourceCaller')
  call a:option.Set("swank-rpc-format-source-handler", 'g:FormatSourceHandler')

  call a:option.Set("swank-rpc-init-project-caller", 'g:InitProjectCaller')
  call a:option.Set("swank-rpc-init-project-handler", 'g:InitProjectHandler')

  call a:option.Set("swank-rpc-repl-config-caller", 'g:ReplConfigCaller')
  call a:option.Set("swank-rpc-repl-config-handler", 'g:ReplConfigHandler')

  call a:option.Set("swank-rpc-shutdown-server-caller", 'g:ShutdownServerCaller')
  call a:option.Set("swank-rpc-shutdown-server-handler", 'g:ShutdownServerHandler')

  call a:option.Set("swank-rpc-symbol-at-point-caller", 'g:SymbolAtPointCaller')
  call a:option.Set("swank-rpc-symbol-at-point-handler", 'g:SymbolAtPointHandler')

  call a:option.Set("swank-rpc-typecheck-all-caller", 'g:TypecheckAllCaller')
  call a:option.Set("swank-rpc-typecheck-all-handler", 'g:TypecheckAllHandler')

  call a:option.Set("swank-rpc-typecheck-file-caller", 'g:TypecheckFileCaller')
  call a:option.Set("swank-rpc-typecheck-file-handler", 'g:TypecheckFileHandler')

  call a:option.Set("swank-rpc-uses-of-symbol-at-point-caller", 'g:UsesOfSymbolAtPointCaller')
  call a:option.Set("swank-rpc-uses-of-symbol-at-point-handler", 'g:UsesOfSymbolAtPointHandler')


  " add default swank event triggers

  call a:option.Set("swank-event-trigger-compiler-ready", 'vimside#swank#event#compiler_ready#Handle')
  call a:option.Set("swank-event-trigger-full-typecheck-finished", 'vimside#swank#event#full_typecheck_finished#Handle')
  call a:option.Set("swank-event-trigger-indexer-ready", 'vimside#swank#event#indexer_ready#Handle')
  call a:option.Set("swank-event-trigger-scala-notes", 'vimside#swank#event#scala_notes#Handle')
  call a:option.Set("swank-event-trigger-java-notes", 'vimside#swank#event#java_notes#Handle')
  call a:option.Set("swank-event-trigger-clear-all-scala-notes", 'vimside#swank#event#clear_all_scala_notes#Handle')
  call a:option.Set("swank-event-trigger-clear-all-java-notes", 'vimside#swank#event#clear_all_java_notes#Handle')

  " add default swank debug triggers
  call a:option.Set("swank-debug-trigger-output", 'vimside#swank#event#debug_output#Handle')
  call a:option.Set("swank-debug-trigger-stop", 'vimside#swank#event#debug_stop#Handle')
  call a:option.Set("swank-debug-trigger-breakpoint", 'vimside#swank#event#debug_breakpoint#Handle')
  call a:option.Set("swank-debug-trigger-death", 'vimside#swank#event#debug_death#Handle')
  call a:option.Set("swank-debug-trigger-start", 'vimside#swank#event#debug_start#Handle')
  call a:option.Set("swank-debug-trigger-disconnect", 'vimside#swank#event#debug_disconnect#Handle')
  call a:option.Set("swank-debug-trigger-exception", 'vimside#swank#event#debug_exception#Handle')
  call a:option.Set("swank-debug-trigger-thread-start", 'vimside#swank#event#debug_thread_start#Handle')
  call a:option.Set("swank-debug-trigger-thread-death", 'vimside#swank#event#debug_thread_death#Handle')


  " Hover
  " same as balloondelay default
  call a:option.Set("vimside-hover-updatetime", 600)
  " one character and hover move triggered
  call a:option.Set("vimside-hover-max-char-mcounter", 0)
  call a:option.Set("vimside-hover-balloon-enabled", 1)
  call a:option.Set("vimside-hover-cmdline-job-time", 300)
  call a:option.Set("vimside-hover-term-balloon-enabled", 1)
  call a:option.Set("vimside-hover-term-balloon-fg", "red")
  call a:option.Set("vimside-hover-term-balloon-bg", "white")
  call a:option.Set("vimside-hover-term-job-time", 300)

endfunction
