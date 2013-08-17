" ============================================================================
" commands.vim
"
" File:          commands.vim
" Summary:       Vimside Pubilic commands
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" 
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function! vimside#command#StartEnsime() range
  call vimside#command#ensime#Start()
endfunction

function! vimside#command#StopEnsime() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#ensime#Stop()
  endif
endfunction

function! vimside#command#InspectTypeAtPoint() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#inspector#type_at_point()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#InspectPackageAtPoint() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#inspector#package_at_point()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#InspectProjectPackage() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#inspector#project_package()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#SymbolAtPoint() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#symbol_at_point#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#PreviousPosition() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#position#Previous()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#ExpandSelection() range
" call s:LOG("vimside#command#ExpandSelection TOP")
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#selection#Expand()
  else
    call s:ERROR("Ensime must be started first")
  endif
" call s:LOG("vimside#command#ExpandSelection BOTTOM")
endfunction

function! vimside#command#ContractSelection() range
" call s:LOG("vimside#command#ContractSelection TOP")
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#selection#Contract()
  else
    call s:ERROR("Ensime must be started first")
  endif
" call s:LOG("vimside#command#ContractSelection BOTTOM")
endfunction

function! vimside#command#HoverToSymbol() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#hover#ToSymbol()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#Search() range
" call s:LOG("vimside#command#Search TOP")
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#search#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
" call s:LOG("vimside#command#Search BOTTOM")
endfunction

function! vimside#command#ShowDocSymbolAtPoint() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#show_doc_symbol_at_point#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#UsesOfSymbolAtPoint() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#uses_of_symbol_at_point#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#SbtSwitch() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#sbt#Switch()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#SbtCompile() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#sbt#Compile()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#SbtClean() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#sbt#Clean()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#SbtPackage() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#sbt#Package()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#SbtExit() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#sbt#Exit()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#SbtInvoke() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#sbt#Invoke()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#Repl() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#repl_config#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#TypecheckFileOnWrite() range
  let [found, check] = g:vimside.GetOption('tailor-type-check-file-on-write')
  if found
    if check
      call vimside#command#TypecheckFile() 
    endif
  else
    throw "Option not found: 'tailor-type-check-file-on-write'"
  endif
endfunction

function! vimside#command#TypecheckFile() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#typecheck_file#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#TypecheckAll() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#typecheck_all#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#ShowErrorsAndWarning() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#show_errors_and_warning#Close()
    call vimside#command#show_errors_and_warning#Run("c")
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#FormatSource() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#format_source#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

"----------------------------------------------
" Debug functions
"----------------------------------------------

" Start and run the debugger.
function! vimside#command#DebugStart()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#Start()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

 " Start and run the debugger.
function! vimside#command#DebugRun()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Set a breakpoint.
function! vimside#command#DebugSetBreakpoint()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#SetBreakpoint()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Clear a breakpoint.
function! vimside#command#DebugClearBreakpoint()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#ClearBreakpoint()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Step.
function! vimside#command#DebugStep()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#Step()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

"  Step over.
function! vimside#command#DebugStepOver()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#StepOver()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Step out.
function! vimside#command#DebugNext()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#Next()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

"  Continue from a breakpoint.
function! vimside#command#DebugContinue()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#Continue()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Kill the debug session.
function! vimside#command#DebugQuit()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#Quit()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Inspect the local variable at cursor.
function! vimside#command#DebugInspectVariable()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#InspectVariable()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Show backtrace.
function! vimside#command#DebugShowBacktrace()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#ShowBacktrace()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

" Clear all breaks
function! vimside#command#DebugClearAllBreaks()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#debug#ClearAllBreaks()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction


"----------------------------------------------
" Refactor functions
"----------------------------------------------

