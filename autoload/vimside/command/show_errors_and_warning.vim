" ============================================================================
" show_errors_and_warning.vim
"
" File:          show_errors_and_warning.vim
" Summary:       Vimside Show Compiler Errors and Warnings
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:WARN = function("vimside#log#warn")
let s:ERROR = function("vimside#log#error")

if 0 " OLD
let [found, use_signs] = g:vimside.GetOption('tailor-show-errors-and-warnings-use-signs')
if found
  let s:show_errors_and_warnings_use_signs = use_signs
else
  let s:show_errors_and_warnings_use_signs = 0
endif

function!  vimside#command#show_errors_and_warning#RunOLD()
" call s:LOG("vimside#command#show_errors_and_warning#RunOLD TOP") 

  let entries = g:vimside.project.java_notes + g:vimside.project.scala_notes
  if len(entries) > 0
    call vimside#quickfix#Display(entries, s:show_errors_and_warnings_use_signs)
  else
    let msg = "No Errors or Warnings"
    call vimside#cmdline#Display(msg) 
  endif

" call s:LOG("vimside#command#show_errors_and_warning#RunOLD BOTTOM") 
endfunction

endif " OLD







let s:actwin_initialized = 0
let s:quickfix_initialized = 0

function! s:GetOption(option, defaultvalue)
  let [l:found, l:value ] = g:vimside.GetOption(a:option)
  if l:found
    return l:value
  else
    call s:WARN("vimside#command#show_errors_and_warning s:GetOption: Option not found: ". a:option)
    return a:defaultvalue 
  endif
endfunction

