

let s:is_init = 0
let s:is_open = 0

function! vimside#quickfix#Init()
if ! s:is_init
  let s:is_init = 1
endif
endfunction

function! s:Clear()
call setqflist([])
endfunction

function! s:Write(entries)
  call setqflist(a:entries)
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
"   'vcol': 1      optional
"   'type': 'a'      optional 'a' add, 'r' replace
"   'nr': 1      optional
" }
"
function! vimside#quickfix#Display(entries)
  if ! s:is_init
    call vimside#quickfix#Init()
  endif


  call s:Clear()
  call s:Write(a:entries)

  copen
  setlocal nonu
  setlocal nocursorline
  redraw

  let s:is_open = 1
endfunction

function!  vimside#quickfix#Close()
  if s:is_open
    execute "cclose"
    redraw

    let s:is_open = 0
  endif
endfunction

function! vimside#quickfix#DOIT()
  let entries = [
        \ {
        \  'filename': 'Foo.scala',
        \  'lnum': 2,
        \  'col': 5,
        \  'vcol': 1,
        \  'text': 'This is some line',
        \  'type': 'r',
        \  'nr': 1
        \ },
        \ {
        \  'filename': 'Bar.scala',
        \  'lnum': 3,
        \  'col': 7,
        \  'vcol': 1,
        \  'text': 'This is some other line',
        \  'type': 'r',
        \  'nr': 2
        \ }
        \ ]
  silent call vimside#quickfix#Display(entries)
endfunction

