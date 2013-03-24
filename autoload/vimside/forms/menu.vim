" ============================================================================
" menu.vim
"
" File:          menu.vim
" Summary:       Vimside Forms popup menu
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

if exists("s:popupform")
  unlet s:popupform
endif

function! VimsideInfoMenuAction(...) dict
  let l:msg = exists("self.msg") 
    \ ? self.msg . ': Not Implemented'
    \ : "No Info Message"
  call forms#dialog#info#Make(l:msg)
endfunction


function! vimside#forms#menu#MakeMenuBuild()
  let items = []

  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Build project',
            \ 'command': ':call vimside#command#BuilderBuild()'
            \ })

  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Rebuild project',
            \ 'command': ':call vimside#command#BuilderReBuild()'
            \ })


  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuSource()
  let items = []

  call add(items, {
            \ 'type': 'button',
            \ 'label': 'Format &Source...',
            \ 'command': ':call vimside#command#FormatSource()'
            \ })

" ["Find all references" ensime-show-uses-of-symbol-at-point]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Find all references...',
            \ 'command': ':call vimside#command#SymbolAtPoint()'
            \ })
  
" ["Inspect type" ensime-inspect-type-at-point]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect type',
            \ 'command': ':call vimside#command#InspectTypeAtPoint()'
            \ })
  
" ["Inspect type in another frame" ensime-inspect-type-at-point-other-frame]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Inspect type in another frame'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect type in another frame',
            \ 'action': action
            \ })
  
" ["Inspect enclosing package" ensime-inspect-package-at-point]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect enclosing package',
            \ 'command': ':call vimside#command#InspectPackageAtPoint()'
            \ })
  
" ["Inspect project package" ensime-inspect-project-package]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect project package',
            \ 'command': ':call vimside#command#InspectProjectPackage()'
            \ })
  
" ["Typecheck file" ensime-typecheck-current-file]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Typecheck file...',
            \ 'command': ':call vimside#command#TypecheckFile()'
            \ })
  
" ["Typecheck project" ensime-typecheck-all]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Typecheck project...',
            \ 'command': ':call vimside#command#TypecheckAll()'
            \ })
  
" ["Show all errors and warnings" ensime-show-all-errors-and-warnings]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Show all errors and warnings',
            \ 'command': ':call vimside#command#ShowErrorsAndWarning()'
            \ })
  
" ["Undo source change" ensime-undo-peek])
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Undo source change'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Undo source change',
            \ 'action': action
            \ })

  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuRefactor()
  let items = []

" ["Organize imports" ensime-refactor-organize-imports]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Organize imports',
            \ 'command': ':call vimside#command#RefactorOrganizeImports()'
            \ })

" ["Import type at point" ensime-import-type-at-point]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Import type at point',
            \ 'command': ':call vimside#command#ImportSuggestions("menu")'
            \ })

" ["Rename" ensime-refactor-rename]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Rename',
            \ 'command': ':call vimside#command#RefactorRename("menu")'
            \ })

" ["Extract local val" ensime-refactor-extract-local]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Extract local val',
            \ 'command': ':call vimside#command#RefactorExtractLocal("menu")'
            \ })

" ["Extract method" ensime-refactor-extract-method]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Extract method',
            \ 'command': ':call vimside#command#RefactorExtractMethod("menu")'
            \ })

" ["Inline local val" ensime-refactor-inline-local])
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inline local val',
            \ 'command': ':call vimside#command#RefactorInlineLocal("menu")'
            \ })

  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuNavidation()
  let items = []

  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Lookup definitions'
" ["Lookup definition" ensime-edit-definition]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Lookup definition',
            \ 'action': action
            \ })

" ["Lookup definition in other window" ensime-edit-definition-other-window]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Lookup definitions in other window'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Lookup definition in other window',
            \ 'action': action
            \ })

" ["Lookup definition in other frame" ensime-edit-definition-other-frame]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Lookup definitions in other framae'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Lookup definition in other frame',
            \ 'action': action
            \ })

" ["Pop definition stack" ensime-pop-find-definition-stack]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Pop definition stack'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Pop definition stack',
            \ 'action': action
            \ })

