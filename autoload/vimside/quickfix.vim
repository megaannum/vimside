
let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:is_quickfix_init = 0
let s:is_open = 0
let s:category = 'QuickFix'

" ==============================================
" Init
" ==============================================

function! s:quickfix_init()
call s:LOG("s:quickfix_init: TOP")
  if ! s:is_quickfix_init
    call s:InitSign()

    let s:is_quickfix_init = 1
  endif
call s:LOG("s:quickfix_init: BOTTOM")
endfunction

" ==============================================
" Sign
" ==============================================
function! s:InitSign()
call s:LOG("s:InitSign: BOTTOM")

  let [l:found, l:sign_quickfix_error_linehl] = g:vimside.GetOption('sign-quickfix-error-linehl')
  if ! found
    throw "Option not found: sign-quickfix-error-linehl"
  endif

  let [l:found, l:sign_quickfix_error_text] = g:vimside.GetOption('sign-quickfix-error-text')
  if ! found
    throw "Option not found: sign-quickfix-error-text"
  endif

  let [l:found, l:sign_quickfix_error_texthl] = g:vimside.GetOption('sign-quickfix-error-texthl')
  if ! found
    throw "Option not found: sign-quickfix-error-texthl"
  endif


  let [l:found, l:sign_quickfix_warn_linehl] = g:vimside.GetOption('sign-quickfix-warn-linehl')
  if ! found
    throw "Option not found: sign-quickfix-warn-linehl"
  endif

  let [l:found, l:sign_quickfix_warn_text] = g:vimside.GetOption('sign-quickfix-warn-text')
  if ! found
    throw "Option not found: sign-quickfix-warn-text"
  endif

  let [l:found, l:sign_quickfix_warn_texthl] = g:vimside.GetOption('sign-quickfix-warn-texthl')
  if ! found
    throw "Option not found: sign-quickfix-warn-texthl"
  endif


  let [l:found, l:sign_quickfix_info_linehl] = g:vimside.GetOption('sign-quickfix-info-linehl')
  if ! found
    throw "Option not found: sign-quickfix-info-linehl"
  endif

  let [l:found, l:sign_quickfix_info_text] = g:vimside.GetOption('sign-quickfix-info-text')
  if ! found
    throw "Option not found: sign-quickfix-info-text"
  endif

  let [l:found, l:sign_quickfix_info_texthl] = g:vimside.GetOption('sign-quickfix-info-texthl')
  if ! found
    throw "Option not found: sign-quickfix-info-texthl"
  endif


  let [l:found, l:sign_quickfix_marker_linehl] = g:vimside.GetOption('sign-quickfix-marker-linehl')
  if ! found
    let l:sign_quickfix_marker_linehl = 'Search' 
  endif

  let [l:found, l:sign_quickfix_marker_text] = g:vimside.GetOption('sign-quickfix-marker-text')
  if ! found
    let l:sign_quickfix_marker_text = 'M>' 
  endif

  let [l:found, l:sign_quickfix_marker_texthl] = g:vimside.GetOption('sign-quickfix-marker-texthl')
  if ! found
    let l:sign_quickfix_marker_texthl = 'Ignore' 
  endif



  let cdata = {}
  let cdata['category'] = s:category
  let cdata['abbreviation'] = 'qfx'
  let kinds = {}
  let cdata['kinds'] = kinds

  let kdata = {}
  let kdata['linehl'] = l:sign_quickfix_error_linehl
  let kdata['texthl'] = l:sign_quickfix_error_texthl
  let kdata['text'] = strpart(l:sign_quickfix_error_text, 0, 2)
  let kinds['error'] = kdata

  let kdata = {}
  let kdata['linehl'] = l:sign_quickfix_warn_linehl
  let kdata['texthl'] = l:sign_quickfix_warn_texthl
  let kdata['text'] = strpart(l:sign_quickfix_warn_text, 0, 2)
  let kinds['warn'] = kdata

  let kdata = {}
  let kdata['linehl'] = l:sign_quickfix_info_linehl
  let kdata['texthl'] = l:sign_quickfix_info_texthl
  let kdata['text'] = strpart(l:sign_quickfix_info_text, 0, 2)
  let kinds['info'] = kdata

  let kdata = {}
  let kdata['linehl'] = l:sign_quickfix_marker_linehl
  let kdata['texthl'] = l:sign_quickfix_marker_texthl
  let kdata['text'] = strpart(l:sign_quickfix_marker_text, 0, 2)
  let kinds['marker'] = kdata

  let cdata['ids'] = {}

  let cdata['toggle'] = 'qf'

  call vimside#sign#AddCategory(s:category, cdata)
call s:LOG("s:InitSign: TOP")
endfunction

function! s:WriteSign(entries)
call s:LOG("s:WriteSign: TOP")
" takes list of { "file": file, "line": line }

  for entry in a:entries
    let l:file = entry['filename']
    let l:line = entry['lnum']
    if has_key(entry, 'kind')
      let l:kind = entry['kind']
    else
      let l:kind = 'error'
    endif
    call vimside#sign#PlaceFile(l:line, l:file, s:category, l:kind)

  endfor

call s:LOG("s:WriteSign: BOTTOM")
endfunction

function! s:quickfix_register_to_clear_sign_auto()
  let bn = bufnr("$")
call s:LOG("s:quickfix_register_to_clear_sign_auto: bn=". bn)
  if bn != -1
    augroup QFX_SIGN_GROUP
      autocmd!
      execute "autocmd BufWinLeave <buffer=" . bn . "> call s:quickfix_clear_sign_auto()"
    augroup END
  endif
endfunction

function! s:quickfix_clear_sign_auto()
call s:LOG("s:quickfix_clear_sign_auto: TOP")
  call vimside#sign#ClearCategory(s:category)
  augroup QFX_SIGN_GROUP
    autocmd!
  augroup END
call s:LOG("s:quickfix_clear_sign_auto: BOTTOM")
endfunction

function! s:ClearSign()
  call vimside#sign#ClearCategory(s:category)
endfunction
 
" ==============================================
" Local
" ==============================================

function! s:Clear()
  call setqflist([])

  call s:ClearSign()
endfunction

function! s:Write(entries, use_signs)
  call setqflist(a:entries)

  if a:use_signs
    call s:WriteSign(a:entries)
  endif
endfunction

" ==============================================
" API
" ==============================================

function! vimside#quickfix#Clear()
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
"   'kind': 'marker'
"   'vcol': 1      optional
"   'type': 'a'      optional 'a' add, 'r' replace
"   'nr': 1      optional
" }
"
" optional argument: use_signs
"
function! vimside#quickfix#Display(entries, ...)
  if a:0 > 0
    let use_signs = a:1
  else
    let use_signs = 0
  endif

  call s:Clear()
  call s:Write(a:entries, use_signs)

  copen
  setlocal nonu
  setlocal nocursorline
  redraw

  if use_signs
    call s:quickfix_register_to_clear_sign_auto()
  endif

  let s:is_open = 1
endfunction

function!  vimside#quickfix#Close()
  if s:is_open
    call s:ClearSign()

    execute "cclose"
    redraw

    let s:is_open = 0
  endif
endfunction

" ==============================================
" Test
" ==============================================
function! vimside#quickfix#DOIT()
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
  silent call vimside#quickfix#Display(entries)
endfunction

" Initialize debug module
call s:quickfix_init()
