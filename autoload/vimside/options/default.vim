" ============================================================================
" vimside#option#default.vim
"
" File:          vimside#option#default.vim
" Summary:       Default Options for Vimside
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"   Default options for Vimside - and nothing else
"   Options:
"     ensime-install-path
"     TODO: make following a user option or search for it
"     ensime-dist-dir
"     ensime-log-file-name
"     ensime-port-file-max-wait
" ============================================================================

" default location of Ensime files/directories
function! vimside#options#default#Load(owner)
  let owner = a:owner
  call owner.Set("test-ensime-file-use", 0)

  if  has('win16') || has('win32') || has('win64')
    call owner.Set("ensime-install-path", $HOME . "/vimfiles/vim-addons/ensime")
    call owner.Set("ensime-config-file-name", "_ensime")
  else
    call owner.Set("ensime-install-path", $HOME . "/.vim/vim-addons/ensime")
    call owner.Set("ensime-config-file-name", ".ensime")
  endif
  call owner.Set("use-cwd-as-default-output-dir", 0)

  " call owner.Set("ensime-dist-dir", "dist_2.9.2")
  call owner.Set("ensime-dist-dir", "ensime_2.9.2-0.9.8.1")
  
  call owner.Set("ensime-log-enabled", 0)
  call owner.Set("ensime-log-file-name", "ENSIME_LOG")
  call owner.Set("ensime-port-file-max-wait", 5)
  call owner.Set("ensime-port-file-name", '_ensime_port')
  call owner.Set("ensime-host-name", "localhost")

  call owner.Set("vimside-log-enabled", 0)
  call owner.Set("vimside-log-file-name", "VIMSIDE_LOG")

  call owner.Set("swank-information", 'preview')
  call owner.Set("swank-location-same-file", 'same_window')
  call owner.Set("swank-location-diff-file", 'same_window')

  " add default swank rpc and event ping info
  call owner.Set('swank-rpc-expecting-read-timeout', 200)
  call owner.Set('swank-rpc-expecting-updatetime', 100)
  call owner.Set('swank-rpc-expecting-char-count', 10)
  call owner.Set('swank-rpc-not-expecting-read-timeout', 0)
  call owner.Set('swank-rpc-not-expecting-updatetime', 10000)
  call owner.Set('swank-rpc-not-expecting-char-count', 50)
  call owner.Set('swank-event-expecting-one-updatetime', 500)
  call owner.Set('swank-event-expecting-one-char-count', 10)
  call owner.Set('swank-event-expecting-many-updatetime', 2000)
  call owner.Set('swank-event-expecting-many-char-count', 20)

  " add default swank rpc callers and handlers
  call owner.Set("swank-rpc-completions-caller", 'g:CompletionsCaller')
  call owner.Set("swank-rpc-completions-handler", 'g:CompletionsHandler')

  call owner.Set("swank-rpc-connection-info-caller", 'g:ConnectionInfoCaller')
  call owner.Set("swank-rpc-connection-info-handler", 'g:ConnectionInfoHandler')

  call owner.Set("swank-rpc-public-symbol-search-caller", 'g:PublicSymbolSearchCaller')
  call owner.Set("swank-rpc-public-symbol-search-handler", 'g:PublicSymbolSearchHandler')
  call owner.Set("public-symbol-search-close-empty-display", 0)
  call owner.Set("public-symbol-search-do-incremental", 1)

  call owner.Set("swank-rpc-expand-selection-caller", 'g:ExpandSelectionCaller')
  call owner.Set("swank-rpc-expand-selection-handler", 'g:ExpandSelectionHandler')
  call owner.Set("swank-rpc-expand-selection-information", 'visual')
  call owner.Set("swank-rpc-expand-selection-highlight-color-dark", '5fffff')
  call owner.Set("swank-rpc-expand-selection-highlight-color-light", '5fffff')

  call owner.Set("swank-rpc-format-source-caller", 'g:FormatSourceCaller')
  call owner.Set("swank-rpc-format-source-handler", 'g:FormatSourceHandler')

  call owner.Set("swank-rpc-init-project-caller", 'g:InitProjectCaller')
  call owner.Set("swank-rpc-init-project-handler", 'g:InitProjectHandler')

  call owner.Set("swank-rpc-repl-config-caller", 'g:ReplConfigCaller')
  call owner.Set("swank-rpc-repl-config-handler", 'g:ReplConfigHandler')

  call owner.Set("swank-rpc-shutdown-server-caller", 'g:ShutdownServerCaller')
  call owner.Set("swank-rpc-shutdown-server-handler", 'g:ShutdownServerHandler')

  call owner.Set("swank-rpc-symbol-at-point-caller", 'g:SymbolAtPointCaller')
  call owner.Set("swank-rpc-symbol-at-point-handler", 'g:SymbolAtPointHandler')

  call owner.Set("swank-rpc-typecheck-all-caller", 'g:TypecheckAllCaller')
  call owner.Set("swank-rpc-typecheck-all-handler", 'g:TypecheckAllHandler')

  call owner.Set("swank-rpc-typecheck-file-caller", 'g:TypecheckFileCaller')
  call owner.Set("swank-rpc-typecheck-file-handler", 'g:TypecheckFileHandler')

  call owner.Set("swank-rpc-uses-of-symbol-at-point-caller", 'g:UsesOfSymbolAtPointCaller')
  call owner.Set("swank-rpc-uses-of-symbol-at-point-handler", 'g:UsesOfSymbolAtPointHandler')


  " add default swank event triggers

  call owner.Set("swank-event-trigger-compiler-ready", 'vimside#swank#event#compiler_ready#Handle')
  call owner.Set("swank-event-trigger-full-typecheck-finished", 'vimside#swank#event#full_typecheck_finished#Handle')
  call owner.Set("swank-event-trigger-indexer-ready", 'vimside#swank#event#indexer_ready#Handle')
  call owner.Set("swank-event-trigger-scala-notes", 'vimside#swank#event#scala_notes#Handle')
  call owner.Set("swank-event-trigger-java-notes", 'vimside#swank#event#java_notes#Handle')
  call owner.Set("swank-event-trigger-clear-all-scala-notes", 'vimside#swank#event#clear_all_scala_notes#Handle')
  call owner.Set("swank-event-trigger-clear-all-java-notes", 'vimside#swank#event#clear_all_java_notes#Handle')

  " add default swank debug triggers
  call owner.Set("swank-debug-trigger-output", 'vimside#swank#event#debug_output#Handle')
  call owner.Set("swank-debug-trigger-stop", 'vimside#swank#event#debug_stop#Handle')
  call owner.Set("swank-debug-trigger-breakpoint", 'vimside#swank#event#debug_breakpoint#Handle')
  call owner.Set("swank-debug-trigger-death", 'vimside#swank#event#debug_death#Handle')
  call owner.Set("swank-debug-trigger-start", 'vimside#swank#event#debug_start#Handle')
  call owner.Set("swank-debug-trigger-disconnect", 'vimside#swank#event#debug_disconnect#Handle')
  call owner.Set("swank-debug-trigger-exception", 'vimside#swank#event#debug_exception#Handle')
  call owner.Set("swank-debug-trigger-thread-start", 'vimside#swank#event#debug_thread_start#Handle')
  call owner.Set("swank-debug-trigger-thread-death", 'vimside#swank#event#debug_thread_death#Handle')


  " Hover
  " same as balloondelay default
  call owner.Set("vimside-hover-updatetime", 600)
  " one character and hover move triggered
  call owner.Set("vimside-hover-max-char-mcounter", 0)
  call owner.Set("vimside-hover-balloon-enabled", 1)
  call owner.Set("vimside-hover-cmdline-job-time", 300)
  call owner.Set("vimside-hover-term-balloon-enabled", 1)
  call owner.Set("vimside-hover-term-balloon-fg", "red")
  call owner.Set("vimside-hover-term-balloon-bg", "white")
  call owner.Set("vimside-hover-term-job-time", 300)

  " Forms
  " do not used Forms by default
  call owner.Set("vimside-forms-use", 0)

  call owner.Set("vimside-forms-sourcebrowser-open-in-tab", 1)

endfunction
