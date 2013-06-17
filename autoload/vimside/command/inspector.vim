" ============================================================================
" inspector.vim
"
" File:          inspector.vim
" Summary:       inspect type at point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2013
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:start_time = []

" Options
" let s:open_close_indicator = 0
" let s:member_single_line = 1
let s:help_show = 1
let s:help_open = 0

" { page, object, [line, col]}
let s:history_pos = -1
let s:history_list = []

let g:type_inspector_config = {}

let s:split_mode = "new"
let s:current_buffer = ""
let s:first_buffe_lLine = 1

let g:typeInspectorSplitBelow = &splitbelow
let g:typeInspectorSplitRight = &splitright

" s:KeyMappings called from s:Initialize
let s:done_key_mappings = 0

" s:Initialize  
" s:Cleanup
let s:running = 0


" SetupSyntax {{{2
" call by s:loadDisplay()
function! s:SetupSyntax()
  if has("syntax")
    " entitieswords with different colors:
    "   class & object & trait 
    "   package path 
    "   class name at end of package path & class name 
    "   doc
    "   method names

    syn match TI_Name0 " [^ \.]\+$"

    syn keyword TI_COMPANION companion
    syn keyword TI_DOC doc 
    " syn keyword TI_Object object nextgroup=TI_ClassName skipwhite
    "syn keyword TI_Trait trait nextgroup=TI_ClassName skipwhite

    syn match TI_MethodName "^\s\+[^ \.]\+" nextgroup=TI_DOC1 skipwhite
    syn match TI_DOC1 "doc" contained
    syn match TI_Class "^\s*class" nextgroup=TI_PackagePath skipwhite
    syn match TI_Object "^\s*object" nextgroup=TI_PackagePath skipwhite
    syn match TI_Trait "^\s*trait" nextgroup=TI_PackagePath skipwhite


    syn match TI_PackagePath "\([a-zA-Z0-9_\$\[\]]\+\.\)\+" contained nextgroup=TI_Name
    syn match TI_Name "[^ \.]\+" contained

    syn match TI_PackagePath1 "\([a-z0-9_\$\[\]]\+\.\)\+" nextgroup=TI_Name1
    " syn match TI_PackagePath1 "\([a-zA-Z0-9_\$\[\]]\+\.\)\+" nextgroup=TI_Name1
    syn match TI_Name1 "[^ \.]\+" contained


  "    syn match TI_ClassName "[^ =:;(\[]\+" contained
  "    syn match TI_ClassName "[a-zA-Z0-9_\.\$\[\]]\+"


    syn match TI_COMMENT "(via implicit [a-zA-Z0-9_]\+)"
    syn match TI_COMMENT "Press .*"
    syn match TI_COMMENT "Type Inspector"
    syn match TI_COMMENT "<F1> .*"
    syn match TI_COMMENT "<CR> .*"
    syn match TI_COMMENT "<TAB> .*"
    syn match TI_COMMENT "<C-n> .*"
    syn match TI_COMMENT "<S-TAB> .*"
    syn match TI_COMMENT "<C-p> .*"
    syn match TI_COMMENT "p .*"
    syn match TI_COMMENT "n .*"
    syn match TI_COMMENT "q .*"


    hi link TI_MethodName PreProc
    hi link TI_Class Keyword
    hi link TI_Object Keyword
    hi link TI_Trait Keyword
    hi link TI_NodeStatus Operator

    hi link TI_DOC Special
    hi link TI_DOC1 Special

    hi link TI_ClassName Type
    hi link TI_COMPANION PreProc

    hi link TI_Name0 Type
    hi link TI_Name Type
    hi link TI_Name1 Type
    hi link TI_PackagePath Comment
    hi link TI_PackagePath1 Comment

    hi link TI_COMMENT Comment

  endif
endfunction

function! s:KeyMappings()
call s:LOG("KeyMappings: TOP")

  if s:done_key_mappings == 0
    nnoremap <script> <silent> <buffer> <CR> :call <SID>OnNodeClick()<CR>
    nnoremap <script> <silent> <buffer> <2-LeftMouse> :call <SID>OnNodeClick()<CR>
    nnoremap <script> <silent> <buffer> <F1> :call <SID>ToggleHelp()<CR>
    nnoremap <script> <silent> <buffer> <TAB> :call <SID>ForwardAtion()<CR>
    nnoremap <script> <silent> <buffer> <C-n> :call <SID>ForwardAtion()<CR>
    nnoremap <script> <silent> <buffer> <S-TAB> :call <SID>BackwardAtion()<CR>
    nnoremap <script> <silent> <buffer> <C-p> :call <SID>BackwardAtion()<CR>
    nnoremap <script> <silent> <buffer> p :call <SID>PreviousHistory()<CR>
    nnoremap <script> <silent> <buffer> n :call <SID>NextHistory()<CR>
    nnoremap <script> <silent> <buffer> q :call <SID>Close()<CR>
    nnoremap <script> <silent> <buffer> :q :call <SID>Close()<CR>


    let s:done_key_mappings = 1
  endif

endfunction

function! s:Initialize()
call s:LOG("Initialize: TOP")
  if s:running == 0
    call s:KeyMappings()

    let s:_insertmode = &insertmode
    set noinsertmode

    let s:_showcmd = &showcmd
    set noshowcmd

    let s:_cpo = &cpo
    set cpo&vim

    let s:_report = &report
    let &report = 10000

    let s:_list = &list
    set nolist

    setlocal nonumber
    setlocal foldcolumn=0
    setlocal nofoldenable
    setlocal cursorline
    setlocal nospell

    setlocal nobuflisted
  endif

  let s:running = 1
call s:LOG("Initialize: BOTTOM")
endfunction

function! s:Setup()
call s:LOG("Setup: TOP")
  call s:Reset()

  augroup TYPE_INSPECPTOR
    autocmd!
    autocmd BufDelete * call s:Close()
if 0
    autocmd BufEnter,BufNew * call s:ActivateBuffer()
    autocmd BufWipeOut * call s:DeactivateBuffer(1)
    autocmd BufDelete * call s:DeactivateBuffer(0)
    autocmd BufWinEnter \[TypeInspector\] call s:Initialize()
    autocmd BufWinLeave \[TypeInspector\] call s:Cleanup()
    autocmd TabEnter * call s:TabEnter()
    autocmd SessionLoadPost * call s:Reset()
endif " 0
  augroup END
endfunction

function! s:Reset()
  call s:LOG("Reset: TOP")
endfunction

" Close {{{2
" called on quit
function! s:Close()
  call s:LOG("Close: TOP")
  call s:Cleanup()

  " If we needed to split the main window, close the split one.
  if (s:split_mode != "")
    exec "wincmd c"
  endif

  exec "keepjumps silent b ". s:current_buffer

  " let s:split_mode = ""
  let s:current_buffer = ""

  " Clear any messages.
  echo
call s:LOG("Close: BOTTOM")
endfunction

" called by Close
function! s:Cleanup()
call s:LOG("Cleanup: TOP")
  if s:running == 1
    if exists("s:_insertmode")
      let &insertmode = s:_insertmode
    endif

    if exists("s:_showcmd")
      let &showcmd = s:_showcmd
    endif

    if exists("s:_cpo")
      let &cpo = s:_cpo
    endif

    if exists("s:_report")
      let &report = s:_report
    endif

    if exists("s:_list")
      let &list = s:_list
    endif
  endif

  let s:running = 0
  let s:first_buffe_lLine = 1
  let s:history_pos = -1
  let s:history_list = []
  let s:done_key_mappings = 0
  if exists("s:current_page")
    unlet s:current_page
  endif
  if exists("s:current_inspector")
    unlet s:current_inspector
  endif

  " delmarks!
endfunction



" ============================================================================
" Functions: {{{1
" ============================================================================

function! s:is_object(type_info)
  return has_key(a:type_info, ":decl-as") ? a:type_info[":decl-as"] == 'object' : 0
endfunction
function! s:is_class(type_info)
  return a:type_info[":decl-as"] == 'class'
endfunction
function! s:is_trait(type_info)
  return a:type_info[":decl-as"] == 'trait'
endfunction
function! s:is_method(type_info)
  return a:type_info[":decl-as"] == 'method'
endfunction
function! s:is_arrow_type(type_info)
  return has_key(a:type_info, ":arrow-type")
        \ ? a:type_info[":arrow-type"] : 0
endfunction

function! s:is_java_file()
  let fn = bufname("%")
  let len = len(fn)
  return len > 5 && strpart(fn, len-5) == ".java"
endfunction

" Input: TypeInspectorInfo
" ensime-inspect-type-at-point
function! s:inspect_type_at_point()
call s:LOG("s:inspect_type_at_point: TOP")
  if s:is_java_file()
    call s:inspect_java_type_at_point()
  else
    let [success, path] = Package_path_at_point()
    if success
      call s:inspect_package_by_path(path)
    else
      call s:type_inspect_info_at_point()
    endif
  endif
call s:LOG("s:inspect_type_at_point: BOTTOM")
endfunction

function! s:inspect_package_at_point()
call s:LOG("s:inspect_package_at_point: TOP")
  let [success, path] = Package_path_at_point()
  if success
call s:LOG("s:inspect_package_at_point: path=". path)
    call s:inspect_by_path(path)
  else
    echo "No package found"
  endif
endfunction
"
" vimside#command#inspector#project_package()
"
function! s:inspect_project_package()
call s:LOG("s:inspect_project_package: TOP")
  let dic = g:vimside.ensime.config
call s:LOG("s:inspect_project_package: dic=". string(dic))
  if has_key(dic, ":package")
    let package = dic[":package"]
    call s:inspect_by_path(package)
  elseif has_key(dic, ":project-package")
    let project_package = dic[":project-package"]
    call s:inspect_by_path(project_package)
  else
call s:LOG("s:inspect_project_package: no project package in ensime config")
  endif
endfunction

" TODO: should be using vimside#command#inspector#with_path_and_name
function! s:inspect_by_path(path)
call s:LOG("s:inspect_by_path: TOP path=". a:path)
  let rindex = strridx(a:path, '.')
  if rindex != -1
    let last = strpart(a:path, rindex+1)
call s:LOG("s:inspect_by_path: last=". last)
    let pattern = '^[a-z_0-9]\+$'
    let m = matchstr(last, pattern)
call s:LOG("s:inspect_by_path: m=". m)
    if m == last
call s:LOG("s:inspect_by_path: is package path")
      call s:inspect_package_by_path(a:path)
    else
call s:LOG("s:inspect_by_path: is type name")
      let dic = {
            \ 'handler': {
            \   'ok': function("g:type_inspector_by_name_at_point_callback")
            \ },
            \ 'args': {
            \   'name': a:path
            \ }
            \ }
let s:start_time = reltime()
      call vimside#swank#rpc#type_by_name#Run(dic)
    endif
  else
call s:LOG("s:inspect_by_path: no '.' found in path")
  endif
endfunction

function! s:inspect_java_type_at_point()
call s:LOG("s:inspect_java_type_at_point: TOP")
  let [success, symbol] = Get_symbol_at_point()
  let dic = {
        \ 'handler': {
        \   'ok': function("g:inspect_java_type_at_point_callback")
        \ },
        \ 'args': {
        \   'type_name': path
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)
endfunction

" SymbolInfo or SymbolSearchResult ???
function! s:inspect_java_type_at_point_callback(dic)
call s:LOG("s:inspect_java_type_at_point_callback: TOP")
  let declpos = a:dic[':decl-pos']
  let start = declpost[':offset']
  let name = a:dic[':local-name']
  let middle = start + len(name)/2

  let dic = {
        \ 'handler': {
        \   'ok': function("g:inspect_java_type_at_point_callback_callback")
        \ },
        \ 'args': {
        \   'offset': middle,
        \   'names': [name],
        \   'max': 10
        \ }
        \ }
  call vimside#swank#rpc#import_suggestions#Run(dic)
endfunction

function! s:inspect_java_type_at_point_callback_callback(dic)
call s:LOG("s:inspect_java_type_at_point_callback_callback: TOP")
  let listlist = a:dic
  if len(listlist) > 0
    let suggestions = listlist[0]
    let names = [ "Select Symbol" ]
    for s in suggestions
      let lname = s[":local-name"]
      call add(names, lname)
    endfor
    let selection = inputlist(names)
call s:LOG("s:inspect_java_type_at_point_callback_callback: selection=". selection)
    if selection > 0
      let s = suggestions[selection-1]
      let name = s[":name"]
      call s:inspect_by_path(name)
    endif
  endif
endfunction

" aa.pp.cc.DDD
function! s:inspect_package_by_path(path)
call s:LOG("s:inspect_package_by_path: path=". a:path)
  let [path, name] = Package_parts(a:path)
call s:LOG("s:inspect_package_by_path: path=". path)
call s:LOG("s:inspect_package_by_path: name=". name)
  if name == ''
    let name = input('Qualified type or package name: ')
    let path = path .'.'. name
  else
    let path = a:path
  endif
call s:LOG("s:inspect_package_by_path: 2 path=". path)
  let dic = {
        \ 'handler': {
        \   'ok': function("g:type_inspector_by_name_at_point_callback")
        \ },
        \ 'args': {
        \   'path': path
        \ }
        \ }
let s:start_time = reltime()
  call vimside#swank#rpc#inspect_package_by_path#Run(dic)
endfunction

" ensime-type-inspect-info-at-point
function! s:type_inspect_info_at_point()
call s:LOG("s:type_inspect_info_at_point: TOP")
  let [success, import_type_path] = Import_path_at_point()
  if success
    let dic = {
          \ 'handler': {
          \   'ok': function("g:type_inspector_by_name_at_point_callback")
          \ },
          \ 'args': {
          \   'type_name': import_type_path
          \ }
          \ }
let s:start_time = reltime()
    call vimside#swank#rpc#type_by_name_at_point#Run(dic)
  else
    let dic = {
          \ 'handler': {
          \   'ok': function("g:type_inspector_show")
          \ }
          \ }
let s:start_time = reltime()
    call vimside#swank#rpc#inspect_type_at_point#Run(dic)
  endif
call s:LOG("s:type_inspect_info_at_point: BOTTOM")
endfunction

function! g:type_inspector_by_name_at_point_callback(dic)
call s:LOG("g:type_inspector_by_name_at_point_callback: TOP")
call s:LOG("g:type_inspector_by_name_at_point_callback: dic=". string(a:dic))
call s:LOG("g:type_inspector_by_name_at_point_callback time=". reltimestr(reltime(s:start_time)))

  if has_key(a:dic, ":name") && a:dic[":name"] == "NA"
    return
  endif

let s:start_time = reltime()
  let s:current_page = s:Page_constructor()
  let s:current_inspector = s:PackageInspector_constructor(a:dic)
  call g:history_and_do(s:current_page, s:current_inspector)
  echo
endfunction

" TypeInspectInfo
" optional focus-on-member
" ensime-type-inspector-show
function! g:type_inspector_show(type_inspector_info)
call s:LOG("g:type_inspector_show: TOP")
call s:LOG("g:type_inspector_show time=". reltimestr(reltime(s:start_time)))

let s:start_time = reltime()
  let s:current_page = s:Page_constructor()
  let s:current_inspector = s:TypeInspector_constructor(a:type_inspector_info)
  call g:history_and_do(s:current_page, s:current_inspector)
  echo
endfunction


function! g:history_and_do(page, inspector)
call s:LOG("g:history_and_do: TOP")

call s:LOG("g:history_and_do: s:history_pos=". s:history_pos)
  " save current position
  if s:history_pos >= 0
    let history = s:history_list[s:history_pos]
    let history.pos = getpos('.')
  endif

  " make new history
  let history = s:History_constructor(a:inspector, a:page)

call s:LOG("g:history_and_do: len(s:history_list)=". len(s:history_list))
  if s:history_pos < len(s:history_list)-1
    let s:history_list[s:history_pos+1] = history

    " clear all histories "later" than this new one
    if s:history_pos < len(s:history_list)-1
      let s:history_list = s:history_list[0:s:history_pos+1]
    endif
  else
    call add(s:history_list, history)
  endif
  let s:history_pos += 1

  call s:DoTypeInspector()
endfunction




" Input: point
" Return: [0, _ ] or [1, path]
function! Package_path_at_point()
  " let pattern = '\%(package\|import\)\s\+\(\(\(\h\w*\)\.\)\+\h\w*\)'
  let pattern = '\%(package\|import\)\s\+\(\(\(\h\w*\)\.\)*\h\w*\)'
  let line = getline(".")
  let m = matchstr(line, pattern)
call s:LOG("Package_path_at_point: m=". m)
  return (m == '') ? [0, ''] : [1, substitute(m, pattern, '\1', '')]
endfunction

" Input: point
" Return: [0, _ ] or [1, path]
" ensime-imported-type-path-at-point
function! Import_path_at_point()
call s:LOG("Import_path_at_point: TOP")
  let [success, symbol] = Get_symbol_at_point()
  if success
    let line = getline(".")
    let pattern = '^\s*\%(import\)\s\+\(\(\h\w*\)\.\)*\(\u[\w\.]\+\|{[\w\., ]\+}\)\s*$'
    let m = matchstr(line, pattern)
call s:LOG("Import_path_at_point: m=". m)
    if m == ''
      return [0, ''] 
    else 
      [1, substitute(m, pattern, '\1', '') . symbol]
    endif
  else
    return [0, '']
  endif
endfunction

" matches "[A-ZA-z_]+"
" Return: [0, _ ] or [1, symbol]
function! Get_symbol_at_point()
call s:LOG("Get_symbol_at_point: TOP")
  let pattern = '[A-Za-z_]'
  let line = getline(".")
  let col = col(".")-1
  if line[col] =~ pattern
    let last_pos = len(line)
    let start = col
    while start > 0 && line[start-1] =~ pattern
      let start -= 1
    endwhile
    let end = col
    while end < last_pos && line[end] =~ pattern
      let end += 1
    endwhile
call s:LOG("Get_symbol_at_point: symbol=". strpart(line, start, end-start))
    return [1, strpart(line, start, end-start)]
  else
    return [0, '']
  endif
endfunction

" ensime-inspector-insert-linked-type
function! s:inspector_insert_linked_type(type_info, with_doc_link, qualified)
call s:LOG("s:inspector_insert_linked_type: TOP")
  let ti = a:type_info
  let wdl = a:with_doc_link
  let q = a:qualified

  if s:is_arrow_type(ti)
    call s:inspector_insert_linked_arrow_type(ti, wdl, q)
  else
    let is_object = s:is_object(ti)
    let type_id = ti[":type-id"]

    if q == 1
      " fullname
      let full_name = ti[":full-name"]
      let [path, outer, name] = vimside#command#inspector#with_name_parts(full_name)
      if path != ''
        call s:inspector_insert_linked_package_path(path, 1)
      endif
      if outer != '' && has_key(ti, ":outer-type-id")
        let outer_type_id = ti[":outer-type-id"]
        call s:current_page.add_text(outer, s:make_inspector_insert_link_to_type_id_action(outer_type_id))
        call s:current_page.add_text('$')
      endif
      " TODO use differ highlight if is_object
      call s:current_page.add_text(name, s:make_inspector_insert_link_to_type_id_action(type_id))
    else
      " short name
      let name = ti[":name"]
      " TODO use differ highlight if is_object
      call s:current_page.add_text(name, s:make_inspector_insert_link_to_type_id_action(type_id))
    endif

    if has_key(ti, ":type-args")
      " List of TypeInfo
      let type_args = ti[":type-args"]
      call s:current_page.add_text('[')
      let first_time = 1
      for targ in type_args
        if first_time
          let first_time = 0
        else
          call s:current_page.add_text(', ')
        endif
        call s:inspector_insert_linked_type(targ, 0 , 0)
      endfor
      call s:current_page.add_text(']')
    endif
  endif
  if wdl == 1
    if has_key(ti, ":pos")
      let pos = ti[":pos"]
      let url = pos[":file"]
    else
      let [found, url] = vimside#command#show_doc_symbol_at_point#MakeUrl(ti)
    endif
    call s:current_page.add_text(' doc', s:make_browser_action(url))
  endif
endfunction

function! s:inspector_insert_linked_arrow_type(type_info, with_doc_link, qualified)
call s:LOG("s:inspector_insert_linked_arrow_type: TOP")
  let ti = a:type_info
  let wdl = a:with_doc_link
  let q = a:qualified
  let result_type = ti[":result-type"]
  if has_key(ti, ":param-sections")
    let param_sections = ti[":param-sections"]

    for param_section in param_sections
  " call s:LOG("s:inspector_insert_linked_arrow_type: param_section=". string(param_section))
      call s:current_page.add_text('(')

      if has_key(param_section, ":params")
        let params = param_section[":params"]
        let is_implicit = has_key(param_section, ":is-implicit") ? param_section[":is-implicit"] : 0

        let first_time = 1
        for param in params
          let [name, pti] = param
          if first_time
            let first_time = 0
          else
            call s:current_page.add_text('. ')
          endif
          call s:inspector_insert_linked_type(pti, 0, 1)
        endfor

      endif
      call s:current_page.add_text(') => ')
    endfor
  endif
  call s:inspector_insert_linked_type(result_type, 0, 1)
endfunction

function! s:inspector_insert_linked_package_path(path, last_dot)
call s:LOG("s:inspector_insert_linked_package_path: path=". a:path)
  let parts = split(a:path, '\.')
" call s:LOG("s:inspector_insert_linked_package_path: parts=". string(parts))
  let accum = ''
  let first_time = 1
  for part in parts
    if first_time
      let first_time = 0
    else
      let accum .= '.'
      call s:current_page.add_text('.')
    endif
    let accum .= part
" call s:LOG("s:inspector_insert_linked_package_path: part=". part)
    call s:current_page.add_text(part, s:make_inspect_pakage_by_path_action(accum))
  endfor
  if a:last_dot
    call s:current_page.add_text('.')
  endif
endfunction

function! s:inspector_insert_linked_member(owner_type, member)
call s:LOG("s:inspector_insert_linked_member: TOP")
  let member = a:member
  let type_info = member.type_info
  let pos = member.pos
  let name = member.name
  let url = member.url
  let decl_as = member.decl_as

  if decl_as == 'method' || decl_as == 'field'
    call s:current_page.add_text(name . ' doc ', s:make_browser_action(url))
    call s:inspector_insert_linked_type(type_info, 0, 0)
  else
    " nested type
    call s:current_page.add_text(decl_as .' ')
    call s:inspector_insert_linked_type(type_info, 0, 0)
  endif
endfunction

" return [path, name]
function! Package_parts(full_name)
  let rindex = strridx(a:full_name, '.')
  if rindex == -1
    return ['', a:full_name ]
  else
    let path = strpart(a:full_name, 0, rindex)
    if rindex+1 == len(a:full_name)
      return [path, ""]
    else
      let name = strpart(a:full_name, rindex+1)
      return [path, name]
    endif
  endif
endfunction

"  :call vimside#command#inspector#with_name_parts('aa.bb.Cc')
"  :call vimside#command#inspector#with_name_parts('pack.pack1.pack2.Types$Type')
"  :call vimside#command#inspector#with_name_parts('pack.pack1.pack2.Type')
"  return [pack.pack1.pack2,  Types, type]
function! vimside#command#inspector#with_name_parts(str)
" call s:LOG("s:name_parts: str=X". a:str . 'X')

  let path = ''
  let other = ''
  let name = ''

  let str = a:str
  let index = stridx(str, '.')
  if index != -1
    let part = strpart(str, 0, index)
    let str = strpart(str, index+1)

    let index = stridx(part, '$')
    if part[index-1] == '$'
      let other = part
    else
      let path = part
    endif

    let index = stridx(str, '.')
    while index != -1
      let part = strpart(str, 0, index)
      let str = strpart(str, index+1)

      let index = stridx(part, '$')
      if part[index-1] == '$'
        if other == ''
          let other = part
        else
          let other .= '$'
          let other .= part
        endif
      else
        if path == ''
          let path = part
        else
          let path .= '.'
          let path .= part
        endif
      endif

      let index = stridx(str, '.')
    endwhile

  endif

  let index = stridx(str, '$')
  while index != -1 && len(str)-1 != index
    let part = strpart(str, 0, index)
    let str = strpart(str, index+1)
    if other == ''
      let other = part
    else
      let other .= '$'
      let other .= part
    endif

    let index = stridx(str, '$')
  endwhile
  return [path, other, str]
endfunction

" ensime-with-path-and-name
" used in inspect_by_path
" return [path, name]
function! vimside#command#inspector#with_path_and_name(str)
  let str = a:str
  let path = ''
  let index = stridx(str, '.')
  while index != -1
    let part = strpart(str, 0, index)
    if path == ''
      let path = part
    else
      let path .= '.'. part
    endif
    let str = strpart(str, index+1)
    let index = stridx(str, '.')
  endwhile
  return [path, str]
endfunction

function! CallUrl() dict
call s:LOG("CallUrl: url=". self.url)
  call vimside#browser#Open(self.url)
endfunction
function! s:make_browser_action(url)
call s:LOG("s:make_browser_action: url=". a:url)
  let action = s:Action_constructor()
  let action.execute = function("CallUrl")
  let action.url = a:url
  return action
endfunction


function! InspectPackage() dict
call s:LOG("InspectPackage: path=". self.path)
  call s:inspect_package_by_path(self.path)
endfunction
function! s:make_inspect_pakage_by_path_action(path)
call s:LOG("s:make_inspect_pakage_by_path_action: path=". a:path)
  let action = s:Action_constructor()
  let action.execute = function("InspectPackage")
  let action.path = a:path
  return action
endfunction

function! InspectTypeId() dict
call s:LOG("InspectTypeId: type_id=". self.type_id)
  let dic = {
        \ 'handler': {
        \   'ok': function("g:type_inspector_show")
        \ },
        \ 'args': {
        \   "type_id": self.type_id
        \ }
        \ }
let s:start_time = reltime()
  call vimside#swank#rpc#inspect_type_by_id#Run(dic)
endfunction
function! s:make_inspector_insert_link_to_type_id_action(type_id)
call s:LOG("s:make_inspector_insert_link_to_type_id_action: type_id=". a:type_id)
  let action = s:Action_constructor()
  let action.execute = function("InspectTypeId")
  let action.type_id = a:type_id
  return action
endfunction


if 0
" type link insert
function! s:inspector_insert_link_to_type_id(lines, text, type_id, is_object)
call s:LOG("s:inspector_insert_link_to_type_id: TOP")

  let page_map[] 
endfunction

endif " 0


" ============================================================================
" Objects: {{{1
" ============================================================================



" class History {{{1
"=============================
let s:History = {}
let s:History.inspector = {}
let s:History.page = {}
let s:History.pos = []

function! s:History_constructor(inspector, page)
call s:LOG("s:History_constructor: TOP")
  let history = deepcopy(s:History)
  call history.init(a:inspector, a:page)
  return history
endfunction
function! s:History_init(inspector, page) dict
call s:LOG("History_init: TOP")
  let self.inspector = a:inspector
  let self.page = a:page
call s:LOG("History_init: BOTTOM")
endfunction
let s:History.init = function("s:History_init")


" class TypeArg {{{1
"=============================
let s:TypeArg = {}
let s:TypeArg.type_id = -1
let s:TypeArg.decl_as = ''
let s:TypeArg.name = ""
let s:TypeArg.fullname = ""

function! s:TypeArg_constructor(type_info)
  let type_arg = deepcopy(s:TypeArg)
  call type_arg.init(a:type_info)
  return type_arg
endfunction

function! s:TypeArg_init(type_info) dict
call s:LOG("TypeArg_init: type_info=". string(a:type_info))
  let ti = a:type_info
  let self.type_id = ti[":type-id"]
  if has_key(ti, ":decl-as")
    let self.decl_as = ti[":decl-as"]
  endif
  let self.name = ti[":name"]
  let self.fullname = ti[":full-name"]
endfunction
let s:TypeArg.init = function("s:TypeArg_init")





" class Package {{{1
"   PackageInfo
"=============================
let s:PackageInspector = {}
let s:PackageInspector.package_info = {}
let s:PackageInspector.full_name = ''
let s:PackageInspector.name = ''
let s:PackageInspector.members = []

function! s:PackageInspector_constructor(package_inspector_info)
call s:LOG("s:PackageInspector_constructor: TOP")
  let package_inspector = deepcopy(s:PackageInspector)
  call package_inspector.init(a:package_inspector_info)
  return package_inspector
endfunction

function! s:PackageInspector_init(package_inspector_info) dict
call s:LOG("PackageInspector_init: TOP")
  let pii = a:package_inspector_info
  let self.package_info = pii
  let self.full_name = pii[":full-name"]
  let self.name = pii[":name"]

  if has_key(pii, ":members")
    let members = pii[":members"]
    for member in members
      if has_key(member, ":members")
        let interface = s:PackageInspector_constructor(member)
        call add(self.members, interface)
      else
        let interface_info = { ":type": member }
        let interface = s:Interface_constructor(interface_info)
        call add(self.members, interface)
      endif
    endfor
  endif
endfunction
let s:PackageInspector.init = function("s:PackageInspector_init")

function! s:PackageInspector_render() dict
call s:LOG("PackageInspector_render: TOP")
  call s:inspector_insert_linked_package_path(self.full_name, 0)

  try 
    call s:current_page.increment_indent()
    call s:current_page.new_line()
    let needs_new_line = 0

    " members
    for member in self.members
      if needs_new_line == 1
        call s:current_page.new_line()
        let needs_new_line = 0
      endif
      if has_key(member, "decl_as")
        let if_text = member.decl_as
        let if_text .= ' '
        call s:current_page.add_text(if_text)

        let owner_type = member.type_info
        call s:inspector_insert_linked_type(owner_type, 1, 1)
      elseif has_key(member, "render")
        call member.render()
      else
        call s:current_page.add_text("OTHER")
      endif

      let needs_new_line = 1
    endfor
  finally
    call s:current_page.decrement_indent()
  endtry 

endfunction
let s:PackageInspector.render = function("s:PackageInspector_render")



" class Type {{{1
"   TypeInspectorInfo
"=============================
let s:TypeInspector = {}
let s:TypeInspector.type_info = {}


let s:TypeInspector.is_open = 0
let s:TypeInspector.offset = 0
let s:TypeInspector.rstring = ''
let s:TypeInspector.idlist = []
let s:TypeInspector.type_id = -1
let s:TypeInspector.outer_type_id = -1
let s:TypeInspector.companion_id = -1
let s:TypeInspector.decl_as = ''
let s:TypeInspector.name = ''
let s:TypeInspector.fullname = ''
let s:TypeInspector.interfaces = []

function! s:TypeInspector_constructor(type_inspector_info)
call s:LOG("s:TypeInspector_constructor: TOP")
  let type_inspector = deepcopy(s:TypeInspector)
  call type_inspector.init(a:type_inspector_info)
  return type_inspector
endfunction

function! s:TypeInspector_init(type_inspector_info) dict
call s:LOG("TypeInspector_init: TOP")
  let tii = a:type_inspector_info
  let self.type_info = tii[":type"]

  if has_key(tii, ":companion-id")
    let self.companion_id = tii[":companion-id"]
  endif

  let self.type_id = self.type_info[":type-id"]
  if has_key(self.type_info, ":outer-type-id")
    let self.outer_type_id = self.type_info[":outer-type-id"]
  endif
  if has_key(self.type_info, ":decl-as")
    let self.decl_as = self.type_info[":decl-as"]
  endif
  let self.name = self.type_info[":name"]
  let self.fullname = self.type_info[":full-name"]

  if has_key(tii, ":interfaces")
  let interfaces = tii[":interfaces"]
    for interface_info in interfaces
      let interface = s:Interface_constructor(interface_info)
      call add(self.interfaces, interface)
    endfor
  endif
endfunction
let s:TypeInspector.init = function("s:TypeInspector_init")

function! s:TypeInspector_render() dict
call s:LOG("TypeInspector_render: TOP")
  call s:current_page.add_text(self.decl_as)
  call s:current_page.add_text(' ')
  
  try 
    call s:current_page.increment_indent()
    call s:inspector_insert_linked_type(self.type_info, 1, 1)
    call s:current_page.add_text(' ')

    " companion
    if self.decl_as != 'object' && self.companion_id >= 0
      let companion_id = self.companion_id
      let companion_text = '(companion)'
      call s:current_page.add_text(companion_text, s:make_inspector_insert_link_to_type_id_action(companion_id))
    endif
    call s:current_page.new_line()
    let needs_new_line = 0

    " interface members
    for interface in self.interfaces
      if needs_new_line == 1
        call s:current_page.new_line()
      endif
      let owner_type = interface.type_info
      let if_text = interface.decl_as
      if interface.via_view != ''
        let if_text .= ' (via implicit '. interface.via_view .')'
      endif
      let if_text .= ' '
      call s:current_page.add_text(if_text)
      " call s:current_page.add_text(if_text, s:make_inspector_insert_link_to_type_id_action(interface.type_id))

      call s:inspector_insert_linked_type(owner_type, 1, 1)
      try 
        call s:current_page.increment_indent()
        for member in interface.members
          call s:current_page.new_line()
          call s:inspector_insert_linked_member(owner_type, member)
        endfor
      finally
        call s:current_page.decrement_indent()
      endtry 
      let needs_new_line = 1
    endfor
  finally
    call s:current_page.decrement_indent()
  endtry 

endfunction
let s:TypeInspector.render = function("s:TypeInspector_render")

" class Interface {{{1
"   InterfaceInfo
"=============================
let s:Interface = {}
let s:Interface.is_open = 0
let s:Interface.type_info = {}
let s:Interface.offset = 0
let s:Interface.rstring = ''
let s:Interface.idlist = []
let s:Interface.type_id = -1
let s:Interface.decl_as = ''
let s:Interface.name = ''
let s:Interface.fullname = ''
let s:Interface.type_args = []
let s:Interface.via_view = ''
let s:Interface.members = []

function! s:Interface_constructor(interface_info)
call s:LOG("s:Interface_constructor: TOP")
  let interface = deepcopy(s:Interface)
  call interface.init(a:interface_info)
call s:LOG("s:Interface_constructor: BOTTOM")
  return interface
endfunction

function! s:Interface_init(interface_info) dict
  let ii = a:interface_info
  let type_info = ii[":type"]
  let self.type_info = type_info
  let self.decl_as = type_info[":decl-as"]
  let type_id = type_info[":type-id"]
  let self.type_id = type_info[":type-id"]
  let self.name = type_info[":name"]
call s:LOG("s:Interface_init: name=". self.name)
  let self.fullname = type_info[":full-name"]
  if has_key(type_info, ":type-args")
    let type_args = type_info[":type-args"]
    for type_arg_info in type_args
      let ta = s:TypeArg_constructor(type_arg_info)
      call add(self.type_args, ta)
    endfor
  endif
  if has_key(ii, ":via-view")
    let self.via_view = ii[":via-view"]
  endif

  if has_key(type_info, ":members")
    let members = type_info[":members"]
    for type_member_info in members
      let member = s:Member_constructor(type_info, type_member_info)
      call add(self.members, member)
    endfor
  endif
endfunction
let s:Interface.init = function("s:Interface_init")

" class Member {{{1
"   TypeMemberInfo
"=============================
let s:Member = {}
let s:Member.is_open = 0
let s:Member.offset = 0
let s:Member.rstring = ''
let s:Member.idlist = []
let s:Member.type_id = -1
let s:Member.type = ''
let s:Member.type_info = {}
let s:Member.name = ''
let s:Member.pos = 0
let s:Member.url = ''
let s:Member.decl_as = ''
let s:Member.type_args = []
let s:Member.signature = ''
let s:Member.typeinfo = {}
let s:Member.param_sections = []
let s:Member.rtype_id = -1
let s:Member.rdecl_as = ''
let s:Member.rname = ''
let s:Member.rfullname = ''
let s:Member.rtype_args = []

function! s:Member_constructor(owner_type_info, type_member_info)
  let member = deepcopy(s:Member)
  call member.init(a:owner_type_info, a:type_member_info)
  return member
endfunction

function! s:Member_init(owner_type_info, type_member_info) dict
call s:LOG("Member_init: TOP")
  let oti = a:owner_type_info
  let tmi = a:type_member_info

  let self.type_info = tmi[":type"]
  let self.name = tmi[":name"]
call s:LOG("s:Member_init: name=". self.name)
  let self.type_id = self.type_info[":type-id"]
  let self.decl_as = tmi[":decl-as"]
  if has_key(tmi, ":pos")
    let self.pos = tmi[":pos"]
    let self.url = self.pos[":file"]
  else
    let self.pos = 0
    let [found, self.url] = vimside#command#show_doc_symbol_at_point#MakeUrl(oti, tmi)
  endif
call s:LOG("Member_init: url=". self.url)

call s:LOG("Member_init: BOTTOM")
endfunction
let s:Member.init = function("s:Member_init")




" class Action {{{1
"=============================
let s:Action = {}
let s:Action.tag = 0
let s:ActionTag = 0

function! s:Action_constructor()
  let s:ActionTag += 1
  let action = deepcopy(s:Action)
  let action.tag = s:ActionTag
  return action
endfunction
function! s:Action_execute() dict
endfunction
let s:Action.execute = function("s:Action_execute")

" class Page {{{1
"=============================
let s:Page = {}
let s:Page.lines = []
let s:Page.current_line = -1
let s:Page.current_indent = 0
" line -> col-range -> action
let s:Page.line_col_map = []

function! s:Page_constructor()
  let page = deepcopy(s:Page)
  call page.init()
  return page
endfunction
                                                                    
function! s:Page_init() dict
  let self.lines = ['']
  let self.current_line = 0
  let self.current_indent = 0
  let self.page_actions = []
  let self.line_col_map = []
  call add(self.line_col_map, {})
endfunction
let s:Page.init = function("s:Page_init")

function! s:Page_increment_indent() dict
  let self.current_indent += 1
endfunction
let s:Page.increment_indent = function("s:Page_increment_indent")

function! s:Page_decrement_indent() dict
  let self.current_indent -= 1
endfunction
let s:Page.decrement_indent = function("s:Page_decrement_indent")

function! s:Page_add_text(text, ...) dict
call s:LOG("s:Page_add_text: text=". a:text)
  let line = self.lines[self.current_line]
call s:LOG("s:Page_add_text: line=X". line . "X")
  if a:0 == 0
    let line .= a:text
    let self.lines[self.current_line] = line
  else
    let start = len(line)
    let line .= a:text
    let end = len(line)
    let self.lines[self.current_line] = line

    let action = a:1
    call self.add_action([start, end], action)
  endif
endfunction
let s:Page.add_text = function("s:Page_add_text")

function! s:Page_new_line() dict
call s:LOG("s:Page_new_line: TOP")
  let indent = repeat(' ', self.current_indent)
  call add(self.lines, indent)
  call add(self.line_col_map, {})
  let self.current_line += 1
endfunction
let s:Page.new_line = function("s:Page_new_line")

function! s:Page_add_action(range, action) dict
call s:LOG("s:Page_add_action: TOP")
  if type(a:action) != type({})
    throw "Bad Page line_col_map action=". string(a:action)
  endif

  let [start, end] = a:range
  let map = self.line_col_map[self.current_line]
  let cnt = start
  while cnt < end
    let map[cnt] = a:action
    let cnt += 1
  endwhile
endfunction
let s:Page.add_action = function("s:Page_add_action")

function! s:Page_do_action(line, col) dict
  let map = self.line_col_map[a:line]
  if has_key(map, a:col)
    let action = map[a:col]
    call call(action,execute(), [])
  endif
endfunction
let s:Page.do_action = function("s:Page_do_action")

function! s:Page_PreviousTypeIdPosition() dict
  let col_in = col(".")-1
  let line_in = line(".")-s:first_buffer_line
call s:LOG("Page_PreviousTypeIdPosition: in col=". col_in . ", line=". line_in)
  if line_in < 0
    let line_in = len(self.lines)-1
  endif
" call s:LOG("Page_PreviousTypeIdPosition: line=". line_in .":". self.lines[line_in])
  let col = col_in
  let line = line_in

  " get current tag
  let map = self.line_col_map[line]
  let tag = has_key(map, col) ? map[col].tag : 0
" call s:LOG("Page_PreviousTypeIdPosition: tag=". tag)
  let col -= 1

  while col > 0 
" call s:LOG("Page_PreviousTypeIdPosition: M col=". col . ", line=". line)
    let t = has_key(map, col) ? map[col].tag : 0
" call s:LOG("Page_PreviousTypeIdPosition: t=". t)
    if t != tag && t != 0
      break
    endif
    let col -= 1
  endwhile

  if col > 0
    " set position
" call s:LOG("Page_PreviousTypeIdPosition: same col=". col . ", line=". line)
    call cursor(line+s:first_buffer_line, col)
  else
    if line == 0
      let line = len(self.lines)-1
    else
      let line -= 1
    endif
    while line >= 0
" call s:LOG("Page_PreviousTypeIdPosition: line=". line .":". self.lines[line])
      let col = len(self.lines[line])
      let map = self.line_col_map[line]

      while col > 0 && (! has_key(map, col) || map[col].tag == tag)
        let col -= 1
      endwhile
      if col >= 0
        break
      endif

      let line -= line
    endwhile

    if line >= 0
" call s:LOG("Page_PreviousTypeIdPosition: diff col=". col . ", line=". line)
      call cursor(line+s:first_buffer_line, col)
    endif
  endif
endfunction
let s:Page.previous_type_id_position = function("s:Page_PreviousTypeIdPosition")

function! s:Page_NextTypeIdPosition() dict
  let col_in = col(".")-1
  let line_in = line(".")-s:first_buffer_line
call s:LOG("Page_NextTypeIdPosition: in col=". col_in . ", line=". line_in)
  if line_in < 0
    let line_in = 0
  endif
" call s:LOG("Page_PreviousTypeIdPosition: len(lines)=". len(self.lines))
" call s:LOG("Page_PreviousTypeIdPosition: line=". line_in .":". self.lines[line_in])
  let col = col_in
  let line = line_in

  " get current tag
  let map = self.line_col_map[line]
  let tag = has_key(map, col) ? map[col].tag : 0
" call s:LOG("Page_PreviousTypeIdPosition: tag=". tag)
  let col += 1

  let end = len(self.lines[line])
  while col < end 
" call s:LOG("Page_PreviousTypeIdPosition: M col=". col . ", line=". line)
    let t = has_key(map, col) ? map[col].tag : 0
" call s:LOG("Page_PreviousTypeIdPosition: t=". t)
    if t != tag && t != 0
      break
    endif
    let col += 1
  endwhile

  if col < end
    " set position
" call s:LOG("Page_PreviousTypeIdPosition: same col=". col . ", line=". line)
    call cursor(line+s:first_buffer_line, col+1)
  else
    let max_lines= len(self.lines)-1
    if line == max_lines
      let line = 0
    else
      let line += 1
    endif
    while line < max_lines
" call s:LOG("Page_PreviousTypeIdPosition: line=". line .":". self.lines[line])
      let col = 0
      let map = self.line_col_map[line]

      let end = len(self.lines[line])
      while col < end && (! has_key(map, col) || map[col].tag == tag)
        let col += 1
      endwhile
      if col < end
        break
      endif

      let line += line
    endwhile

    if line >= 0
" call s:LOG("Page_PreviousTypeIdPosition: diff col=". col . ", line=". line)
      call cursor(line+s:first_buffer_line, col+1)
    endif
  endif

endfunction
let s:Page.next_type_id_position = function("s:Page_NextTypeIdPosition")




" ============================================================================
" KeyMappings: {{{1
" ============================================================================

function! s:ToggleHelp()
call s:LOG("ToggleHelp TOP")
  let s:help_open = !s:help_open

  setlocal modifiable

  " Save position.
  normal! ma
  
  " Remove existing help
  if (s:first_buffer_line > 1)
    exec "keepjumps 1,".(s:first_buffer_line - 1) "d _"
  endif
  
  call append(0, s:CreateHelp())

  silent! normal! g`a
  delmarks a

  setlocal nomodifiable
endfunction

function! s:ForwardAtion()
call s:LOG("ForwardAtion TOP")
  call s:current_page.next_type_id_position()
endfunction

function! s:BackwardAtion()
call s:LOG("BackwardAtion TOP")
  call s:current_page.previous_type_id_position()
endfunction


" OnNodeClick {{{2
"Node click event
function! s:OnNodeClick()
  let col = col(".")-1
  let line = line(".")-s:first_buffer_line
call s:LOG("OnNodeClick: col=". col . ", line=". line)
  if line > 0
    let amap = s:current_page.line_col_map[line]
    if has_key(amap, col)
      let action = amap[col]
call s:LOG("OnNodeClick: action=". string(action))
      echo "Getting Type Info...."
      call action.execute()
    else
call s:LOG("OnNodeClick: no action")
    endif
  else
call s:LOG("OnNodeClick: no amap")
  endif
endfunction

function! s:NextHistory()
call s:LOG("NextHistory history_pos=". s:history_pos)
  if s:history_pos < len(s:history_list)-1
    let s:history_pos += 1
    let history = s:history_list[s:history_pos]
    let s:current_inspector = history.inspector
    let s:current_page = history.page
    call s:loadDisplay(1)
    call setpos('.', history.pos)
  endif
endfunction
function! s:PreviousHistory()
call s:LOG("PreviousHistory history_pos=". s:history_pos)
  if s:history_pos > 0
    let s:history_pos -= 1
    let history = s:history_list[s:history_pos]
    let s:current_inspector = history.inspector
    let s:current_page = history.page
    call s:loadDisplay(1)
    call setpos('.', history.pos)
  endif
endfunction

function! s:ReBuildDisplay()
call s:LOG("ReBuildDisplay TOP")
  setlocal modifiable
  let curPos = getpos('.')

  exec "keepjumps ".s:first_buffer_line.',$d "_'
  call s:BuildDisplay(0)

  call setpos('.', curPos)
  setlocal nomodifiable
call s:LOG("ReBuildDisplay BOTTOM")
endfunction

" called by ReBuildDisplay
" called by loadDisplay
function! s:BuildDisplay(use_current_page)
call s:LOG("BuildDisplay TOP")

  call setline(1, s:CreateHelp())

if 1
  if ! a:use_current_page
    call s:current_inspector.render()
  endif
else
  call s:current_inspector.render()
endif
  let lines = s:current_page.lines
  call setline(s:first_buffer_line, lines)

" call s:LOG("BuildDisplay lines=". string(lines))
call s:LOG("BuildDisplay time=". reltimestr(reltime(s:start_time)))

call s:LOG("BuildDisplay BOTTOM")
endfunction

" return [lines...]
function! s:CreateHelp()
  if s:help_show == 0
    let s:first_buffer_line = 1
    return []
  else
    let help_lines = []
    if s:help_open == 1
      call add(help_lines, "Type Inspector")
      call add(help_lines, "-------------------")
      call add(help_lines, "<F1>    : toggle help")
      call add(help_lines, "<CR>    : inspect type")
      call add(help_lines, "<TAB>   : next type")
      call add(help_lines, "<C-n>   : next type")
      call add(help_lines, "<S-TAB> : previous type (may not work)")
      call add(help_lines, "<C-p>   : previous type")
      call add(help_lines, "n       : next history")
      call add(help_lines, "p       : previous history")
      call add(help_lines, "q       : quit")
    else
      call add(help_lines, "Press <F1> for Help")
    endif
    
    let s:first_buffer_line = len(help_lines) + 1
    return help_lines
  endif
endfunction

function! s:MakeMapKeys()
endfunction

" called by s:DoTypeInspector()
" called by s:PreviousHistory()
" called by s:NextHistory()
function! s:loadDisplay(use_current_page)
call s:LOG("loadDisplay TOP")
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap

  " delete buffer contents
  execute "1,$d"

  call s:SetupSyntax()
  call s:MakeMapKeys()
  call s:BuildDisplay(a:use_current_page)
  call cursor(s:first_buffer_line, 1)

if 0
  if !g:bufExplorerResize
    normal! zz
  endif
endif

  setlocal nomodifiable
call s:LOG("loadDisplay BOTTOM")
endfunction

" only called by g:history_and_do(page, inspector)
function! s:DoTypeInspector()
call s:LOG("DoTypeInspector TOP")

  if s:running == 0
    let s:current_buffer = bufname("%")

    " do split mode
    if s:split_mode != ""
      " exe 'keepalt '. s:split_mode
      execute s:split_mode .' '. 'ActWin'
    endif
  endif

  " only does something it s:running == 0
  call s:Initialize()

  call s:loadDisplay(0)

call s:LOG("DoTypeInspector BOTTOM")
endfunction


" ============================================================================
" External Interface: {{{1
" ============================================================================

function!  vimside#command#inspector#type_at_point()
call s:LOG("vimside#command#inspector#type_at_point TOP")
  let [success, _] = vimside#util#GetCurrentFilename()
  if success
    echo "Starting Type Inspector..."
    call s:inspect_type_at_point()
  elseif s:running == 1
    call s:OnNodeClick()
  endif
call s:LOG("vimside#command#inspector#type_at_point BOTTOM")
endfunction

function!  vimside#command#inspector#package_at_point()
call s:LOG("vimside#command#inspector#package_at_point TOP")
  let [success, _] = vimside#util#GetCurrentFilename()
  if success
    echo "Starting Type Inspector..."
    call s:inspect_package_at_point()
  elseif s:running == 1
    call s:OnNodeClick()
  endif
call s:LOG("vimside#command#inspector#package_at_point BOTTOM")
endfunction

function!  vimside#command#inspector#project_package()
  call s:LOG("vimside#command#inspector#project_package TOP")
    echo "Starting Type Inspector..."
    call s:inspect_project_package()
  call s:LOG("vimside#command#inspector#project_package BOTTOM")
endfunction