" ["Backward compilation note" ensime-backward-note]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Backward compilation note'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Backward compilation note',
            \ 'action': action
            \ })

" ["Forward compilation note" ensime-forward-note]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Forward compilation note'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Forward compilation note',
            \ 'action': action
            \ })

if 0
  function! VimsideExpandSelectionCommand()
    if exists("s:firstline")
      if ! vimside#ExpandSelection()
        call vimside#command#ExpandRangeSelection(s:firstline, s:firstcol, s:lastline, s:lastcol)
      endif
    else 
      call vimside#command#ExpandSelection('n')
    endif
  endfunction
endif

" ["Expand selection" ensime-expand-selection-command]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Expand selection...',
            \ 'command': ':call vimside#command#ExpandSelection()'
            \ })

" ["Contract selection" ensime-contract-selection-command]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Contract selection...',
            \ 'command': ':call vimside#command#ContractSelection()'
            \ })

" ["Search" ensime-search]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Search...',
            \ 'command': ':call vimside#command#Search()'
            \ })

" ["Scalex-Search" ensime-scalex])
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Scalex-Search'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Scalex-Search',
            \ 'action': action
            \ })

  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuDocumentation()
  let items = []

" ["Browse documentation of symbol" ensime-show-doc-for-symbol-at-point])
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Browse documentaion of symbol',
            \ 'command': ':call vimside#command#ShowDocSymbolAtPoint()'
            \ })
  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuSBT()
  let items = []

" ["Start or switch to" ensime-sbt-switch]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Start or switch to',
            \ 'command': ':call vimside#command#SbtSwitch()'
            \ })

" ["Compile" ensime-sbt-do-compile]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Compile',
            \ 'command': ':call vimside#command#SbtCompile()'
            \ })

" ["Clean" ensime-sbt-do-clean]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Clean',
            \ 'command': ':call vimside#command#SbtClean()'
            \ })

" ["Package" ensime-sbt-do-package])
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Package',
            \ 'command': ':call vimside#command#SbtPackage()'
            \ })

" ["Exit" ])
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Exit',
            \ 'command': ':call vimside#command#SbtExit()'
            \ })

  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuSBT()
  let items = []

" ["Start" ensime-db-start]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Start'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Start',
            \ 'action': action
            \ })

" ["Set break point" ensime-db-set-break]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Set breakpoint'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Set breakpoint',
            \ 'action': action
            \ })

" ["Clear breakpoint" ensime-db-clear-break]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Clear breakpoint'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&',
            \ 'action': action
            \ })

" ["Clear all breakpoints" ensime-db-clear-all-breaks]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Clear all breakpoints'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Clear all breakpoints',
            \ 'action': action
            \ })

" ["Step" ensime-db-step]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Step'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Step',
            \ 'action': action
            \ })

" ["Next" ensime-db-next]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Next'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Next',
            \ 'action': action
            \ })

" ["Run" ensime-db-run]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Run'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Run',
            \ 'action': action
            \ })

" ["Continue" ensime-db-continue]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Continue'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Continue',
            \ 'action': action
            \ })

" ["Quit" ensime-db-quit]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Quit'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Quit',
            \ 'action': action
            \ })

" ["Show Backtrace" ensime-db-backtrace]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Show Backtrace'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Show Backtrace',
            \ 'action': action
            \ })

" ["Inspect value at point" ensime-db-inspect-value-at-point]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Inspect value at point'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect value at point',
            \ 'action': action
            \ })

  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction



"---------------------------------------------------------------------------
" vimside#forms#menu#MakePopUp: {{{2
"   Returns menu
"
" parameters: 
"   REMOVE mode : 'n' (normal) or 'v' (visual)
"---------------------------------------------------------------------------
if 0
function! vimside#forms#menu#MakePopUp(mode) range
endfunction
endif