function! s:InitializeActWin()
  let l:option = 'tailor-show-errors-and-warning-actwin-display-scala-sign-enable'
  let s:scala_sign_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-scala-color-line-enable'
  let s:scala_color_line_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-scala-color-column-enable'
  let s:scala_color_column_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-actwin-cursor-line-enable'
  let s:actwin_cursor_line_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-actwin-highlight-line-enable'
  let s:actwin_highlight_line_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-actwin-sign-enable'
  let s:actwin_sign_enable = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-scala-sign-on'
  let s:scala_sign_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-scala-color-line-on'
  let s:scala_color_line_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-scala-color-column-on'
  let s:scala_color_column_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-actwin-cursor-line-on'
  let s:actwin_cursor_line_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-actwin-highlight-line-on'
  let s:actwin_highlight_line_on = s:GetOption(l:option, 0)

  let l:option = 'tailor-show-errors-and-warning-actwin-display-actwin-sign-on'
  let s:actwin_sign_on = s:GetOption(l:option, 0)


  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-first'
  let s:actwin_cmds_scala_cmd_first = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-last'
  let s:actwin_cmds_scala_cmd_last = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-previous'
  let s:actwin_cmds_scala_cmd_previous = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-next'
  let s:actwin_cmds_scala_cmd_next = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-enter'
  let s:actwin_cmds_scala_cmd_enter = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-delete'
  let s:actwin_cmds_scala_cmd_delete = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-cmd-close'
  let s:actwin_cmds_scala_cmd_close = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-first'
  let s:actwin_cmds_scala_map_first = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-last'
  let s:actwin_cmds_scala_map_last = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-previous'
  let s:actwin_cmds_scala_map_previous = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-next'
  let s:actwin_cmds_scala_map_next = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-enter'
  let s:actwin_cmds_scala_map_enter = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-delete'
  let s:actwin_cmds_scala_map_delete = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-scala-map-close'
  let s:actwin_cmds_scala_map_close = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-actwin-map-show'
  let s:actwin_cmds_actwin_map_actwin_map_show = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-scala-cmd-show'
  let s:actwin_cmds_actwin_map_scala_cmd_show = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-scala-map-show'
  let s:actwin_cmds_actwin_map_scala_map_show = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-help'
  let s:actwin_cmds_actwin_map_help = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-select'
  let s:actwin_cmds_actwin_map_select = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-enter-mouse'
  let s:actwin_cmds_actwin_map_enter_mouse = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-top'
  let s:actwin_cmds_actwin_map_top = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-bottom'
  let s:actwin_cmds_actwin_map_bottom = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-down'
  let s:actwin_cmds_actwin_map_down = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-up'
  let s:actwin_cmds_actwin_map_up = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-delete'
  let s:actwin_cmds_actwin_map_delete = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-actwin-cmds-actwin-map-close'
  let s:actwin_cmds_actwin_map_close = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-toggle-actwin-map'
  let s:scala_sign_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-toggle-actwin-cmd'
  let s:scala_sign_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-toggle-actwin-abbr'
  let s:scala_sign_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-toggle-scala-map'
  let s:scala_sign_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-toggle-scala-cmd'
  let s:scala_sign_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-toggle-scala-abbr'
  let s:scala_sign_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-toggle-actwin-map'
  let s:scala_color_line_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-toggle-actwin-cmd'
  let s:scala_color_line_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-toggle-actwin-abbr'
  let s:scala_color_line_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-toggle-scala-map'
  let s:scala_color_line_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-toggle-scala-cmd'
  let s:scala_color_line_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-toggle-scala-abbr'
  let s:scala_color_line_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-toggle-actwin-map'
  let s:scala_color_column_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-toggle-actwin-cmd'
  let s:scala_color_column_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-toggle-actwin-abbr'
  let s:scala_color_column_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-toggle-scala-map'
  let s:scala_color_column_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-toggle-scala-cmd'
  let s:scala_color_column_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-toggle-scala-abbr'
  let s:scala_color_column_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-actwin-map'
  let s:actwin_cursor_line_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-actwin-cmd'
  let s:actwin_cursor_line_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-actwin-abbr'
  let s:actwin_cursor_line_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-scala-map'
  let s:actwin_cursor_line_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-scala-cmd'
  let s:actwin_cursor_line_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-toggle-scala-abbr'
  let s:actwin_cursor_line_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-actwin-map'
  let s:actwin_highlight_line_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-actwin-cmd'
  let s:actwin_highlight_line_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-actwin-abbr'
  let s:actwin_highlight_line_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-scala-map'
  let s:actwin_highlight_line_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-scala-cmd'
  let s:actwin_highlight_line_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-toggle-scala-abbr'
  let s:actwin_highlight_line_toggle_scala_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-toggle-actwin-map'
  let s:actwin_sign_toggle_actwin_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-toggle-actwin-cmd'
  let s:actwin_sign_toggle_actwin_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-toggle-actwin-abbr'
  let s:actwin_sign_toggle_actwin_abbr = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-toggle-scala-map'
  let s:actwin_sign_toggle_scala_map = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-toggle-scala-cmd'
  let s:actwin_sign_toggle_scala_cmd = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-toggle-scala-abbr'
  let s:actwin_sign_toggle_scala_abbr = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-error-text'
  let s:scala_sign_kinds_error_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-error-texthl'
  let s:scala_sign_kinds_error_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-error-linehl'
  let s:scala_sign_kinds_error_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-warn-text'
  let s:scala_sign_kinds_warn_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-warn-texthl'
  let s:scala_sign_kinds_warn_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-warn-linehl'
  let s:scala_sign_kinds_warn_linehl = s:GetOption(l:option, "")


  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-info-text'
  let s:scala_sign_kinds_info_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-info-texthl'
  let s:scala_sign_kinds_info_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-info-linehl'
  let s:scala_sign_kinds_info_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-marker-text'
  let s:scala_sign_kinds_marker_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-marker-texthl'
  let s:scala_sign_kinds_marker_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-sign-kinds-marker-linehl'
  let s:scala_sign_kinds_marker_linehl = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-error-text'
  let s:scala_color_line_kinds_error_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-error-texthl'
  let s:scala_color_line_kinds_error_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-error-linehl'
  let s:scala_color_line_kinds_error_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-warn-text'
  let s:scala_color_line_kinds_warn_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-warn-texthl'
  let s:scala_color_line_kinds_warn_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-warn-linehl'
  let s:scala_color_line_kinds_warn_linehl = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-info-text'
  let s:scala_color_line_kinds_info_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-info-texthl'
  let s:scala_color_line_kinds_info_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-info-linehl'
  let s:scala_color_line_kinds_info_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-marker-text'
  let s:scala_color_line_kinds_marker_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-marker-texthl'
  let s:scala_color_line_kinds_marker_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-line-kinds-marker-linehl'
  let s:scala_color_line_kinds_marker_linehl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-scala-color-column-color-column'
  let s:scala_color_column_color_column = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-cursor-line-highlight'
  let s:actwin_cursor_line_highlight = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-highlight-line-highlight'
  let s:actwin_highlight_line_highlight = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-error-text'
  let s:actwin_sign_kinds_error_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-error-texthl'
  let s:actwin_sign_kinds_error_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-error-linehl'
  let s:actwin_sign_kinds_error_linehl = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-warn-text'
  let s:actwin_sign_kinds_warn_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-warn-texthl'
  let s:actwin_sign_kinds_warn_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-warn-linehl'
  let s:actwin_sign_kinds_warn_linehl = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-info-text'
  let s:actwin_sign_kinds_info_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-info-texthl'
  let s:actwin_sign_kinds_info_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-info-linehl'
  let s:actwin_sign_kinds_info_linehl = s:GetOption(l:option, "")

  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-marker-text'
  let s:actwin_sign_kinds_marker_text = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-marker-texthl'
  let s:actwin_sign_kinds_marker_texthl = s:GetOption(l:option, "")
  let l:option = 'tailor-show-errors-and-warning-display-actwin-sign-kinds-marker-linehl'
  let s:actwin_sign_kinds_marker_linehl = s:GetOption(l:option, "")

  let s:actwin_initialized = 1
