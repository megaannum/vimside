" ============================================================================
" uses_of_symbol_at_point.vim
"
" File:          uses_of_symbol_at_point.vim
" Summary:       Vimside Uses of Symbol At Point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:WARN = function("vimside#log#warn")
let s:ERROR = function("vimside#log#error")

let s:actwin_initialized = 0
let s:quickfix_initialized = 0

function! s:InitializeActWing()
  let l:option = 'tailor-uses-of-symbol-at-point-use-actwin-display-scala-sign-enable'
  let [l:found, s:scala_sign_enable] = g:vimside.GetOption(l:option)
  if ! l:found
    call s:WARN("vimside#command#uses_of_symbol_at_point s:InitializeActWing: Option not found: ". l:option)
    let s:scala_sign_enable = 0
  endif

  let l:option = 'tailor-uses-of-symbol-at-point-use-actwin-display-scala-color-line-enable'
  let [l:found, s:scala_color_line_enable] = g:vimside.GetOption(l:option)
  if ! l:found
    call s:WARN("vimside#command#uses_of_symbol_at_point s:InitializeActWing: Option not found: ". l:option)
    let s:scala_color_line_enable = 0
  endif

  let l:option = 'tailor-uses-of-symbol-at-point-use-actwin-display-scala-color-column-enable'
  let [l:found, s:scala_color_column_enable] = g:vimside.GetOption(l:option)
  if ! l:found
    call s:WARN("vimside#command#uses_of_symbol_at_point s:InitializeActWing: Option not found: ". l:option)
    let s:scala_color_column_enable = 0
  endif

  let l:option = 'tailor-uses-of-symbol-at-point-use-actwin-display-actwin-cursor-line-enable'
  let [l:found, s:actwin_cursor_line_enable] = g:vimside.GetOption(l:option)
  if ! l:found
    call s:WARN("vimside#command#uses_of_symbol_at_point s:InitializeActWing: Option not found: ". l:option)
    let s:actwin_cursor_line_enable = 0
  endif

  let l:option = 'tailor-uses-of-symbol-at-point-use-actwin-display-actwin-highlight-line-enable'
  let [l:found, s:actwin_highlight_line_enable] = g:vimside.GetOption(l:option)
  if ! l:found
    call s:WARN("vimside#command#uses_of_symbol_at_point s:InitializeActWing: Option not found: ". l:option)
    let s:actwin_highlight_line_enable = 0
  endif

  let l:option = 'tailor-uses-of-symbol-at-point-use-actwin-display-actwin-sign-enable'
  let [l:found, s:actwin_sign_enable] = g:vimside.GetOption(l:option)
  if ! l:found
    call s:WARN("vimside#command#uses_of_symbol_at_point s:InitializeActWing: Option not found: ". l:option)
    let s:actwin_sign_enable = 0
  endif

  let s:actwin_initialized = 1
endfunction

function! s:InitializeQuickFix()
  let [l:found, s:use_signs] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-use-signs')
  if ! l:found
    let s:use_signs = 0
  endif
  let [l:found, s:use_sign_kind_marker] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-use-sign-kind-marker')
  if ! l:found
    let s:use_sign_kind_marker = 0
  endif

  let s:quickfix_initialized = 1
endfunction

function! vimside#command#uses_of_symbol_at_point#Run()
  let [found, filename] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr filename
    return
  endif

" call s:LOG("vimside#command#uses_of_symbol_at_point#Run filename=".filename) 
  let offset = vimside#util#GetCurrentOffset()

  let dic = {
        \ 'handler': {
        \   'ok': function("g:uses_of_symbol_at_point_callback")
        \ },
        \ 'args': {
        \   'filename': filename,
        \   'offset': offset
        \ }
        \ }
  call vimside#swank#rpc#uses_of_symbol_at_point#Run(dic)
endfunction

function! g:uses_of_symbol_at_point_callback(diclist, ...)
  let l:diclist = a:diclist