function! vimside#forms#menu#MakePopUp() range
if 0
  if a:mode == 'n'
    if exists("s:firstline")
      unlet s:firstline
      unlet s:firstcol
      unlet s:lastline
      unlet s:lastcol
      unlet s:visualmode
    endif
  elseif a:mode == 'v'
    let s:firstline = a:firstline
    let s:firstcol = col("'<")
    let s:lastline = a:lastline
    let s:lastcol = col("'>")
    let s:visualmode = visualmode()
  else
    call s:LOG("vimside#forms#menu#MakePopUp: unknown mode argument: ".  a:mode)
  endif
endif

  if ! exists("s:popupform")
    let items = []

    let MenuBuildFN = function("vimside#forms#menu#MakeMenuBuild")
    let s:buildlabel = forms#newLabel({'text': '&Build'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:buildlabel,
                 \ 'menuFN': MenuBuildFN
                 \ })

    call add(items, {
                 \ 'type': 'label',
                 \ 'label': 'Test'
                 \ })

    let MenuSourceFN = function("vimside#forms#menu#MakeMenuSource")
    let s:sourcelabel = forms#newLabel({'text': '&Source'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:sourcelabel,
                 \ 'menuFN': MenuSourceFN
                 \ })

    let MenuRefactorFN = function("vimside#forms#menu#MakeMenuRefactor")
    let s:refactorlabel = forms#newLabel({'text': '&Refactor'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:refactorlabel,
                 \ 'menuFN': MenuRefactorFN
                 \ })

    let MenuNavigationFN = function("vimside#forms#menu#MakeMenuNavidation")
    let s:navigationlabel = forms#newLabel({'text': '&Navigation'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:navigationlabel,
                 \ 'menuFN': MenuNavigationFN
                 \ })

    let MenuDocumentationFN = function("vimside#forms#menu#MakeMenuDocumentation")
    let s:documentationlabel = forms#newLabel({'text': '&Documentation'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:documentationlabel,
                 \ 'menuFN': MenuDocumentationFN
                 \ })

    let MenuSBTFN = function("vimside#forms#menu#MakeMenuSBT")
    let s:sbtlabel = forms#newLabel({'text': '&SBT'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:sbtlabel,
                 \ 'menuFN': MenuSBTFN
                 \ })

    let MenuDebuggerFN = function("vimside#forms#menu#MakeMenuDebugger")
    let s:debuggerlabel = forms#newLabel({'text': '&Debugger'})
    call add(items, {
                 \ 'type': 'menu',
                 \ 'label': s:debuggerlabel,
                 \ 'menuFN': MenuDebuggerFN
                 \ })

    call add(items, {
                 \ 'type': 'separator'
                 \ })

  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Browse Source Roots...',
            \ 'command': ':call vimside#command#BrowseSourceRoots()'
            \ })

  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Browse Reference Source Roots...',
            \ 'command': ':call vimside#command#BrowseReferenceSourceRoots()'
            \ })
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Options...',
            \ 'command': ':call vimside#command#OptionEditor()'
            \ })

" ["Go to SBT console" ensime-sbt-switch]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Goto SBT console',
            \ 'command': ':call vimside#command#SbtSwitch()'
            \ })

" ["Go to Scala REPL" ensime-inf-switch]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Goto Scala REPL...',
            \ 'command': ':call vimside#swank#rpc#repl_config#Run()'
            \ })

" ["Shutdown ENSIME server" ensime-shutdown]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Shutdown ENSIME server',
            \ 'command': ':call vimside#StopEnsime()'
            \ })


    let attrs = { 'items': items }
    let s:popupmenu = forms#newMenu(attrs)
    function! s:popupmenu.purpose() dict
      return [
          \ "The Vimside access to the Ensime Server API.",
          \ "  While most of the capabilities here can also",
          \ "  be accessed without the Forms library, some can.",
          \ "  not. For instance, the Package and Type Inspectors",
          \ "  or the Dynamic Option Editor can not easily be",
          \ "  duplicated with standard Vim."
          \ ]
    endfunction

    let attrsForm = {
             \ 'delete': '0',
             \ 'body': s:popupmenu
             \ }
    let s:popupform = forms#newForm(attrsForm)
  endif

  call vimside#scheduler#HaltFeedKeys()
  try
    call s:popupform.run()
  finally
    call vimside#scheduler#ResumeFeedKeys()
  endtry
endfunction


" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
