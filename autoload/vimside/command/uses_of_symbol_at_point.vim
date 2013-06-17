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
let s:ERROR = function("vimside#log#error")

let [found, use_signs] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-use-signs')
if found
  let s:use_signs = use_signs
else
  let s:use_signs = 0
endif
let [found, use_sign_kind_marker] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-use-sign-kind-marker')
if found
  let s:use_sign_kind_marker = use_sign_kind_marker
else
  let s:use_sign_kind_marker = 0
endif

if 0 " REMOVE
function!  vimside#command#uses_of_symbol_at_point#Run()
  call vimside#swank#rpc#uses_of_symbol_at_point#Run()
endfunction
endif " REMOVE

function!  vimside#command#uses_of_symbol_at_point#Run()
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
  if bn != -1
    augroup VIMSIDE_USAP
      autocmd!
      execute "autocmd BufWinLeave <buffer=" . bn . "> call s:CloseWindow()"
    augroup END
  endif

  return 1
endfunction

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
