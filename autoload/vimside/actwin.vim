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

" let s:LOG = function("vimside#log#log")
" let s:ERROR = function("vimside#log#error")

function! s:LOG(msg)
  execute "redir >> ". "AW_LOG"
  silent echo "INFO: ". a:msg
  execute "redir END"
endfunction

"TODO
" remove entry, list of entries
" help: 
" active row/column highlight 
" range of lines
"

let s:is_colorline_enabled = 1
let s:is_colorcolumn_enabled = 1
let s:is_sign_enabled = 1

let s:split_mode_default = "new"
let s:split_size_default = "10"
let s:split_below_default = 1
let s:split_right_default = 0
let s:winname_default="ActWin"

" actwin {
"   is_global: 0,
"   source_buffer_nr: source_buffer_nr
"   source_buffer_name: source_buffer_name
"   uid: unique id
"   tag: tag
"   first_buffer_line: first_buffer_line
"   current_line: current_line
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
"   window: {
"     split_size: "10"
"     split_mode: "new"
"     split_below: 1
"     split_right: 0
"   }
"   builtincmd: {
"   }
"   usercmd: {
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
"     text: [lines] and/or line
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
" source_buffer_nr -> tags 
"    tags 1-1 target_buffer_nr
"
let s:locals = {}

" TODO maps from unique id -> actwin
let s:uid_to_actwin = {}

" maps actwin buffer number to actwin
let s:actwin_buffer_nr_to_actwin = {}


let s:next_uid = 0
function! s:NextUID()
  let l:uid = s:next_uid
  let s:next_uid += 1
  return l:uid
endfunction

function! s:Initialize(actwin)
call s:LOG("Initialize TOP")

  call s:MakeKeyMappings(a:actwin)
  call s:MakeAutoCmds(a:actwin)
  call s:MakeUserCommands(a:actwin)
  call s:MakeOverrideCommands(a:actwin)

  " TODO is this needed ... only when using the same window
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

  setlocal nonumber
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal cursorline
  setlocal nospell
  setlocal nobuflisted
call s:LOG("Initialize BOTTOM")
endfunction

function! s:MakeKeyMappings(actwin)
  " These are created as "buffer" maps so they disappear
  " when the buffer is deleted.
  nnoremap <script> <silent> <buffer> <F1> :call <SID>ToggleHelp()<CR>
  nnoremap <script> <silent> <buffer> <TAB> :call <SID>ForwardAtion()<CR>
  nnoremap <script> <silent> <buffer> <C-n> :call <SID>ForwardAtion()<CR>
  nnoremap <script> <silent> <buffer> <S-TAB> :call <SID>BackwardAtion()<CR>
  nnoremap <script> <silent> <buffer> <C-p> :call <SID>BackwardAtion()<CR>

  nnoremap <script> <silent> <buffer> <2-LeftMouse> :call <SID>OnSelect()<CR>
  nnoremap <script> <silent> <buffer> <CR> :call <SID>OnSelect()<CR>

  " nnoremap <script> <buffer> <LeftMouse> <LeftMouse> :echo v:mouse_lnum<CR>
  nnoremap <script> <silent> <buffer> <LeftMouse> <LeftMouse> :call <SID>OnEnterMouse()<CR>
  nnoremap <script> <silent> <buffer> <Down> :call <SID>OnDown()<CR>
  nnoremap <script> <silent> <buffer> j :call <SID>OnDown()<CR>
  nnoremap <script> <silent> <buffer> <Up> :call <SID>OnUp()<CR>
  nnoremap <script> <silent> <buffer> k :call <SID>OnUp()<CR>

  nnoremap <script> <silent> <buffer> q :call vimside#actwin#Close()<CR>
  nnoremap <script> <silent> <buffer> :q :call vimside#actwin#Close()<CR>
endfunction

function! s:MakeAutoCmds(actwin)
  augroup ACT_WIN_AUTOCMD
    autocmd!
    autocmd BufEnter <buffer> call s:BufEnter()
    autocmd BufLeave <buffer> call s:BufLeave()
  augroup END
endfunction

function! s:CloseAutoCmds(actwin)
  augroup ACT_WIN_AUTOCMD
    autocmd!
  augroup END
endfunction