" call s:LOG("uses_of_symbol_at_point_callback dic=list".  string(l:diclist)) 
if 0 " XXX
  if a:0 == 0
    let l:start_line = -1
  else
    let l:start_line = a:1
  endif
call s:LOG("uses_of_symbol_at_point_callback start_line=".  l:start_line) 
endif " XXX

   let [found, l:window] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-window')
   if found
     if l:window == 'actwin'
call s:LOG("uses_of_symbol_at_point_callback call ActWin Display") 
        return s:ActWin(l:diclist)
      elseif l:window == 'quickfix'
call s:LOG("uses_of_symbol_at_point_callback call Quickfix Display") 
        return s:Quickfix(l:diclist)
      else " punt
call s:LOG("uses_of_symbol_at_point_callback punt call ActWin Display") 
        return s:ActWin(l:diclist)
      endif
   else " default
call s:LOG("uses_of_symbol_at_point_callback default call ActWin Display") 
      return s:ActWin(l:diclist)
   endif
endfunction

function! s:Quickfix(diclist)
  let l:diclist = a:diclist
call s:LOG("uses_of_symbol_at_point_callback Quickfix TOP") 
  if ! s:quickfix_initialized 
    call s:InitializeQuickFix()
  endif

  let l:entries = []
  let l:same_file = 1

  let l:current_file = expand('%:p')
  let l:len = len(l:diclist)
  let l:cnt = 0
  while l:cnt < l:len
    let l:dic = l:diclist[cnt]

    let l:file = l:dic[':file']
    let l:offset = l:dic[':offset']

    if l:current_file == l:file
      let [l:lnum, l:column, l:text] = vimside#util#GetLineColumnTextFromOffset(l:offset)
if 0 " XXX
      if l:lnum == l:start_line && s:use_sign_kind_marker
        let l:kind = 'marker'
      else
        let l:kind = 'info'
      endif
endif " XXX
      let l:kind = 'info'
    else
      let l:same_file = 0
      let [l:lnum, l:column, l:text] = vimside#util#GetLineColumnTextFromOffset(l:offset, l:file)
      let l:kind = 'info'
    endif
call s:LOG("uses_of_symbol_at_point_callback kind=".  l:kind) 

    let l:entry = {
      \ 'filename': l:file,
      \ 'lnum': l:lnum,
      \ 'col': l:column,
      \ 'vcol': 1,
      \ 'text': l:text,
      \ 'kind': l:kind,
      \ 'type': 'r',
      \  'nr': (l:cnt + 1)
      \ }

    call add(l:entries, l:entry)
call s:LOG("uses_of_symbol_at_point_callback Quickfix entry=".  string(entry)) 

    let l:cnt += 1
  endwhile

  let l:location = s:GetLocation()
call s:LOG("uses_of_symbol_at_point_callback location=".  l:location) 

  let g:switchbuf_save = &switchbuf

  if l:location == 'tab_window'
    let &switchbuf = "usetab,newtab"
  elseif l:location == 'split_window'
    let &switchbuf = "useopen,split"
  elseif l:location == 'vsplit_window'
    vsplit
    let &switchbuf = ""
  else " l:location == 'same_window'
    let &switchbuf = ""
  endif

  call vimside#quickfix#Display(l:entries, s:use_signs) 
   

  let l:bn = bufnr("$")
" call s:LOG("uses_of_symbol_at_point_callback bn=".  l:bn) 
  if l:bn != -1
    augroup VIMSIDE_USAP
      autocmd!
      execute "autocmd BufWinLeave <buffer=" . l:bn . "> call s:CloseWindow()"
    augroup END
  endif

call s:LOG("uses_of_symbol_at_point_callback Quickfix BOTTOM") 
  return 1
endfunction

function! s:ActWin(diclist)
  let l:diclist = a:diclist
