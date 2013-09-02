" ============================================================================
" actwin.vim
"
" File:          actwin.vim
" Summary:       action window
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2013
"
" ============================================================================
" Intro: {{{1
" ============================================================================

if 1 
let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")
else
function! s:LOG(msg)
  execute "redir >> ". "AW_LOG"
  silent echo "INFO: ". a:msg
  execute "redir END"
endfunction
function! s:ERROR(msg)
  execute "redir >> ". "AW_LOG"
  silent echo "ERROR: ". a:msg
  execute "redir END"
endfunction
endif

" TODO
" color_column :hi ColorColumn ctermbg=lightgrey guibg=lightgrey
" allow toggle with map, map 
"    toggle: {
"      map: "t",
"      cmd: "t",
"    }
" default sign kind: marker

" toggle: km uc bc
" map
" cmds
"
" toggle {
"   actwin: {
"     map: 
"     cmd: 
"     abbr: 
"   }
"   scala: {
"     map: 
"     cmd: 
"     abbr: 
"   }
" }
"
" toggle
"   is_XXX_enable
"   is_XXX_on
"
"   scala actwin
"     sign
"       category
"       different kinds
"       current position
"     entity
"       row (sign or highlight)
"       column (color or highlight)
"       row & column
"       cursorcolumn
"   actwin actwin
"     cursorline cl
"     text highlight th
"     lines highlight lh

"
" vimside properties
" vimside.quickfix.texthl.group=
" vimside.quickfix.texthl.ctermfg=
"
" for line inf readfile(prop_file)
"   if [found, name, value] = ParseProp(line)
"   if found
"   endif
" endfor
"  let [namepath, value] = split(line, "=")
"  let names = split(namepath, ".")
"
"  vimside.actwin.quickfix.actwin.sign.error.textln.group=
"  vimside.actwin.quickfix.actwin.sign.error.textln.cterm=
"

"
" term= bold underline reverse italic standout NONE
" cterm= bold underline reverse italic standout NONE
" ctermfg
" ctermbg
" gui=
" guifg=
" guibg=
"  attrs
"    bold
"    underline
"    reverse
"    italic
"    standout
"    NONE
"  ctermfg color_nr or simple_color_name
"  ctermbg color_nr or simple_color_name
"  guifg  color_name
"  guibg  color_name
"  
"  group="Comment"
"  group="Comment"
"  texthl={ ... fg/bg}
"  texthl=group
"  linehl={ fg/bg}
"  linehl=group
"
"

"
" remove entry, list of entries
" help: 
" active row/column highlight 
" range of lines
"
"http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_actwin
"
"http://stackoverflow.com/questions/2447109/showing-a-different-background-colour-in-vim-past-80-characters
"http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
"http://vim.wikia.com/wiki/Highlight_current_line
"
"sort entries
"various sort functions
"
"help: no display, one line, full help vim help
"
"range of scala lines per target line
"sign a range of lines
"
"
"options
"row/column display

let s:is_color_column_enabled = 0

let s:split_cmd_default = "new"
let s:split_size_default = "10"
let s:split_below_default = 1
let s:split_right_default = 0
let s:edit_cmd_default = "enew"
let s:tab_cmd_default = "tabnew"

let s:dislay_scala_sign_toggle_default = "ss"
let s:dislay_scala_sign_is_on_default = 0
let s:dislay_scala_color_line_toggle_default = "cl"
let s:dislay_scala_color_line_is_on_default = 0
let s:dislay_scala_color_column_toggle_default = "cc"
let s:dislay_scala_color_column_is_on_default = 0

let s:dislay_actwin_cursor_line_toggle_default = "wcl"
let s:dislay_actwin_cursor_line_is_on_default = 0
let s:dislay_actwin_highlight_line_toggle_default = "whl"
let s:dislay_actwin_highlight_line_is_on_default = 0
let s:dislay_actwin_highlight_line_is_full_default = 0
let s:dislay_actwin_highlight_line_all_text_default = 0

let s:dislay_actwin_sign_toggle_default = "sw"
let s:dislay_actwin_sign_is_on_default = 0
let s:dislay_actwin_sign_all_text_default = 0


let s:winname_default="ActWin"

" control whether or not buffer entry events trigger 
" save/restore option code execution
let s:buf_change = 1

" actwin {
"   is_global: 0,
"   is_info_open: 0,
"   scala_win_nr: scala_win_nr
"   scala_buffer_nr: scala_buffer_nr
"   scala_buffer_name: scala_buffer_name
"   buffer_nr
"   win_nr
"   uid: unique id
"   tag: tag
"   first_buffer_line: first_buffer_line
"   current_line: current_line
"   linenos_to_entrynos: []
"   entrynos_to_linenos: []
"   entrynos_to_nos_of_lines: []
"   is_info_open: 0
"   data {
"   }
" }
" data {
"   title: ""
"   winname: ""
"   buffer_nr: number
"   action: create/modify/append/replace default create
"   help: {
"     do_show: 0
"     is_open: 0
"     .....
"   }
"   actwin: {
"     split; {
"        cmd: "new"
"        size: "10"
"        below: 1
"        right: 0
"     }
"     edit: {
"        cmd: "enew"
"     }
"     tab: {
"        cmd: "tabnew"
"     }
"   }
"   map: {
"     actwin_map_show: ""
"     scala_cmd_show: ""
"     scala_map_show: ""
"     help: ""
"     select: []
"     select_mouse: []
"     enter_mouse: []
"     down: []
"     up: []
"     close: []
"   }
"   cmd: {
"   }
"   map: {
"     up: cp
"     down: cn
"     close: ccl
"   }
"   sign: {
"     category: QuickFix
"     abbreviation: qf
"     kinds: {
"       kname: {text, textlh, linehl }
"       .....
"     }
"   }
"   actions: {
"     enter:
"     leave:
"     select:
"   }
"   entries: [ 
"     file:
"     line:
"     optional col: (default 0)
"     content: [lines] and/or line
"     id: unique identifying number 
"     kind: 'error'
"     optional actions: {
"       enter:
"       leave:
"       select:
"     } (default global actions)
"   ]
" }
"


" quickfix commands
"  :cc 
"  :cn 
"  :cp 
"  :cr 
"  :cl 
"    override
"      http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
"      cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
"    leader
" open quickfix commands
"    existing
"      <Leader>ve
"
"

" functions that can be bound to keys (key mappings)
" map
let s:cmds_actwin_defs = {
      \ "actwin_map_show": [ "ToggleActWinMapInfo", "Display actwin key-map info" ],
      \ "scala_cmd_show": [ "ToggleScalaBuiltinCmdInfo", "Display scala builtin cmd info" ],
      \ "scala_map_show": [ "ToggleScalaMapInfo", "Display scala key map cmd info" ],
      \ "help": [ "OnHelp", "Display help" ],
      \ "select": [ "OnSelect", "Select current line" ],
      \ "enter_mouse": [ "OnEnterMouse", "Use mouse to set current line" ],
      \ "down": [ "OnDown", "Move down to next line" ],
      \ "top": [ "OnTop", "Move to top line" ],
      \ "bottom": [ "OnBottom", "Move to bottom line" ],
      \ "up": [ "OnUp", "Move up to next line" ],
      \ "left": [ "OnLeft", "Move left one postion" ],
      \ "right": [ "OnRight", "Move right one postion" ],
      \ "delete": [ "OnDelete", "Delete current entry" ],
      \ "close": [ "OnClose", "Close actwin"]
      \ }

" mappings to override existing builtin commands
let s:cmds_scala_defs = {
      \ "first": [ "g:VimsideActWinFirst", "Goto first line" ],
      \ "last": [ "g:VimsideActWinLast", "Goto last line" ],
      \ "previous": [ "g:VimsideActWinUp", "Move up to next line" ],
      \ "next": [ "g:VimsideActWinDown", "Move down to next line" ],
      \ "enter": [ "g:VimsideActWinEnter", "Enter actwin" ],
      \ "delete": [ "g:VimsideActWinDelete", "Delete Current Entry" ],
      \ "close": [ "g:VimsideActWinClose", "Close actwin" ]
      \ }

" globals = {
"   type1: actwin1
"   type2: actwin2
"   .....
" }
let s:globals = {}

" locals = {
"   src_buffer_nos1: {
"      tag1: actwin1
"      tag2: actwin2
"      tag3: actwin3
"      ....
"   }
"   src_buffer_nos2: {
"      ....
"   }
"   ....
" }
"
" scala_buffer_nr -> tags 
"    tags 1-1 target_buffer_nr
"
let s:locals = {}

" TODO maps from unique id -> actwin
" let s:uid_to_actwin = {}

" maps actwin buffer number to actwin
let s:actwin_buffer_nr_to_actwin = {}

" --------------------------------------------
" Util
" --------------------------------------------


let s:next_uid = 0
function! s:NextUID()
  let l:uid = s:next_uid
  let s:next_uid += 1
  return l:uid
endfunction

function! s:Redraw()
  if has('gui_running') || has('gui_macvim')
    redraw
  else
    redraw!
  endif
endfunction

" MUST be called from local buffer
" return [0, _] or [1, instance]
function! s:GetBufferActWin()
  if exists("b:buffer_nr") && has_key(s:actwin_buffer_nr_to_actwin, b:buffer_nr)
    return [1, s:actwin_buffer_nr_to_actwin[b:buffer_nr]]
  else
    return [0, ""]
  endif
endfunction

function! s:GetActWin(buffer_nr)
  if has_key(s:actwin_buffer_nr_to_actwin, a:buffer_nr)
    return [1, s:actwin_buffer_nr_to_actwin[a:buffer_nr]]
  else
    return [0, ""]
  endif
endfunction

" --------------------------------------------
" Initialize
" --------------------------------------------

" MUST be called from local buffer
function! s:Initialize(instance)
call s:LOG("Initialize TOP")
call s:LOG("Initialize current buffer=". bufnr("%"))

  " must create handlers first
  call s:CreateFileHandlers(a:instance)

  call s:MakeAutoCmds(a:instance)
  call s:MakeCmds(a:instance)


  " TODO is this needed ... only when using the same actwin
  " how about using enter/leave buffer autocmd maps instead
  let b:insertmode = &insertmode
  let b:showcmd = &showcmd
  let b:cpo = &cpo
  let b:report = &report
  let b:list = &list
  set noinsertmode
  set noshowcmd
  set cpo&vim
  let &report = 10000
  set nolist

  set bufhidden=hide

  setlocal nonumber
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal nospell
  setlocal nobuflisted
call s:LOG("Initialize current buffer=". bufnr("%"))
call s:LOG("Initialize BOTTOM")
endfunction

" --------------------------------------------
" Scala File Handlers
" --------------------------------------------

function! s:CreateFileHandlers(instance)
  let a:instance.files = []
  let a:instance.handlers = {}
  let a:instance.handlers['on_new_file'] = []
  let a:instance.handlers['on_close'] = []
endfunction

function! s:CallNewFileHandlers(instance, file, entrynos)
call s:LOG("s:CallNewFileHandlers: TOP file=". a:file)
  call add(a:instance.files, a:file)

  for l:Handler in a:instance.handlers.on_new_file
    call l:Handler(a:instance, a:file, a:entrynos)
  endfor
call s:LOG("s:CallNewFileHandlers: BOTTOM")
endfunction

function! s:CallOnCloseHandlers(instance)
  let l:onclosehandlers = a:instance.handlers.on_close
  for l:file in a:instance.files
    for l:Handler in l:onclosehandlers
      call l:Handler(a:instance, l:file)
    endfor
  endfor
  let a:instance.files = []
endfunction

" --------------------------------------------
" Auto Cmds
" --------------------------------------------

" MUST be called from local buffer
function! s:MakeAutoCmds(instance)
call s:LOG("MakeAutoCmds current buffer=". bufnr("%"))
  augroup ACT_WIN_AUTOCMD
    " autocmd!
    
    execute "autocmd BufEnter <buffer=". bufnr("%") ."> call s:BufEnter()"
    execute "autocmd BufLeave <buffer=". bufnr("%") ."> call s:BufLeave()"

    execute "autocmd BufWinEnter <buffer=". bufnr("%") ."> call s:BufWinEnter()"
    execute "autocmd BufWinLeave <buffer=". bufnr("%") ."> call s:BufWinLeave()"
  augroup END
endfunction

function! s:CloseAutoCmds(instance)
call s:LOG("CloseAutoCmds close buffer=". a:instance.buffer_nr)
call s:LOG("CloseAutoCmds current buffer=". bufnr("%"))
 augroup ACT_WIN_AUTOCMD
   execute "autocmd! *  <buffer=". a:instance.buffer_nr .">"
 augroup END
endfunction

" --------------------------------------------
" Cmds
" --------------------------------------------

" MUST be called from local buffer
function! s:MakeCmds(instance)
call s:LOG("MakeCmds TOP")
  call s:MakeActWinMappings(a:instance)
  call s:MakeActWinBuiltinCommands(a:instance)
  " TODO abbr

  call s:MakeScalaMappings(a:instance)
  call s:MakeScalaBuiltinCommands(a:instance)
  " TODO abbr
call s:LOG("MakeCmds BOTTOM")
endfunction

" MUST be called from local buffer
function! s:ClearCmds(instance)
  call s:ClearScalaMappings(a:instance)
  call s:ClearScalaBuiltinCommands(a:instance)
  " TODO abbr
endfunction

" MUST be called from local buffer
function! s:MakeActWinMappings(instance)
call s:LOG("MakeActWinMappings TOP")
  if ! empty(a:instance.data.cmds.actwin.map)
" call s:LOG("MakeActWinMappings not empty")
    for [l:key, l:value] in items(a:instance.data.cmds.actwin.map)
" call s:LOG("MakeActWinMappings l:key=". l:key)
      let [l:fn, l:txt] = s:cmds_actwin_defs[l:key]
      for l:v in l:value
        execute 'nnoremap <script> <silent> <buffer> '. l:v .' :call <SID>'. l:fn .'()<CR>'
      endfor
    endfor
  endif
call s:LOG("MakeActWinMappings BOTTOM")
endfunction


" MUST be called from local buffer
function! s:MakeActWinBuiltinCommands(instance)
  if ! empty(a:instance.data.cmds.actwin.cmd)
    for [l:key, l:value] in items(a:instance.data.cmds.actwin.cmd)
      let [l:fn, l:txt] = s:cmds_actwin_defs[l:key]
      for l:v in l:value
        execute "cabbrev <silent> <buffer> ". l:v ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". l:fn ."()' : '". l:v ."')<CR>"
      endfor
    endfor
  endif
endfunction




" MUST be called from local buffer
function! s:MakeScalaMappings(instance)
  if ! empty(a:instance.data.cmds.scala.map)
    let l:map = a:instance.data.cmds.scala.map
    let l:buffer_nr =  a:instance.buffer_nr
    let l:is_global = a:instance.is_global

    if l:is_global
      for [l:key, l:value] in items(l:map)
        let [l:fn, l:txt] = s:cmds_scala_defs[l:key]
        for l:v in l:value
          execute ":nnoremap <silent> ". l:v ." :silent call ". l:fn ."(". l:buffer_nr .")<CR>"
        endfor
      endfor

    else
      let s:buf_change = 0
      execute 'silent '. a:instance.scala_win_nr.'wincmd w'
        for [l:key, l:value] in items(l:map)
          let [l:fn, l:txt] = s:cmds_scala_defs[l:key]
          for l:v in l:value
            execute ":nnoremap <silent> <buffer> ". l:v ." :silent call ". l:fn ."(". l:buffer_nr .")<CR>"
          endfor
        endfor
      execute 'silent '. a:instance.win_nr.'wincmd w'
      let s:buf_change = 1
    endif
  endif
endfunction

function! s:ClearScalaMappings(instance)
  if ! empty(a:instance.data.cmds.scala.map)
    let s:buf_change = 0
    let l:is_global = a:instance.is_global

    if l:is_global
      for l:value in values(a:instance.data.cmds.scala.map)
        for l:v in l:value
          execute "nunmap ". l:v
        endfor
      endfor
    else
      " execute 'silent '. a:instance.scala_win_nr.'wincmd w'
      execute ':buffer '. a:instance.scala_buffer_nr
      for l:value in values(a:instance.data.cmds.scala.map)
        for l:v in l:value
          execute "nunmap <buffer> ". l:v
        endfor
      endfor
      execute 'silent '. a:instance.win_nr.'wincmd w'
    endif
    let s:buf_change = 1
  endif
endfunction