endfunction

function! s:InitializeQuickFix()
  let s:use_signs = s:GetOption('tailor-show-errors-and-warnings-use-signs', 0)
  let s:quickfix_initialized = 1
endfunction

function!  vimside#command#show_errors_and_warning#Close()
call s:LOG("vimside#command#show_errors_and_warning#Close TOP") 
  let [found, l:window] = g:vimside.GetOption('tailor-show-errors-and-warning-window')
  if found
    if l:window == 'actwin'
      return s:ActWinClose()
    elseif l:window == 'quickfix'
      return s:QuickfixClose()
    else " punt
      return s:ActWinClose()
    endif
  endif
call s:LOG("vimside#command#show_errors_and_warning#Close BOTTOM") 
endfunction

function!  vimside#command#show_errors_and_warning#Run(action)
call s:LOG("vimside#command#show_errors_and_warning#Run TOP") 

  let l:entries = g:vimside.project.java_notes + g:vimside.project.scala_notes
  if len(l:entries) > 0
    let [found, l:window] = g:vimside.GetOption('tailor-show-errors-and-warning-window')
    if found
      if l:window == 'actwin'
call s:LOG("show_errors_and_warning call ActWin Display") 
        return s:ActWin(l:entries, a:action)
      elseif l:window == 'quickfix'
call s:LOG("show_errors_and_warning call Quickfix Display") 
        return s:Quickfix(l:entries, a:action)
      else " punt
call s:LOG("show_errors_and_warning punt call ActWin Display") 
        return s:ActWin(l:entries, a:action)
      endif
    else " default
call s:LOG("show_errors_and_warning default call ActWin Display") 
      return s:ActWin(l:entries, a:action)
    endif

  else
    let msg = "No Errors or Warnings"
    call vimside#cmdline#Display(msg) 
  endif

call s:LOG("vimside#command#show_errors_and_warning#Run BOTTOM") 
endfunction

function! s:QuickfixClose()
  call vimside#quickfix#Close()
endfunction

function! s:Quickfix(entries, action)
  let l:entries = a:entries
call s:LOG("show_errors_and_warning Quickfix TOP") 
  if ! s:quickfix_initialized 
    call s:InitializeQuickFix()
  endif

  let l:location = s:GetLocation()
