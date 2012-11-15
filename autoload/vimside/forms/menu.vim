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

  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Build project'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Build project',
            \ 'action': action
            \ })

  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Rebuild project'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Rebuild project',
            \ 'action': action
            \ })


  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuSource()
  let items = []

  call add(items, {
            \ 'type': 'button',
            \ 'label': 'Format &Source',
            \ 'command': ':call vimside#swank#rpc#format_source#Run()")'
            \ })

" ["Find all references" ensime-show-uses-of-symbol-at-point]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Find all references'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Find all references',
            \ 'action': action
            \ })
  
" ["Inspect type" ensime-inspect-type-at-point]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Inspect type'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect type',
            \ 'action': action
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
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Inspect enclosing package'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect enclosing package',
            \ 'action': action
            \ })
  
" ["Inspect project package" ensime-inspect-project-package]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Inspect project package'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inspect project package',
            \ 'action': action
            \ })
  
" ["Typecheck file" ensime-typecheck-current-file]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Typecheck file'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Typecheck file',
            \ 'action': action
            \ })
  
" ["Typecheck project" ensime-typecheck-all]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Typecheck project'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Typecheck project',
            \ 'action': action
            \ })
  
" ["Show all errors and warnings" ensime-show-all-errors-and-warnings]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Show all errors and warnings'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Show all errors and warnings',
            \ 'action': action
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
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Organize imports'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Organize imports',
            \ 'action': action
            \ })

" ["Import type at point" ensime-import-type-at-point]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Import type at point'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Import type at point',
            \ 'action': action
            \ })

" ["Rename" ensime-refactor-rename]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Rename'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Rename',
            \ 'action': action
            \ })

" ["Extract local val" ensime-refactor-extract-local]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Extract local val'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Extract local val',
            \ 'action': action
            \ })

" ["Extract method" ensime-refactor-extract-method]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Extract method'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Extract method',
            \ 'action': action
            \ })

" ["Inline local val" ensime-refactor-inline-local])
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Inline local val'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Inline local val',
            \ 'action': action
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

" ["Expand selection" ensime-expand-selection-command]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Expand selection'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Expand selection',
            \ 'action': action
            \ })

" ["Search" ensime-search]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Search'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Search',
            \ 'action': action
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
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Browse documentation of symbol'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Browse documentaion of symbol',
            \ 'action': action
            \ })
  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

function! vimside#forms#menu#MakeMenuSBT()
  let items = []

" ["Start or switch to" ensime-sbt-switch]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Start or switch to'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Start or switch to',
            \ 'action': action
            \ })

" ["Compile" ensime-sbt-do-compile]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Compile'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Compile',
            \ 'action': action
            \ })

" ["Clean" ensime-sbt-do-clean]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Clear'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Clean',
            \ 'action': action
            \ })

" ["Package" ensime-sbt-do-package])
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Package'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Package',
            \ 'action': action
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
"   mode : 'n' (normal) or 'v' (visual)
"---------------------------------------------------------------------------
function! vimside#forms#menu#MakePopUp(mode)
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
            \ 'label': '&Browse Source Roots',
            \ 'command': ':call vimside#command#BrowseSourceRoots()'
            \ })

  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Browse Reference Source Roots',
            \ 'command': ':call vimside#command#BrowseReferenceSourceRoots()'
            \ })
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Options',
            \ 'command': ':call vimside#command#OptionEditor()'
            \ })

" ["Go to SBT console" ensime-sbt-switch]
  let action = forms#newAction({ 'execute': function("VimsideInfoMenuAction")})
  let action.msg = 'Go to SBT console'
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Goto SBT console',
            \ 'action': action
            \ })

" ["Go to Scala REPL" ensime-inf-switch]
  call add(items, {
            \ 'type': 'button',
            \ 'label': '&Goto Scala REPL',
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

  call s:popupform.run()
endfunction


" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