function! s:MakeUserCommands(actwin)
  if has_key(a:actwin.data, 'usercmd')
    let l:usercmd = a:actwin.data.usercmd
    let l:buffer_nr =  a:actwin.buffer_nr

    if has_key(l:usercmd,'up')
      execute ":nnoremap <silent> <Leader>". l:usercmd.up ." :call g:UserUp(". l:buffer_nr .")<CR>"
    endif

    if has_key(l:usercmd,'down')
      execute ":nnoremap <silent> <Leader>". l:usercmd.down ." :call g:UserDown(". l:buffer_nr .")<CR>"
    endif

    if has_key(l:usercmd,'close')
      execute ":nnoremap <silent> <Leader>". l:usercmd.close ." :call g:UserClose(". l:buffer_nr .")<CR>"
    endif
  endif
endfunction

function! s:ClearUserCommands(actwin)
  if has_key(a:actwin.data, 'usercmd')
    let l:usercmd = a:actwin.data.usercmd

    if has_key(l:usercmd,'up')
      execute "nunmap <silent> <Leader>". l:usercmd.up
    endif

    if has_key(l:usercmd,'down')
      execute "nunmap <silent> <Leader>". l:usercmd.down
    endif

    if has_key(l:usercmd,'close')
      execute "nunmap <silent> <Leader>ccl". l:usercmd.close
    endif
  endif
endfunction

function! s:MakeOverrideCommands(actwin)
  " :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
  if has_key(a:actwin.data, 'builtincmd')
    let l:builtincmd = a:actwin.data.builtincmd
    let l:buffer_nr =  a:actwin.buffer_nr

    if has_key(l:builtincmd,'cp')
      execute "cabbrev cp <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call g:UserUp(". l:buffer_nr .")' : 'cp')<CR>"
    endif

    if has_key(l:builtincmd,'cn')
      execute "cabbrev cn <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call g:UserDown(". l:buffer_nr .")' : 'cn')<CR>"
    endif

    if has_key(l:builtincmd,'ccl')
      execute "cabbrev ccl <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call g:UserClose(". l:buffer_nr .")' : 'ccl')<CR>"
    endif

  endif
endfunction

function! s:ClearOverrideCommands(actwin)
  " :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
  " cunabbrev e
  if has_key(a:actwin.data, 'builtincmd')
    let l:builtincmd = a:actwin.data.builtincmd

    if has_key(l:builtincmd,'cp')
      execute "cunabbrev cp"
    endif

    if has_key(l:builtincmd,'cn')
      execute "cunabbrev cn"
    endif

    if has_key(l:builtincmd,'ccl')
      execute "cunabbrev ccl"
    endif
  endif
endfunction

" return [0, _] or [1, actwin]
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


function! vimside#actwin#DisplayLocal(tag, data)
call s:LOG("DisplayLocal TOP")
  let l:data = deepcopy(a:data)
  let l:source_buffer_name = bufname("%")
  let l:source_buffer_nr = bufnr("%")

  if has_key(s:locals, l:source_buffer_nr)
    let l:bnr_dic = s:locals[l:source_buffer_nr]
    if has_key(l:bnr_dic, a:tag)
      let l:action = s:GetAction(l:data)
      if l:action == 'm'
        " modify
        let l:actwin = l:bnr_dic[a:tag]
      elseif l:action == 'a'
        " append
        let l:actwin = l:bnr_dic[a:tag]
      elseif l:action == 'r'
        " replace
        let l:actwin = l:bnr_dic[a:tag]
      else
        " create
        let l:uid = s:NextUID()
        let l:actwin = {
            \ "is_global": 0,
            \ "source_buffer_nr": l:source_buffer_nr,
            \ "source_buffer_name": l:source_buffer_name,
            \ "tag": a:tag,
            \ "uid": l:uid,
            \ "data": l:data
          \ }
        let l:bnr_dic[a:tag] = l:actwin

        let l:action = 'c'
      endif

    else
      let l:uid = s:NextUID()
      let l:actwin = {
          \ "is_global": 0,
          \ "source_buffer_nr": l:source_buffer_nr,
          \ "source_buffer_name": l:source_buffer_name,
          \ "tag": a:tag,
          \ "uid": l:uid,
          \ "data": l:data
        \ }
      let l:bnr_dic[a:tag] = l:actwin

      let l:action = 'c'
    endif

  else
    let l:uid = s:NextUID()
    let l:actwin = {
        \ "is_global": 0,
        \ "source_buffer_nr": l:source_buffer_nr,
        \ "source_buffer_name": l:source_buffer_name,
        \ "tag": a:tag,
        \ "uid": l:uid,
        \ "data": l:data
      \ }
    let l:bnr_dic = {}
    let l:bnr_dic[a:tag] = l:actwin
    let s:locals[l:source_buffer_nr] = l:bnr_dic

    let l:action = 'c'
  endif