call s:LOG("uses_of_symbol_at_point_callback ActWin TOP") 
  if ! s:actwin_initialized
    call s:InitializeActWing()
  endif

  let l:entries = []

  let l:current_file = expand('%:p')
  let l:len = len(diclist)
  let l:cnt = 0
  while l:cnt < l:len
    let l:dic = l:diclist[cnt]

    let l:file = l:dic[':file']
    let l:offset = l:dic[':offset']

    if l:current_file == l:file
      let [l:line, l:col, l:text] = vimside#util#GetLineColumnTextFromOffset(l:offset)
    else
      let [l:line, l:col, l:text] = vimside#util#GetLineColumnTextFromOffset(l:offset, l:file)
    endif
    let l:kind = 'info'

    let l:content = fnamemodify(l:file, ':t') .'('. l:line .','. l:col .'): '. l:text

    let l:entry = {
      \ 'content': l:content,
      \ 'file': l:file,
      \ 'line': l:line,
      \ 'col': l:col,
      \ 'kind': l:kind
      \ }

    call add(l:entries, l:entry)
call s:LOG("uses_of_symbol_at_point_callback ActWin entry=".  string(entry)) 

    let l:cnt += 1
  endwhile

  let l:helpdata = {
        \ "title": "Help Window",
        \ "winname": "Help",
        \ "actwin": {
          \ "edit": {
          \ "cmd": "enew"
          \ }
        \ },
        \ "cmds": {
          \ "actwin": {
            \ "map": {
              \ "close": "q"
            \ }
          \ }
        \ },
        \ "actions": {
          \ "enter": function("vimside#actwin#EnterActionDoNothing"),
          \ "select": function("vimside#actwin#SelectActionDoNothing"),
          \ "leave": function("vimside#actwin#LeaveActionDoNothing")
        \ },
        \ "entries": [
        \  { 'content': [
            \  "Use of Symbol at Point",
            \  "  Where a symbol is defined and where it is used.",
            \  "  To close help, enter 'q'."
            \ ],
          \ "kind": "info"
          \ }
        \ ]
    \ }


  let l:cmds = {
          \ "scala": {
            \ "cmd": {
              \ "first": "cr",
              \ "last": "cl",
              \ "previous": "cp",
              \ "next": "cn",
              \ "enter": "ce",
              \ "delete": "ccd",
              \ "close": "ccl"
            \ },
            \ "map": {
              \ "first": "<Leader>cr",
              \ "last": "<Leader>cl",
              \ "previous": "<Leader>cp",
              \ "next": "<Leader>cn",
              \ "enter": "<Leader>ce",
              \ "delete": "<Leader>ccd",
              \ "close": "<Leader>ccl"
            \ }
          \ },
          \ "actwin": {
            \ "map": {
              \ "actwin_key_map_show": "<F2>",
              \ "scala_cmd_show": "<F3>",
              \ "scala_key_map_show": "<F4>",
              \ "help": "<F1>",
              \ "select": [ "<CR>", "<2-LeftMouse>"],
              \ "enter_mouse": "<LeftMouse> <LeftMouse>",
              \ "top": [ "gg", "1G", "<PageUp>"],
              \ "bottom": [ "G", "<PageDown>"],
              \ "down": [ "j", "<Down>"],
              \ "up": [ "k", "<Up>"],
              \ "delete": "dd",
              \ "close": "q"
            \ }
          \ }
        \ }


  let l:scala = {
            \ "sign": {
              \ "info": "use sign to note all entry line/col kind",
              \ "is_enable": s:scala_sign_enable,
              \ "category": "UseOfSymbolAtPoint",
              \ "abbreviation": "tw",
              \ "toggle": {
                \ "actwin": {
                  \ "map": "tw",
                  \ "cmd": "TW",
                  \ "abbr": "tw"
                \ },
                \ "scala": {
                  \ "map": "tw",
                  \ "cmd": "TW",
                  \ "abbr": "tw"
                \ }
              \ },
              \ "default_kind": "marker",
              \ "kinds": {
                \ "info": {
                  \ "text": "I>",
                  \ "texthl": "DiffAdd",
                  \ "linehl": "ColorColumn"
                \ },
                \ "marker": {
                  \ "text": "M>",
                  \ "texthl": "Search",
                  \ "linehl": "Ignore"
                \ }
              \ }
            \ },
            \ "color_line": {
              \ "info": "use sign to note current entry line kind",
              \ "is_enable": s:scala_color_line_enable,
              \ "is_on": 0,
              \ "category": "ColorLine",
              \ "toggle": {
                \ "actwin": {
                  \ "map": "tc",
                  \ "cmd": "TC",
                  \ "abbr": "tc"
                \ },
                \ "scala": {
                  \ "map": "tc",
                  \ "cmd": "TC",
                  \ "abbr": "tc"
                \ }
              \ },
              \ "abbreviation": "cl",
              \ "default_kind": "marker",
              \ "kinds": {
                \ "info": {
                  \ "text": "II",
                  \ "texthl": "DiffAdd",
                  \ "linehl": "ColorColumn"
                \ },
                \ "marker": {
                  \ "text": "MM",
                  \ "texthl": "Search",
                  \ "linehl": "Search"
                \ }
              \ }
            \ },
            \ "color_column": {
              \ "info": "use colorcolumn to note current entry col",
              \ "is_enable": s:scala_color_column_enable,
              \ "is_on": 0,
              \ "colorcolumn": "cterm=reverse"
            \ }
          \ }

  let l:actwin = {
            \ "cursor_line": {
              \ "info": "use cursorline to note current line",
              \ "is_enable": s:actwin_cursor_line_enable,
              \ "is_on": 0,
              \ "cursorline": "cterm=bold ctermfg=DarkYellow ctermbg=Cyan",
              \ "toggle": {
                \ "scala": {
                  \ "map": "wc",
                  \ "cmd": "WC",
                  \ "abbr": "wc"
                \ },
                \ "actwin": {
                  \ "map": "wc",
                  \ "cmd": "WC",
                  \ "abbr": "wc"
                \ }
              \ }
            \ },
            \ "highlight_line": {
              \ "info": "use pattern to note current line",
              \ "is_enable": s:actwin_highlight_line_enable,
              \ "is_on": 0,
              \ "is_full": 1,
              \ "nos_columns": 0,
              \ "all_text": 1,
              \ "toggle": {
                \ "actwin": {
                  \ "map": "wh",
                  \ "cmd": "WH",
                  \ "abbr": "wh"
                \ },
                \ "scala": {
                  \ "map": "wh",
                  \ "cmd": "WH",
                  \ "abbr": "wh"
                \ }
              \ }
            \ },
            \ "sign": {
              \ "info": "use sign to note current line",
              \ "is_enable": s:actwin_sign_enable,
              \ "all_text": 1,
              \ "category": "ScalaWindow",
              \ "abbreviation": "sw",
              \ "toggle": {
                \ "actwin": {
                  \ "map": "ws",
                  \ "cmd": "WS",
                  \ "abbr": "ws"
                \ },
                \ "scala": {
                  \ "map": "ws",
                  \ "cmd": "WS",
                  \ "abbr": "ws"
                \ }
              \ },
              \ "default_kind": "marker",
              \ "kinds": {
                \ "info": {
                  \ "texthl": "DiffAdd",
                  \ "text": "I>"
                \ },
                \ "marker": {
                  \ "text": "M>"
                \ }
              \ }
            \ }
          \ }

  let l:display = {
          \ "scala": l:scala,
          \ "actwin": l:actwin
          \ }

  let l:data = {
        \ "title": "Test Window",
        \ "winname": "Test",
        \ "help": {
          \ "do_show": 1,
          \ "data": l:helpdata,
        \ },
        \ "cmds": l:cmds,
        \ "display": l:display,
        \ "actions": {
          \ "enter": function("vimside#actwin#EnterActionQuickFix"),
          \ "select": function("vimside#actwin#SelectActionQuickFix"),
          \ "leave": function("vimside#actwin#LeaveActionQuickFix")
        \ },
        \ "entries": l:entries,
    \ }
  call vimside#actwin#DisplayLocal('uses_of_symbol', l:data)