function! vimside#command#RefactorRename(mode) range
  if exists("g:vimside.started") && g:vimside.started
    if a:mode == 'n'
      call s:ClearVisualSelection()
    elseif a:mode == 'v'
      let s:firstline = a:firstline
      let s:firstcol = col("'<")
      let s:lastline = a:lastline
      let s:lastcol = col("'>")
      let s:visualmode = visualmode()
    elseif a:mode  != 'menu'
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#refactor#Rename()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#RefactorOrganizeImports() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#refactor#OrganizeImports()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#RefactorExtractLocal(mode) range
  if exists("g:vimside.started") && g:vimside.started
    if a:mode == 'n'
      call s:ClearVisualSelection()
    elseif a:mode == 'v'
      let s:firstline = a:firstline
      let s:firstcol = col("'<")
      let s:lastline = a:lastline
      let s:lastcol = col("'>")
      let s:visualmode = visualmode()
    elseif a:mode  != 'menu'
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#refactor#ExtractLocal()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#RefactorExtractMethod(mode) range
  if exists("g:vimside.started") && g:vimside.started
    if a:mode == 'n'
      call s:ClearVisualSelection()
    elseif a:mode == 'v'
      let s:firstline = a:firstline
      let s:firstcol = col("'<")
      let s:lastline = a:lastline
      let s:lastcol = col("'>")
      let s:visualmode = visualmode()
    elseif a:mode  != 'menu'
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#refactor#ExtractMethod()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#RefactorInlineLocal(mode) range
  if exists("g:vimside.started") && g:vimside.started
    if a:mode == 'n'
      call s:ClearVisualSelection()
    elseif a:mode == 'v'
      let s:firstline = a:firstline
      let s:firstcol = col("'<")
      let s:lastline = a:lastline
      let s:lastcol = col("'>")
      let s:visualmode = visualmode()
    elseif a:mode  != 'menu'
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#refactor#InlineLocal()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#RefactorAddImport() range
  if exists("g:vimside.started") && g:vimside.started
    call s:ClearVisualSelection()
    call vimside#command#refactor#AddImport()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#ImportSuggestions(mode) range
  if exists("g:vimside.started") && g:vimside.started
    if a:mode == 'n'
      call s:ClearVisualSelection()
    elseif a:mode == 'v'
      let s:firstline = a:firstline
      let s:firstcol = col("'<")
      let s:lastline = a:lastline
      let s:lastcol = col("'>")
      let s:visualmode = visualmode()
    elseif a:mode  != 'menu'
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#refactor#ImportSuggestions()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction


function! vimside#command#BuilderBuild()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#builder#Build()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#BuilderReBuild()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#builder#ReBuild()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction
function! vimside#command#BuilderTrackFile()
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#builder#AddTrackFile()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction



function! s:ClearVisualSelection()
  if exists("s:firstline")
    unlet s:firstline
    unlet s:firstcol
    unlet s:lastline
    unlet s:lastcol
    unlet s:visualmode
  endif
endfunction

" return [found, start, end]
function! vimside#command#GetVisualSelection()
  if exists("s:firstline")
call s:LOG("vimside#command#GetVisualSelection: s:firstline=". s:firstline)
call s:LOG("vimside#command#GetVisualSelection: s:firstcol=". s:firstcol)
call s:LOG("vimside#command#GetVisualSelection: s:lastline=". s:lastline)
call s:LOG("vimside#command#GetVisualSelection: s:lastcol=". s:lastcol)
    let start = line2byte(s:firstline)+s:firstcol-1
    let end = line2byte(s:lastline)+s:lastcol-1
    return [1, start, end]
  else
    return [0, -1, -1]
  endif
endfunction


"----------------------------------------------
" Popup Menu functions
"----------------------------------------------

function! vimside#command#MakePopUp(mode) range
  if exists("g:vimside.started") && g:vimside.started
    if a:mode == 'n'
      call s:ClearVisualSelection()
    elseif a:mode == 'v'
      let s:firstline = a:firstline
      let s:firstcol = col("'<")
      let s:lastline = a:lastline
      let s:lastcol = col("'>")
      let s:visualmode = visualmode()
    else
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#popup_menu#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#BrowseSourceRoots() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#browse_source_roots#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#BrowseReferenceSourceRoots() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#browse_reference_source_roots#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#OptionEditor() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#option_editor#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction


