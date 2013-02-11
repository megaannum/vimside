

let s:is_init = 0
let s:is_open = 0

function! vimside#cmdline#Init()
  if ! s:is_init
    let s:is_init = 1
  endif
endfunction

function! s:Clear()
  echo ''
endfunction

function! s:Write(msg)
  echo a:msg
endfunction

"
" arg: String message
"
function! vimside#cmdline#Display(msg)
  if ! s:is_init
    call vimside#cmdline#Init()
  endif


  " call s:Clear()
  call s:Write(a:msg)

  let s:is_open = 1
endfunction

function!  vimside#cmdline#Close()
  if s:is_open
    call s:Clear()
    let s:is_open = 0
  endif
  let s:is_init = 0
endfunction

function! vimside#cmdline#DOIT()
  let msg = "This is a message"
  call vimside#cmdline#Display(msg)
endfunction