call s:LOG("DisplayLocal action=". l:action)

  " make adjustments, modification and replacements
  if l:action == 'c'
    " save actwin by its uid
    let s:uid_to_actwin[l:actwin.uid] = l:actwin
    " create = new display
    call s:Adjust(l:actwin.data)
  elseif l:action == 'm'
    " modify = change non-entries
    call s:Modify(l:actwin.data, l:data)
  elseif l:action == 'r'
    " replace entries
    call s:ReplaceEntries(l:actwin.data, l:data)
  else
    " append entries
    call s:AppendEntries(l:actwin.data, l:data)
  endif

  if l:action == 'c'
    let l:window =  l:data.window
    let l:winname =  l:data.winname

    " save current values
    let l:split_below = &splitbelow
    let &splitbelow = l:window.split_below

call s:LOG("DisplayLocal split")
    let l:split_right = &splitright
    let &splitright = l:window.split_right

    let l:split_mode = l:window.split_mode
    let l:split_size = l:window.split_size

    " do split mode
    if l:split_mode != ""
      " exe 'keepalt '. l:split_mode
call s:LOG("DisplayLocal split=" .l:split_size . l:split_mode .' '. l:winname)
      execute l:split_size . l:split_mode .' '. l:winname
    endif

    " restore values
    let &splitbelow = l:split_below
    let &splitright = l:split_right

    " save the buffer number
    let l:actwin.buffer_nr = bufnr(bufname("%"))
    let b:buffer_nr = l:actwin.buffer_nr
    let s:actwin_buffer_nr_to_actwin[l:actwin.buffer_nr] = l:actwin

let b:buf_change = 0
    call s:Initialize(l:actwin)
  endif

  call s:LoadDisplay(l:actwin)
if s:is_sign_enabled
  call s:DefineSigns(l:actwin)
  call s:WriteSigns(l:actwin)
endif

call s:LOG("Display actwin_buffer=". l:actwin.buffer_nr)

  call s:SetAtEntry(1, l:actwin)

let b:buf_change = 1

call s:LOG("DisplayLocal BOTTOM")
endfunction

if 0 " GLOBAL
function! vimside#actwin#DisplayGlobal(type, data)
  let l:data = deepcopy(a:data)
  let l:source_buffer_name = bufname("%")
  let l:source_buffer_nr = bufnr("%")

  if has_key(s:globals, a:type)
    let l:action = s:GetAction(l:data)
    " not modify replace or append
    if l:action == 'm' || l:action == 'r' || l:action == 'a'
      let l:actwin = s:globals[a:type]
    else
      let l:uid = s:NextUID()
      let l:actwin = {
          \ "is_global": 1,
          \ "source_buffer_nr": l:source_buffer_nr,
          \ "source_buffer_name": l:source_buffer_name,
          \ "type": a:type,
          \ "uid": l:uid,
          \ "data": l:data
        \ }
      let s:globals[a:type] = l:actwin

      let l:action = 'c'
    endif
  else
    let l:uid = s:NextUID()
    let l:actwin = {
        \ "is_global": 1,
        \ "source_buffer_nr": l:source_buffer_nr,
        \ "source_buffer_name": l:source_buffer_name,
        \ "type": a:type,
        \ "uid": l:uid,
        \ "data": l:data
      \ }
    let s:globals[a:type] = l:actwin

    let l:action = 'c'
  endif
call s:LOG("DisplayGlobal action=". l:action)

  " make adjustments, modification and replacements
  if l:action == 'c'
    " save actwin by its uid
    let s:uid_to_actwin[l:actwin.uid] = l:actwin
    " create = new display
    call s:Adjust(l:actwin.data)
  elseif l:action == 'm'
    " modify = change non-entries
    call s:Modify(l:actwin.data, l:data)
  elseif l:action == 'r'
    " replace entries
    call s:ReplaceEntries(l:actwin.data, l:data)
  else
    " append entries
    call s:AppendEntries(l:actwin.data, l:data)
  endif








  call s:AdjustInput()

  if s:running == 0
    let s:original_buffer_name = bufname("%")
    let s:original_buffer_nr = bufnr("%")

    let s:_splitbelow = &splitbelow
    let &splitbelow = 1

    " do split mode
    if l:split_mode != ""
      " exe 'keepalt '. l:split_mode
      let l:winname = has_key(s:dic, 'winname') ? s:dic.winname : s:winname_default
      execute s:split_size . l:split_mode .' '. l:winname
    endif
  endif


  let s:actwin_buffer = bufnr(bufname("%"))

  " only does something it s:running == 0
  call s:Initialize()

  call s:LoadDisplay()
  call s:DefineSigns()
  call s:WriteSigns()

