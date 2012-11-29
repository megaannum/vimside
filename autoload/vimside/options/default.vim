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
  call owner.Set("ensime-dist-dir", "ensime_2.9.2-0.9.8.1")
  
  call owner.Set("ensime-log-enabled", 0)
  call owner.Set("ensime-log-file-name", "ENSIME_LOG")
  call owner.Set("ensime-port-file-max-wait", 5)
  call owner.Set("ensime-port-file-name", '_ensime_port')
  call owner.Set("ensime-host-name", "localhost")

  " supported java and scala versions
  call owner.Set("vimside-java-version", "1.6")
  call owner.Set("vimside-scala-version", "2.9.2")

  call owner.Set("vimside-project-options-enabled", 0)
  call owner.Set("vimside-project-options-file-name", "options_project.vim")

  call owner.Set("vimside-log-enabled", 0)
  call owner.Set("vimside-log-file-name", "VIMSIDE_LOG")

  call owner.Set("tailor-information", 'preview')
  call owner.Set("tailor-location-same-file", 'same_window')
  call owner.Set("tailor-location-diff-file", 'same_window')

  " add default swank rpc and event ping info
  call owner.Set('scheduler-rpc-expecting-read-timeout', 200)
  call owner.Set('scheduler-rpc-expecting-updatetime', 100)
  call owner.Set('scheduler-rpc-expecting-char-count', 10)
  call owner.Set('scheduler-rpc-not-expecting-read-timeout', 0)
  call owner.Set('scheduler-rpc-not-expecting-updatetime', 10000)
  call owner.Set('scheduler-rpc-not-expecting-char-count', 50)
  call owner.Set('scheduler-event-expecting-one-updatetime', 500)
  call owner.Set('scheduler-event-expecting-one-char-count', 10)
  call owner.Set('scheduler-event-expecting-many-updatetime', 2000)
  call owner.Set('scheduler-event-expecting-many-char-count', 20)

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
  call owner.Set("tailor-symbol-search-do-incremental", 1)

  call owner.Set("tailor-expand-selection-information", 'highlight')
  call owner.Set("tailor-expand-selection-highlight-color-dark", '5fffff')
  call owner.Set("tailor-expand-selection-highlight-color-light", '5fffff')



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

endfunction
