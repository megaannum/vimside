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

  " TODO remove
  " if  has("win32") || has("win95") || has("win64") || has("win16") || has("dos32")
  if g:vimside.os.is_mswin 
    let ensime_install_path = $HOME . "/vimfiles/vim-addons/ensime"
    if isdirectory(ensime_install_path)
      call owner.Set("ensime-install-path", ensime_install_path)
    endif

    call owner.Set("ensime-config-file-name", "_ensime")
  else
    let ensime_install_path = $HOME . "/.vim/vim-addons/ensime"
    if isdirectory(ensime_install_path)
      call owner.Set("ensime-install-path", ensime_install_path)
    endif

    call owner.Set("ensime-config-file-name", ".ensime")
  endif
  call owner.Set("vimside-use-cwd-as-output-dir", 0)

  " call owner.Set("ensime-dist-dir", "dist_2.9.2")
  call owner.Set("ensime-dist-dir", "ensime_2.9.2-0.9.8.9")
  
  call owner.Set("ensime-log-enabled", 0)
  call owner.Set("ensime-log-file-name", "ENSIME_LOG")
  call owner.Set("ensime-log-file-use-pid", 0)
  call owner.Set("ensime-port-file-max-wait", 5)
  call owner.Set("ensime-port-file-name", '_ensime_port')
  call owner.Set("ensime-host-name", "localhost")
  call owner.Set("ensime-shutdown-on-vim-exit", 1)

  " supported java and scala versions
  call owner.Set("vimside-java-version", "1.6")
  call owner.Set("vimside-scala-version", "2.9.2")

  call owner.Set("vimside-project-options-enabled", 1)
  call owner.Set("vimside-project-options-file-name", "options_project.vim")

  call owner.Set("vimside-log-enabled", 0)
  call owner.Set("vimside-log-file-name", "VIMSIDE_LOG")
  call owner.Set("vimside-log-file-use-pid", 0)

  call owner.Set("vimside-port-file-wait-time", 4)

  call owner.Set("tailor-information", 'preview')
  call owner.Set("tailor-location-same-file", 'same_window')
  call owner.Set("tailor-location-diff-file", 'same_window')

  " Swank RPC Event Ping Info
  call owner.Set('scheduler-not-expecting-anything-read-time-out', 0)
  call owner.Set('scheduler-not-expecting-anything-update-time', 10000)
  call owner.Set('scheduler-not-expecting-anything-char-count', 100)
  call owner.Set('scheduler-expecting-rpc-response-read-time-out', 200)
  call owner.Set('scheduler-expecting-rpc-response-update-time', 200)
  call owner.Set('scheduler-expecting-rpc-response-char-count', 100)
  call owner.Set('scheduler-expecting-events-read-time-out', 50)
  call owner.Set('scheduler-expecting-events-update-time', 500)
  call owner.Set('scheduler-expecting-events-char-count', 10)
  call owner.Set('scheduler-expecting-many-events-read-time-out', 100)
  call owner.Set('scheduler-expecting-many-events-update-time', 2000)
  call owner.Set('scheduler-expecting-many-events-char-count', 20)
  call owner.Set('scheduler-many-max-count-no-events', 50)
  call owner.Set('scheduler-events-max-count-no-events', 50)



  " Start of swank rpc caller/handlers
  call owner.Set('swank-rpc-builder-add-files-handler', 'g:BuilderAddFilesHandler')
  call owner.Set('swank-rpc-builder-add-files-caller', 'g:BuilderAddFilesCaller')
  call owner.Set('swank-rpc-builder-init-handler', 'g:BuilderInitHandler')
  call owner.Set('swank-rpc-builder-init-caller', 'g:BuilderInitCaller')
  call owner.Set('swank-rpc-builder-remove-files-handler', 'g:BuilderRemoveFilesHandler')
  call owner.Set('swank-rpc-builder-remove-files-caller', 'g:BuilderRemoveFilesCaller')
  call owner.Set('swank-rpc-builder-update-files-handler', 'g:BuilderUpdateFilesHandler')
  call owner.Set('swank-rpc-builder-update-files-caller', 'g:BuilderUpdateFilesCaller')
  call owner.Set('swank-rpc-call-completion-handler', 'g:CallCompletionHandler')
  call owner.Set('swank-rpc-call-completion-caller', 'g:CallCompletionCaller')
  call owner.Set('swank-rpc-cancel-refactor-handler', 'g:CancelRefactorHandler')
  call owner.Set('swank-rpc-cancel-refactor-caller', 'g:CancelRefactorCaller')
  call owner.Set('swank-rpc-completions-handler', 'g:CompletionsHandler')
  call owner.Set('swank-rpc-completions-caller', 'g:CompletionsCaller')
  call owner.Set('swank-rpc-connection-info-handler', 'g:ConnectionInfoHandler')
  call owner.Set('swank-rpc-connection-info-caller', 'g:ConnectionInfoCaller')
  call owner.Set('swank-rpc-debug-active-vm-handler', 'g:DebugActiveVMHandler')
  call owner.Set('swank-rpc-debug-active-vm-caller', 'g:DebugActiveVMCaller')
  call owner.Set('swank-rpc-debug-attach-handler', 'g:DebugAttachHandler')
  call owner.Set('swank-rpc-debug-attach-caller', 'g:DebugAttachCaller')
  call owner.Set('swank-rpc-debug-backtrace-handler', 'g:DebugBacktraceHandler')
  call owner.Set('swank-rpc-debug-backtrace-caller', 'g:DebugBacktraceCaller')
  call owner.Set('swank-rpc-debug-clear-all-breaks-handler', 'g:DebugClearAllBreaksHandler')
  call owner.Set('swank-rpc-debug-clear-all-breaks-caller', 'g:DebugClearAllBreaksCaller')
  call owner.Set('swank-rpc-debug-clear-break-handler', 'g:DebugClearBreakHandler')
  call owner.Set('swank-rpc-debug-clear-break-caller', 'g:DebugClearBreakCaller')
  call owner.Set('swank-rpc-debug-continue-handler', 'g:DebugContinueHandler')
  call owner.Set('swank-rpc-debug-continue-caller', 'g:DebugContinueCaller')
  call owner.Set('swank-rpc-debug-list-breakpoints-handler', 'g:DebugListBreakpointsHandler')
  call owner.Set('swank-rpc-debug-list-breakpoints-caller', 'g:DebugListBreakpointsCaller')
  call owner.Set('swank-rpc-debug-locate-name-handler', 'g:DebugLocateNameHandler')
  call owner.Set('swank-rpc-debug-locate-name-caller', 'g:DebugLocateNameCaller')
  call owner.Set('swank-rpc-debug-next-handler', 'g:DebugNextHandler')
  call owner.Set('swank-rpc-debug-next-caller', 'g:DebugNextCaller')
  call owner.Set('swank-rpc-debug-run-handler', 'g:DebugRunHandler')
  call owner.Set('swank-rpc-debug-run-caller', 'g:DebugRunCaller')
  call owner.Set('swank-rpc-debug-set-break-handler', 'g:DebugSetBreakHandler')
  call owner.Set('swank-rpc-debug-set-break-caller', 'g:DebugSetBreakCaller')
  call owner.Set('swank-rpc-debug-set-value-handler', 'g:DebugSetValueHandler')
  call owner.Set('swank-rpc-debug-set-value-caller', 'g:DebugSetValueCaller')
  call owner.Set('swank-rpc-debug-start-handler', 'g:DebugStartHandler')
  call owner.Set('swank-rpc-debug-start-caller', 'g:DebugStartCaller')
  call owner.Set('swank-rpc-debug-step-out-handler', 'g:DebugStepOutHandler')
  call owner.Set('swank-rpc-debug-step-out-caller', 'g:DebugStepOutCaller')
  call owner.Set('swank-rpc-debug-step-handler', 'g:DebugStepHandler')
  call owner.Set('swank-rpc-debug-step-caller', 'g:DebugStepCaller')
  call owner.Set('swank-rpc-debug-stop-handler', 'g:DebugStopHandler')
  call owner.Set('swank-rpc-debug-stop-caller', 'g:DebugStopCaller')
  call owner.Set('swank-rpc-debug-to-string-handler', 'g:DebugToStringHandler')
  call owner.Set('swank-rpc-debug-to-string-caller', 'g:DebugToStringCaller')
  call owner.Set('swank-rpc-debug-value-handler', 'g:DebugValueHandler')
  call owner.Set('swank-rpc-debug-value-caller', 'g:DebugValueCaller')
  call owner.Set('swank-rpc-exec-refactor-handler', 'g:ExecRefactorHandler')
  call owner.Set('swank-rpc-exec-refactor-caller', 'g:ExecRefactorCaller')
  call owner.Set('swank-rpc-exec-undo-handler', 'g:ExecUndoHandler')
  call owner.Set('swank-rpc-exec-undo-caller', 'g:ExecUndoCaller')
  call owner.Set('swank-rpc-expand-selection-handler', 'g:ExpandSelectionHandler')
  call owner.Set('swank-rpc-expand-selection-caller', 'g:ExpandSelectionCaller')
  call owner.Set('swank-rpc-format-source-handler', 'g:FormatSourceHandler')
  call owner.Set('swank-rpc-format-source-caller', 'g:FormatSourceCaller')
  call owner.Set('swank-rpc-import-suggestions-handler', 'g:ImportSuggestionsHandler')
  call owner.Set('swank-rpc-import-suggestions-caller', 'g:ImportSuggestionsCaller')
  call owner.Set('swank-rpc-init-project-handler', 'g:InitProjectHandler')
  call owner.Set('swank-rpc-init-project-caller', 'g:InitProjectCaller')
  call owner.Set('swank-rpc-inspect-package-by-path-handler', 'g:InspectPackageByPathHandler')
  call owner.Set('swank-rpc-inspect-package-by-path-caller', 'g:InspectPackageByPathCaller')
  call owner.Set('swank-rpc-inspect-type-at-point-handler', 'g:InspectTypeAtPointHandler')
  call owner.Set('swank-rpc-inspect-type-at-point-caller', 'g:InspectTypeAtPointCaller')
  call owner.Set('swank-rpc-inspect-type-by-id-handler', 'g:InspectTypeByIdHandler')
  call owner.Set('swank-rpc-inspect-type-by-id-caller', 'g:InspectTypeByIdCaller')
  call owner.Set('swank-rpc-method-bytecode-handler', 'g:MethodBytecodeHandler')
  call owner.Set('swank-rpc-method-bytecode-caller', 'g:MethodBytecodeCaller')
  call owner.Set('swank-rpc-package-member-completion-handler', 'g:PackageMemberCompletionHandler')
  call owner.Set('swank-rpc-package-member-completion-caller', 'g:PackageMemberCompletionCaller')
  call owner.Set('swank-rpc-patch-source-handler', 'g:PatchSourceHandler')
  call owner.Set('swank-rpc-patch-source-caller', 'g:PatchSourceCaller')
  call owner.Set('swank-rpc-peek-undo-handler', 'g:PeekUndoHandler')
  call owner.Set('swank-rpc-peek-undo-caller', 'g:PeekUndoCaller')
  call owner.Set('swank-rpc-prepare-refactor-handler', 'g:PrepareRefactorHandler')
  call owner.Set('swank-rpc-prepare-refactor-caller', 'g:PrepareRefactorCaller')
  call owner.Set('swank-rpc-public-symbol-search-handler', 'g:PublicSymbolSearchHandler')
  call owner.Set('swank-rpc-public-symbol-search-caller', 'g:PublicSymbolSearchCaller')
  call owner.Set('swank-rpc-remove-file-handler', 'g:RemoveFileHandler')
  call owner.Set('swank-rpc-remove-file-caller', 'g:RemoveFileCaller')
  call owner.Set('swank-rpc-repl-config-handler', 'g:ReplConfigHandler')
  call owner.Set('swank-rpc-repl-config-caller', 'g:ReplConfigCaller')
  call owner.Set('swank-rpc-shutdown-server-handler', 'g:ShutdownServerHandler')
  call owner.Set('swank-rpc-shutdown-server-caller', 'g:ShutdownServerCaller')
  call owner.Set('swank-rpc-symbol-at-point-handler', 'g:SymbolAtPointHandler')
  call owner.Set('swank-rpc-symbol-at-point-caller', 'g:SymbolAtPointCaller')
  call owner.Set('swank-rpc-symbol-designations-handler', 'g:SymbolDesignationsHandler')
  call owner.Set('swank-rpc-symbol-designations-caller', 'g:SymbolDesignationsCaller')
  call owner.Set('swank-rpc-type-at-point-handler', 'g:TypeAtPointHandler')
  call owner.Set('swank-rpc-type-at-point-caller', 'g:TypeAtPointCaller')
  call owner.Set('swank-rpc-type-by-id-handler', 'g:TypeByIdHandler')
  call owner.Set('swank-rpc-type-by-id-caller', 'g:TypeByIdCaller')
  call owner.Set('swank-rpc-type-by-name_at_point-handler', 'g:TypeByNameAtPointHandler')
  call owner.Set('swank-rpc-type-by-name_at_point-caller', 'g:TypeByNameAtPointCaller')
  call owner.Set('swank-rpc-type-by-name-handler', 'g:TypeByNameHandler')
  call owner.Set('swank-rpc-type-by-name-caller', 'g:TypeByNameCaller')
  call owner.Set('swank-rpc-typecheck-all-handler', 'g:TypecheckAllHandler')
  call owner.Set('swank-rpc-typecheck-all-caller', 'g:TypecheckAllCaller')
  call owner.Set('swank-rpc-typecheck-files-handler', 'g:TypecheckFilesHandler')
  call owner.Set('swank-rpc-typecheck-files-caller', 'g:TypecheckFilesCaller')
  call owner.Set('swank-rpc-typecheck-file-handler', 'g:TypecheckFileHandler')
  call owner.Set('swank-rpc-typecheck-file-caller', 'g:TypecheckFileCaller')
  call owner.Set('swank-rpc-uses-of-symbol-at-point-handler', 'g:UsesOfSymbolAtPointHandler')
  call owner.Set('swank-rpc-uses-of-symbol-at-point-caller', 'g:UsesOfSymbolAtPointCaller')

  " End of swank rpc caller/handlers


  call owner.Set("tailor-symbol-search-close-empty-display", 0)
  call owner.Set("tailor-symbol-search-do-incremental", 0)
  call owner.Set("tailor-symbol-search-maximum-return", 50)

  call owner.Set("tailor-expand-selection-information", 'highlight')
  call owner.Set("tailor-expand-selection-highlight-color-dark", '5fffff')
  call owner.Set("tailor-expand-selection-highlight-color-light", '5fffff')


  call owner.Set("tailor-uses-of-symbol-at-point-window", 'quickfix')
  call owner.Set("tailor-uses-of-symbol-at-point-use-signs", '1')
  call owner.Set("tailor-uses-of-symbol-at-point-use-sign-kind-marker", '1')

  call owner.Set('sign-quickfix-error-linehl', 'Error')
  call owner.Set('sign-quickfix-error-text', 'E>')
  call owner.Set('sign-quickfix-error-texthl', 'Todo')

  call owner.Set('sign-quickfix-warn-linehl', 'StatusLine')
  call owner.Set('sign-quickfix-warn-text', 'W>')
  call owner.Set('sign-quickfix-warn-texthl', 'Todo')

  call owner.Set('sign-quickfix-info-linehl', 'DiffAdd')
  call owner.Set('sign-quickfix-info-text', 'I>')
  call owner.Set('sign-quickfix-info-texthl', 'TODO')

  call owner.Set('sign-quickfix-marker-linehl', 'Search')
  call owner.Set('sign-quickfix-marker-text', 'M>')
  call owner.Set('sign-quickfix-marker-texthl', 'Ignore')

  call owner.Set('sign-locationlist-info-linehl', 'DiffAdd')
  call owner.Set('sign-locationlist-info-text', 'I>')
  call owner.Set('sign-locationlist-info-texthl', 'TODO')

  call owner.Set('sign-locationlist-marker-linehl', 'Search')
  call owner.Set('sign-locationlist-marker-text', 'M>')
  call owner.Set('sign-locationlist-marker-texthl', 'Ignore')

  call owner.Set('sign-debug-active-linehl', 'DiffText')
  call owner.Set('sign-debug-active-text', 'A>')
  call owner.Set('sign-debug-active-texthl', 'SpellCap')

  call owner.Set('sign-debug-pending-linehl', 'DiffAdd')
  call owner.Set('sign-debug-pending-text', 'P>')
  call owner.Set('sign-debug-pending-texthl', 'DiffDelete')

  call owner.Set('sign-debug-marker-linehl', 'Search')
  call owner.Set('sign-debug-marker-text', 'M>')
  call owner.Set('sign-debug-marker-texthl', 'Ignore')

  call owner.Set('sign-start-place-id', 2656)

  " add default swank event triggers

  call owner.Set("swank-event-trigger-compiler-ready", 'vimside#swank#event#compiler_ready#Handle')
  call owner.Set("swank-event-trigger-full-typecheck-finished", 'vimside#swank#event#full_typecheck_finished#Handle')
  call owner.Set("swank-event-trigger-indexer-ready", 'vimside#swank#event#indexer_ready#Handle')
  call owner.Set("swank-event-trigger-scala-notes", 'vimside#swank#event#scala_notes#Handle')
  call owner.Set("swank-event-trigger-java-notes", 'vimside#swank#event#java_notes#Handle')
  call owner.Set("swank-event-trigger-clear-all-scala-notes", 'vimside#swank#event#clear_all_scala_notes#Handle')
  call owner.Set("swank-event-trigger-clear-all-java-notes", 'vimside#swank#event#clear_all_java_notes#Handle')

  " add default swank debug triggers
  call owner.Set("swank-debug-trigger-output", 'vimside#command#debug#OutputEvent')
  call owner.Set("swank-debug-trigger-stop", 'vimside#command#debug#StopEvent')
  call owner.Set("swank-debug-trigger-breakpoint", 'vimside#command#debug#BreakPointEvent')
  call owner.Set("swank-debug-trigger-death", 'vimside#command#debug#DeathEvent')
  call owner.Set("swank-debug-trigger-start", 'vimside#command#debug#StartEvent')
  call owner.Set("swank-debug-trigger-disconnect", 'vimside#command#debug#DisconnectEvent')
  call owner.Set("swank-debug-trigger-exception", 'vimside#command#debug#ExceptionEvent')
  call owner.Set("swank-debug-trigger-thread-start", 'vimside#command#debug#ThreadStartEvent')
  call owner.Set("swank-debug-trigger-thread-death", 'vimside#command#debug#ThreadDeathEvent')


  " Hover
  " same as balloondelay default
  call owner.Set("tailor-hover-updatetime", 600)
  " one character and hover move triggered
  call owner.Set("tailor-hover-max-char-mcounter", 0)
  call owner.Set("vimside-hover-balloon-enabled", 1)
  call owner.Set("tailor-hover-cmdline-job-time", 300)
  call owner.Set("vimside-hover-term-balloon-enabled", 1)
  call owner.Set("tailor-hover-term-balloon-fg", "red")
  call owner.Set("tailor-hover-term-balloon-bg", "white")
  call owner.Set("tailor-hover-term-job-time", 300)

  " Browser
  call owner.Set("tailor-browser-keys-platform", ['unix', 'cygwin', 'mswin', 'macunix'])
  "    unix
  call owner.Set("tailor-browser-unix-commands", ['xdg-open', 'firefox', 'opera'])
  call owner.Set("tailor-browser-unix-url-funcname", ['shellescape', 'shellescape', 'shellescape'])
  "    cygwin
  call owner.Set("tailor-browser-cygwin-commands", ['cygstart'])
  call owner.Set("tailor-browser-cygwin-url-funcname", ['shellescape'])
  "    mswin TODO I do not know how to do this and I can not test it.
  call owner.Set("tailor-browser-mswin-commands", ['cmd.exe', 'firefox'])
  call owner.Set("tailor-browser-mswin-url-funcname", ['shellescape', 'shellescape'])
  "    macunix
  call owner.Set("tailor-browser-macunix-commands", ['open'])
  call owner.Set("tailor-browser-macunix-url-funcname", ['shellescape'])

  " Show Doc Url 
  let l:FuncrefJava = function("vimside#command#show_doc_symbol_at_point#MakeUrlJava")
  let l:FuncrefScala = function("vimside#command#show_doc_symbol_at_point#MakeUrlScala")
  call owner.Set("tailor-show-doc-keys", ['java', 'scala', 'scala-compiler', 'scala-reflect', 'android'])
 
  "    java 1.5, 1.6, 1.7
  call owner.Set('tailor-show-doc-java1.5-url-base', "http://docs.oracle.com/javase/5/docs/api/")
  call owner.Set('tailor-show-doc-java1.6-url-base', "http://docs.oracle.com/javase/6/docs/api/")
  call owner.Set('tailor-show-doc-java1.7-url-base', "http://docs.oracle.com/javase/7/docs/api/")
  call owner.Set('tailor-show-doc-java-regex', '^java.')
  call owner.Set('tailor-show-doc-java-func-ref', l:FuncrefJava)

  "    scala 2.9.2
  "    scala 2.10.0
  call owner.Set('tailor-show-doc-scala2.9.2-url-base', 'http://www.scala-lang.org/api/current/index.html')
  call owner.Set('tailor-show-doc-scala2.10.0-url-base', 'http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/library/index.html')
  call owner.Set('tailor-show-doc-scala-regex', '^scala.')
  call owner.Set('tailor-show-doc-scala-func-ref', l:FuncrefScala)


  "    scala_compiler 2.10.0
  call owner.Set('tailor-show-doc-scala-compiler2.10.0-url-base', 'http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/compiler/index.html')
  call owner.Set('tailor-show-doc-scala-compiler-regex', '^scala.tools.')
  call owner.Set('tailor-show-doc-scala-compiler-func-ref', l:FuncrefScala)

  "    scala_reflect 2.10.0
  call owner.Set('tailor-show-doc-scala-reflect2.10.0-url-base', 'http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/compiler/index.html')
  call owner.Set('tailor-show-doc-scala-reflect-regex', '^scala.reflect.')
  call owner.Set('tailor-show-doc-scala-reflect-func-ref', l:FuncrefScala)

  "    android
  call owner.Set('tailor-show-doc-android-url-base', "http://developer.android.com/reference/")
  call owner.Set('tailor-show-doc-android-regex', '^android.')
  call owner.Set('tailor-show-doc-android-func-ref', l:FuncrefJava)


  " Forms
  " do not used Forms by default
  call owner.Set("forms-use", 0)

  call owner.Set("tailor-forms-sourcebrowser-open-in-tab", 1)

  " Typecheck file on write
  call owner.Set('tailor-type-check-file-on-write', 0)

  call owner.Set('tailor-sbt-compile-error-long-line-quickfix', 1)
  call owner.Set('tailor-sbt-error-read-size', 10000)
  call owner.Set('tailor-sbt-use-signs', 1)

  call owner.Set('tailor-show-errors-and-warnings-use-signs', 1)
  call owner.Set('tailor-full-typecheck-finished-use-signs', 1)

  " Refactor Rename
  call owner.Set("tailor-refactor-rename-pattern-enable", 1)
  call owner.Set("tailor-refactor-rename-pattern", '[^ =:;()[\]]\+')
  
  " Refactor Extract Local
  call owner.Set("tailor-refactor-extract-local-pattern-enable", 1)
  call owner.Set("tailor-refactor-extract-local-pattern", '[^ =:;()[\]]\+')
  
  " Refactor Extract Method
  call owner.Set("tailor-refactor-extract-method-pattern-enable", 1)
  call owner.Set("tailor-refactor-extract-method-pattern", '[^ =:;()[\]]\+')

endfunction