call s:LOG("uses_of_symbol_at_point_callback ActWin BOTTOM") 
endfunction


if 0 " REMOVE
function! g:uses_of_symbol_at_point_callback(diclist, ...)
  let diclist = a:diclist
" call s:LOG("uses_of_symbol_at_point_callback dic=list".  string(diclist)) 
  if a:0 == 0
    let l:start_line = -1
  else
    let l:start_line = a:1
  endif
call s:LOG("uses_of_symbol_at_point_callback start_line=".  l:start_line) 
  let entries = []
  let l:same_file = 1

  let current_file = expand('%:p')
  let len = len(diclist)
  let cnt = 0
  while cnt < len
    let dic = diclist[cnt]

    let file = dic[':file']
    let offset = dic[':offset']

    if current_file == file
      let [lnum, column, text] = vimside#util#GetLineColumnTextFromOffset(offset)
      if lnum == l:start_line && s:use_sign_kind_marker
        let l:kind = 'marker'
      else
        let l:kind = 'info'
      endif
    else
      let l:same_file = 0
      let [lnum, column, text] = vimside#util#GetLineColumnTextFromOffset(offset, file)
      let l:kind = 'info'
    endif
call s:LOG("uses_of_symbol_at_point_callback kind=".  l:kind) 

    let entry = {
      \ 'filename': file,
      \ 'lnum': lnum,
      \ 'col': column,
      \ 'vcol': 1,
      \ 'text': text,
      \ 'kind': l:kind,
      \ 'type': 'r',
      \  'nr': (cnt + 1)
      \ }

    call add(entries, entry)
