" ============================================================================
" builder.vim
"
" File:          builder.vim
" Summary:       Vimside Builder
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:current_files = {}

function! vimside#command#builder#Build()
  " One event following build
  let dic = {
        \ 'events': 2
        \ }
  call vimside#swank#rpc#builder_init#Run(dic)

  call vimside#command#builder#ClearTrackFiles()
endfunction

function! vimside#command#builder#ReBuild()
  let keys = keys(s:current_files)
  if empty(keys)
    echo "Nothing to rebuild."
  else
    let dic = {
          \ 'args': {
          \   'files': copy(keys)
          \ }
          \ }
    call vimside#swank#rpc#builder_update_files#Run(dic)

    call vimside#command#builder#ClearTrackFiles()
  endif
endfunction



function! vimside#command#builder#ClearTrackFiles()
  let s:current_files = {}
endfunction

function! vimside#command#builder#AddTrackFile()
  let [found, fn] = vimside#util#GetCurrentFilename()
  if found
    let s:current_files[fn] = 1
  endif
endfunction

