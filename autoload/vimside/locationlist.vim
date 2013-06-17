
let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:is_locationlist_init = 0
let s:is_open = 0
let s:category = 'LocationList'

" ==============================================
" Init
" ==============================================

function! s:locationlist_init()
call s:LOG("s:locationlist_init: TOP")
  if ! s:is_locationlist_init
    call s:InitSign()

    let s:is_locationlist_init = 1
  endif
call s:LOG("s:locationlist_init: BOTTOM")
endfunction

" ==============================================
" Sign
" ==============================================
function! s:InitSign()
call s:LOG("s:InitSign: BOTTOM")

  let [l:found, l:sign_locationlist_info_linehl] = g:vimside.GetOption('sign-locationlist-info-linehl')
  if ! found
    throw "Option not found: sign-locationlist-info-linehl"
  endif

  let [l:found, l:sign_locationlist_info_text] = g:vimside.GetOption('sign-locationlist-info-text')
  if ! found
    throw "Option not found: sign-locationlist-info-text"
  endif

  let [l:found, l:sign_locationlist_info_texthl] = g:vimside.GetOption('sign-locationlist-info-texthl')
  if ! found
    throw "Option not found: 'sign-locationlist-info-texthl"
  endif


  let [l:found, l:sign_locationlist_marker_linehl] = g:vimside.GetOption('sign-locationlist-marker-linehl')
  if ! found
    throw "Option not found: sign-locationlist-marker-linehl"
  endif

  let [l:found, l:sign_locationlist_marker_text] = g:vimside.GetOption('sign-locationlist-marker-text')
  if ! found
    throw "Option not found: sign-locationlist-marker-text"
  endif

  let [l:found, l:sign_locationlist_marker_texthl] = g:vimside.GetOption('sign-locationlist-marker-texthl')
  if ! found
    throw "Option not found: sign-locationlist-marker-texthl"
  endif


  let cdata = {}
  let cdata['category'] = s:category
  let cdata['abbreviation'] = 'locl'
  let kinds = {}
  let cdata['kinds'] = kinds

  let kdata = {}
  let kdata['linehl'] = l:sign_locationlist_info_linehl
  let kdata['texthl'] = l:sign_locationlist_info_texthl
  let kdata['text'] = strpart(l:sign_locationlist_info_text, 0, 2)
  let kinds['info'] = kdata

  let kdata = {}
  let kdata['linehl'] = l:sign_locationlist_marker_linehl
  let kdata['texthl'] = l:sign_locationlist_marker_texthl
  let kdata['text'] = strpart(l:sign_locationlist_marker_text, 0, 2)
  let kinds['marker'] = kdata


  let cdata['ids'] = {}

  call vimside#sign#AddCategory(s:category, cdata)
call s:LOG("s:InitSign: TOP")
endfunction

function! s:WriteSign(entries)
call s:LOG("s:WriteSign: TOP")
" takes list of { "file": file, "line": line }
  let l:infos = []

  for entry in a:entries
    let l:file = entry['filename']
    let l:line = entry['lnum']
    let l:kind = entry['kind']
    call vimside#sign#PlaceFile(l:line, l:file, s:category, l:kind)
  endfor

call s:LOG("s:WriteSign: BOTTOM")
endfunction

function! s:locationlist_register_to_clear_sign_auto()
  let bn = bufnr("$")
call s:LOG("s:locationlist_register_to_clear_sign_auto: bn=". bn)
  if bn != -1
    augroup LOC_SIGN_GROUP
      autocmd!
      execute "autocmd BufWinLeave <buffer=" . bn . "> call s:locationlist_clear_sign_auto()"
    augroup END
  endif
endfunction

function! s:locationlist_clear_sign_auto()
call s:LOG("s:locationlist_clear_sign_auto: TOP")
  call vimside#sign#ClearCategory(s:category)
  augroup LOC_SIGN_GROUP
    autocmd!
  augroup END
call s:LOG("s:locationlist_clear_sign_auto: BOTTOM")
endfunction


function! s:ClearSign()
  call vimside#sign#ClearCategory(s:category)
endfunction
 
" ==============================================
" Local
" ==============================================

function! s:Clear()
  call setloclist(0, [])

  call s:ClearSign()
endfunction

function! s:Write(entries, use_signs)
  call setloclist(0, a:entries)

  if a:use_signs
    call s:WriteSign(a:entries)
  endif
endfunction

" ==============================================
" API
" ==============================================

function! vimside#locationlist#Clear()
  call s:Clear()
endfunction

"
" arg: List of entries
" entry: Dictionary
" {
"   'filename': ''
"   'lnum': 4
"   'pattern' : not needed if lnum is present
"   'col': 4      optional
"   'text': line      optional
"   'kind': kind of sign
"   'vcol': 1      optional
"   'type': 'a'      optional 'a' add, 'r' replace
"   'nr': 1      optional
" }
"
"
" optional argument: use_signs
"
function! vimside#locationlist#Display(entries, ...)
  if a:0 > 0
    let use_signs = a:1
  else
    let use_signs = 0
  endif

  call s:Clear()
  call s:Write(a:entries, use_signs)

  lopen
  setlocal nonu
  setlocal nocursorline
  redraw

  call s:locationlist_register_to_clear_sign_auto()

  let s:is_open = 1
endfunction

function!  vimside#locationlist#Close()
  if s:is_open
    execute "lclose"
    redraw

    let s:is_open = 0
  endif
endfunction

" ==============================================
" Test
" ==============================================
function! vimside#locationlist#DOIT()
  let entries = [
        \ {
        \  'filename': 'Foo.scala',
        \  'lnum': 2,
        \  'col': 5,
        \  'vcol': 1,
        \  'text': 'This is some line',
        \  'kind': 'marker',
        \  'type': 'r',
        \  'nr': 1
        \ },
        \ {
        \  'filename': 'Bar.scala',
        \  'lnum': 3,
        \  'col': 7,
        \  'vcol': 1,
        \  'text': 'This is some other line',
        \  'kind': 'marker',
        \  'type': 'r',
        \  'nr': 2
        \ }
        \ ]
  silent call vimside#locationlist#Display(entries)
endfunction

" Initialize debug module
call s:locationlist_init()