function! s:MakeScalaBuiltinCommands(instance)
  " :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
  if ! empty(a:instance.data.cmds.scala.cmd)
    let l:cmd = a:instance.data.cmds.scala.cmd
    let l:buffer_nr =  a:instance.buffer_nr
    let l:is_global = a:instance.is_global

    if l:is_global
      for [l:key, l:value] in items(l:cmd)
        let [l:fn, l:txt] = s:cmds_scala_defs[l:key]
        for l:v in l:value
          execute "cabbrev <silent> ". l:v ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". l:fn ."(". l:buffer_nr .")' : '". l:v ."')<CR>"
        endfor
      endfor

    else
      let s:buf_change = 0
      execute 'silent '. a:instance.win_nr.'wincmd w'
      for [l:key, l:value] in items(l:cmd)
        let [l:fn, l:txt] = s:cmds_scala_defs[l:key]
        for l:v in l:value
        execute "cabbrev <silent> ". l:v ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". l:fn ."(". l:buffer_nr .")' : '". l:v ."')<CR>"
        endfor
      endfor
      execute 'silent '. a:instance.win_nr.'wincmd w'
      let s:buf_change = 1
    endif
  endif
endfunction

" MUST be called from local buffer
function! s:ClearScalaBuiltinCommands(instance)
  " :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
  " cunabbrev e
  if ! empty(a:instance.data.cmds.scala.cmd)
    let s:buf_change = 0
    let l:cmd = a:instance.data.cmds.scala.cmd
    let l:is_global = a:instance.is_global

    if l:is_global
      for l:value in values(l:cmd)
        for l:v in l:value
          execute "cunabbrev ". l:v
        endfor
      endfor

    else
      execute 'silent '. a:instance.win_nr.'wincmd w'
      for l:value in values(l:cmd)
        for l:v in l:value
          execute "cunabbrev ". l:v
        endfor
      endfor
      execute 'silent '. a:instance.win_nr.'wincmd w'

    endif
    let s:buf_change = 1
  endif
endfunction



" --------------------------------------------
" Main entry function
" --------------------------------------------

function! vimside#actwin#DisplayGlobalClose(type)
call s:LOG("vimside#actwin#DisplayGlobalClose TOP")
  if has_key(s:globals, a:type)
    let l:instance = s:globals[a:type]
    call g:VimsideActWinClose(l:instance.buffer_nr)
  endif
call s:LOG("vimside#actwin#DisplayGlobalClose Bottom")
endfunction

function! vimside#actwin#DisplayGlobal(type, data)
call s:LOG("vimside#actwin#DisplayGlobal TOP")
  if len(a:data.entries) == 0
call s:LOG("vimside#actwin#DisplayGlobal entries empty")
    return
  endif
call s:LOG("vimside#actwin#DisplayGlobal type=". a:type)
  let l:data = deepcopy(a:data)

  if has_key(s:globals, a:type)

    " already exists, see what the action is.
    " action: create/modify/append create
    let l:action = s:GetAction(l:data)
call s:LOG("vimside#actwin#DisplayGlobal action=". l:action)
    let l:instance = s:globals[a:type]

    if l:action == 'm'
      " modify
      call s:Modify(l:instance.data, l:data)
      " TODO
      return
    elseif l:action == 'a'
      " append
      call s:AppendEntries(l:instance.data, l:data)
      " TODO
      return
    elseif l:action == 'r'
      " replace
      call s:ReplaceEntries(l:instance.data, l:data)
      " TODO
      return
    else
      " create
      " it exist but must create anyway
      let l:data.action = 'c'
      let l:uid = s:NextUID()
      let l:scala_buffer_name = bufname("%")
      let l:scala_buffer_nr = bufnr("%")
      let l:scala_win_nr = bufwinnr(l:scala_buffer_nr)
      let l:instance = {
          \ "is_global": 1,
          \ "is_info_open": 0,
          \ "scala_win_nr": l:scala_win_nr,
          \ "scala_buffer_nr": l:scala_buffer_nr,
          \ "scala_buffer_name": l:scala_buffer_name,
          \ "tag": a:type,
          \ "uid": l:uid,
          \ "data": l:data
        \ }

      let s:globals[a:type] = l:instance
      call s:Adjust(l:instance.data)
    endif

  else

    " does not exist, must create it regardless of action
    let l:data.action = 'c'
    let l:uid = s:NextUID()
    let l:scala_buffer_name = bufname("%")
    let l:scala_buffer_nr = bufnr("%")
    let l:scala_win_nr = bufwinnr(l:scala_buffer_nr)
    let l:instance = {
        \ "is_global": 1,
        \ "is_info_open": 0,
        \ "scala_win_nr": l:scala_win_nr,
        \ "scala_buffer_nr": l:scala_buffer_nr,
        \ "scala_buffer_name": l:scala_buffer_name,
        \ "tag": a:type,
        \ "uid": l:uid,
        \ "data": l:data
      \ }

    let s:globals[a:type] = l:instance
    call s:Adjust(l:instance.data)

  endif
  call s:DoDisplay(a:type, l:instance)

  " call s:DoDisplay(a:type, a:data, 1)
endfunction

function! vimside#actwin#DisplayLocal(tag, data)
call s:LOG("vimside#actwin#DisplayLocal TOP")
  if len(a:data.entries) == 0
call s:LOG("vimside#actwin#DisplayLocal entries empty")
    return
  endif
call s:LOG("vimside#actwin#DisplayLocal tag=". a:tag)
  let l:data = deepcopy(a:data)

  " TODO for now just create it
  let l:data.action = 'c'
  let l:uid = s:NextUID()
  let l:scala_buffer_name = bufname("%")
  let l:scala_buffer_nr = bufnr("%")
  let l:scala_win_nr = bufwinnr(l:scala_buffer_nr)
  let l:instance = {
      \ "is_global": 0,
      \ "is_info_open": 0,
      \ "scala_win_nr": l:scala_win_nr,
      \ "scala_buffer_nr": l:scala_buffer_nr,
      \ "scala_buffer_name": l:scala_buffer_name,
      \ "tag": a:tag,
      \ "uid": l:uid,
      \ "data": l:data
    \ }

  let s:locals[a:tag] = l:instance
  call s:Adjust(l:instance.data)

  call s:DoDisplay(a:tag, l:instance)

  " call s:DoDisplay(a:tag, a:data, 0)
endfunction

function! s:DoDisplay(tag, instance)
call s:LOG("DoDisplay TOP")
  let l:instance = a:instance
  let l:data = l:instance.data
  let l:action = l:data.action

if 0 " OLD
  let l:data = deepcopy(a:data)
  let l:scala_buffer_name = bufname("%")
  let l:scala_buffer_nr = bufnr("%")
  let l:scala_win_nr = bufwinnr(l:scala_buffer_nr)
call s:LOG("DoDisplay l:scala_buffer_nr=". l:scala_buffer_nr)
call s:LOG("DoDisplay l:scala_win_nr=". l:scala_win_nr)

  " TODO remove l:scala_buffer_nr / a:tag on close
  if has_key(s:locals, l:scala_buffer_nr)
    let l:bnr_dic = s:locals[l:scala_buffer_nr]
    if has_key(l:bnr_dic, a:tag)
      let l:action = s:GetAction(l:data)
      if l:action == 'm'
        " modify
        let l:instance = l:bnr_dic[a:tag]
      elseif l:action == 'a'
        " append
        let l:instance = l:bnr_dic[a:tag]
      elseif l:action == 'r'
        " replace
        let l:instance = l:bnr_dic[a:tag]
      else
        " create
        let l:uid = s:NextUID()
        let l:instance = {
            \ "is_global": a:is_global,
            \ "is_info_open": 0,
            \ "scala_win_nr": l:scala_win_nr,
            \ "scala_buffer_nr": l:scala_buffer_nr,
            \ "scala_buffer_name": l:scala_buffer_name,
            \ "tag": a:tag,
            \ "uid": l:uid,
            \ "data": l:data
          \ }
        let l:bnr_dic[a:tag] = l:instance

        let l:action = 'c'
      endif

    else
      let l:uid = s:NextUID()
      let l:instance = {
          \ "is_global": a:is_global,
          \ "is_info_open": 0,
          \ "scala_win_nr": l:scala_win_nr,
          \ "scala_buffer_nr": l:scala_buffer_nr,
          \ "scala_buffer_name": l:scala_buffer_name,
          \ "tag": a:tag,
          \ "uid": l:uid,
          \ "data": l:data
        \ }
      let l:bnr_dic[a:tag] = l:instance

      let l:action = 'c'
    endif

  else
    let l:uid = s:NextUID()
    let l:instance = {
        \ "is_global": a:is_global,
        \ "is_info_open": 0,
        \ "scala_win_nr": l:scala_win_nr,
        \ "scala_buffer_nr": l:scala_buffer_nr,
        \ "scala_buffer_name": l:scala_buffer_name,
        \ "tag": a:tag,
        \ "uid": l:uid,
        \ "data": l:data
      \ }
    let l:bnr_dic = {}
    let l:bnr_dic[a:tag] = l:instance
    let s:locals[l:scala_buffer_nr] = l:bnr_dic

    let l:action = 'c'
  endif

call s:LOG("DoDisplay action=". l:action)

  " make adjustments, modification and replacements
  if l:action == 'c'
    " save instance by its uid
    " let s:uid_to_actwin[l:instance.uid] = l:instance
    " create = new display
    call s:Adjust(l:instance.data)
  elseif l:action == 'm'
    " modify = change non-entries
    call s:Modify(l:instance.data, l:data)
  elseif l:action == 'r'
    " replace entries
    call s:ReplaceEntries(l:instance.data, l:data)
  else
    " append entries
    call s:AppendEntries(l:instance.data, l:data)
  endif
endif " OLD

  if l:action == 'c'
    let l:actwin =  l:data.actwin
    let l:winname =  l:data.winname

    let l:actwin = l:instance.data.actwin
    if has_key(l:actwin, 'split')
call s:LOG("DoDisplay split")
      let l:split = l:actwin.split

      " save current values
      let l:below = &splitbelow
      let &splitbelow = l:split.below

      let l:right = &splitright
      let &splitright = l:split.right

      let l:cmd = l:split.cmd
      let l:size = l:split.size

      silent execute l:size . l:cmd .' '. l:winname

      " restore values
      let &splitbelow = l:below
      let &splitright = l:right

    elseif has_key(l:actwin, 'edit')
call s:LOG("DoDisplay edit")
      let l:edit = l:actwin.edit
      let l:cmd = l:edit.cmd
call s:LOG("DoDisplay l:cmd=". l:cmd)
call s:LOG("DoDisplay current buffer=". bufnr("%"))
      " execute l:cmd .' '. l:winname
      execute l:cmd 
call s:LOG("DoDisplay current buffer=". bufnr("%"))

    elseif has_key(l:actwin, 'tab')
call s:LOG("DoDisplay tab")
      let l:tab = l:actwin.tab
      let l:cmd = l:tab.cmd
      execute l:cmd .' '. l:winname

    endif

    " save the actwin buffer and actwin number
    let l:instance.buffer_nr = bufnr("%")
    let l:instance.win_nr = bufwinnr(l:instance.buffer_nr)
    let b:return_win_nr = l:instance.scala_win_nr 

call s:LOG("DoDisplay l:instance.buffer_nr=". l:instance.buffer_nr)
    let b:buffer_nr = l:instance.buffer_nr
    let s:actwin_buffer_nr_to_actwin[l:instance.buffer_nr] = l:instance

let s:buf_change = 0
    call s:Initialize(l:instance)
  endif

  call s:LoadDisplay(l:instance)

  call s:DisplayDefine(l:instance)

  call s:DisplayEnable(l:instance)

call s:LOG("Display actwin_buffer=". l:instance.buffer_nr)

  call s:EnterEntry(0, l:instance)

let s:buf_change = 1


 echo  "Show cmds: <F2>"

call s:LOG("DoDisplay BOTTOM")
endfunction




"   action: create/modify/append create
function! s:GetAction(data)
  if has_key(a:data, 'action') 
    if a:data.action == 'c' 
      return 'c'
    elseif a:data.action == 'm' 
      return 'm'
    elseif a:data.action == 'a' 
      return 'a'
    elseif a:data.action == 'r' 
      return 'r'
    endif
  endif 

  return 'c'
endfunction

function! s:AdjustMapping(owner, mapname, ref_map_defs)
  if ! has_key(a:owner, a:mapname)
    let a:owner[a:mapname] = {}
  else
    let map = {}
    for [l:key, l:value] in items(a:owner[a:mapname])
      if ! has_key(a:ref_map_defs, l:key)
        call s:ERROR('AdjustMapping '. a:mapname .' - bad key "'. l:key .'"')
      elseif type(l:value) == type("") 
        if l:value == ''
          " no values
          let map[l:key] = [ ]
        else
          let map[l:key] = [ l:value ]
        endif
      elseif type(l:value) == type([])
        let map[l:key] = l:value
      else
        call s:ERROR('AdjustMapping '. a:mapname .' - for key "'. l:key .'" bad value type: '. type(l:value))
      endif
      unlet l:value
    endfor
    let a:owner[a:mapname] = map
  endif
endfunction

