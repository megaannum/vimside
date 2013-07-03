" ============================================================================
" property.vim
"
" File:          property.vim
" Summary:       property file parsing
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2013
"
" ============================================================================
" Intro: {{{1
" ============================================================================

" let s:LOG = function("vimside#log#log")
" let s:ERROR = function("vimside#log#error")

function! s:LOG(msg)
  execute "redir >> ". "PROP_LOG"
  silent echo "INFO: ". a:msg
  execute "redir END"
endfunction
function! s:ERROR(msg)
  execute "redir >> ". "PROP_LOG"
  silent echo "ERROR: ". a:msg
  execute "redir END"
endfunction

function! s:Strip(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! vimside#property#ConvertOptionNameToPropParts(option_name)
  return split(a:option_name, '-')
endfunction

function! vimside#property#ConvertPropPartsToOptionName(parts)
  return join(a:parts, "-")
endfunction

" return [ [option_name, value] ]
function! vimside#property#ConvertToOptions(props)
  let l:options = []

  for [l:parts, l:value] in a:props
    let l:option_name = vimside#property#ConvertPropPartsToOptionName(l:parts)
    call add(l:options, [l:options_name, l:value])
  endfor

  return l:options
endfunction

" return [0, _] or [1, [[[part, ...], value]]]
function! vimside#property#ParseFile(filename)
  if ! filereadable(a:filename)
    return [0, []]
  endif

  let proplist = []

  for l:line in readfile(a:filename)
    if strpart(l:line, 0, 1) != "#"
      let l:namelist_value = vimside#property#ParseLine(l:line)
      call add(l:proplist, l:namelist_value)
    endif
 endfor

 return [1, l:proplist]
endfunction

" [[part, ...], value]
function! vimside#property#ParseLine(line)
  let [l:namepath, l:value] = split(a:line, '=')
  let l:namepath = s:Strip(l:namepath)
  let l:value = s:Strip(l:value)

  let l:namelist = split(l:namepath, '\.')
  return [l:namelist, l:value]
endfunction
