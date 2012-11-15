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

function! vimside#command#StartEnsime()
  call vimside#StartEnsime()
endfunction

function! vimside#command#StopEnsime()
  call vimside#StopEnsime()
endfunction

function! vimside#command#SymbolAtPoint()
  call vimside#swank#rpc#symbol_at_point#Run()
endfunction

function! vimside#command#PreviousPosition()
  call vimside#PreviousPosition()
endfunction

function! vimside#command#ExpandSelection(mode) range
  if a:mode == 'n'
    call vimside#ClearSelection()
    call vimside#swank#rpc#expand_selection#Run()
  elseif a:mode == 'v'
    if ! vimside#ExpandSelection()
      let l:firstline = a:firstline
      let l:firstcol = col("'<")
      let l:lastline = a:lastline
      let l:lastcol = col("'>")

      let start = line2byte(l:firstline)+l:firstcol-1
      if start > 1
        let start -= 1
      endif
      let end = line2byte(l:lastline)+l:lastcol-1
      let dic = {
                \ 'args': {
                \   'start': start,
                \   'end': end
                \ }
                \ }
      call vimside#swank#rpc#expand_selection#Run(dic)
    endif
  else
    throw "vimside#command#ExpandSelection: bad mode: ". string(a:mode)
  endif
endfunction

function! vimside#command#ContractSelection(mode) range
  call vimside#ContractSelection()
endfunction

function! vimside#command#HoverToSymbol()
  call vimside#hover#ToSymbol()
endfunction

function! vimside#command#UsesOfSymbolAtPoint()
  call vimside#swank#rpc#uses_of_symbol_at_point#Run()
endfunction

function! vimside#command#Repl()
  call vimside#swank#rpc#repl_config#Run()
endfunction

function! vimside#command#TypecheckFile()
  call vimside#swank#rpc#typecheck_file#Run()
endfunction

function! vimside#command#TypecheckAll()
  call vimside#swank#rpc#typecheck_all#Run()
endfunction

function! vimside#command#FormatSource()
  call vimside#swank#rpc#format_source#Run()
endfunction

function! vimside#command#MapPopUp(mode)
  call vimside#forms#menu#MakePopUp(a:mode)
endfunction

function! vimside#command#BrowseSourceRoots()
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
endfunction

function! vimside#command#BrowseReferenceSourceRoots()
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
endfunction

function! vimside#command#OptionEditor()
  call vimside#forms#optioneditor#Run()
endfunction