function! s:Adjust(data)
call s:LOG("Adjust  TOP")
  if ! has_key(a:data, 'winname')
    let a:data['winname'] = s:winname_default
  endif

  "--------------
  " cmds
  "--------------
  if ! has_key(a:data, 'cmds')
    let a:data['cmds'] = {}
  endif
  let l:cmds = a:data.cmds

  if ! has_key(l:cmds, 'actwin')
    let l:cmds['actwin'] = {}
  endif
  let l:actwin = l:cmds.actwin

  if ! has_key(l:cmds, 'scala')
    let l:cmds['scala'] = {}
  endif
  let l:scala = l:cmds.scala

  " actwin cmds
  call s:AdjustMapping(l:actwin, 'map', s:cmds_actwin_defs)
  call s:AdjustMapping(l:actwin, 'cmd', s:cmds_actwin_defs)
  " call s:AdjustMapping(l:actwin, 'map', s:cmds_actwin_defs)
  " TODO abbr


  " scala cmds
  call s:AdjustMapping(l:scala, 'map', s:cmds_scala_defs)
  call s:AdjustMapping(l:scala, 'cmd', s:cmds_scala_defs)
  " TODO abbr

  "--------------
  " actwin
  "--------------
  if ! has_key(a:data, 'actwin')
    let a:data['actwin'] = {
      \ "split": {
        \ "cmd": s:split_cmd_default,
        \ "size": s:split_size_default,
        \ "below": s:split_below_default,
        \ "right": s:split_right_default 
        \ }
      \ }
  else
    let l:actwin = a:data.actwin
    if has_key(l:actwin, 'split')
      let l:split = l:actwin.split
      if ! has_key(l:split, 'cmd')
        let l:split['cmd'] = s:split_cmd_default
      endif
      if ! has_key(l:split, 'size')
        let l:split['size'] = s:split_size_default
      endif
      if ! has_key(l:split, 'below')
        let l:split['below'] = s:split_below_default
      endif
      if ! has_key(l:split, 'right')
        let l:split['right'] = s:split_right_default
      endif

    elseif has_key(l:actwin, 'edit')
      let l:edit = l:actwin.edit
      if ! has_key(l:edit, 'cmd')
        let l:edit['cmd'] = s:edit_cmd_default
      endif

    elseif has_key(l:actwin, 'tab')
      let l:tab = l:actwin.tab
      if ! has_key(l:tab, 'cmd')
        let l:tab['cmd'] = s:tab_cmd_default
      endif

    else
      let l:actwin['split'] = {
          \ "cmd": s:split_cmd_default,
          \ "size": s:split_size_default,
          \ "below": s:split_below_default,
          \ "right": s:split_right_default 
        \ }
    endif
  endif

  if ! has_key(a:data, 'display')
    let a:data['display'] = {
        \ "scala": {
          \ "sign": {
            \ "is_enable": 0
          \ },
          \ "color_line": {
            \ "is_enable": 0
          \ },
          \ "color_column": {
            \ "is_enable": 0
          \ }
        \ },
        \ "actwin": {
          \ "cursor_line": {
            \ "is_enable": 0
          \ },
          \ "highlight_line": {
            \ "is_enable": 0
          \ },
          \ "sign": {
            \ "is_enable": 0
          \ }
        \ }
      \ }
  else
    let l:display = a:data.display

    " display.scala
    if ! has_key(l:display, 'scala')
      let l:display['scala'] = { 
          \ "sign": {
            \ "is_enable": 0
          \ }
        \ }
    else
      let l:scala = l:display.scala

      " display.scala.sign
      if ! has_key(l:scala, 'sign')
        let l:display['sign'] = {
          \ "is_enable": 0
          \ }
      else
        let l:sign = l:scala.sign

        if ! has_key(l:sign, 'is_enable')
          let l:sign['is_enable'] = 0
        else
          if ! has_key(l:sign, 'toggle')
            let l:sign['toggle'] = {}
          endif
          if ! has_key(l:sign, 'is_on')
            let l:sign['is_on'] = s:dislay_scala_sign_is_on_default
          endif

          if ! has_key(l:sign, 'kinds')
            let l:sign['kinds'] = {}
          endif
          if has_key(l:sign, 'default_kind')
            let l:default_kind = l:sign.default_kind
            if ! has_key(l:sign.kinds, l:default_kind)
              " TODO issue warning????
              unlet l:sign.default_kind
            endif
          endif
        endif
      endif

      " display.scala.color_line
      if ! has_key(l:scala, 'color_line')
        let l:display['color_line'] = {
          \ "is_enable": 0
          \ }
      else
        let l:color_line = l:scala.color_line

        if ! has_key(l:color_line, 'is_enable')
          let l:color_line['is_enable'] = 0
        else
          if ! has_key(l:color_line, 'toggle')
            let l:color_line['toggle'] = {}
          endif
          if ! has_key(l:color_line, 'is_on')
            let l:color_line['is_on'] = s:dislay_scala_color_line_is_on_default
          endif
          if ! has_key(l:color_line, 'kinds')
            let l:color_line['kinds'] = {}
          endif
          if has_key(l:color_line, 'default_kind')
            let l:default_kind = l:color_line.default_kind
            if ! has_key(l:color_line.kinds, l:default_kind)
              " TODO issue warning????
              unlet l:color_line.default_kind
            endif
          endif
        endif
      endif

      " display.scala.color_column
      if ! has_key(l:scala, 'color_column')
        let l:display['color_column'] = {
          \ "is_enable": 0
          \ }
      else
        let l:color_column = l:scala.color_column
        if ! has_key(l:color_column, 'is_enable')
          let l:color_column['is_enable'] = 0
        else
          if ! has_key(l:color_column, 'toggle')
            let l:color_column['toggle'] = {}
          endif
          if ! has_key(l:color_column, 'is_on')
            let l:color_column['is_on'] = s:dislay_scala_color_column_is_on_default
          endif

        endif
      endif
      
    endif



    " display.actwin
    if ! has_key(l:display, 'actwin')
      let l:display['actwin'] = { 
          \ "cursor_line": {
            \ "is_enable": 0
          \ },
          \ "highlight_line": {
            \ "is_enable": 0
          \ },
          \ "highlight_text": {
            \ "is_enable": 0
          \ }
        \ }
    else
      let l:actwin = l:display.actwin

      " display.actwin.cursor_line
      if ! has_key(l:actwin, 'cursor_line')
        let l:display['cursor_line'] = {
          \ "is_enable": 0
          \ }
      else
        let l:cursor_line = l:actwin.cursor_line

        if ! has_key(l:cursor_line, 'is_enable')
          let l:cursor_line['is_enable'] = 0
        else
          if ! has_key(l:cursor_line, 'toggle')
            let l:cursor_line['toggle'] = {}
          endif
          if ! has_key(l:cursor_line, 'is_on')
            let l:cursor_line['is_on'] = s:dislay_actwin_cursor_line_is_on_default
          endif
        endif
      endif

      " display.actwin.highlight_line
      if ! has_key(l:actwin, 'highlight_line')
        let l:display['highlight_line'] = {
          \ "is_enable": 0
          \ }
      else
        let l:highlight_line = l:actwin.highlight_line

        if ! has_key(l:highlight_line, 'is_enable')
          let l:highlight_line['is_enable'] = 0
        else
          if ! has_key(l:highlight_line, 'toggle')
            let l:highlight_line['toggle'] = {}
          endif
          if ! has_key(l:highlight_line, 'is_on')
            let l:highlight_line['is_on'] = s:dislay_actwin_highlight_line_is_on_default
          endif
          if ! has_key(l:highlight_line, 'is_full')
            let l:highlight_line['is_full'] = s:dislay_actwin_highlight_line_is_full_default
          endif
          if ! has_key(l:highlight_line, 'all_text')
            let l:highlight_line['all_text'] = s:dislay_actwin_highlight_line_all_text_default
          endif
        endif

        " TODO highlight colors
      endif

      " display.actwin.sign
      if ! has_key(l:actwin, 'sign')
        let l:display['sign'] = {
          \ "is_enable": 0
          \ }
      else
        let l:sign = l:actwin.sign
        if ! has_key(l:sign, 'is_enable')
          let l:sign['is_enable'] = 0
        endif
        if ! has_key(l:sign, 'toggle')
          let l:sign['toggle'] = {}
        endif
        if ! has_key(l:sign, 'is_on')
          let l:sign['is_on'] = s:dislay_actwin_sign_is_on_default
        endif
        if ! has_key(l:sign, 'all_text')
          let l:sign['all_text'] = s:dislay_actwin_sign_all_text_default
        endif

        if ! has_key(l:sign, 'kinds')
          let l:sign['kinds'] = {}
        endif
        if has_key(l:sign, 'default_kind')
          let l:default_kind = l:sign.default_kind
          if ! has_key(l:sign.kinds, l:default_kind)
            " TODO issue warning????
            unlet l:sign.default_kind
          endif
        endif
      endif
    endif
  endif

  if ! has_key(a:data, 'help')
    let a:data['help'] = {
      \ "do_show": 0,
      \ "is_open": 0
      \ }
  else
    if ! has_key(a:data.help, 'do_show')
      let a:data.help['do_show'] = 0
    endif
    if ! has_key(a:data.help, 'is_open')
      let a:data.help['is_open'] = 0
    endif
  endif

  if ! has_key(a:data, 'actions')
    let a:data['actions'] = {
      \ "enter": function("vimside#actwin#EnterActionDoNothing"),
      \ "select": function("vimside#actwin#SelectActionDoNothing"),
      \ "leave": function("vimside#actwin#LeaveActionDoNothing")
      \ }
  else
    if ! has_key(a:data.actions, 'enter')
      let a:data.actions['enter'] = function("vimside#actwin#EnterActionDoNothing")
    endif
    if ! has_key(a:data.actions, 'select')
      let a:data.actions['select'] = function("vimside#actwin#SelectActionDoNothing")
    endif
    if ! has_key(a:data.actions, 'leave')
      let a:data.actions['leave'] = function("vimside#actwin#LeaveActionDoNothing")
    endif
  endif
  if ! has_key(a:data, 'formatter')
      let a:data['formatter'] = function("s:FormatterDefault")
  endif

  if has_key(a:data, 'entries')
    for l:entry in a:data.entries
      if has_key(l:entry, 'file')
        let l:file = l:entry.file
        if filereadable(l:file)
          let l:entry.file = fnamemodify(l:file, ":p")
        endif
      endif
    endfor
  endif


call s:LOG("Adjust  BOTTOM")
endfunction

"   sign: {
"     category: QuickFix
"     kinds: {
"       kname: {text, textlh, linehl }
"     }
"   }
function! s:Modify(org_data, new_data)
  " Change sign
  "   category 
  "   abbreviation
  "   kinds
" TODO SIGN data.display.scala.sign
  let l:has_org_data_sign = has_key(a:org_data, 'display') && has_key(a:org_data.display, 'scala') && has_key(a:org_data.display.scala, 'sign')
  let l:has_new_data_sign = has_key(a:new_data, 'display') && has_key(a:new_data.display, 'scala') && has_key(a:new_data.display.scala, 'sign')

  if l:has_org_data_sign && l:has_new_data_sign
    " TODO
  elseif l:has_org_data_sign 
    " TODO
  elseif l:has_new_data_sign 
    " register sign
    let l:sign = a:new_data.display.scala.sign
    if ! vimside#sign#HasCategory(l:sign.category)
      call vimside#sign#AddCategory(l:sign.category, l:sign)
    endif
  endif

  " Change action
  "   enter
  "   leave
  "   select
  "   If the new data has actions, then copy those key/values that it
  "   does not have from the original data; otherwise, copy the
  "   complete actions from original to new.
  if has_key(a:new_data, 'actions')
    let l:new_actions = a:new_data.actions
    if ! has_key(l:new_actions, 'enter')
      let l:new_actions['enter'] = a:org_data.actions.enter
    endif
    if ! has_key(l:new_actions, 'select')
      let l:new_actions['select'] = a:org_data.actions.select
    endif
    if ! has_key(l:new_actions, 'leave')
      let l:new_actions['leave'] = a:org_data.actions.leave
    endif
  else
    let a:new_data['actions'] = a:original.actions
  endif

endfunction

" remove org entries and copy new entries
function! s:ReplaceEntries(org_data, new_data)
  if has_key(a:new_data, 'entries')
    let a:org_data['entries'] = a:new_data.entries
  else
    let a:org_data['entries'] = []
  endif
endfunction

" copy entries from new_data.entries to org_data.entries
function! s:AppendEntries(org_data, new_data)
  if ! has_key(a:new_data, 'entries')
    " nothing to add
    return
  endif
  let l:new_entries = a:new_data.entries

  if ! has_key(a:org_data, 'entries')
    let a:org_data['entries'] = []
  endif

  let l:org_entries = a:org_data.entries

  for l:entry in l:new_entries
    call add(l:org_entries, l:entry)
  endfor
endfunction





function! s:AdjustInput()
  if ! has_key(s:dic, 'actions')
    let s:dic['actions'] = {
      \ "enter": function("vimside#actwin#EnterActionDoNothing"),
      \ "select": function("vimside#actwin#SelectActionDoNothing"),
      \ "leave": function("vimside#actwin#LeaveActionDoNothing")
      \ }
  else
    if ! has_key(s:dic.actions, 'enter')
      let s:dic.actions['enter'] = function("vimside#actwin#EnterActionDoNothing")
    endif
    if ! has_key(s:dic.actions, 'select')
      let s:dic.actions['select'] = function("vimside#actwin#SelectActionDoNothing")
    endif
    if ! has_key(s:dic.actions, 'leave')
      let s:dic.actions['leave'] = function("vimside#actwin#LeaveActionDoNothing")
    endif
  endif
endfunction

function! s:LoadDisplay(instance)
call s:LOG("LoadDisplay TOP current buffer=". bufnr("%"))
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap

  execute "1,$d"

  call s:BuildDisplay(a:instance)
  call cursor(a:instance.first_buffer_line, 1)
  let a:instance.current_line = a:instance.first_buffer_line

 setlocal nomodifiable
call s:LOG("LoadDisplay BOTTOM")
endfunction

" --------------------------------------------
" FastHelp  
" --------------------------------------------

function! s:CreateToggleInfo(data_win, data_element, key_value, defs, instance)
  let a:instance.is_info_open = ! a:instance.is_info_open 

  if ! a:instance.is_info_open
    let a:instance.first_buffer_line = 1
call s:LOG("CreateToggleInfo lines=[]")
    return []
  endif

  let l:cmds = a:instance.data.cmds
  let l:data_win = l:cmds[a:data_win]
  let l:elements = l:data_win[a:data_element]

  let l:lines = []
  let l:size = 25

  if a:data_win == 'scala'
    let l:title = 'Scala'
  elseif a:data_win == 'actwin'
    let l:title = a:instance.data.winname
  else
    let l:title = "ActWin"
  endif

  if type(a:key_value) == type([]) && len(a:key_value) == 1
    let l:head = l:title ." ". a:data_element ." (toggle: '". a:key_value[0] ."')"
  else
    let l:head = l:title ." ". a:data_element ." (toggle: '". string(a:key_value) ."')"
  endif

  call add(l:lines, l:head)
  call add(l:lines, repeat('-', len(l:head)))


  for l:key in sort(keys(l:elements))
    let l:value = l:elements[l:key]
    let [l:fn, l:txt] = a:defs[l:key]
    if type(l:value) == type("")
      let l:head =  l:key ." '". l:value . "'"
      let l:len = len(l:head)
      call add(l:lines, l:head. repeat(' ', l:size - l:len) .': '. l:txt)
      
    elseif type(l:value) == type([])
      let l:vs = ""
      for l:v in l:value
        if l:vs == ""
          let l:vs = "'". l:v . "'"
        else
          let l:vs .= " '". l:v . "'"
        endif
      endfor
      let l:head =  l:key ." ". l:vs

      let l:len = len(l:head)
      call add(l:lines, l:head. repeat(' ', l:size - l:len) .': '. l:txt)

    endif

    unlet l:value
  endfor
  call add(l:lines, "")

call s:LOG("CreateToggleInfo lines=". string(l:lines))
  let a:instance.first_buffer_line = len(lines) + 1
  return l:lines

endfunction


" --------------------------------------------
" Build Display
" --------------------------------------------
function! s:BuildDisplay(instance)
call s:LOG("BuildDisplay TOP")
  let l:Formatter = a:instance.data.formatter

  let a:instance.first_buffer_line = 1

  let l:linenos_to_entrynos = []
  let l:entrynos_to_linenos = []
  let l:entrynos_to_nos_of_lines = []

  let l:linenos = 0
  let l:entrynos = 0
  let l:lines = []
  let l:lineslen = 0
  for entry in a:instance.data.entries
    let l:current_lineslen = l:lineslen

    call l:Formatter(lines, entry)

    let l:lineslen = len(l:lines)
    let l:delta = l:lineslen - l:current_lineslen
    if l:delta == 1
      call add(l:linenos_to_entrynos, l:entrynos)
    else
      call extend(l:linenos_to_entrynos, repeat([l:entrynos], l:delta))
    endif

    call add(l:entrynos_to_linenos, l:lineslen)
    call add(l:entrynos_to_nos_of_lines, l:delta)

    let l:entrynos += 1

  endfor
call s:LOG("BuildDisplay current buffer=". bufnr("%"))

  call setline(a:instance.first_buffer_line, lines)
  let a:instance.linenos_to_entrynos = l:linenos_to_entrynos
  let a:instance.entrynos_to_linenos = l:entrynos_to_linenos
  let a:instance.entrynos_to_nos_of_lines = l:entrynos_to_nos_of_lines

call s:LOG("BuildDisplay BOTTOM")
endfunction

" ============================================================================
" Display: {{{1
"   LifeCycle:
"     Define
"     Enable
"     EnableFile
"     Toggle
"     Entry
"       Enter
"       Leave
"       Delete
"     DisableFile
"     Disable
"     Destroy
"
"
" Display Scala LifeCycle: {{{1
"     Define - create structures
"       s:ScalaDefineSigns(a:instance)
"     Enable - enable on buffered files
"       s:ScalaEnableSigns(a:instance)
"     EnableFile (goto file previously not displayed)
"       s:ScalaEnableFileSigns(a:instance, a:file)
"     Toggle - toggle between effect on/off (Enable/Disable)
"       g:ToggleSigns(buffer_nr)
"       - ToggleSignMatch
"       - ToggleShowColumn - colorcolumn
"
" s:EnterEntry(0, l:instance)
"   calls s:EnterActionQuickFix(entrynos, instance)
"      calls s:ScalaSetAtEntry(entrynos, instance)
" s:SelectEntry(0, l:instance)
"   calls s:SelectActionQuickFix(entrynos, instance)
"      calls s:ScalaGoToEntry(entrynos, instance)
" s:LeaveEntry(0, l:instance)
"   calls s:LeaveActionQuickFix(entrynos, instance)
"      calls s:RemoveAtEntry(a:entrynos, a:instance)
"
"     Entry
"       Enter - side effect of entering Window line
"       Leave - side effect of leaving Window line
"     DisableFile - disable on file that has been unbuffered
"     Disable - disable on buffered files
"       s:ScalaDisableSigns(a:instance)
"     Destroy - remove structures
"       s:ScalaDestroySigns(a:instance)
"
" Display ActWin LifeCycle: {{{1
"     Define - create structures
"       s:ActWinDefineCursorLine(a:instance)
"       s:ActWinDefineHighlightLine(a:instance)
"       s:ActWinDefineSign(a:instance)
"     Enable
"     EnableFile
"     Toggle - toggle between effect on/off (Enable/Disable)
"       g:ToggleCursorLine()
"       g:ToggleHighlightLine()
"       g:ToggleSign()
"     Entry
"       Enter call by s:EnterEntry(0, l:instance)
"           s:ActWinEnterCursorLine(a:entrynos, a:instance)
"           s:ActWinEnterHighlightLine(a:entrynos, a:instance)
"           s:ActWinEnterSign(a:entrynos, a:instance)
"       Leave call by s:LeaveEntry(entrynos, instance)
"           s:ActWinLeaveCursorLine(a:entrynos, a:instance)
"           s:ActWinLeaveHighlightLine(a:entrynos, a:instance)
"           s:ActWinLeaveSign(a:entrynos, a:instance)
"     DisableFile
"     Disable
"     Destroy - remove structures
"       s:ActWinDestroyCursorLine(a:instance)
"       s:ActWinDestroyHighlightLine(a:instance)
"       s:ActWinDestroySign(a:instance)
" ============================================================================

