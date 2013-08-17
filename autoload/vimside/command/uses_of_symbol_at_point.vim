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

function! s:GetOption(option, defaultvalue)
  let [l:found, l:value ] = g:vimside.GetOption(a:option)
  if l:found
    return l:value
  else
    call s:WARN("vimside#command#uses_of_symbol_at_point s:GetOption: Option not found: ". a:option)
    return a:defaultvalue 
  endif
endfunction

function! s:InitializeActWin()
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-scala-sign-enable'
  let s:scala_sign_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-scala-color-line-enable'
  let s:scala_color_line_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-scala-color-column-enable'
  let s:scala_color_column_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-actwin-cursor-line-enable'
  let s:actwin_cursor_line_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-actwin-highlight-line-enable'
  let s:actwin_highlight_line_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-actwin-sign-enable'
  let s:actwin_sign_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-scala-sign-on'
  let s:scala_sign_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-scala-color-line-on'
  let s:scala_color_line_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-scala-color-column-on'
  let s:scala_color_column_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-actwin-cursor-line-on'
  let s:actwin_cursor_line_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-actwin-highlight-line-on'
  let s:actwin_highlight_line_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-display-actwin-sign-on'
  let s:actwin_sign_on = s:GetOption(l:option, 0)


  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-first'
  let s:actwin_cmds_scala_cmd_first = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-last'
  let s:actwin_cmds_scala_cmd_last = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-previous'
  let s:actwin_cmds_scala_cmd_previous = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-next'
  let s:actwin_cmds_scala_cmd_next = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-enter'
  let s:actwin_cmds_scala_cmd_enter = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-delete'
  let s:actwin_cmds_scala_cmd_delete = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-cmd-close'
  let s:actwin_cmds_scala_cmd_close = s:GetOption(l:option, "")

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-first'
  let s:actwin_cmds_scala_map_first = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-last'
  let s:actwin_cmds_scala_map_last = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-previous'
  let s:actwin_cmds_scala_map_previous = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-next'
  let s:actwin_cmds_scala_map_next = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-enter'
  let s:actwin_cmds_scala_map_enter = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-delete'
  let s:actwin_cmds_scala_map_delete = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-scala-map-close'
  let s:actwin_cmds_scala_map_close = s:GetOption(l:option, "")

  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-actwin-map-show'
  let s:actwin_cmds_actwin_map_actwin_map_show = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-scala-cmd-show'
  let s:actwin_cmds_actwin_map_scala_cmd_show = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-scala-map-show'
  let s:actwin_cmds_actwin_map_scala_map_show = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-help'
  let s:actwin_cmds_actwin_map_help = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-select'
  let s:actwin_cmds_actwin_map_select = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-enter-mouse'
  let s:actwin_cmds_actwin_map_enter_mouse = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-top'
  let s:actwin_cmds_actwin_map_top = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-bottom'
  let s:actwin_cmds_actwin_map_bottom = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-down'
  let s:actwin_cmds_actwin_map_down = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-up'
  let s:actwin_cmds_actwin_map_up = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-delete'
  let s:actwin_cmds_actwin_map_delete = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-actwin-cmds-actwin-map-close'
  let s:actwin_cmds_actwin_map_close = s:GetOption(l:option, "")

  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-toggle-actwin-map'
  let s:scala_sign_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-toggle-actwin-cmd'
  let s:scala_sign_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-toggle-actwin-abbr'
  let s:scala_sign_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-toggle-scala-map'
  let s:scala_sign_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-toggle-scala-cmd'
  let s:scala_sign_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-toggle-scala-abbr'
  let s:scala_sign_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-actwin-map'
  let s:scala_color_line_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-actwin-cmd'
  let s:scala_color_line_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-actwin-abbr'
  let s:scala_color_line_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-scala-map'
  let s:scala_color_line_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-scala-cmd'
  let s:scala_color_line_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-toggle-scala-abbr'
  let s:scala_color_line_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-actwin-map'
  let s:scala_color_column_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-actwin-cmd'
  let s:scala_color_column_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-actwin-abbr'
  let s:scala_color_column_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-scala-map'
  let s:scala_color_column_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-scala-cmd'
  let s:scala_color_column_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-toggle-scala-abbr'
  let s:scala_color_column_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-actwin-map'
  let s:actwin_cursor_line_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-actwin-cmd'
  let s:actwin_cursor_line_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-actwin-abbr'
  let s:actwin_cursor_line_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-scala-map'
  let s:actwin_cursor_line_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-scala-cmd'
  let s:actwin_cursor_line_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-toggle-scala-abbr'
  let s:actwin_cursor_line_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-actwin-map'
  let s:actwin_highlight_line_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-actwin-cmd'
  let s:actwin_highlight_line_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-actwin-abbr'
  let s:actwin_highlight_line_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-scala-map'
  let s:actwin_highlight_line_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-scala-cmd'
  let s:actwin_highlight_line_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-toggle-scala-abbr'
  let s:actwin_highlight_line_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-actwin-map'
  let s:actwin_sign_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-actwin-cmd'
  let s:actwin_sign_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-actwin-abbr'
  let s:actwin_sign_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-scala-map'
  let s:actwin_sign_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-scala-cmd'
  let s:actwin_sign_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-toggle-scala-abbr'
  let s:actwin_sign_toggle_scala_abbr = s:GetOption(l:option, "")


  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-kinds-info-text'
  let s:scala_sign_kinds_info_text = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-kinds-info-texthl'
  let s:scala_sign_kinds_info_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-kinds-info-linehl'
  let s:scala_sign_kinds_info_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-kinds-marker-text'
  let s:scala_sign_kinds_marker_text = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-kinds-marker-texthl'
  let s:scala_sign_kinds_marker_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-sign-kinds-marker-linehl'
  let s:scala_sign_kinds_marker_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-info-text'
  let s:scala_color_line_kinds_info_text = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-info-texthl'
  let s:scala_color_line_kinds_info_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-info-linehl'
  let s:scala_color_line_kinds_info_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-marker-text'
  let s:scala_color_line_kinds_marker_text = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-marker-texthl'
  let s:scala_color_line_kinds_marker_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-line-kinds-marker-linehl'
  let s:scala_color_line_kinds_marker_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-scala-color-column-color-column'
  let s:scala_color_column_color_column = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-cursor-line-highlight'
  let s:actwin_cursor_line_highlight = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-highlight-line-highlight'
  let s:actwin_highlight_line_highlight = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-info-text'
  let s:actwin_sign_kinds_info_text = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-info-texthl'
  let s:actwin_sign_kinds_info_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-info-linehl'
  let s:actwin_sign_kinds_info_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-marker-text'
  let s:actwin_sign_kinds_marker_text = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-marker-texthl'
  let s:actwin_sign_kinds_marker_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-uses-of-symbol-at-point-display-actwin-sign-kinds-marker-linehl'
  let s:actwin_sign_kinds_marker_linehl = s:GetOption(l:option, "")


  let s:actwin_initialized = 1
