" ============================================================================
" uses_of_symbol_at_point.vim
"
" File:          vimside#swank#rpc#uses_of_symbol_at_point.vim
" Summary:       Vimside RPC uses-of-symbol-at-point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Request all source locations where indicated symbol is used in this project.
"
" Arguments:
" String:A Scala source filename, absolute or relative to the project.
" Int:Character offset of the desired symbol within that file.
"
" Return:
" List of RangePosition:Locations where the symbol is reference.
"
" Example:
"
" (:swank-rpc (swank:uses-of-symbol-at-point "Test.scala" 11334) 42)
"
" (:return (:ok ((:file "RichPresentationCompiler.scala"
" :offset 11442
" :start 11428 :end 11849) (:file
" "RichPresentationCompiler.scala"
" :offset 11319 :start 11319 :end 11339))) 42)
" 
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

" public API
function! vimside#swank#rpc#uses_of_symbol_at_point#Run(...)
" call s:LOG("UsesOfSymbolAtPoint TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-uses-of-symbol-at-point-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-uses-of-symbol-at-point-caller')
  endif

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr fn
    return
  endif
" call s:LOG("UsesOfSymbolAtPoint fn=".fn) 
    let offset = vimside#util#GetCurrentOffset()

  let l:args = { }
  let l:args['filename'] = fn
  let l:args['offset'] = offset
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
  let l:rr['data'] = line
call s:LOG("UsesOfSymbolAtPoint line=". line) 
  call vimside#ensime#swank#dispatch(l:rr)

" call s:LOG("UsesOfSymbolAtPoint BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:UsesOfSymbolAtPointCaller(args)
  let cmd = "swank:uses-of-symbol-at-point"
  let fn = a:args.filename
  let offset = a:args.offset

  return '(' . cmd . ' "' . fn . '" ' . offset . ')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:UsesOfSymbolAtPointHandler()

  function! g:UsesOfSymbolAtPointHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:UsesOfSymbolAtPointHandler_Ok(diclist, ...)
    let diclist = a:diclist
" call s:LOG("UsesOfSymbolAtPointHandler_Ok dic=list".  string(diclist)) 
    if a:0 == 0
      let l:start_line = -1
    else
      let l:start_line = a:1
    endif
call s:LOG("UsesOfSymbolAtPointHandler_Ok start_line=".  l:start_line) 
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
call s:LOG("UsesOfSymbolAtPointHandler_Ok kind=".  l:kind) 

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
" call s:LOG("UsesOfSymbolAtPointHandler_Ok entry=".  string(entry)) 

      let cnt += 1
    endwhile

    let location = s:GetLocation()
call s:LOG("UsesOfSymbolAtPointHandler_Ok location=".  location) 

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

" call s:LOG("UsesOfSymbolAtPointHandler_Ok call s:use_signs=". s:use_signs) 
     let [found, l:window] = g:vimside.GetOption('tailor-uses-of-symbol-at-point-window')
     if found
       if l:window == 'quickfix'
" call s:LOG("UsesOfSymbolAtPointHandler_Ok call quickfix Display") 
        call vimside#quickfix#Display(entries, s:use_signs) 
       else " mixed
        if l:same_file
" call s:LOG("UsesOfSymbolAtPointHandler_Ok call locationlist Display") 
          call vimside#locationlist#Display(entries, s:use_signs) 
        else
" call s:LOG("UsesOfSymbolAtPointHandler_Ok call quickfix Display") 
          call vimside#quickfix#Display(entries, s:use_signs) 
        endif
       endif
     else " default
" call s:LOG("UsesOfSymbolAtPointHandler_Ok call quickfix Display") 
        call vimside#quickfix#Display(entries, s:use_signs) 
     endif


    let bn = bufnr("$")
" call s:LOG("UsesOfSymbolAtPointHandler_Ok bn=".  bn) 
    if bn != -1
      augroup VIMSIDE_USAP
        autocmd!
        execute "autocmd BufWinLeave <buffer=" . bn . "> call s:CloseWindow()"
      augroup END
    endif

    return 1
  endfunction

  return { 
    \ 'abort': function("g:UsesOfSymbolAtPointHandler_Abort"),
    \ 'ok': function("g:UsesOfSymbolAtPointHandler_Ok") 
    \ }
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