function! s:DisplayDefine(instance)
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala

  if l:scala.sign.is_enable
    call s:ScalaDefineSigns(a:instance)
  endif
  if l:scala.color_line.is_enable
    call s:ScalaDefineColorLine(a:instance)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaDefineColorColumn(a:instance)
  endif

  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinDefineCursorLine(a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinDefineHighlightLine(a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinDefineSign(a:instance)
  endif

  " handlers
  call add(a:instance.handlers.on_new_file, function("s:DisplayEnableFile"))
  call add(a:instance.handlers.on_close, function("s:DisplayDisableFile"))
endfunction

function! s:DisplayEnable(instance)
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala

  if l:scala.sign.is_enable
    call s:ScalaEnableSigns(a:instance)
  endif
  if l:scala.color_line.is_enable
    call s:ScalaEnableColorLine(a:instance)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaEnableColorColumn(a:instance)
  endif

  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinEnableCursorLine(a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinEnableHighlightLine(a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinEnableSign(a:instance)
  endif

endfunction

function! s:DisplayEnableFile(instance, file, entrynos)
call s:LOG("DisplayEnableFile TOP")
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala

  if l:scala.sign.is_enable
    call s:ScalaEnableFileSigns(a:instance, a:file, a:entrynos)
  endif
  if l:scala.color_line.is_enable
    call s:ScalaEnableFileColorLine(a:instance, a:file, a:entrynos)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaEnableFileColorColumn(a:instance, a:file, a:entrynos)
  endif

  " actwin
  let l:actwin = l:display.actwin

  " No new files for actwin

call s:LOG("DisplayEnableFile BOTTOM")
endfunction


function! s:DisplayEntryEnter(entrynos, instance)
call s:LOG("s:DisplayEntryEnter TOP")
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala

  if l:scala.color_line.is_enable
    call s:ScalaEntryEnterColorLine(a:instance, a:entrynos)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaEntryEnterColorColumn(a:instance, a:entrynos)
  endif

  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinEnterCursorLine(a:entrynos, a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinEnterHighlightLine(a:entrynos, a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinEnterSign(a:entrynos, a:instance)
  endif

call s:LOG("s:DisplayEntryEnter BOTTOM")
endfunction

function! s:DisplayEntryLeave(entrynos, instance)
call s:LOG("s:DisplayEntryLeave TOP")
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala
  if l:scala.color_line.is_enable
    call s:ScalaEntryLeaveColorLine(a:instance, a:entrynos)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaEntryLeaveColorColumn(a:instance, a:entrynos)
  endif


  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinLeaveCursorLine(a:entrynos, a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinLeaveHighlightLine(a:entrynos, a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinLeaveSign(a:entrynos, a:instance)
  endif
call s:LOG("s:DisplayEntryLeave BOTTOM")
endfunction

function! s:DisplayEntryDelete(entrynos, instance)
call s:LOG("s:DisplayEntryDelete TOP")
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala
  if l:scala.sign.is_enable
    call s:ScalaEntryDeleteSigns(a:instance, a:entrynos)
  endif
  if l:scala.color_line.is_enable
    call s:ScalaEntryDeleteColorLine(a:instance, a:entrynos)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaEntryDeleteColorColumn(a:instance, a:entrynos)
  endif


  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinDeleteCursorLine(a:entrynos, a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinDeleteHighlightLine(a:entrynos, a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinDeleteSign(a:entrynos, a:instance)
  endif
call s:LOG("s:DisplayEntryDelete BOTTOM")
endfunction

" MUST be called from local buffer
function! s:DisplayDisableFile(instance, file)
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala


  " actwin
  let l:actwin = l:display.actwin

endfunction

" MUST be called from local buffer
function! s:DisplayDisable(instance)
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala

  if l:scala.sign.is_enable
    call s:ScalaDisableSigns(a:instance)
  endif
  if l:scala.color_line.is_enable
    call s:ScalaDisableColorLine(a:instance)
  endif
  if l:scala.color_column.is_enable
    call s:ScalaDisableColorColumn(a:instance)
  endif

  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinDisableCursorLine(a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinDisableHighlightLine(a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinDisableSign(a:instance)
  endif
endfunction

" MUST be called from local buffer
function! s:DisplayDestroy(instance)
call s:LOG("s:DisplayDestroy TOP")
  let l:display = a:instance.data.display

  " scala
  let l:scala = l:display.scala

  if l:scala.sign.is_enable
    call s:ScalaDestroySigns(a:instance)
  endif
  if l:scala.color_line.is_enable
    call s:ScalaDestroyColorLine(a:instance)
  endif

  if l:scala.color_column.is_enable
    call s:ScalaDestroyColorColumn(a:instance)
  endif
if s:is_color_column_enabled
    execute 'silent '. a:instance.scala_win_nr.'wincmd w | :set colorcolumn='
endif

  " actwin
  let l:actwin = l:display.actwin

  if l:actwin.cursor_line.is_enable
    call s:ActWinDestroyCursorLine(a:instance)
  endif
  if l:actwin.highlight_line.is_enable
    call s:ActWinDestroyHighlightLine(a:instance)
  endif
  if l:actwin.sign.is_enable
    call s:ActWinDestroySign(a:instance)
  endif
call s:LOG("s:DisplayDestroy BOTTOM")
endfunction

" ------------------------------
" Display Scala: {{{1
"   Define
"    Toggle
"    Enable
"     Enter
"     Leave
"    Disable
"   Destroy
" ------------------------------

" ------------------------------
" Sign {{{1
" ------------------------------

function! s:ScalaDefineSigns(instance)
call s:LOG("s:ScalaDefineSigns TOP")
  let l:sign = a:instance.data.display.scala.sign
  let l:category = l:sign.category

  if has_key(l:sign, 'kinds') && ! vimside#sign#HasCategory(l:category)
    call vimside#sign#AddCategory(l:category, l:sign)
  endif
call s:LOG("s:ScalaDefineSigns BOTTOM")
endfunction

function! s:ScalaEnableSigns(instance)
call s:LOG("s:ScalaEnableSigns TOP")
  let l:data = a:instance.data
  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:sign = l:data.display.scala.sign
  let l:category = l:sign.category
  for l:entry in l:data.entries
    let l:file = l:entry.file
    let l:bnr = bufnr(l:file)
    if l:bnr > 0
      let l:line = l:entry.line
      let l:kind = l:entry.kind
      call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
    else
call s:LOG("s:ScalaEnableSigns not placed file=". l:file)
    endif
  endfor

  let l:toggle = l:sign.toggle
  let l:funcname = "g:ScalaToggleSigns"

  call s:DoToggleCmds(1, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

call s:LOG("s:ScalaEnableSigns BOTTOM")
endfunction

function! s:ScalaEnableFileSigns(instance, file, entrynos)
call s:LOG("s:ScalaEnableFileSigns TOP")
  let l:file = fnamemodify(a:file, ":p")
  let l:data = a:instance.data
  let l:sign = a:instance.data.display.scala.sign
  let l:category = l:sign.category
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:bnr = bufnr(l:file)
  if l:bnr > 0 && a:file == l:file
    let l:line = l:entry.line
    let l:kind = l:entry.kind
    call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
call s:LOG("s:ScalaEnableFileSigns placed file=". l:file)
  endif
call s:LOG("s:ScalaEnableFileSigns BOTTOM")
endfunction


function! g:ScalaToggleSigns(buffer_nr)
call s:LOG("g:ScalaToggleSigns TOP")
  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:ToggleSigns instance not found")
    return
  endif

  let l:data = l:instance.data
  let l:has_data_sign = has_key(l:data, 'display') && has_key(l:data.display, 'scala') && has_key(l:data.display.scala, 'sign')
  if l:has_data_sign
    let l:sign = l:data.display.scala.sign
    let l:sign.is_on = ! l:sign.is_on
    call vimside#sign#Toggle(l:sign.category, l:sign.is_on)
  endif
call s:LOG("g:ScalaToggleSigns BOTTOM")
endfunction

function! s:ScalaEntryDeleteSigns(instance, entrynos)
call s:LOG("g:ScalaEntryDeleteSigns TOP")
  let l:data = a:instance.data
  let l:sign = a:instance.data.display.scala.sign
  let l:category = l:sign.category
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:bnr = bufnr(l:file)
  if l:bnr > 0 
    let l:line = l:entry.line
    let l:kind = l:entry.kind
    call vimside#sign#UnPlaceFile(l:file, l:category, l:kind, l:line)
call s:LOG("s:ScalaEntryDeleteSigns unplaced file=". l:file .", line=". l:line)
  endif

call s:LOG("g:ScalaEntryDeleteSigns BOTTOM")
endfunction

function! s:ScalaDisableSigns(instance)
call s:LOG("s:ScalaDisableSigns TOP")

  let l:data = a:instance.data
  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:sign = l:data.display.scala.sign
  let l:toggle = l:sign.toggle
  let l:funcname = "g:ScalaToggleSigns"

  call s:DoToggleCmds(0, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

  let l:category = l:sign.category
  if vimside#sign#HasCategory(l:category)
    call vimside#sign#ClearCategory(l:category)
  endif

call s:LOG("s:ScalaDisableSigns BOTTOM")
endfunction

function! s:ScalaDestroySigns(instance)
call s:LOG("s:ScalaDestroySigns TOP")
  let l:sign = a:instance.data.display.scala.sign
  let l:category = l:sign.category
  if vimside#sign#HasCategory(l:category)
    call vimside#sign#RemoveCategory(l:category)
  endif
call s:LOG("s:ScalaDestroySigns BOTTOM")
endfunction

" ------------------------------
" ColorLine {{{1
" ------------------------------

function! s:ScalaDefineColorLine(instance)
call s:LOG("s:ScalaDefineColorLine TOP")
  let l:color_line = a:instance.data.display.scala.color_line
  let l:category = l:color_line.category


  if has_key(l:color_line, 'kinds') && ! vimside#sign#HasCategory(l:category)
    call vimside#sign#AddCategory(l:category, l:color_line)
  endif
call s:LOG("s:ScalaDefineColorLine BOTTOM")
endfunction

function! s:ScalaEnableColorLine(instance)
call s:LOG("s:ScalaEnableColorLine TOP")

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:color_line = a:instance.data.display.scala.color_line
  let l:toggle = l:color_line.toggle
  let l:funcname = "g:ScalaToggleColorLine"

  call s:DoToggleCmds(1, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)


call s:LOG("s:ScalaEnableColorLine BOTTOM")
endfunction

function! s:ScalaEnableFileColorLine(instance, file, entrynos)
call s:LOG("s:ScalaEnableFileColorLine TOP")
  let l:file = fnamemodify(a:file, ":p")
  let l:data = a:instance.data
  let l:color_line = a:instance.data.display.scala.color_line
  let l:category = l:color_line.category

  let l:bnr = bufnr(l:file)
  if l:bnr > 0 && a:file == l:file
    let l:entry = l:data.entries[a:entrynos]
    let l:file = l:entry.file
    let l:line = l:entry.line

    let l:kind = l:entry.kind
    let l:kinds = l:color_line.kinds
    if ! has_key(l:kinds, l:kind)
      if has_key(l:color_line, 'default_kind')
        let l:kind = l:color_line.default_kind
      else
        let l:kind = 'marker'
        for l:key in keys(l:kinds)
          let l:kind = l:key
          break
        endfor
      endif
    endif

    
call s:LOG("s:ScalaEnableFileSigns placed file=". l:file)
    if ! vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
      call s:ERROR("ScalaEnableFileSigns placed line=". l:line .", file=". l:file .", l:category=". l:category .", l:kind=". l:kind )
    endif
  endif
call s:LOG("s:ScalaEnableFileColorLine BOTTOM")
endfunction

function! s:ScalaEntryEnterColorLine(instance, entrynos)
call s:LOG("s:ScalaEntryEnterColorLine TOP")
  let l:data = a:instance.data
  let l:color_line = l:data.display.scala.color_line
  let l:category = l:color_line.category

  let l:entry = l:data.entries[a:entrynos]
  let l:line = l:entry.line
  let l:file = l:entry.file

  let l:kind = l:entry.kind
  let l:kinds = l:color_line.kinds
  if ! has_key(l:kinds, l:kind)
    if has_key(l:color_line, 'default_kind')
      let l:kind = l:color_line.default_kind
    else
      let l:kind = 'marker'
      for l:key in keys(l:kinds)
        let l:kind = l:key
        break
      endfor
    endif
  endif

  let l:bnr = bufnr(l:file)
call s:LOG("s:ScalaEntryEnterColorLine file=". l:file)
call s:LOG("s:ScalaEntryEnterColorLine bnr=". l:bnr)
  if l:bnr > 0
    if ! vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
      call s:ERROR("ScalaEntryEnterColorLine placed line=". l:line .", file=". l:file .", l:category=". l:category .", l:kind=". l:kind )
    endif
  endif

call s:LOG("s:ScalaEntryEnterColorLine BOTTOM")
endfunction

function! s:ScalaEntryLeaveColorLine(instance, entrynos)
call s:LOG("s:ScalaEntryLeaveColorLine TOP")
  let l:data = a:instance.data
  let l:color_line = l:data.display.scala.color_line
  let l:category = l:color_line.category

  let l:kind = 'marker'
  for l:key in keys(l:color_line.kinds)
    let l:kind = l:key
    break
  endfor

  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
call s:LOG("s:ScalaEntryLeaveColorLine file=". l:file)
  let l:line = l:entry.line
  " call vimside#sign#UnPlaceFileByLine(l:file, l:category, l:kind, l:line)
  " call vimside#sign#UnPlaceFile(l:file, l:category, l:kind)
  if vimside#sign#HasCategory(l:category)
    call vimside#sign#ClearCategory(l:category)
  endif

call s:LOG("s:ScalaEntryLeaveColorLine BOTTOM")
endfunction

function! g:ScalaToggleColorLine(buffer_nr)
call s:LOG("g:ScalaToggleColorLine TOP")
  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:ToggleColorLine instance not found")
    return
  endif

  let l:color_line = a:instance.data.display.scala.color_line
  let l:color_line.is_on = ! l:color_line.is_on = 0
  call vimside#sign#Toggle(l:color_line.category, l:color_line.is_on)
call s:LOG("g:ScalaToggleColorLine BOTTOM")
endfunction

function! s:ScalaEntryDeleteColorLine(instance, entrynos)
call s:LOG("g:ScalaEntryDeleteColorLine TOP")
call s:LOG("g:ScalaEntryDeleteColorLine BOTTOM")
endfunction

function! s:ScalaDisableColorLine(instance)
call s:LOG("s:ScalaDisableColorLine TOP")

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:color_line = a:instance.data.display.scala.color_line
  let l:toggle = l:color_line.toggle
  let l:funcname = "g:ScalaToggleColorLine"

  call s:DoToggleCmds(0, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)


  let l:category = l:color_line.category
  if vimside#sign#HasCategory(l:category)
    call vimside#sign#ClearCategory(l:category)
  endif

call s:LOG("s:ScalaDisableColorLine BOTTOM")
endfunction

function! s:ScalaDestroyColorLine(instance)
call s:LOG("s:ScalaDestroyColorLine TOP")
  let l:color_line = a:instance.data.display.scala.color_line
  let l:category = l:color_line.category
  if vimside#sign#HasCategory(l:category)
    call vimside#sign#RemoveCategory(l:category)
  endif
call s:LOG("s:ScalaDestroyColorLine BOTTOM")
endfunction

" ------------------------------
" ColorColumn {{{1
" ------------------------------
function! s:ScalaDefineColorColumn(instance)
call s:LOG("s:ScalaDefineColorColumn TOP")
"  let l:color_line = a:instance.data.display.scala.color_line
"  let b:color_column_toggle = l:color_line.toggle
"  let l:color_column = a:instance.data.display.scala.color_column
"
"  if has_key(l:color_column, 'toggle')
"    let b:color_column_toggle = l:color_column.toggle
"    " unlet l:color_line.toggle
"  endif
call s:LOG("s:ScalaDefineColorColumn BOTTOM")
endfunction

function! s:ScalaEnableColorColumn(instance)
call s:LOG("s:ScalaEnableColorColumn TOP")

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:color_column = a:instance.data.display.scala.color_column
  let l:toggle = l:color_column.toggle
  let l:funcname = "g:ScalaToggleColorColumn"

  call s:DoToggleCmds(1, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

call s:LOG("s:ScalaEnableColorColumn BOTTOM")
endfunction

function! s:ScalaEnableFileColorColumn(instance, file, entrynos)
call s:LOG("s:ScalaEnableFileColorColumn TOP")

  let l:data = a:instance.data
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
  let l:bnr = bufnr(l:file)
call s:LOG("s:ScalaEnableFileColorColumn: file=". l:file)
call s:LOG("s:ScalaEnableFileColorColumn: bnr=". l:bnr)
  if l:bnr > 0 && l:file == a:file
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:ScalaEntryEnterColorColumn: DO_COLOR file win_nr=". l:win_nr)


    if l:win_nr > 0
let s:buf_change = 0
      if l:colnos > 0
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
      else
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
      endif
let s:buf_change = 1

call s:LOG("s:ScalaEntryEnterColorColumn: RETURN a:instance.win_nr=". a:instance.win_nr)
      execute 'silent '. a:instance.win_nr.'wincmd w'
    endif
  endif
call s:LOG("s:ScalaEnableFileColorColumn BOTTOM")
endfunction

function! s:ScalaEntryEnterColorColumn(instance, entrynos)
call s:LOG("s:ScalaEntryEnterColorColumn TOP")

  let l:data = a:instance.data
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
  let l:bnr = bufnr(l:file)
call s:LOG("s:ScalaEntryEnterColorColumn: file=". l:file)
call s:LOG("s:ScalaEntryEnterColorColumn: bnr=". l:bnr)
  if l:bnr > 0 
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:ScalaEntryEnterColorColumn: DO_COLOR file win_nr=". l:win_nr)


    if l:win_nr > 0
let s:buf_change = 0
      if l:colnos > 0
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
      else
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
      endif
let s:buf_change = 1

call s:LOG("s:ScalaEntryEnterColorColumn: RETURN a:instance.win_nr=". a:instance.win_nr)
      execute 'silent '. a:instance.win_nr.'wincmd w'
    endif
  endif

call s:LOG("s:ScalaEntryEnterColorColumn BOTTOM")
endfunction

function! s:ScalaEntryLeaveColorColumn(instance, entrynos)
call s:LOG("s:ScalaEntryLeaveColorColumn TOP")

  let l:data = a:instance.data
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file

  let l:bnr = bufnr(l:file)
call s:LOG("s:ScalaEntryLeaveColorColumn: file=". l:file)
call s:LOG("s:ScalaEntryLeaveColorColumn: bnr=". l:bnr)
  if l:bnr > 0
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:ScalaEntryLeaveColorColumn: DO_COLOR file win_nr=". l:win_nr)

    if l:win_nr > 0
call s:LOG("s:ScalaEntryLeaveColorColumn: CLEAR")
let s:buf_change = 0
      execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
let s:buf_change = 1

call s:LOG("s:ScalaEntryEnterColorColumn: RETURN a:instance.win_nr=". a:instance.win_nr)
      execute 'silent '. a:instance.win_nr.'wincmd w'
    endif
  endif


call s:LOG("s:ScalaEntryLeaveColorColumn BOTTOM")
endfunction

function! s:ScalaDisableColorColumn(instance)
call s:LOG("s:ScalaDisableColorColumn TOP")

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:color_column = a:instance.data.display.scala.color_column
  let l:toggle = l:color_column.toggle
  let l:funcname = "g:ScalaToggleColorColumn"

  call s:DoToggleCmds(0, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

call s:LOG("s:ScalaDisableColorColumn BOTTOM")
endfunction

function! g:ScalaToggleColorColumn(buffer_nr)
call s:LOG("g:ScalaToggleColorColumn TOP")
  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:ToggleColorColumn instance not found")
    return
  endif

  let l:data = l:instance.data
  let l:color_column = l:data.display.scala.color_column

  let l:linenos = l:instance.current_line
  let l:linenos_to_entrynos = l:instance.linenos_to_entrynos
  let l:entrynos = l:linenos_to_entrynos[l:linenos-1]
  let l:entry = l:data.entries[l:entrynos]
  let l:file = l:entry.file
  let l:bnr = bufnr(l:file)
  let l:win_nr = bufwinnr(l:bnr)
call s:LOG("g:ScalaToggleColorColumn: file=". l:file)
call s:LOG("g:ScalaToggleColorColumn: bnr=". l:bnr)
call s:LOG("g:ScalaToggleColorColumn: win_nr=". l:win_nr)
  if l:win_nr > 0

let s:buf_change = 0
    let l:color_column.is_on = ! l:color_column.is_on
    if l:color_column.is_on
      let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1

      if l:colnos > 0
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
      else
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
      endif
    else
      execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
    endif
let s:buf_change = 1

  endif

call s:LOG("g:ScalaToggleColorColumn BOTTOM")
endfunction

function! s:ScalaEntryDeleteColorColumn(instance, entrynos)
call s:LOG("g:ScalaEntryDeleteColorColumn TOP")
call s:LOG("g:ScalaEntryDeleteColorColumn BOTTOM")
endfunction

function! s:ScalaDestroyColorColumn(instance)
call s:LOG("s:ScalaDestroyColorColumn TOP")
call s:LOG("s:ScalaDestroyColorColumn: REMOVE COLOR scala win_nr=". a:instance.scala_win_nr)
  execute 'silent '. a:instance.scala_win_nr.'wincmd w | :set colorcolumn='
call s:LOG("s:ScalaDestroyColorColumn BOTTOM")
endfunction

" ------------------------------
" Display ActWin: {{{1
"   Define
"    Enter
"    Leave
"    Toggle
"   Destroy
" ------------------------------

" ------------------------------
" CursorLine {{{1
" ------------------------------

" MUST be called from local buffer
function! s:ActWinDefineCursorLine(instance)
  let l:cursor_line = a:instance.data.display.actwin.cursor_line

  if has_key(l:cursor_line, 'highlight') 
    let l:highlight = l:cursor_line.highlight
    let l:cursor_line.current_highlight = vimside#color#util#GetCurrentHighlight("CursorLine")
    execute "hi ".  ." ". l:highlight
  endif

  if l:cursor_line.is_on
    setlocal modifiable
    setlocal cursorline
    setlocal nomodifiable
  endif
endfunction

function! s:ActWinEnableCursorLine(instance)

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:cursor_line = a:instance.data.display.actwin.cursor_line
  let l:toggle = l:cursor_line.toggle
  let l:funcname = "g:ActWinToggleCursorLine"

  call s:DoToggleCmds(1, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

endfunction

function! s:ActWinEnterCursorLine(entrynos, instance)
  " emtpy
endfunction

function! s:ActWinLeaveCursorLine(entrynos, instance)
  " emtpy
endfunction

function! g:ActWinToggleCursorLine(buffer_nr)
call s:LOG("g:0ctWinToggleCursorLine TOP")
  " let [l:found, l:instance] = s:GetBufferActWin()
  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:ToggleCursorLine instance not found")
    return
  endif
  let l:current_buffer_nr = bufnr("%")

  let l:cursor_line = l:instance.data.display.actwin.cursor_line
  let l:cursor_line.is_on = ! l:cursor_line.is_on

let s:buf_change = 0
execute 'silent '. a:buffer_nr.'wincmd w'
  setlocal modifiable
  if l:cursor_line.is_on
    setlocal cursorline
  else
    setlocal nocursorline
  endif
  setlocal nomodifiable
execute 'silent '. l:current_buffer_nr.'wincmd w'
let s:buf_change = 0

call s:LOG("g:ActWinToggleCursorLine BOTTOM")
endfunction

function! s:ActWinDeleteCursorLine(entrynos, instance)
call s:LOG("g:ActWinDeleteCursorLine TOP")
  " emtpy
call s:LOG("g:ActWinDeleteCursorLine BOTTOM")
endfunction

function! s:ActWinDisableCursorLine(instance)
call s:LOG("g:ActWinDisableCursorLine TOP")

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:cursor_line = a:instance.data.display.actwin.cursor_line
  let l:toggle = l:cursor_line.toggle
  let l:funcname = "g:ActWinToggleCursorLine"

  call s:DoToggleCmds(0, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

  if exists(l:cursor_line.current_highlight) && l:cursor_line.current_highlight != ''
    execute "highlight CursorLine " . l:cursor_line.current_highlight
  endif
call s:LOG("g:ActWinDisableCursorLine BOTTOM")
endfunction


" MUST be called from local buffer
function! s:ActWinDestroyCursorLine(instance)
  " empty
endfunction

" ------------------------------
" HighlightLine {{{1
" ------------------------------

" MUST be called from local buffer
function! s:ActWinDefineHighlightLine(instance)
  let l:highlight_line = a:instance.data.display.actwin.highlight_line

  if has_key(l:highlight_line, 'highlight') 
    let l:group = "HighlightLine"
    execute "highlight ". l:group ." ". l:highlight_line.highlight
  endif

  if l:highlight_line.is_full
    let l:currentline = a:instance.current_line
" call s:LOG("s:ActWinDefineHighlightLine currentline=". l:currentline)
    let l:winWidth = winwidth(0)
    let l:winHeight = line('$')

    let l:cnt = 1
    setlocal modifiable
    execute "normal! 1G"
    for l:line in getline(0, l:winHeight)
      execute "normal! ". (l:winWidth - len(l:line)) ."A "
      " execute "normal! j"
      let l:cnt += 1
      execute "normal! ".l:cnt."G"
    endfor
    execute "normal! ".l:currentline."G"
    setlocal nomodifiable
  endif
endfunction

function! s:ActWinEnableHighlightLine(instance)

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:highlight_line = a:instance.data.display.actwin.highlight_line
  let l:toggle = l:highlight_line.toggle
  let l:funcname = "g:ActWinToggleHighlightLine"

  call s:DoToggleCmds(1, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

endfunction

function! s:ActWinEnterHighlightLine(entrynos, instance)
call s:LOG("s:ActWinEnterHighlightLine TOP")
  let l:highlight_line = a:instance.data.display.actwin.highlight_line

" call s:LOG("s:ActWinEnterHighlightLine entrynos=". a:entrynos)

  let l:entry = a:instance.data.entries[a:entrynos]
  let l:content = l:entry.content
  let l:nos_lines = (type(l:content) == type("")) ? 0 : (len(l:content)-1)
  if l:highlight_line.all_text
    let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
  else
    let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
    let l:nos_lines = 0
  endif
  let l:nos_columns = l:highlight_line.nos_columns

  let l:group = "HighlightLine"

" call s:LOG("s:ActWinEnterHighlightLine line_start=". l:line_start)
" call s:LOG("s:ActWinEnterHighlightLine nos_lines=". l:nos_lines)
  let l:highlight_line.sids = s:HighlightDisplay(l:group, l:line_start, l:line_start + l:nos_lines, l:nos_columns)

  let l:highlight_line.is_on = 1

endfunction

function! s:ActWinLeaveHighlightLine(entrynos, instance)
call s:LOG("s:ActWinLeaveHighlightLine entrynos=". a:entrynos)
  let l:highlight_line = a:instance.data.display.actwin.highlight_line

  if has_key(l:highlight_line, 'sids')
    call s:HighlightClear(l:highlight_line.sids)
    unlet l:highlight_line.sids
  endif

endfunction

function! g:ActWinToggleHighlightLine()
call s:LOG("g:ActWinToggleHighlightLine TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:ToggleHighlightLine instance not found")
    return
  endif

call s:LOG("g:ActWinToggleHighlightLine l:instance.current_line=". l:instance.current_line)
  let l:linenos = l:instance.current_line
  let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]

  let l:highlight_line = l:instance.data.display.actwin.highlight_line
  let l:highlight_line.is_on = ! l:highlight_line.is_on
  if l:highlight_line.is_on
    call s:ActWinEnterHighlightLine(l:entrynos, l:instance)
  else
    call s:ActWinLeaveHighlightLine(l:entrynos, l:instance)
  endif

call s:LOG("g:ActWinToggleHighlightLine BOTTOM")
endfunction

function! s:ActWinDeleteHighlightLine(entrynos, instance)
call s:LOG("g:ActWinDeleteHighlightLine TOP")
  " emtpy
call s:LOG("g:ActWinDeleteHighlightLine BOTTOM")
endfunction


function! s:ActWinDisableHighlightLine(instance)
call s:LOG("s:ActWinDisableHighlightLine TOP")
  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:highlight_line = a:instance.data.display.actwin.highlight_line
  let l:toggle = l:highlight_line.toggle
  let l:funcname = "g:ActWinToggleHighlightLine"

  call s:DoToggleCmds(0, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)
endfunction

" MUST be called from local buffer
function! s:ActWinDestroyHighlightLine(instance)
call s:LOG("s:ActWinDestroyHighlightLine TOP")
  let l:highlight_line = a:instance.data.display.actwin.highlight_line

  if has_key(l:highlight_line, 'sids')
    call s:HighlightClear(l:highlight_line.sids)
    unlet l:highlight_line.sids
  endif

  if l:highlight_line.is_full
    let l:currentline = a:instance.current_line
    let l:winHeight = line('$')

    let l:cnt = 1
    setlocal modifiable
    execute "normal! 1G"
    for l:line in getline(0, l:winHeight)                
      execute "normal! $b1 D"
      " execute "normal! b"
      " execute "normal! 1 "
      " execute "normal! D"
      let l:cnt += 1
      execute "normal! ".l:cnt."G"
    endfor
    execute "normal! ".l:currentline."G"
    setlocal nomodifiable
  endif


  let l:highlight_line.is_on = 0
endfunction


" ------------------------------
" Sign {{{1
" ------------------------------

function! s:ActWinDefineSign(instance)
call s:LOG("s:ActWinDefineSign TOP")
  let l:sign = a:instance.data.display.actwin.sign

  let l:category = l:sign.category

  if has_key(l:sign, 'kinds') && ! vimside#sign#HasCategory(l:category)
    call vimside#sign#AddCategory(l:category, l:sign)
  endif
endfunction

function! s:ActWinEnableSign(instance)

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:sign = a:instance.data.display.actwin.sign
  let l:toggle = l:sign.toggle
  let l:funcname = "g:ActWinToggleSign"

  call s:DoToggleCmds(1, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)

endfunction

function! s:ActWinEnterSign(entrynos, instance)
call s:LOG("s:ActWinEnterSign TOP")
call s:LOG("s:ActWinEnterSign entrynos=". a:entrynos)
  let l:sign = a:instance.data.display.actwin.sign
  let l:buffer_nr = a:instance.buffer_nr
  let l:category = l:sign.category
  let l:entry = a:instance.data.entries[a:entrynos]

  let l:kind = l:entry.kind
  let l:kinds = l:sign.kinds
  if ! has_key(l:kinds, l:kind)
    if has_key(l:sign, 'default_kind')
      let l:kind = l:sign.default_kind
    else
      let l:kind = 'marker'
      for l:key in keys(l:kinds)
        let l:kind = l:key
        break
      endfor
    endif
  endif
call s:LOG("s:ActWinEnterSign kind=". l:kind)

  let l:content = l:entry.content
  let l:nos_lines = (type(l:content) == type("")) ? 0 : (len(l:content)-1)
  " let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
  "
  if l:sign.all_text
    let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
    let l:cnt = 0
    while l:cnt <= l:nos_lines
      call vimside#sign#PlaceBuffer(l:line_start+l:cnt, l:buffer_nr, l:category, l:kind)
      let l:cnt += 1
    endwhile
  else
    let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
    call vimside#sign#PlaceBuffer(l:line_start, l:buffer_nr, l:category, l:kind)
  endif

" call vimside#sign#PlaceBuffer(l:line_start, l:buffer_nr, l:category, l:kind)

if 0 " example of text file sign
  let l:file = l:entry.file
  call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
endif " example of text file sign

call s:LOG("s:ActWinEnterSign BOTTOM")
endfunction

function! s:ActWinLeaveSign(entrynos, instance)
call s:LOG("s:ActWinLeaveSign TOP")
call s:LOG("s:ActWinLeaveSign entrynos=". a:entrynos)
  let l:sign = a:instance.data.display.actwin.sign
  let l:buffer_nr = a:instance.buffer_nr
  let l:category = l:sign.category
  let l:entry = a:instance.data.entries[a:entrynos]
  let l:file = l:entry.file

  let l:kind = l:entry.kind
  let l:kinds = l:sign.kinds
  if ! has_key(l:kinds, l:kind)
    if has_key(l:sign, 'default_kind')
      let l:kind = l:sign.default_kind
    else
      let l:kind = 'marker'
      for l:key in keys(l:kinds)
        let l:kind = l:key
        break
      endfor
    endif
  endif
call s:LOG("s:ActWinLeaveSign kind=". l:kind)

  let l:content = l:entry.content
  let l:nos_lines = (type(l:content) == type("")) ? 0 : (len(l:content)-1)
  " let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
  if l:sign.all_text
    let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
    let l:cnt = 0
    while l:cnt <= l:nos_lines
      call vimside#sign#UnPlaceBuffer(l:buffer_nr, l:category, l:kind, l:line_start+l:cnt)
      let l:cnt += 1
    endwhile
  else
    let l:line_start = a:instance.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:instance.first_buffer_line - 1
    call vimside#sign#UnPlaceBuffer(l:buffer_nr, l:category, l:kind, l:line_start)
  endif



if 0 " example of text file sign
  let l:file = l:entry.file
  call vimside#sign#UnPlaceFileByLine(l:line, l:file, l:category, l:kind)
endif " example of text file sign

call s:LOG("s:ActWinLeaveSign BOTTOM")
endfunction

function! g:ActWinToggleSign()
call s:LOG("g:ActWinToggleSign TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:ToggleSign instance not found")
    return
  endif

call s:LOG("g:ActWinToggleSign l:instance.current_line=". l:instance.current_line)
  let l:linenos = l:instance.current_line
  let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]

  let l:sign = l:instance.data.display.actwin.sign
  let l:sign.is_on = ! l:sign.is_on
  if l:sign.is_on
    call s:ActWinEnterSign(l:entrynos, l:instance)
  else
    call s:ActWinLeaveSign(l:entrynos, l:instance)
  endif

call s:LOG("g:ActWinToggleSign BOTTOM")
endfunction

function! s:ActWinDeleteSign(entrynos, instance)
call s:LOG("g:ActWinDeleteSign TOP")
  " emtpy
call s:LOG("g:ActWinDeleteSign BOTTOM")
endfunction

function! s:ActWinDisableSign(instance)
call s:LOG("s:ActWinDisableSign TOP")

  let l:is_global = a:instance.is_global
  let l:buffer_nr = a:instance.buffer_nr
  let l:scala_buffer_nr = a:instance.scala_buffer_nr
  let l:sign = a:instance.data.display.actwin.sign
  let l:toggle = l:sign.toggle
  let l:funcname = "g:ActWinToggleSign"

  call s:DoToggleCmds(0, l:is_global, l:toggle, l:buffer_nr, l:scala_buffer_nr, l:funcname)
endfunction

function! s:ActWinDestroySign(instance)
call s:LOG("s:ActWinDestroySign TOP")
  let l:sign = a:instance.data.display.actwin.sign
  let l:category = l:sign.category

  if vimside#sign#HasCategory(l:category)
    call vimside#sign#RemoveCategory(l:category)
  endif
endfunction

" ============================================================================
" Toggle Util: {{{1
" ============================================================================

function! s:DoToggleCmds(create, is_global, toggle, buffer_nr, scala_buffer_nr, funcname)
call s:LOG("s:DoToggleCmds TOP: funcname=". a:funcname)
let s:buf_change = 0
  if has_key(a:toggle, "actwin")
    let l:actwin = a:toggle.actwin

    if has_key(l:actwin, "map")
      let l:value = l:actwin.map
" call s:LOG("s:DoToggleCmds actwin.map(". l:value .")=". string(maparg(l:value, "n", 0, 1)))
      if a:create
        execute ":nnoremap <silent> <buffer> ". l:value ." :call ". a:funcname ."(". a:buffer_nr .")<CR>"
      else
        if hasmapto(a:funcname, "n")
          execute ":nunmap <buffer> ". l:value 
        endif
      endif
      unlet l:value
    endif
    if has_key(l:actwin, "cmd")
      let l:value = l:actwin.cmd
      if a:create
        execute ":command! -buffer ". l:value ." call ". a:funcname ."(". a:buffer_nr .")"
      else
        if exists(":". l:value) == 2
          execute "silent delcommand ". l:value 
        endif
      endif
      " execute ":command! -buffer ". l:value ." call ". a:funcname ."(". a:buffer_nr .")<CR>"
      " execute ":command! ". l:value ." call ". a:funcname ."(". a:buffer_nr .")"
      unlet l:value
    endif
    if has_key(l:actwin, "abbr")
      let l:value = l:actwin.abbr
" call s:LOG("s:DoToggleCmds actwin.abbr(". l:value .")=". string(maparg(l:value, "c", 1, 1)))
      if a:create
        execute "cabbrev <silent> <buffer> ". l:value ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". a:funcname ."(".  a:buffer_nr .")' : '' )<CR>"
      else
        execute "cunabbrev <buffer> ". l:value
      endif
      unlet l:value
    endif
  endif

  if has_key(a:toggle, "scala")
    let l:scala = a:toggle.scala

    if has_key(l:scala, "map")
      let l:value = l:scala.map
" call s:LOG("s:DoToggleCmds scala.map(". l:value .")=". string(maparg(l:value, "n", 0, 1)))
      if (a:is_global)
        if a:create
          execute ":nnoremap <silent> ". l:value ." :call ". a:funcname ."(". a:buffer_nr .")<CR>"
        else
          if hasmapto(a:funcname, "n")
            execute ":nunmap ". l:value 
          endif
        endif
      else

        execute 'silent '. a:scala_buffer_nr.'wincmd w'
        if a:create
          execute ":nnoremap <silent> <buffer> ". l:value ." :call ". a:funcname ."(". a:buffer_nr .")<CR>"
        else
          if hasmapto(a:funcname, "n")
            execute ":nunmap <buffer> ". l:value 
          endif
        endif
        execute 'silent '. a:buffer_nr.'wincmd w'

      endif
      unlet l:value
    endif
    if has_key(l:scala, "cmd")
      let l:value = l:scala.cmd
      if (a:is_global)
        " execute ":command! ". l:value ." call ". a:funcname ."(". a:buffer_nr .")<CR>"
        if a:create
          execute ":command! ". l:value ." call ". a:funcname ."(". a:buffer_nr .")"
        else
          if exists(":". l:value) == 2
            execute "silent delcommand ". l:value 
          endif
        endif
      else

        execute 'silent '. a:scala_buffer_nr.'wincmd w'
        " execute ":command! -buffer ". l:value ." call ". a:funcname ."(". a:buffer_nr .")<CR>"
        if a:create
          execute ":command! -buffer ". l:value ." call ". a:funcname ."(". a:buffer_nr .")"
        else
          if exists(":". l:value) == 2
            execute "silent delcommand ". l:value 
          endif
        endif
        execute 'silent '. a:buffer_nr.'wincmd w'

      endif
      unlet l:value
    endif
    if has_key(l:scala, "abbr")
      let l:value = l:scala.abbr
" call s:LOG("s:DoToggleCmds scala.abbr(". l:value .")=". string(maparg(l:value, "c", 1, 1)))
      if (a:is_global)
        if a:create
          " execute "cabbrev <silent> ". l:value ." 'call ". a:funcname ."(". a:buffer_nr .")'<CR>"
          execute "cabbrev <silent> ". l:value ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". a:funcname ."(".  a:buffer_nr .")' : '' )<CR>"
        else
          execute "cunabbrev  ". l:value
        endif
      else

        execute 'silent '. a:scala_buffer_nr.'wincmd w'
        if a:create
          execute "cabbrev <silent> <buffer> ". l:value ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". a:funcname ."(".  a:buffer_nr .")' : '' )<CR>"
        else
          execute "cunabbrev  <silent> <buffer> ". l:value
        endif
        execute 'silent '. a:buffer_nr.'wincmd w'

      endif
      unlet l:value
    endif
  endif

let s:buf_change = 1
call s:LOG("s:DoToggleCmds BOTTOM")
endfunction

" ============================================================================
" Util {{{1
" ============================================================================

if 0 " NOT USED
" return [line, ...]
function! s:GetLines(instance)
  let l:lines = []
  for entry in a:instance.data.entries
    let l:content = entry.content
    call add(l:lines, l:content)
  endfor

  return l:lines
endfunction
endif " NOT USED

" return [found, line]
function! s:GetEntry(entrynos, instance)
  if a:entrynos < 0
    return [0, {}]
  else
    let l:entries = a:instance.data.entries
    if a:entrynos < len(l:entries)
      return [1, l:entries[a:entrynos]]
    else
      return [0, {}]
    endif
endfunction

" ============================================================================
" Close {{{1
" ============================================================================

" TODO how to close from a different buffer???
" MUST be called from local buffer
function! vimside#actwin#Close()
call s:LOG("vimside#actwin#Close TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("vimside#actwin#Close: instance not found")
    return
  endif
  call s:Close(l:instance)
endfunction

function! s:OnClose()
call s:LOG("s:OnClose TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnClose: instance not found")
    return
  endif

  call s:Close(l:instance)
call s:LOG("s:OnClose BOTTOM")
endfunction

" MUST be called from local buffer
function! s:Close(instance)
  let l:instance = a:instance
call s:LOG("s:Close l:instance.buffer_nr=". l:instance.buffer_nr)

  call s:DisplayDisable(l:instance)

  call s:DisplayDestroy(l:instance)

  call s:ClearCmds(l:instance)

  " If we needed to split the main actwin, close the split one.
  let l:actwin = l:instance.data.actwin
  if has_key(l:actwin, 'split')
call s:LOG("s:Close split")
execute 'silent '. l:instance.win_nr.'wincmd w'
    exec "wincmd c"
" execute 'silent '. l:instance.win_nr.'wincmd w'
  elseif has_key(l:actwin, 'edit')
call s:LOG("s:Close edit")
    let l:scala_buffer_nr = l:instance.scala_buffer_nr
call s:LOG("s:Close scala_buffer_nr=". l:scala_buffer_nr)
    execute "buffer ". l:scala_buffer_nr
    " exec "e!#"
  elseif has_key(l:actwin, 'tab')
call s:LOG("s:Close tab")
execute 'silent '. l:instance.win_nr.'wincmd w'
    exec "e!#"
" execute 'silent '. l:instance.buffer_nr.'wincmd w'
    " exec "wincmd c"
  endif

  execute "bwipeout ". l:instance.buffer_nr 
  call s:CloseAutoCmds(l:instance)
execute 'silent '. l:instance.scala_win_nr.'wincmd w'

  call s:CallOnCloseHandlers(l:instance)

  unlet s:actwin_buffer_nr_to_actwin[l:instance.buffer_nr]

  if l:instance.is_global
    unlet s:globals[l:instance.tag]
  else
    unlet s:locals[l:instance.tag]
  endif

call s:LOG("Close BOTTOM")
endfunction

" ============================================================================
" Mappings: {{{1
" ============================================================================

" MUST be called from local buffer
function! s:OnHelp()
call s:LOG("OnHelp TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnHelp: instance not found")
    return
  endif

  let l:help = l:instance.data.help

  if l:help.do_show
    " TODO remove is_open   
    let l:help.is_open = !l:help.is_open
    call vimside#actwin#DisplayLocal('testhelp', l:help.data)
  endif

call s:LOG("OnHelp BOTTOM")
endfunction

" MUST be called from local buffer
function! s:ToggleActWinMapInfo()
  call s:Toggle('actwin_map_show', 'actwin', 'map', s:cmds_actwin_defs)
endfunction

function! s:ToggleScalaBuiltinCmdInfo()
  call s:Toggle('scala_cmd_show', 'scala', 'cmd', s:cmds_scala_defs)
endfunction

function! s:ToggleScalaMapInfo()
  call s:Toggle('scala_map_show', 'scala', 'map', s:cmds_scala_defs)
endfunction

function! s:Toggle(key_name, data_win, data_element, defs)
call s:LOG("Toggle TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:Toggle: instance not found")
    return
  endif

  let l:key_value = l:instance.data.cmds.actwin.map[a:key_name]

  setlocal modifiable

  " Save position.
  normal! ma
    
  " Remove existing help
  if (l:instance.first_buffer_line > 1)
call s:LOG("Toggle delete")
    exec "keepjumps 1,".(l:instance.first_buffer_line - 1) "d _"
  endif
    
  call append(0, s:CreateToggleInfo(a:data_win, a:data_element, l:key_value, a:defs, l:instance))

  silent! normal! g`a
  delmarks a

  setlocal nomodifiable
  redraw
call s:LOG("Toggle BOTTOM")
endfunction

" MUST be called from local buffer
function! s:EnterCurrentEntry(instance)
  let l:current_line = a:instance.current_line
  let l:current_entrynos = a:instance.linenos_to_entrynos[l:current_line-1]
  call s:EnterEntry(l:current_entrynos, a:instance)
endfunction


" MUST be called from local buffer
" cursor entering given entrynos
function! s:EnterEntry(entrynos, instance)
call s:LOG("s:EnterEntry TOP entrynos=". a:entrynos)

  call s:DisplayEntryEnter(a:entrynos, a:instance)
  call a:instance.data.actions.enter(a:entrynos, a:instance)

call s:LOG("s:EnterEntry BOTTOM")
endfunction

function! s:DeleteEntry(entrynos, instance)
  let l:entrynos = a:entrynos
call s:LOG("s:DeleteEntry TOP entrynos=". l:entrynos)
call s:LOG("s:DeleteEntry current_line=". a:instance.current_line)

  let l:current_line = a:instance.current_line

  call s:DisplayEntryDelete(l:entrynos, a:instance)

  let l:entries = a:instance.data.entries
call s:LOG("s:DeleteEntry BEFORE nos entries=". len(l:entries))
  let l:entry = remove(l:entries, l:entrynos)
call s:LOG("s:DeleteEntry AFTER nos entries=". len(l:entries))

  call s:LoadDisplay(a:instance)

  " let l:entrynos_to_linenos = l:instance.entrynos_to_linenos

  if l:entrynos == len(l:entries)
    let a:instance.current_line = l:current_line - 1
  else
    let a:instance.current_line = l:current_line
  endif
  call cursor(a:instance.current_line, 1)

call s:LOG("s:DeleteEntry current_line=". a:instance.current_line)
call s:LOG("s:DeleteEntry BOTTOM")
endfunction


" MUST be called from local buffer
function! s:SelectEntry(entrynos, instance)
  call a:instance.data.actions.select(a:entrynos, a:instance)
endfunction

" MUST be called from local buffer
function! s:LeaveCurrentEntry(instance)
  let l:current_line = a:instance.current_line
  let l:current_entrynos = a:instance.linenos_to_entrynos[l:current_line-1]
  call s:LeaveEntry(l:current_entrynos, a:instance)
endfunction

" MUST be called from local buffer
" cursor leaving given entrynos
function! s:LeaveEntry(entrynos, instance)
call s:LOG("s:LeaveEntry TOP entrynos=". a:entrynos)

  call a:instance.data.actions.leave(a:entrynos, a:instance)
  call s:DisplayEntryLeave(a:entrynos, a:instance)

call s:LOG("s:LeaveEntry BOTTOM")
endfunction





" MUST be called from local buffer
function! s:OnEnterMouse()
call s:LOG("s:OnEnterMouse: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnEnterMouse: instance not found")
    return
  endif

  let l:line = line(".")
call s:LOG("s:OnEnterMouse: l:line=". l:line)
call s:LOG("s:OnEnterMouse: l:instance.first_buffer_line=". l:instance.first_buffer_line)

  if l:line > (l:instance.first_buffer_line - 1)
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:current_line = l:instance.current_line
call s:LOG("s:OnEnterMouse: l:linenos=". l:linenos)
call s:LOG("s:OnEnterMouse: l:current_line=". l:current_line)
    let l:current_entrynos = l:instance.linenos_to_entrynos[l:current_line-1]
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]

    if l:entrynos != l:current_entrynos
      call s:LeaveEntry(l:current_entrynos, l:instance)
      call s:EnterEntry(l:entrynos, l:instance)
      let l:instance.current_line = l:linenos
    endif
  endif

call s:LOG("s:OnEnterMouse: BOTTOM")
endfunction

" MUST be called from local buffer <CR> -> OnSelect
function! s:OnSelect()
call s:LOG("s:OnSelect: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnSelect: instance not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:instance.first_buffer_line - 1)
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]

    call s:SelectEntry(l:entrynos, l:instance)
    let l:instance.current_line = l:linenos
  else
    call feedkeys("\<CR>", 'n')
  endif

call s:LOG("s:OnSelect: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnTop()
call s:LOG("s:OnTop: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnTop: instance not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:instance.first_buffer_line - 1)
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnTop l:entrynos=". l:entrynos)

    call s:LeaveEntry(l:entrynos, l:instance)

    let l:nos_of_linenos = l:linenos
    if l:nos_of_linenos == 1
      call feedkeys('k', 'n')
    else
      call feedkeys(repeat('k', l:nos_of_linenos), 'n')
    endif


    call s:EnterEntry(0, l:instance)
    let l:instance.current_line = 1
call s:LOG("s:OnTop l:instance.current_line=". l:instance.current_line)
  endif
call s:LOG("s:OnTop: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnBottom()
call s:LOG("s:OnBottom: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnBottom: instance not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:instance.first_buffer_line - 1)
    let l:entrynos_to_linenos = l:instance.entrynos_to_linenos
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnBottom l:entrynos=". l:entrynos)

    let l:len = len(l:entrynos_to_linenos)
call s:LOG("s:OnBottom l:len=". l:len)
    if l:entrynos < l:len - 1
      call s:LeaveEntry(l:entrynos, l:instance)

      let l:entries = l:instance.data.entries
      let l:entries_len = len(l:entries)
      let l:delta_lines = 0
      let l:cnt = l:entrynos
      while l:cnt < l:entries_len
        let l:delta_lines += l:instance.entrynos_to_nos_of_lines[l:cnt]
        let l:cnt += 1
      endwhile
      let l:nos_of_linenos = l:delta_lines
      if l:nos_of_linenos == 1
        call feedkeys('j', 'n')
      else
        call feedkeys(repeat('j', l:nos_of_linenos), 'n')
      endif


      call s:EnterEntry(l:entries_len-1, l:instance)
      let l:instance.current_line += l:delta_lines
call s:LOG("s:OnBottom l:instance.current_line=". l:instance.current_line)
    endif
  endif

call s:LOG("s:OnBottom: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnUp()
call s:LOG("s:OnUp: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnUp: instance not found")
    return
  endif
call s:LOG("s:OnUp l:instance.current_line=". l:instance.current_line)

  let l:line = line(".")
call s:LOG("s:OnUp l:line=". l:line)
call s:LOG("s:OnUp l:instance.first_buffer_line=". l:instance.first_buffer_line)

  if l:line > l:instance.first_buffer_line
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnUp l:entrynos=". l:entrynos)

    call s:LeaveEntry(l:entrynos, l:instance)

    let l:nos_of_linenos = l:instance.entrynos_to_nos_of_lines[l:entrynos-1] 
    let l:new_linenos = l:instance.entrynos_to_linenos[l:entrynos-1] 
call s:LOG("s:OnUp l:nos_of_linenos=". l:nos_of_linenos)
    if l:nos_of_linenos == 1
      call feedkeys('k', 'n')
    elseif l:nos_of_linenos > 1
      call feedkeys(repeat('k', l:nos_of_linenos), 'n')
    endif


    call s:EnterEntry(l:entrynos-1, l:instance)
    " let l:instance.current_line = l:new_linenos
    let l:instance.current_line -= l:nos_of_linenos
call s:LOG("s:OnUp l:instance.current_line=". l:instance.current_line)
  else
    call feedkeys('k', 'n')
  endif

call s:LOG("s:OnUp: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnDown()
call s:LOG("s:OnDown: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnDown: instance not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:instance.first_buffer_line - 1)
    let l:entrynos_to_linenos = l:instance.entrynos_to_linenos
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnDown l:entrynos=". l:entrynos)

    let l:len = len(l:entrynos_to_linenos)
call s:LOG("s:OnDown l:len=". l:len)
    if l:entrynos < l:len - 1
      call s:LeaveEntry(l:entrynos, l:instance)

      let l:nos_of_linenos = l:instance.entrynos_to_nos_of_lines[l:entrynos] 
      let l:new_linenos = l:entrynos_to_linenos[l:entrynos+1] 
call s:LOG("s:OnDown l:instance.current_line=". l:instance.current_line)
call s:LOG("s:OnDown l:nos_of_linenos=". l:nos_of_linenos)
call s:LOG("s:OnDown l:new_linenos=". l:new_linenos)
      " let l:nos_of_linenos -= 1
      if l:nos_of_linenos == 1
        call feedkeys('j', 'n')
      elseif l:nos_of_linenos > 1
        call feedkeys(repeat('j', l:nos_of_linenos), 'n')
      endif


      call s:EnterEntry(l:entrynos+1, l:instance)
      " let l:instance.current_line = l:new_linenos
      let l:instance.current_line += l:nos_of_linenos

call s:LOG("s:OnDown l:instance.current_line=". l:instance.current_line)
    endif

  endif

call s:LOG("s:OnDown: BOTTOM")
endfunction

function! s:OnLeft()
call s:LOG("s:OnLeft: TOP")
  call feedkeys('h', 'n')
call s:LOG("s:OnLeft: BOTTOM")
endfunction

function! s:OnRight()
call s:LOG("s:OnRight: TOP")
  call feedkeys('l', 'n')
call s:LOG("s:OnRight: BOTTOM")
endfunction

function! s:OnDelete()
call s:LOG("s:OnDelete: TOP")
  let [l:found, l:instance] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnDown: instance not found")
    return
  endif

  " are we deleting the last entry
  if len(l:instance.data.entries)  <= 1
    let s:buf_change = 0
    call s:Close(l:instance)
    let s:buf_change = 1
  else
    let l:line = line(".")

    if l:line > (l:instance.first_buffer_line - 1)
      let l:entrynos_to_linenos = l:instance.entrynos_to_linenos
      let l:linenos = l:line - l:instance.first_buffer_line + 1
      let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
  call s:LOG("s:OnDelete l:entrynos=". l:entrynos)

      let l:len = len(l:entrynos_to_linenos)
  call s:LOG("s:OnDelete l:len=". l:len)
      if l:entrynos < l:len 
        call s:LeaveEntry(l:entrynos, l:instance)

        call s:DeleteEntry(l:entrynos, l:instance)

        let l:entries = l:instance.data.entries
        if l:entrynos == len(l:entries)
          call s:EnterEntry(l:entrynos-1, l:instance)
        else
          call s:EnterEntry(l:entrynos, l:instance)
        endif

      endif
    endif
  endif

call s:LOG("s:OnDelete: BOTTOM")
endfunction

" ============================================================================
" Scala Commands: {{{1
" ============================================================================

function! g:VimsideActWinFirst(buffer_nr)
call s:LOG("g:VimsideActWinFirst: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnTop()
    return
  endif

  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinFirst: instance not found")
    return
  endif

  let l:win_nr = bufwinnr(a:buffer_nr)
  let l:current_win_nr = bufwinnr(l:current_buffer_nr)
  let b:return_win_nr = l:current_win_nr 

let s:buf_change = 0
  execute 'silent '. l:win_nr.'wincmd w'
  let l:line = line(".")

  if l:line > (l:instance.first_buffer_line - 1)
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnTop l:entrynos=". l:entrynos)

    call s:LeaveEntry(l:entrynos, l:instance)

    let l:nos_of_linenos = l:linenos
execute 'silent '. l:win_nr.'wincmd w'
    let l:line = line(".") - l:instance.first_buffer_line + 1
    if l:nos_of_linenos == 1
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-1),1)'
    else
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-'. l:nos_of_linenos .'),1)'
    endif


    call s:EnterEntry(0, l:instance)
    redraw

    let l:instance.current_line = 1
call s:LOG("s:OnTop l:instance.current_line=". l:instance.current_line)
  endif

  execute 'silent '. b:return_win_nr.'wincmd w'
let s:buf_change = 1

call histdel(":", "VimsideActWinFirst")

call s:LOG("g:VimsideActWinFirst: BOTTOM")
endfunction

function! g:VimsideActWinLast(buffer_nr)
call s:LOG("g:VimsideActWinLast: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnBottom()
    return
  endif

  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinLast: instance not found")
    return
  endif

  let l:win_nr = bufwinnr(a:buffer_nr)
  let l:current_win_nr = bufwinnr(l:current_buffer_nr)
  let b:return_win_nr = l:current_win_nr 

let s:buf_change = 0
  execute 'silent '. l:win_nr.'wincmd w'
  let l:line = line(".")

  if l:line > (l:instance.first_buffer_line - 1)
    let l:linenos = l:line - l:instance.first_buffer_line + 1
    let l:entrynos = l:instance.linenos_to_entrynos[l:linenos-1]
    let l:entrynos_to_linenos = l:instance.entrynos_to_linenos
call s:LOG("s:OnTop l:entrynos=". l:entrynos)

    let l:len = len(l:entrynos_to_linenos)
call s:LOG("s:VimsideActWinLast l:len=". l:len)
    if l:entrynos < l:len - 1
      call s:LeaveEntry(l:entrynos, l:instance)

      let l:entries = l:instance.data.entries
      let l:entries_len = len(l:entries)
      let l:delta_lines = 0
      let l:cnt = l:entrynos
      while l:cnt < l:entries_len
        let l:delta_lines += l:instance.entrynos_to_nos_of_lines[l:cnt]
        let l:cnt += 1
      endwhile

      let l:nos_of_linenos = l:line+l:delta_lines -1
      call cursor(l:nos_of_linenos, 1)

      call s:EnterEntry(l:entries_len-1, l:instance)
      let l:instance.current_line = l:nos_of_linenos
      redraw
call s:LOG("s:VimsideActWinLast l:instance.current_line=". l:instance.current_line)

    endif
  endif

  execute 'silent '. b:return_win_nr.'wincmd w'
let s:buf_change = 1

call histdel(":", "VimsideActWinLast")
echo ""
call s:LOG("g:VimsideActWinLast: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinUp(buffer_nr)
call s:LOG("g:VimsideActWinUp: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnUp()
    return
  endif

  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinUp: instance not found")
    return
  endif

  let l:current_win_nr = bufwinnr(l:current_buffer_nr)
let b:return_win_nr = l:current_win_nr 
  let l:win_nr = bufwinnr(a:buffer_nr)

  let l:linenos_to_entrynos = l:instance.linenos_to_entrynos
  let l:entrynos_to_linenos = l:instance.entrynos_to_linenos
  let l:entrynos_to_nos_of_lines = l:instance.entrynos_to_nos_of_lines

  let l:linenos = l:instance.current_line
  let l:entrynos = l:linenos_to_entrynos[l:linenos-1]

  " let l:len = len(l:instance.data.entries)
  if l:entrynos > 0
let s:buf_change = 0

execute 'silent '. l:win_nr.'wincmd w'
    call s:LeaveEntry(l:entrynos, l:instance)

    let l:new_linenos = l:entrynos_to_linenos[l:entrynos-1] 
    let l:nos_of_linenos = l:entrynos_to_nos_of_lines[l:entrynos-1] 

    " TODO Selection is not Entry
    " call s:SelectEntry(l:entrynos-1, l:instance)

execute 'silent '. l:win_nr.'wincmd w'
    let l:line = line(".") - l:instance.first_buffer_line + 1
    if l:nos_of_linenos == 1
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-1),1)'
    else
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-'. l:nos_of_linenos .'),1)'
    endif

    call s:EnterEntry(l:entrynos-1, l:instance)
redraw
" execute 'silent '. l:current_win_nr.'wincmd w'
execute 'silent '. b:return_win_nr.'wincmd w'


let s:buf_change = 1

    let l:instance.current_line = l:new_linenos
  endif
call histdel(":", "VimsideActWinUp")
echo ""
call s:LOG("g:VimsideActWinUp: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinDown(buffer_nr)
call s:LOG("g:VimsideActWinDown: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnDown()
    return
  endif

  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinDown: instance not found")
    return
  endif

let b:return_win_nr = bufwinnr(l:current_buffer_nr)
  let l:win_nr = bufwinnr(a:buffer_nr)

  let l:linenos_to_entrynos = l:instance.linenos_to_entrynos
  let l:entrynos_to_linenos = l:instance.entrynos_to_linenos
  let l:entrynos_to_nos_of_lines = l:instance.entrynos_to_nos_of_lines

  let l:linenos = l:instance.current_line
  let l:entrynos = l:linenos_to_entrynos[l:linenos-1]
call s:LOG("g:VimsideActWinDown l:linenos=". l:linenos)
call s:LOG("g:VimsideActWinDown l:entrynos=". l:entrynos)

  let l:len = len(l:instance.data.entries)
  if l:entrynos < l:len - 1
let s:buf_change = 0

execute 'silent '. l:win_nr.'wincmd w'
    call s:LeaveEntry(l:entrynos, l:instance)

    let l:new_linenos = l:entrynos_to_linenos[l:entrynos+1] 
    let l:nos_of_linenos = l:entrynos_to_nos_of_lines[l:entrynos] 
call s:LOG("g:VimsideActWinDown l:new_linenos=". l:new_linenos)
call s:LOG("g:VimsideActWinDown l:nos_of_linenos=". l:nos_of_linenos)

    " TODO Selection is not Entry
    " call s:SelectEntry(l:entrynos+1, l:instance)

execute 'silent '. l:win_nr.'wincmd w'
    let l:line = line(".") - l:instance.first_buffer_line + 1
call s:LOG("g:VimsideActWinDown l:line=". l:line)
    if l:nos_of_linenos == 1
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'+1),1)'
    else
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'+'. l:nos_of_linenos .'),1)'
    endif


    call s:EnterEntry(l:entrynos+1, l:instance)
redraw
execute 'silent '. b:return_win_nr.'wincmd w'

let s:buf_change = 1

    let l:instance.current_line = l:new_linenos
  endif
call histdel(":", "VimsideActWinDown")
echo ""
call s:LOG("g:VimsideActWinDown: BOTTOM")
endfunction

function! g:VimsideActWinEnter(buffer_nr)
call s:LOG("g:VimsideActWinEnter: TOP buffer_nr=". a:buffer_nr)
  " If called from ActWin, do nothing
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    return
  endif

  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinEnter: instance not found")
    return
  endif

  execute 'silent '. l:instance.win_nr.'wincmd w'

call histdel(":", "VimsideActWinEnter")
call s:LOG("g:VimsideActWinEnter: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinDelete(buffer_nr)
call s:LOG("g:VimsideActWinDelete: TOP buffer_nr=". a:buffer_nr)
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnDelete()
    return
  endif

  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinDelete: instance not found")
    return
  endif

  let b:return_win_nr = bufwinnr(l:current_buffer_nr)
  let l:win_nr = bufwinnr(a:buffer_nr)

  execute 'silent '. l:win_nr.'wincmd w'
  call s:OnDelete()
  execute 'silent '. b:return_win_nr.'wincmd w'

call histdel(":", "VimsideActWinDelete")
call s:LOG("g:VimsideActWinDelete: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinClose(buffer_nr)
call s:LOG("g:VimsideActWinClose: TOP buffer_nr=". a:buffer_nr)
  let [l:found, l:instance] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinClose: instance not found")
    return
  endif

  let b:return_win_nr = bufwinnr(bufnr("%"))

  execute 'silent '. l:instance.win_nr.'wincmd w'
  call s:Close(l:instance)
  if exists("b:return_win_nr")
    execute 'silent '. b:return_win_nr.'wincmd w'
  else
    execute 'silent '. l:instance.scala_win_nr.'wincmd w'
  endif

call histdel(":", "VimsideActWinClose")
echo ""
call s:LOG("g:VimsideActWinClose: BOTTOM")
endfunction

" ============================================================================
" AutoCmd Functions: {{{1
" ============================================================================

" called after entering or switching to buffer
function! s:BufEnter()
  if s:buf_change
call s:LOG("s:BufEnter: TOP ". bufnr("%"))
    let b:insertmode = &insertmode
    let b:showcmd = &showcmd
    let b:cpo = &cpo
    let b:report = &report
    let b:list = &list
call s:LOG("s:BufEnter: BOTTOM")
  endif
endfunction

" called when switching from buffer to another buffer
function! s:BufLeave()
  if s:buf_change
call s:LOG("s:BufLeave: TOP ".  bufnr("%"))
    if exists("b:insertmode")
      let &insertmode = b:insertmode
      unlet b:insertmode
    endif
    if exists("b:showcmd")
      let &showcmd = b:showcmd
      unlet b:showcmd
    endif
    if exists("b:cpo")
      let &cpo = b:cpo
      unlet b:cpo
    endif
    if exists("b:report")
      let &report = b:report
      unlet b:report
    endif
    if exists("b:list")
      let &list = b:list
      unlet b:list
    endif
call s:LOG("s:BufLeave: BOTTOM")
  endif
endfunction

" called when buffer is displayed in actwin
" when loaded or no longer hidden
function! s:BufWinEnter()
  if s:buf_change
call s:LOG("s:BufWinEnter: buffer_nr=". bufnr("%"))
    let [l:found, l:instance] = s:GetActWin(bufnr("%"))
    if ! l:found
      call s:ERROR("s:BufWinEnter instance not found")
      return
    endif

    call s:EnterCurrentEntry(l:instance)
  endif
endfunction

" called before buffer is removed from actwin
" Note that buffer "%" may not be buffer being unloaded
function! s:BufWinLeave()
  if s:buf_change
" call s:LOG("s:BufWinLeave: buffer_nr=". bufnr("%"))
" call s:LOG("s:BufWinLeave: afile=". expand('<afile>')) 
call s:LOG("s:BufWinLeave: afile nr=". bufnr(expand('<afile>'))) 
    " call s:DisplayDestroy()
  
    let [l:found, l:instance] = s:GetActWin(bufnr(expand('<afile>')))
    if ! l:found
      call s:ERROR("s:BufWinLeave instance not found")
      return
    endif

    call s:LeaveCurrentEntry(l:instance)
  endif
endfunction

" ============================================================================
" Formatter Functions: {{{1
" ============================================================================

function! s:FormatterDefault(lines, entry)
" call s:LOG("s:FormatterDefault: TOP")
  let content = a:entry.content
  if type(content) == type([])
    call extend(a:lines, content)
  else
    call add(a:lines, content)
  endif
" call s:LOG("s:FormatterDefault: BOTTOM")
endfunction

" ============================================================================
" Default Action Functions: {{{1
" ============================================================================

" --------------------------------------------
" Behavior: Do Nothing, Text
" --------------------------------------------

" Set Non-ActWin cursor file and postion but stay in ActWin
function! vimside#actwin#EnterActionDoNothing(entrynos, instance)
call s:LOG("vimside#actwin#EnterActionDoNothing: entrynos=". a:entrynos)
endfunction

" Goto Non-ActWin cursor file and postion
function! vimside#actwin#SelectActionDoNothing(entrynos, instance)
call s:LOG("vimside#actwin#SelectActionDoNothing")
endfunction

" Do Nothing
function! vimside#actwin#LeaveActionDoNothing(entrynos, instance)
call s:LOG("vimside#actwin#LeaveActionDoNothing: entrynos=". a:entrynos)
endfunction

" --------------------------------------------
" Behavior: QuickFix
" --------------------------------------------
" Set Non-ActWin cursor file and postion but stay in ActWin
function! vimside#actwin#EnterActionQuickFix(entrynos, instance)
call s:LOG("vimside#actwin#EnterActionQuickFix: TOP entrynos=". a:entrynos)
  call s:ScalaSetAtEntry(a:entrynos, a:instance)
call s:LOG("vimside#actwin#EnterActionQuickFix: BOTTOM")
endfunction

" Goto Non-ActWin cursor file and postion
function! vimside#actwin#SelectActionQuickFix(entrynos, instance)
call s:LOG("vimside#actwin#SelectActionQuickFix TOP")
  call s:ScalaGoToEntry(a:entrynos, a:instance)
call s:LOG("vimside#actwin#SelectActionQuickFix BOTTOM")
endfunction

" Do Nothing
function! vimside#actwin#LeaveActionQuickFix(entrynos, instance)
call s:LOG("vimside#actwin#LeaveActionQuickFix: TOP entrynos=". a:entrynos)
  call s:RemoveAtEntry(a:entrynos, a:instance)
call s:LOG("vimside#actwin#LeaveActionQuickFix: BOTTOM")
endfunction

" --------------------------------------------
" Behavior: History/Search Command ActWin
" --------------------------------------------

" --------------------------------------------
" Behavior: Type Inspector, Multi-line Structured
" --------------------------------------------

" --------------------------------------------
" Behavior: Type Inspector
" --------------------------------------------


" ============================================================================
" Support Action Function: {{{1
" ============================================================================


" Set Non-ActWin cursor file and postion but stay in ActWin
function! s:ScalaSetAtEntry(entrynos, instance)
let s:buf_change = 0
call s:LOG("s:ScalaSetAtEntry: entrynos=". a:entrynos)
  let [l:found, l:entry] = s:GetEntry(a:entrynos, a:instance)
  if l:found && has_key(l:entry, 'file')
    let l:file = l:entry.file
    let l:bnr = bufnr(l:file)
call s:LOG("s:ScalaSetAtEntry: bnr=". l:bnr)
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:ScalaSetAtEntry: file=". l:file)
call s:LOG("s:ScalaSetAtEntry: win_nr=". l:win_nr)
call s:LOG("s:ScalaSetAtEntry: scala_buffer_nr bufwinnr=". bufwinnr(a:instance.scala_buffer_nr))

    let l:new_file = 0
    if l:win_nr == -1
execute 'silent '. a:instance.scala_win_nr.'wincmd w'
      execute "edit ". l:file
execute 'silent '. bufwinnr(a:instance.win_nr).'wincmd w'
      let l:bnr = bufnr(l:file)
call s:LOG("s:ScalaSetAtEntry: bnr=". l:bnr)
      let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:ScalaSetAtEntry: win_nr=". l:win_nr)
      let l:new_file = 1
    endif

    if l:win_nr > 0
let b:return_win_nr = l:win_nr
      let l:linenos = has_key(l:entry, 'line') ? l:entry.line : 1
      let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
call s:LOG("s:ScalaSetAtEntry: linenos=". l:linenos)
call s:LOG("s:ScalaSetAtEntry: colnos=". l:colnos)
      if l:colnos > 1
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G' . (l:colnos-1) . "l"
      else
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G'
      endif

      if l:new_file 
        call s:CallNewFileHandlers(a:instance, l:file, a:entrynos)
      endif


if s:is_color_column_enabled
  if l:colnos > 0
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
  else
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
  endif
endif

      " execute 'keepjumps silent '. actwin_buffer.'wincmd 2'
execute 'silent '. a:instance.win_nr.'wincmd w'
    endif
  endif
call s:LOG("s:ScalaSetAtEntry: BOTTOM")
let s:buf_change = 1
endfunction

function! s:RemoveAtEntry(entrynos, instance)
let s:buf_change = 0
call s:LOG("s:RemoveAtEntry: entrynos=". a:entrynos)
  let [l:found, l:entry] = s:GetEntry(a:entrynos, a:instance)
  if l:found && has_key(l:entry, 'file')
    let l:file = l:entry.file
    let l:linenos = has_key(l:entry, 'line') ? l:entry.line : 1

  endif
call s:LOG("s:RemoveAtEntry: BOTTOM")
let s:buf_change = 1
endfunction

" Goto Non-ActWin cursor file and postion
function! s:ScalaGoToEntry(entrynos, instance)
call s:LOG("s:ScalaGoToEntry: in Non-ActWin entrynos=". a:entrynos)
  let [l:found, l:entry] = s:GetEntry(a:entrynos, a:instance)
  if l:found && has_key(l:entry, 'file')
    let l:file = l:entry.file
    let l:win_nr = bufwinnr(l:file)
call s:LOG("s:ScalaGoToEntry: win_nr=". l:win_nr)
    if l:win_nr > 0
let b:return_win_nr = l:win_nr
      let l:linenos = has_key(l:entry, 'line') ? l:entry.line : 1
      let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
call s:LOG("s:ScalaGoToEntry: linenos=". l:linenos)
call s:LOG("s:ScalaGoToEntry: colnos=". l:colnos)
      if l:colnos > 1
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G' . l:colnos . "l"
      else
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G'
      endif

if s:is_color_column_enabled
  if l:colnos > 1
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
  else
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
  endif
endif

    endif
  endif
call s:LOG("s:ScalaGoToEntry: BOTTOM")
endfunction

" ============================================================================
" Highlight Patterns: {{{1
" ============================================================================

function! s:GetOption(name)
  let [found, value] = g:vimside.GetOption(a:name)
  if ! found
    throw "Option not found: '". a:name ."'
  endif
  return value
endfunction

if 0 " HIGHLIGHT
function! s:Color_2_Number(color)
  " is it a name
  let rgbtxt = forms#color#util#ConvertName_2_RGB(a:color)
  if rgbtxt == ''
    let nos = forms#color#term#ConvertRGBTxt_2_Int(a:color)
  else
    let nos = forms#color#term#ConvertRGBTxt_2_Int(rgbtxt)
  endif
  return nos
endfunction

function! s:InitGui()
  if &background == 'light' 
    let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-light')

  else " &background == 'dark'
    let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-dark')
  endif
call s:LOG("s:InitGui: selectedColor=". selectedColor) 
  execute "hi VimsideActWin_HL gui=bold guibg=#" . selectedColor
endfunction

function! s:InitCTerm()
  if exists("g:vimside.plugins.forms") && g:vimside.plugins.forms
    if &background == 'light' 
      let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-light')
    else " &background == 'dark'
      let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-dark')
    endif
call s:LOG("s:InitCTerm: selectedColor=". selectedColor) 
    let selectedNumber = s:Color_2_Number(selectedColor)
  else
    if &background == 'light' 
      " TODO: hardcode for now
      let selectedNumber = '87'
    else " &background == 'dark'
      " TODO: hardcode for now
      let selectedNumber = '87'
    endif
  endif
call s:LOG("s:InitCTerm: selectedNumber=". selectedNumber) 
  execute "hi VimsideActWin_HL cterm=bold ctermbg=" . selectedNumber
endfunction

function! s:InitializeHighlight()
  if has("gui_running")
    call s:InitGui()
  else
    call s:InitCTerm()
  endif
endfunction

call s:InitializeHighlight()

endif " HIGHLIGHT

function! s:GetLinesMatchPatterns(line_start, line_end, nos_columns)
  let lnum1 = a:line_start
  let lnum2 = a:line_end
  let endCol = 200

  if a:nos_columns > 0
    let l:nos_columns = a:nos_columns + 1

    if lnum1 == lnum2
      " one lines
      
      let patterns = [ '\%'.lnum1.'l\%<'. l:nos_columns .'c' ]
    elseif lnum1+1 == lnum2
      let pat1 = '\%'.lnum1.'l\%<'. l:nos_columns .'c'
      let pat2 = '\%'.lnum2.'l\%<'. l:nos_columns .'c'
      let patterns = [ pat1, pat2 ]
    else
      " general case
      let patterns = [ ]
      let l:ln = lnum1
      while l:ln <= lnum2
        let pat = '\%'.l:ln.'l\%<'. l:nos_columns .'c'
        call add(patterns, pat)
        let l:ln += 1
      endwhile

    endif

  else
    if lnum1 == lnum2
      " one lines
      " let range = [ '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(endCol+2).'v' ]
      " let patterns = [ '\%'.lnum1.'l', '\%3c' ]
      
      let patterns = [ '\%'.lnum1.'l' ]
    elseif lnum1+1 == lnum2
      " two lines
      " let pat1 = '\%'.lnum1.'l\%>'.(col1+1).'v.*\%<'.(endCol).'v'
      " let pat1 = '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(endCol).'v'
      " let pat2 = '\%'.lnum2.'l\%>'.(1).'v.*\%<'.(endCol).'v'

      let pat1 = '\%'.lnum1.'l'
      let pat2 = '\%'.lnum2.'l'
      let patterns = [ pat1, pat2 ]
    else
      " general case
      let patterns = [ ]
      let l:ln = lnum1
      while l:ln <= lnum2
        let pat = '\%'.l:ln.'l'
        call add(patterns, pat)
        let l:ln += 1
      endwhile

    endif
  endif

call s:LOG("s:GetLinesMatchPatterns: patterns=". string(patterns)) 
  return patterns
endfunction

function! s:HighlightClear(sids)
" call s:LOG("s:HighlightClear: TOP") 
" call s:LOG("s:HighlightClear: clearing sids") 
  for sid in a:sids
" call s:LOG("s:HighlightClear: clear sid=". sid) 
    try
      if matchdelete(sid) == -1
" call s:LOG("s:HighlightClear: failed to clear sid=". sid) 
      endif
    catch /.*/
" call s:LOG("ERROR s:HighlightClear: sid=". sid) 
    endtry
  endfor
" call s:LOG("s:HighlightClear: matches=". string(getmatches())) 
" call s:LOG("s:HighlightClear: BOTTOM") 
endfunction

" returns list of sids
function! s:HighlightDisplay(group, line_start, line_end, nos_columns)
" call s:LOG("s:HighlightDisplay: line_start=". a:line_start .", line_end=". a:line_end) 
  let patterns = s:GetLinesMatchPatterns(a:line_start, a:line_end, a:nos_columns)
  let l:sids = []
  for pattern in patterns
    let sid = matchadd(a:group, pattern)
" call s:LOG("s:HighlightDisplay: sid=". sid) 
    call add(l:sids, sid)
  endfor
  return l:sids
endfunction

" ============================================================================
" Test: {{{1
" ============================================================================

function! vimside#actwin#TestQuickFix()

"   help: {
"     do_show: 0
"     is_open: 0
"     .....
"   }
"   cmd: {
"   }
"   map: {
"   }
"   sign: {
"     category: QuickFix
"     kinds: {
"       kname: {text, textlh, linehl }
"     }
"   }
"     file:
"     line:
"     kind: 'error'
"
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
            \  "This is some help text",
            \  "  Help text line 1",
            \  "  Help text line 2",
            \  "  Help text line 3",
            \  "  Help text line 4",
            \  "  Help text line 5",
            \  "  Help text line 6"
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
              \ "actwin_map_show": "<F2>",
              \ "scala_cmd_show": "<F3>",
              \ "scala_map_show": "<F4>",
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
              \ "is_enable": 0,
              \ "category": "TestWindow",
              \ "abbreviation": "tw",
              \ "toggle": {
                \ "actwin": {
                  \ "map": "ts",
                  \ "cmd": "TS",
                  \ "abbr": "ts"
                \ },
                \ "scala": {
                  \ "map": "ts",
                  \ "cmd": "TS",
                  \ "abbr": "ts"
                \ }
              \ },
              \ "default_kind": "marker",
              \ "kinds": {
                \ "error": {
                  \ "text": "EE",
                  \ "texthl": "Todo",
                  \ "linehl": "Error"
                \ },
                \ "warn": {
                  \ "text": "WW",
                  \ "texthl": "ToDo",
                  \ "linehl": "StatusLine"
                \ },
                \ "info": {
                  \ "text": "II",
                  \ "texthl": "DiffAdd",
                  \ "linehl": "Ignore"
                \ },
                \ "marker": {
                  \ "text": "MM",
                  \ "texthl": "Search",
                  \ "linehl": "Ignore"
                \ }
              \ }
            \ },
            \ "color_line": {
              \ "info": "use sign to note current entry line kind",
              \ "is_enable": 1,
              \ "is_on": 0,
              \ "category": "ColorLine",
              \ "toggle": {
                \ "actwin": {
                  \ "map": "tcl",
                  \ "cmd": "TCL",
                  \ "abbr": "tcl"
                \ },
                \ "scala": {
                  \ "map": "tcl",
                  \ "cmd": "TCL",
                  \ "abbr": "tcl"
                \ }
              \ },
              \ "abbreviation": "cl",
              \ "default_kind": "marker",
              \ "kinds": {
                \ "error": {
                  \ "text": "EE",
                  \ "texthl": "Error",
                  \ "linehl": "Error"
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
              \ "is_enable": 0,
              \ "is_on": 0,
              \ "toggle": {
                \ "actwin": {
                  \ "map": "tcc",
                  \ "cmd": "TCC",
                  \ "abbr": "tcc"
                \ },
                \ "scala": {
                  \ "map": "tcc",
                  \ "cmd": "TCC",
                  \ "abbr": "tcc"
                \ }
              \ },
              \ "colorcolumn": "cterm=reverse"
            \ }
          \ }

  let l:actwin = {
            \ "cursor_line": {
              \ "info": "use cursorline to note current line",
              \ "is_enable": 0,
              \ "is_on": 0,
              \ "highlight": "cterm=bold ctermfg=DarkYellow ctermbg=Cyan",
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
              \ "is_enable": 0,
              \ "is_on": 0,
              \ "is_full": 1,
              \ "nos_columns": 0,
              \ "all_text": 1,
              \ "highlight": "cterm=bold ctermfg=DarkYellow ctermbg=Cyan",
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
              \ "is_enable": 1,
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
                \ "error": {
                  \ "text": "EE"
                \ },
                \ "warn": {
                  \ "linehl": "StatusLine",
                  \ "text": "WW"
                \ },
                \ "info": {
                  \ "texthl": "DiffAdd",
                  \ "text": "II"
                \ },
                \ "marker": {
                  \ "text": "MM"
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
        \ "entries": [
        \  { 'content': "Entry 1 line one",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 1,
          \ "col": 1,
          \ "kind": "error"
          \ },
        \  { 'content': "Entry 2 line two",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 3,
          \ "col": 6,
          \ "kind": "warn"
          \ },
        \  { 'content': [
            \  "Entry 3 line three line 0",
            \  "   Entry 3 line four line 1",
            \  "   Entry 3 line five line 2"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 5,
          \ "col": 7,
          \ "kind": "info"
          \ },
        \  { 'content': "Entry 4 line six",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 7,
          \ "col": 2,
          \ "kind": "error"
          \ },
        \  { 'content': [
            \  "Entry 5 line seven line 0",
            \  "   Entry 5 line eigth line 1",
            \  "   Entry 5 line nine line 2"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 9,
          \ "col": 4,
          \ "kind": "warn"
          \ },
        \  { 'content': [
            \  "Entry 6 line ten"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 10,
          \ "col": 8,
          \ "kind": "info"
          \ },
        \  { 'content': [
            \  "Entry 7 line eleven",
            \  "  Entry 7 line 1"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 11,
          \ "col": 10,
          \ "kind": "error"
          \ },
        \  { 'content': "line thirteen Bar",
          \ "file": "src/main/scala/com/megaannum/Bar.scala",
          \ "line": 12,
          \ "col": 10,
          \ "kind": "warn"
          \ },
        \  { 'content': "line fourteen Bar",
          \ "file": "src/main/scala/com/megaannum/Bar.scala",
          \ "line": 15,
          \ "col": 5,
          \ "kind": "info"
          \ },
        \  { 'content': "line fifteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 15,
          \ "kind": "error"
          \ },
        \  { 'content': "line sixteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 16,
          \ "col": 5,
          \ "kind": "warn"
          \ }
        \ ]
    \ }
  call vimside#actwin#DisplayLocal('testqf', l:data)

endfunction

function! vimside#actwin#TestHelp()
  let l:data = {
        \ "title": "Help Window",
        \ "winname": "Help",
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
            \  "This is some help text",
            \  "  Help text line 1",
            \  "  Help text line 2",
            \  "  Help text line 3",
            \  "  Help text line 4",
            \  "  Help text line 5",
            \  "  Help text line 6"
            \ ],
          \ "kind": "info"
          \ }
        \ ]
    \ }
  call vimside#actwin#DisplayLocal('testhelp', l:data)
endfunction