call s:LOG("Display s:actwin_buffer=". s:actwin_buffer)

  " execute ':sign place 2 line=1 name=aw buffer='. s:actwin_buffer
  call s:SetAtEntry(1, l:actwin)

call s:LOG("Display BOTTOM")
endfunction
endif " GLOBAL

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


" create = new display
function! s:Adjust(data)
call s:LOG("Adjust  TOP")
  if ! has_key(a:data, 'winname')
    let a:data['winname'] = s:winname_default
  endif
  if ! has_key(a:data, 'window')
    let a:data['window'] = {
      \ "split_size": s:split_size_default,
      \ "split_mode": s:split_mode_default,
      \ "split_below": s:split_below_default,
      \ "split_right": s:split_right_default 
      \ }
  else
    if ! has_key(a:data.window, 'split_size')
      let a:data.window['split_size'] = s:split_size_default
    endif
    if ! has_key(a:data.window, 'split_mode')
      let a:data.window['split_mode'] = s:split_mode_default
    endif
    if ! has_key(a:data.window, 'split_below')
      let a:data.window['split_below'] = s:split_below_default
    endif
    if ! has_key(a:data.window, 'split_right')
      let a:data.window['split_right'] = s:split_right_default
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
      \ "enter": function("s:EnterActionDoNothing"),
      \ "select": function("s:SelectActionDoNothing"),
      \ "leave": function("s:LeaveActionDoNothing")
      \ }
  else
    if ! has_key(a:data.actions, 'enter')
      let a:data.actions['enter'] = function("s:EnterActionDoNothing")
    endif
    if ! has_key(a:data.actions, 'select')
      let a:data.actions['select'] = function("s:SelectActionDoNothing")
    endif
    if ! has_key(a:data.actions, 'leave')
      let a:data.actions['leave'] = function("s:LeaveActionDoNothing")
    endif
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
  if has_key(a:org_data, 'sign') && has_key(a:new_data, 'sign')
  elseif has_key(a:org_data, 'sign') 
  elseif has_key(a:new_data, 'sign') 
    " register sign
    let l:sign = a:new_data.sign
    if ! vimside#sign#HasCategory(l:sign.category)
      vimside#sign#AddCategory(l:sign.category, l:sign)
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
      \ "enter": function("s:EnterActionDoNothing"),
      \ "select": function("s:SelectActionDoNothing"),
      \ "leave": function("s:LeaveActionDoNothing")
      \ }
  else
    if ! has_key(s:dic.actions, 'enter')
      let s:dic.actions['enter'] = function("s:EnterActionDoNothing")
    endif
    if ! has_key(s:dic.actions, 'select')
      let s:dic.actions['select'] = function("s:SelectActionDoNothing")
    endif
    if ! has_key(s:dic.actions, 'leave')
      let s:dic.actions['leave'] = function("s:LeaveActionDoNothing")
    endif
  endif
endfunction

function! s:LoadDisplay(actwin)
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap

  execute "1,$d"

  " call s:SetupSyntax()
  call s:BuildDisplay(a:actwin)
  call cursor(a:actwin.first_buffer_line, 1)
  let a:actwin.current_line = a:actwin.first_buffer_line

 setlocal nomodifiable
endfunction

" return [lines...]
function! s:CreateHelp(actwin)
  let l:help = a:actwin.data.help

  if l:help.do_show
    let help_lines = []
    if l:help.is_open
      call add(help_lines, s:dic.title )
      call add(help_lines, "-------------------")
      call add(help_lines, "<F1>    : toggle help")
      call add(help_lines, "<CR>    : inspect type")
      call add(help_lines, "<TAB>   : next type")
      call add(help_lines, "<C-n>   : next type")
      call add(help_lines, "<S-TAB> : previous type (may not work)")
      call add(help_lines, "<C-p>   : previous type")
      call add(help_lines, "q       : quit")
    else
      call add(help_lines, "Press <F1> for Help")
    endif
    
    let a:actwin.first_buffer_line = len(help_lines) + 1
    return help_lines
  else
    let a:actwin.first_buffer_line = 1
    return []
  endif
