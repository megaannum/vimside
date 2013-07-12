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
    call add(l:options, [l:option_name, l:value])
  endfor

  return l:options
endfunction

" Mirrors Java's Properties file reading code
" return [0, _] or [1, [[[part, ...], value]]]
function! vimside#property#ParseFile(filename)
  if ! filereadable(a:filename)
    return [0, []]
  endif

  let l:proplist = []

  let l:keep_processing_lines = 1
  let l:lines = readfile(a:filename)
  let l:current_line = 0
  let l:nos_lines = len(l:lines)
" echo "l:nos_lines=". l:nos_lines


  while l:keep_processing_lines
" echo "while l:keep_processing_lines"

    let l:line_buf = ""

    let l:skip_white_space = 1
    let l:in_comment = 0
    let l:is_new_line = 1
    let l:append_line_begin = 0
    let l:has_back_slash = 0
    let l:skip_lf = 0

    let l:keep_processing_line = 1

    " start: create a logical line from one or more input lines
    while l:keep_processing_line
" echo "while l:keep_processing_line"

      if l:current_line == l:nos_lines
        let l:keep_processing_lines = 0
        " leave: create a logical line from one or more input lines
" echo "break: keep_processing_lines = 0 EOF"
        break
      endif

      let l:line = l:lines[l:current_line]
" echo "l:line=". l:line
      let l:current_line += 1

      let l:line_len = len(l:line)
      let l:len = 0

      " start: process single input line
      while l:len < l:line_len
        let l:c = l:line[l:len]
        let l:len += 1

        if l:skip_lf
          let l:skip_lf = 0
          if l:c == '\n'
            " goto: process single input line
" echo "continue: skip_lf EOF"
            continue
          endif
        endif

        if l:skip_white_space
          if l:c == ' ' || l:c == '\t' || l:c == '\f'
            " goto: process single input line
" echo "continue: skip_white_space"
            continue
          endif
          if ! l:append_line_begin && (l:c == '\r' || l:c == '\n')
" echo "continue: not append_line_begin EOF"
            " goto: process single input line
            continue
          endif

          let l:skip_white_space = 0
          let l:append_line_begin = 0
        endif

        if l:is_new_line
          let l:is_new_line = 0
          if l:c == '#' || l:c == ':'
            let l:in_comment = 1
            " goto: process single input line
" echo "break: in_comment=1"
            break
          endif
        endif

        let l:line_buf .= l:c

" echo "l:c=". l:c

        if l:c == '\'
          let l:has_back_slash = ! l:has_back_slash
" echo "got has_back_slash=". l:has_back_slash
        else
          let l:has_back_slash = 0
        endif

        if l:len == l:line_len
        
          if l:has_back_slash
" echo "had has_back_slash=". l:has_back_slash
            let l:line_buf = l:line_buf[0 : len(l:line_buf)-2]
" echo "l:line_buf=". l:line_buf
            let l:skip_white_space = 1
            let l:append_line_begin = 1
            let l:has_back_slash = 0
            if l:c == '\r'
              let l:skip_lf = 1
            endif
          else
" echo "leave: keep_processing_line=0"
            let l:keep_processing_line = 0
            " leave: process single input line
            break
          endif

        endif

      " end: process single input line
      endwhile
" echo "after process single input line"

      " end: create a logical line from one or more input lines
    endwhile
" echo "after create logical line"

      let l:limit = l:len
      let l:key_len = 0
      let l:value_start = l:limit
      let l:has_sep = 0
      let l:has_back_slash = 0

      while l:key_len < l:limit
        let l:c = l:line_buf[l:key_len]

        if (l:c == '=') && ! l:has_back_slash
          let l:value_start = l:key_len + 1
          let l:has_sep = 1
          break
        elseif (l:c == ' ' || l:c == '\t' || l:c == '\f') && ! l:has_back_slash
          let l:value_start = l:key_len + 1
          break
        endif

        if l:c == '\\'
          let l:has_back_slash = ! l:has_back_slash
        else
          let l:has_back_slash = 0
        endif

        let l:key_len += 1
      endwhile

      while l:value_start < l:limit
        let l:c = l:line_buf[l:key_len]
        
        if l:c != ' ' && l:c != '\t' && l:c != '\f'
          if ! l:has_sep && c == ' '
            let l:has_sep = 1
          else
            break
          endif
        endif

        let l:value_start += 1
      endwhile
" echo "l:line_buf=". l:line_buf

      let l:key = l:line_buf[0 : (l:key_len-1)]
" echo "l:key=". l:key
      let l:value = l:line_buf[(l:key_len+1) : ]
" echo "l:value=". l:value
      let l:keylist = split(l:key, '\.')
      let l:keylist_value = [l:keylist, l:value]

      call add(l:proplist, l:keylist_value)
      let l:line_buf = ""

" echo "l:current_line=". l:current_line
      if l:current_line == l:nos_lines
        break
      endif

  endwhile


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
