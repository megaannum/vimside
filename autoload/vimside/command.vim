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
  call vimside#plugin#sourcebrowser#Run(g:vimside.project.info['source_roots'])
endfunction

function! vimside#command#BrowseReferenceSourceRoots()
  call vimside#plugin#sourcebrowser#Run(g:vimside.project.info['reference_source_roots'])
endfunction