endfunction

function! s:BuildDisplay(actwin)
  call setline(1, s:CreateHelp(a:actwin))

  let lines = s:GetLines(a:actwin)
  call setline(a:actwin.first_buffer_line, lines)
endfunction

" ============================================================================
" Sign {{{1
" ============================================================================

function! s:DefineSigns(actwin)
  let l:data = a:actwin.data
  if has_key(l:data, 'sign')
    let l:sign = l:data.sign
    let l:category = l:sign.category
    if has_key(l:sign, 'kinds') && ! vimside#sign#HasCategory(l:category)
      call vimside#sign#AddCategory(l:category, l:sign)
    endif
  endif
endfunction

function! s:WriteSigns(actwin)
"     file:
"     line:
"     sign: kind
  let l:data = a:actwin.data
  if has_key(l:data, 'sign')
    let l:sign = l:data.sign
    let l:category = l:sign.category
    for entry in l:data.entries
      let l:file = entry.file
      let l:line = entry.line
      let l:kind = entry.kind
      call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
    endfor
  endif
endfunction

function! s:ClearSigns(actwin)
  let l:data = a:actwin.data
  if has_key(l:data, 'sign')
    let l:sign = l:data.sign
    let l:category = l:sign.category
    call vimside#sign#ClearCategory(l:category)
  endif
endfunction

" ============================================================================
" Util {{{1
" ============================================================================

" return [line, ...]
function! s:GetLines(actwin)
  let l:lines = []
  for entry in a:actwin.data.entries
    let l:text = entry.text
    call add(l:lines, l:text)
  endfor

  return l:lines
endfunction

" return [found, line]
function! s:GetLine(pos, actwin)
  if a:pos < 0
    return [0, {}]
  else
    let l:entries = a:actwin.data.entries
    if a:pos < len(l:entries)
      return [1, l:entries[a:pos]]
    else
      return [0, {}]
    endif
endfunction

" ============================================================================
" Close {{{1
" ============================================================================

if 0 " CLOSE
function! s:Close()
call s:LOG("s:Close")
  call vimside#actwin#Close()
endfunction
endif " CLOSE

