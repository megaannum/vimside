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
  call vimside#StartEnsime()
endfunction

function! vimside#command#StopEnsime() range
  if g:vimside.started
    call vimside#StopEnsime()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#SymbolAtPoint() range
  if g:vimside.started
    call vimside#swank#rpc#symbol_at_point#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#PreviousPosition() range
  if g:vimside.started
    call vimside#PreviousPosition()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#ExpandSelection() range
call s:LOG("vimside#command#ExpandSelection TOP")
  if g:vimside.started
    call vimside#selection#Expand()
  else
    call s:ERROR("Ensime must be started first")
  endif
call s:LOG("vimside#command#ExpandSelection BOTTOM")
if 0
  if a:mode == 'n'
    call vimside#selection#Clear()
    call vimside#swank#rpc#expand_selection#Run()
  elseif a:mode == 'v'
    if ! vimside#selection#Expand()
      let l:firstline = a:firstline
      let l:firstcol = col("'<")
      let l:lastline = a:lastline
      let l:lastcol = col("'>")
      call vimside#command#ExpandRangeSelection(l:firstline, l:firstcol, l:lastline, l:lastcol)
    endif
  else
    throw "vimside#command#ExpandSelection: bad mode: ". string(a:mode)
  endif
endif
endfunction

if 0
function! vimside#command#ExpandRangeSelection(linestart, colstart, lineend, colend)
  let start = line2byte(a:linestart)+a:colstart-1
  if start > 1
    let start -= 1
  endif
  let end = line2byte(a:lineend)+a:colend-1
  let dic = {
            \ 'args': {
            \   'start': start,
            \   'end': end
            \ }
            \ }
  call vimside#swank#rpc#expand_selection#Run(dic)
endfunction
endif

function! vimside#command#ContractSelection() range
call s:LOG("vimside#command#ContractSelection TOP")
  if g:vimside.started
    call vimside#selection#Contract()
  else
    call s:ERROR("Ensime must be started first")
  endif
call s:LOG("vimside#command#ContractSelection BOTTOM")
endfunction

function! vimside#command#HoverToSymbol() range
  if g:vimside.started
    call vimside#hover#ToSymbol()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#UsesOfSymbolAtPoint() range
  if g:vimside.started
    call vimside#swank#rpc#uses_of_symbol_at_point#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#Repl() range
  if g:vimside.started
    call vimside#swank#rpc#repl_config#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#TypecheckFile() range
  if g:vimside.started
    call vimside#swank#rpc#typecheck_file#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#TypecheckAll() range
  if g:vimside.started
    call vimside#swank#rpc#typecheck_all#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#FormatSource() range
  if g:vimside.started
    call vimside#swank#rpc#format_source#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#MapPopUp(mode) range
  if g:vimside.started
    call vimside#forms#menu#MakePopUp(a:mode)
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#BrowseSourceRoots() range
  if g:vimside.started
    let [found, forms_use] = g:vimside.GetOption('vimside-forms-use')
    let sources = g:vimside.project.info['source_roots']
    if found
      if forms_use
        call vimside#forms#sourcebrowser#Run(sources)
      else
        call vimside#plugin#sourcebrowser#Run(sources)
      endif
    else
      call s:ERROR("Vimside: Option not found: "'vimside-forms-use'")
    endif
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#BrowseReferenceSourceRoots() range
  if g:vimside.started
    let [found, forms_use] = g:vimside.GetOption('vimside-forms-use')
    let sources = g:vimside.project.info['reference_source_roots']
    if found
      if forms_use
        call vimside#forms#sourcebrowser#Run(sources)
      else
        call vimside#plugin#sourcebrowser#Run(sources)
      endif
    else
      call s:ERROR("Vimside: Option not found: "'vimside-forms-use'")
    endif
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction

function! vimside#command#OptionEditor() range
  if g:vimside.started
    call vimside#forms#optioneditor#Run()
  else
    call s:ERROR("Ensime must be started first")
  endif
endfunction