endfunction

function! s:InitializeQuickFix()
  let s:use_signs = s:GetOption('tailor-uses-of-symbol-at-point-use-signs', 0)
  let s:use_sign_kind_marker = s:GetOption('tailor-uses-of-symbol-at-point-use-sign-kind-marker', 0)

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

  let s:switchbuf_save = &switchbuf

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
    call s:InitializeActWin()
  endif

  let l:entries = []

  let l:current_file = expand('%:p')
  let l:len = len(diclist)
  if l:len == 0
call s:LOG("uses_of_symbol_at_point_callback ActWin diclist empty") 
    return
  endif
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
              \ "first": s:actwin_cmds_scala_cmd_first,
              \ "last":  s:actwin_cmds_scala_cmd_last,
              \ "previous": s:actwin_cmds_scala_cmd_previous,
              \ "next": s:actwin_cmds_scala_cmd_next,
              \ "enter": s:actwin_cmds_scala_cmd_enter,
              \ "delete": s:actwin_cmds_scala_cmd_delete,
              \ "close": s:actwin_cmds_scala_cmd_close
            \ },
            \ "map": {
              \ "first": s:actwin_cmds_scala_map_first,
              \ "last": s:actwin_cmds_scala_map_last,
              \ "previous": s:actwin_cmds_scala_map_previous,
              \ "next": s:actwin_cmds_scala_map_next,
              \ "enter": s:actwin_cmds_scala_map_enter,
              \ "delete": s:actwin_cmds_scala_map_delete,
              \ "close": s:actwin_cmds_scala_map_close
            \ }
          \ },
          \ "actwin": {
            \ "map": {
              \ "actwin_map_show": s:actwin_cmds_actwin_map_actwin_map_show,
              \ "scala_cmd_show": s:actwin_cmds_actwin_map_scala_cmd_show,
              \ "scala_map_show": s:actwin_cmds_actwin_map_scala_map_show,
              \ "help": s:actwin_cmds_actwin_map_help,
              \ "select": s:actwin_cmds_actwin_map_select,
              \ "enter_mouse": s:actwin_cmds_actwin_map_enter_mouse,
              \ "top": s:actwin_cmds_actwin_map_top,
              \ "bottom": s:actwin_cmds_actwin_map_bottom,
              \ "down": s:actwin_cmds_actwin_map_down,
              \ "up": s:actwin_cmds_actwin_map_up,
              \ "delete": s:actwin_cmds_actwin_map_delete,
              \ "close": s:actwin_cmds_actwin_map_close
            \ }
          \ }
        \ }


  let l:scala = {
            \ "sign": {
              \ "info": "use sign to note all entry line/col kind",
              \ "is_enable": s:scala_sign_enable,
              \ "is_on": s:scala_sign_on,
              \ "category": "UseOfSymbolAtPoint",
              \ "abbreviation": "tw",
              \ "toggle": {
                \ "actwin": {
                  \ "map": s:scala_sign_toggle_actwin_map,
                  \ "cmd": s:scala_sign_toggle_actwin_cmd,
                  \ "abbr": s:scala_sign_toggle_actwin_abbr
                \ },
                \ "scala": {
                  \ "map": s:scala_sign_toggle_scala_map,
                  \ "cmd": s:scala_sign_toggle_scala_cmd,
                  \ "abbr": s:scala_sign_toggle_scala_abbr
                \ }
              \ },
              \ "default_kind": "marker",
              \ "kinds": {
                \ "info": {
                  \ "text": s:scala_sign_kinds_info_text,
                  \ "texthl": s:scala_sign_kinds_info_texthl,
                  \ "linehl": s:scala_sign_kinds_info_linehl
                \ },
                \ "marker": {
                  \ "text": s:scala_sign_kinds_marker_text,
                  \ "texthl": s:scala_sign_kinds_marker_texthl,
                  \ "linehl": s:scala_sign_kinds_marker_linehl
                \ }
              \ }
            \ },
            \ "color_line": {
              \ "info": "use sign to note current entry line kind",
              \ "is_enable": s:scala_color_line_enable,
              \ "is_on": s:scala_color_line_on,
              \ "category": "USPColorLine",
              \ "toggle": {
                \ "actwin": {
                  \ "map": s:scala_color_line_toggle_actwin_map,
                  \ "cmd": s:scala_color_line_toggle_actwin_cmd,
                  \ "abbr": s:scala_color_line_toggle_actwin_abbr
                \ },
                \ "scala": {
                  \ "map": s:scala_color_line_toggle_scala_map,
                  \ "cmd": s:scala_color_line_toggle_scala_cmd,
                  \ "abbr": s:scala_color_line_toggle_scala_abbr
                \ }
              \ },
              \ "abbreviation": "cl",
              \ "default_kind": "marker",
              \ "kinds": {
                \ "info": {
                  \ "text": s:scala_color_line_kinds_info_text,
                  \ "texthl": s:scala_color_line_kinds_info_texthl,
                  \ "linehl": s:scala_color_line_kinds_info_linehl
                \ },
                \ "marker": {
                  \ "text": s:scala_color_line_kinds_marker_text,
                  \ "texthl": s:scala_color_line_kinds_marker_texthl,
                  \ "linehl": s:scala_color_line_kinds_marker_linehl
                \ }
              \ }
            \ },
            \ "color_column": {
              \ "info": "use colorcolumn to note current entry col",
              \ "is_enable": s:scala_color_column_enable,
              \ "is_on": s:scala_color_column_on,
              \ "toggle": {
                \ "actwin": {
                  \ "map": s:scala_color_column_toggle_actwin_map,
                  \ "cmd": s:scala_color_column_toggle_actwin_cmd,
                  \ "abbr": s:scala_color_column_toggle_actwin_abbr
                \ },
                \ "scala": {
                  \ "map": s:scala_color_column_toggle_scala_map,
                  \ "cmd": s:scala_color_column_toggle_scala_cmd,
                  \ "abbr": s:scala_color_column_toggle_scala_abbr
                \ }
              \ },
              \ "colorcolumn": s:scala_color_column_color_column
            \ }
          \ }

  let l:actwin = {
            \ "cursor_line": {
              \ "info": "use cursorline to note current line",
              \ "is_enable": s:actwin_cursor_line_enable,
              \ "is_on": s:actwin_cursor_line_on,
              \ "highlight": s:actwin_cursor_line_highlight,
              \ "toggle": {
                \ "scala": {
                  \ "map": s:actwin_cursor_line_toggle_actwin_map,
                  \ "cmd": s:actwin_cursor_line_toggle_actwin_cmd,
                  \ "abbr": s:actwin_cursor_line_toggle_actwin_abbr
                \ },
                \ "actwin": {
                  \ "map": s:actwin_cursor_line_toggle_scala_map,
                  \ "cmd": s:actwin_cursor_line_toggle_scala_cmd,
                  \ "abbr": s:actwin_cursor_line_toggle_scala_abbr
                \ }
              \ }
            \ },
            \ "highlight_line": {
              \ "info": "use pattern to note current line",
              \ "is_enable": s:actwin_highlight_line_enable,
              \ "is_on": s:actwin_highlight_line_on,
              \ "is_full": 1,
              \ "nos_columns": 0,
              \ "all_text": 1,
              \ "highlight": s:actwin_highlight_line_highlight,
              \ "toggle": {
                \ "actwin": {
                  \ "map": s:actwin_highlight_line_toggle_actwin_map,
                  \ "cmd": s:actwin_highlight_line_toggle_actwin_cmd,
                  \ "abbr": s:actwin_highlight_line_toggle_actwin_abbr
                \ },
                \ "scala": {
                  \ "map": s:actwin_highlight_line_toggle_scala_map,
                  \ "cmd": s:actwin_highlight_line_toggle_scala_cmd,
                  \ "abbr": s:actwin_highlight_line_toggle_scala_abbr
                \ }
              \ }
            \ },
            \ "sign": {
              \ "info": "use sign to note current line",
              \ "is_enable": s:actwin_sign_enable,
              \ "is_on": s:actwin_sign_on,
              \ "all_text": 1,
              \ "category": "USPScalaWindow",
              \ "abbreviation": "sw",
              \ "toggle": {
                \ "actwin": {
                  \ "map": s:actwin_sign_toggle_actwin_map,
                  \ "cmd": s:actwin_sign_toggle_actwin_cmd,
                  \ "abbr": s:actwin_sign_toggle_actwin_abbr
                \ },
                \ "scala": {
                  \ "map": s:actwin_sign_toggle_scala_map,
                  \ "cmd": s:actwin_sign_toggle_scala_cmd,
                  \ "abbr": s:actwin_sign_toggle_scala_abbr
                \ }
              \ },
              \ "default_kind": "marker",
              \ "kinds": {
                \ "info": {
                  \ "text": s:actwin_sign_kinds_info_text,
                  \ "texthl": s:actwin_sign_kinds_info_texthl,
                  \ "linelh": s:actwin_sign_kinds_info_linehl
                \ },
                \ "marker": {
                  \ "text": s:actwin_sign_kinds_marker_text,
                  \ "texthl": s:actwin_sign_kinds_marker_texthl,
                  \ "linehl": s:actwin_sign_kinds_marker_linehl
                \ }
              \ }
            \ }
          \ }

  let l:display = {
          \ "scala": l:scala,
          \ "actwin": l:actwin
          \ }

  let l:data = {
        \ "action": "c",
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
  call vimside#actwin#DisplayGlobal('uses_of_symbol', l:data)

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

  let &switchbuf = s:switchbuf_save

  let location = s:GetLocation()
  if location == 'vsplit_window'
    quit
  endif
endfunction