" TODO how to close from a different buffer???
function! vimside#actwin#Close()
call s:LOG("vimside#actwin#Close TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
call s:LOG("vimside#actwin#Close NOT FOUND BOTTOM")
    return
  endif
  call s:Close(l:actwin)
endfunction

function! s:Close(actwin)
  let l:actwin = a:actwin
  call s:CloseAutoCmds(l:actwin)
  call s:BufLeave()

  " If we needed to split the main window, close the split one.
  if l:actwin.data.window.split_mode != ""
    exec "wincmd c"
  endif

  " call s:CleanUp(l:actwin)

  call s:ClearUserCommands(l:actwin)
  call s:ClearOverrideCommands(l:actwin)

  exec "keepjumps silent b ". l:actwin.source_buffer_name
  execute 'silent set colorcolumn='

if s:is_sign_enabled
  call s:ClearSigns(l:actwin)
endif

  " Clear any messages.
  echo ""

  unlet s:actwin_buffer_nr_to_actwin[l:actwin.buffer_nr]
call s:LOG("Close BOTTOM")
endfunction

if 0 " XXXXX
function!  s:CleanUp(actwin)
  if exists("b:insertmode")
    let &insertmode = b:insertmode
  endif

  if exists("b:showcmd")
    let &showcmd = b:showcmd
  endif

  if exists("b:cpo")
    let &cpo = b:cpo
  endif

  if exists("b:report")
    let &report = b:report
  endif

  if exists("b:list")
    let &list = b:list
  endif

endfunction
endif " XXXXX

" ============================================================================
" KeyMappings: {{{1
" ============================================================================

function! s:ToggleHelp()
call s:LOG("ToggleHelp TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
call s:LOG("ToggleHelp NOT FOUND BOTTOM")
    return
  endif

  let l:help = l:actwin.help

  if l:help.do_show
    let l:help.is_open = !l:help.is_open

    setlocal modifiable

    " Save position.
    normal! ma
    
    " Remove existing help
    if (l:actwin.first_buffer_line > 1)
      exec "keepjumps 1,".(l:actwin.first_buffer_line - 1) "d _"
    endif
    
    call append(0, s:CreateHelp(l:actwin))

    silent! normal! g`a
    delmarks a

    setlocal nomodifiable
  endif
call s:LOG("ToggleHelp BOTTOM")
endfunction

function! s:Enter(linenos, actwin)
  call a:actwin.data.actions.enter(a:linenos, a:actwin)
endfunction

function! s:Select(linenos, actwin)
  call a:actwin.data.actions.select(a:linenos, a:actwin)
endfunction

function! s:Leave(linenos, actwin)
  call a:actwin.data.actions.leave(a:linenos, a:actwin)
endfunction


function! s:OnEnterMouse()
call s:LOG("s:OnEnterMouse: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
call s:LOG("s:OnEnterMouse NOT FOUND BOTTOM")
    return
  endif

  let l:current_line = l:actwin.current_line
  let l:linenos = line(".")
"call s:LOG("s:OnEnterMouse l:current_line=". l:current_line)
"call s:LOG("s:OnEnterMouse l:linenos=". l:linenos)
  if l:linenos != l:current_line
    call s:Leave(l:current_line, l:actwin)
    call s:Enter(l:linenos, l:actwin)
    let l:actwin.current_line = l:linenos
  endif
call s:LOG("s:OnEnterMouse: BOTTOM")
endfunction

function! s:OnSelect()
call s:LOG("s:OnSelect: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
call s:LOG("s:OnSelect NOT FOUND BOTTOM")
    return
  endif

  let l:linenos = line(".")
  call s:Select(l:linenos, l:actwin)
  let l:actwin.current_line = l:linenos
call s:LOG("s:OnSelect: BOTTOM")
endfunction

function! s:OnUp()
call s:LOG("s:OnUp: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
call s:LOG("s:OnUp NOT FOUND BOTTOM")
    return
  endif

  let l:linenos = line(".")
  if l:linenos > 1
    call s:Leave(l:linenos, l:actwin)
    call feedkeys('k', 'n')
    call s:Enter(l:linenos-1, l:actwin)
    let l:actwin.current_line = l:linenos-1
  endif
call s:LOG("s:OnUp: BOTTOM")
endfunction

function! s:OnDown()
call s:LOG("s:OnDown: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
call s:LOG("s:OnDown NOT FOUND BOTTOM")
    return
  endif

  let l:linenos = line(".")
  let l:len = len(l:actwin.data.entries)
  if l:linenos < l:len
    call s:Leave(l:linenos, l:actwin)
    call feedkeys('j', 'n')
    call s:Enter(l:linenos+1, l:actwin)
    let l:actwin.current_line = l:linenos+1
  endif
call s:LOG("s:OnDown: BOTTOM")
endfunction

" ============================================================================
" User commands: {{{1
" ============================================================================

function! g:UserUp(buffer_nr)
call s:LOG("g:UserUp: TOP")
  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
call s:LOG("g:UserUp NOT FOUND BOTTOM")
    return
  endif

  let l:linenos = l:actwin.current_line
  let l:len = len(l:actwin.data.entries)
  if l:linenos < l:len
    call s:Leave(l:linenos, l:actwin)
    call s:Select(l:linenos-1, l:actwin)
    let l:actwin.current_line = l:linenos-1
  endif
echo ""
call s:LOG("g:UserUp: BOTTOM")
endfunction

function! g:UserDown(buffer_nr)
call s:LOG("g:UserDown: TOP")
  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
call s:LOG("g:UserDown NOT FOUND BOTTOM")
    return
  endif

  let l:linenos = l:actwin.current_line
  let l:len = len(l:actwin.data.entries)
  if l:linenos < l:len
    call s:Leave(l:linenos, l:actwin)
    call s:Select(l:linenos+1, l:actwin)
    let l:actwin.current_line = l:linenos+1
  endif
echo ""
call s:LOG("g:UserDown: BOTTOM")
endfunction

function! g:UserClose(buffer_nr)
call s:LOG("g:UserClose: TOP")
  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
call s:LOG("g:UserClose NOT FOUND BOTTOM")
    return
  endif

  call s:Close(l:actwin)

echo ""
call s:LOG("g:UserClose: BOTTOM")
endfunction

" ============================================================================
" AutoCmd functions: {{{1
" ============================================================================

function! s:BufEnter()
  if b:buf_change
call s:LOG("s:BufEnter: TOP")
    let b:insertmode = &insertmode
    let b:showcmd = &showcmd
    let b:cpo = &cpo
    let b:report = &report
    let b:list = &list
call s:LOG("s:BufEnter: BOTTOM")
  endif
endfunction

function! s:BufLeave()
  if b:buf_change
call s:LOG("s:BufLeave: TOP")
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

" ============================================================================
" Default Action Functions: {{{1
" ============================================================================

" --------------------------------------------
" Behavior: Do Nothing, Text
" --------------------------------------------

" Set Non-ActWin cursor file and postion but stay in ActWin
function! s:EnterActionDoNothing(linenos, actwin)
  call s:LOG("s:EnterActionDoNothing: linenos=". a:linenos)
endfunction

" Goto Non-ActWin cursor file and postion
function! s:SelectActionDoNothing(linenos, actwin)
  call s:LOG("s:SelectActionDoNothing")
endfunction

" Do Nothing
function! s:LeaveActionDoNothing(linenos, actwin)
  call s:LOG("s:LeaveActionDoNothing: linenos=". a:linenos)
endfunction

" --------------------------------------------
" Behavior: QuickFix
" --------------------------------------------
" Set Non-ActWin cursor file and postion but stay in ActWin
function! s:EnterActionQuickFix(linenos, actwin)
  call s:LOG("s:EnterActionQuickFix: linenos=". a:linenos)
  call s:SetAtEntry(a:linenos, a:actwin)
endfunction

" Goto Non-ActWin cursor file and postion
function! s:SelectActionQuickFix(linenos, actwin)
  call s:LOG("s:SelectActionQuickFix")
  call s:GoToEntry(a:linenos, a:actwin)
endfunction

" Do Nothing
function! s:LeaveActionQuickFix(linenos, actwin)
  call s:LOG("s:LeaveActionQuickFix: linenos=". a:linenos)
  call s:RemoveAtEntry(a:linenos, a:actwin)
endfunction

" --------------------------------------------
" Behavior: History/Search Command Window
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
function! s:SetAtEntry(entrynos, actwin)
let b:buf_change = 0
call s:LOG("s:SetAtEntry: entrynos=". a:entrynos)
  let [l:found, l:line] = s:GetLine(a:entrynos - 1, a:actwin)
  if l:found && has_key(l:line, 'file')
    let l:file = l:line.file
    let l:winnr = bufwinnr(l:file)
call s:LOG("s:SetAtEntry: winnr=". l:winnr)
    if l:winnr > 0
      let l:linenos = has_key(l:line, 'line') ? l:line.line : 1
      let l:colnos = has_key(l:line, 'col') ? l:line.col : -1
call s:LOG("s:SetAtEntry: linenos=". l:linenos)
call s:LOG("s:SetAtEntry: colnos=". l:colnos)
      " execute 'keepjumps silent '. l:winnr.'wincmd w | :normal '. l:linenos .'G' . l:colnos . " "
      if l:colnos > 1
        execute 'silent '. l:winnr.'wincmd w | :normal '. l:linenos .'G' . l:colnos . "l"
      else
        execute 'silent '. l:winnr.'wincmd w | :normal '. l:linenos .'G'
      endif
if s:is_colorline_enabled
  let l:kind = l:line.kind
  let l:category = a:actwin.data.sign.category
  call  vimside#sign#ChangeKindFile(l:linenos, l:file, l:category, 'marker')
endif
if s:is_colorcolumn_enabled
  if l:colnos > 0
    execute 'silent '. l:winnr.'wincmd w | :set colorcolumn='. l:colnos
  else
    execute 'silent '. l:winnr.'wincmd w | :set colorcolumn='
  endif
endif

      " execute 'keepjumps silent '. actwin_buffer.'wincmd 2'
      wincmd p
    endif
  endif
call s:LOG("s:SetAtEntry: BOTTOM")
let b:buf_change = 1
endfunction

function! s:RemoveAtEntry(entrynos, actwin)
let b:buf_change = 0
call s:LOG("s:RemoveAtEntry: entrynos=". a:entrynos)
  let [l:found, l:line] = s:GetLine(a:entrynos - 1, a:actwin)
  if l:found && has_key(l:line, 'file')
    let l:file = l:line.file
    let l:linenos = has_key(l:line, 'line') ? l:line.line : 1
if s:is_colorline_enabled
  let l:kind = l:line.kind
  let l:category = a:actwin.data.sign.category
  call vimside#sign#ChangeKindFile(l:linenos, l:file, l:category, l:kind)
endif
  endif
call s:LOG("s:RemoveAtEntry: BOTTOM")
let b:buf_change = 1
endfunction

" Goto Non-ActWin cursor file and postion
function! s:GoToEntry(entrynos, actwin)
call s:LOG("s:GoToEntry: entrynos=". a:entrynos)
  let [l:found, l:line] = s:GetLine(a:entrynos - 1, a:actwin)
  if l:found && has_key(l:line, 'file')
    let l:file = l:line.file
    let l:winnr = bufwinnr(l:file)
call s:LOG("s:GoToEntry: winnr=". l:winnr)
    if l:winnr > 0
      let l:linenos = has_key(l:line, 'line') ? l:line.line : 1
      let l:colnos = has_key(l:line, 'col') ? l:line.col : -1
call s:LOG("s:GoToEntry: linenos=". l:linenos)
call s:LOG("s:GoToEntry: colnos=". l:colnos)
      " execute 'keepjumps silent '. l:winnr.'wincmd w | :normal '. l:linenos .'G' . l:colnos . " "
      if l:colnos > 1
        execute 'silent '. l:winnr.'wincmd w | :normal '. l:linenos .'G' . l:colnos . "l"
      else
        execute 'silent '. l:winnr.'wincmd w | :normal '. l:linenos .'G'
      endif
if s:is_colorcolumn_enabled
  if l:colnos > 1
    execute 'silent '. l:winnr.'wincmd w | :set colorcolumn='. l:colnos
  else
    execute 'silent '. l:winnr.'wincmd w | :set colorcolumn='
  endif
endif
    endif
  endif
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
"   window: {
"     split_size: "10"
"     split_mode: "new"
"     split_below: 1
"     split_right: 0
"   }
"   builtincmd: {
"   }
"   usercmd: {
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
  let l:data = {
        \ "title": "Test Window",
        \ "winname": "Test",
        \ "builtincmd": {
          \ "cp": "cp",
          \ "cn": "cn",
          \ "ccl": "ccl"
        \ },
        \ "usercmd": {
          \ "up": "cp",
          \ "down": "cn",
          \ "close": "ccl"
        \ },
        \ "sign": {
          \ "category": "TestWindow",
          \ "abbreviation": "tw",
          \ "toggle": "tw",
          \ "kinds": {
            \ "error": {
              \ "text": "EE",
              \ "texthl": "Todo",
              \ "linehl": "Error",
            \ },
            \ "warn": {
              \ "text": "WW",
              \ "texthl": "ToDo",
              \ "linehl": "StatusLine",
            \ },
            \ "info": {
              \ "text": "II",
              \ "texthl": "DiffAdd",
              \ "linehl": "Ignore",
            \ },
            \ "marker": {
              \ "text": "MM",
              \ "texthl": "Search",
              \ "linehl": "Ignore",
            \ }
          \ }
        \ },
        \ "actions": {
          \ "enter": function("s:EnterActionQuickFix"),
          \ "select": function("s:SelectActionQuickFix"),
          \ "leave": function("s:LeaveActionQuickFix")
        \ },
        \ "entries": [
        \  { 'text': "line one",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 1,
          \ "col": 1,
          \ "kind": "error"
          \ },
        \  { 'text': "line three",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 3,
          \ "col": 6,
          \ "kind": "warn"
          \ },
        \  { 'text': "line five",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 5,
          \ "col": 7,
          \ "kind": "info"
          \ },
        \  { 'text': "line seven",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 7,
          \ "col": 2,
          \ "kind": "error"
          \ },
        \  { 'text': "line nine",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 9,
          \ "col": 4,
          \ "kind": "warn"
          \ },
        \  { 'text': "line ten",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 10,
          \ "col": 8,
          \ "kind": "info"
          \ },
        \  { 'text': "line eleven",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 11,
          \ "col": 10,
          \ "kind": "error"
          \ },
        \  { 'text': "line thirteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 13,
          \ "kind": "warn"
          \ },
        \  { 'text': "line fourteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 14,
          \ "kind": "info"
          \ },
        \  { 'text': "line fifteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 15,
          \ "kind": "error"
          \ },
        \  { 'text': "line sixteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 16,
          \ "kind": "warn"
          \ }
        \ ]
    \ }
  call vimside#actwin#DisplayLocal('test', l:data)

endfunction