" call s:LOG("uses_of_symbol_at_point_callback entry=".  string(entry)) 

    let cnt += 1
  endwhile

  let location = s:GetLocation()
call s:LOG("uses_of_symbol_at_point_callback location=".  location) 

  let g:switchbuf_save = &switchbuf

  if location == 'tab_window'
    let &switchbuf = "usetab,newtab"
  elseif location == 'split_window'
    let &switchbuf = "useopen,split"
  elseif location == 'vsplit_window'
    vsplit
    let &switchbuf = ""
  else " location == 'same_window'
    let &switchbuf = ""
  endif

" call s:LOG("uses_of_symbol_at_point_callback call s:use_signs=". s:use_signs) 
   let [found, l:window] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-window')
   if found
     if l:window == 'quickfix'
" call s:LOG("uses_of_symbol_at_point_callback call quickfix Display") 
      call vimside#quickfix#Display(entries, s:use_signs) 
     else " mixed
      if l:same_file
" call s:LOG("uses_of_symbol_at_point_callback call locationlist Display") 
        call vimside#locationlist#Display(entries, s:use_signs) 
      else
" call s:LOG("uses_of_symbol_at_point_callback call quickfix Display") 
        call vimside#quickfix#Display(entries, s:use_signs) 
      endif
     endif
   else " default
" call s:LOG("uses_of_symbol_at_point_callback call quickfix Display") 
      call vimside#quickfix#Display(entries, s:use_signs) 
   endif


  let bn = bufnr("$")
" call s:LOG("uses_of_symbol_at_point_callback bn=".  bn) 
  if bn != -s
    augroup VIMSIDE_USAP
      autocmd!
      execute "autocmd BufWinLeave <buffer=" . bn . "> call s:CloseWindow()"
    augroup END
  endif

  return 1
endfunction
endif " REMOVE

function! s:GetLocation()
  let l:option_name = 'tailor-uses-of-symbol-at-point-location'
  let l:default_location = 'same_window'
  return vimside#util#GetLocation(l:option_name, l:default_location)
endfunction

function! s:CloseWindow()
call s:LOG("CloseWindow:") 

  augroup VIMSIDE_USAP
   autocmd!
  augroup END

  let &switchbuf = g:switchbuf_save

  let location = s:GetLocation()
  if location == 'vsplit_window'
    quit
  endif
endfunction