call s:LOG("show_errors_and_warning location=".  l:location) 

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
" call s:LOG("show_errors_and_warning bn=".  l:bn) 
  if l:bn != -1
    augroup VIMSIDE_SEAW
      autocmd!
      execute "autocmd BufWinLeave <buffer=" . l:bn . "> call s:CloseWindow()"
    augroup END
  endif
endfunction

function! s:ActWinClose()
  call vimside#actwin#DisplayGlobalClose('show_errors')
endfunction

function! s:ActWin(entries, action)
  let l:entries = a:entries
call s:LOG("show_errors_and_warning ActWin TOP") 
  if ! s:actwin_initialized
    call s:InitializeActWin()
  endif

  let l:new_entries = []

  let l:current_file = expand('%:p')
  let l:len = len(l:entries)
  let l:cnt = 0
  while l:cnt < l:len
    let l:dic = l:entries[cnt]

    let l:file = l:dic['filename']
    let l:line = l:dic['lnum']
    let l:col = l:dic['col']
    let l:kind = l:dic['kind']
    let l:text = l:dic['text']

    let l:content = fnamemodify(l:file, ':t') .'('. l:line .','. l:col .'): '. l:text

    let l:entry = {
      \ 'content': l:content,
      \ 'file': l:file,
      \ 'line': l:line,
      \ 'col': l:col,
      \ 'kind': l:kind
      \ }

    call add(l:new_entries, l:entry)
call s:LOG("show_errors_and_warning ActWin entry=".  string(entry)) 

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
            \  "Show Errors and Warnings",
            \  "  Compiler generated errors, warnings and information.",
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
              \ "info": "use sign to note all errors and warnings",
              \ "is_enable": s:scala_sign_enable,
              \ "is_on": s:scala_sign_on,
              \ "category": "ShowErrorAndWarning",
              \ "abbreviation": "sew",
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
                \ "error": {
                  \ "text": s:scala_sign_kinds_error_text,
                  \ "texthl": s:scala_sign_kinds_error_texthl,
                  \ "linehl": s:scala_sign_kinds_error_linehl
                \ },
                \ "warn": {
                  \ "text": s:scala_sign_kinds_warn_text,
                  \ "texthl": s:scala_sign_kinds_warn_texthl,
                  \ "linehl": s:scala_sign_kinds_warn_linehl
                \ },
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
              \ "category": "SEWColorLine",
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
                \ "error": {
                  \ "text": s:scala_color_line_kinds_error_text,
                  \ "texthl": s:scala_color_line_kinds_error_texthl,
                  \ "linehl": s:scala_color_line_kinds_error_linehl
                \ },
                \ "warn": {
                  \ "text": s:scala_color_line_kinds_warn_text,
                  \ "texthl": s:scala_color_line_kinds_warn_texthl,
                  \ "linehl": s:scala_color_line_kinds_warn_linehl
                \ },
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
              \ "category": "SEWScalaWindow",
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
                \ "error": {
                  \ "text": s:actwin_sign_kinds_error_text,
                  \ "texthl": s:actwin_sign_kinds_error_texthl,
                  \ "linelh": s:actwin_sign_kinds_error_linehl
                \ },
                \ "warn": {
                  \ "text": s:actwin_sign_kinds_warn_text,
                  \ "texthl": s:actwin_sign_kinds_warn_texthl,
                  \ "linelh": s:actwin_sign_kinds_warn_linehl
                \ },
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
        \ "action": a:action,
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
        \ "entries": l:new_entries,
    \ }
  call vimside#actwin#DisplayGlobal('show_errors', l:data)

call s:LOG("show_errors_and_warning ActWin BOTTOM") 
endfunction




function! s:GetLocation()
  let l:option_name = 'tailor-show-errors-and-warning-location'
  let l:default_location = 'same_window'
  return vimside#util#GetLocation(l:option_name, l:default_location)
endfunction

function! s:CloseWindow()
call s:LOG("CloseWindow:") 

  augroup VIMSIDE_SEAW
   autocmd!
  augroup END

  let &switchbuf = s:switchbuf_save

  let location = s:GetLocation()
  if location == 'vsplit_window'
    quit
  endif
endfunction
