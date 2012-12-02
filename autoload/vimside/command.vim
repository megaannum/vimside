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
    call vimside#command#show_errors_and_warning#Run()
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
    else
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
    else
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
    else
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
    else
      throw "s:DoMode unknown mode argument: ".  a:mode
    endif

    call vimside#command#refactor#InlineLocal()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#RefactorAddImportTypeAtPoint() range
  if exists("g:vimside.started") && g:vimside.started
    call vimside#command#refactor#AddImportTypeAtPoint()
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

    call vimside#command#popup_menu#Run(a:mode)
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


