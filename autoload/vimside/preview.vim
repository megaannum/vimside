
" Tim Chase
"  http://vim.1045645.n5.nabble.com/Creating-using-background-hidden-buffers-td1143991.html

let s:buffer_id = 0
let s:buffer_name = 'VIMSIDE'
let s:is_init = 0
let s:is_open = 0
let s:close_cnt = 0
let s:close_at = 2


function! vimside#preview#Init()
  if ! s:is_init
    execute "badd ". s:buffer_name

    let s:buffer_id = bufnr(s:buffer_name)
"echo "Init id=" .s:buffer_id
"sleep 2

    call setbufvar(s:buffer_id, '&buftype', 'nofile')
    call setbufvar(s:buffer_id, '&bufhidden', 'hide')
    call setbufvar(s:buffer_id, '&swapfile', 0)
    call setbufvar(s:buffer_id, '&buflisted', 0)
    call setbufvar(s:buffer_id, '&lazyredraw', 0)
    call setbufvar(s:buffer_id, '&modifiable', 1)
    set previewheight=2
sleep 1

    let s:is_init = 1
  endif
endfunction

function! s:Clear()
  exec 'sp #'. s:buffer_id
  try
    execute "normal ggVGGdd"
  finally
    q
  endtry
endfunction

function! s:Write(lines)
  exec 'sp #'. s:buffer_id
  try
    let len = len(a:lines)
    if len > 0
      execute "normal i" . a:lines[0]
      let cnt = 1
      while cnt < len
        execute "normal o" . a:lines[cnt]

        let cnt += 1
      endwhile
if 0
      let cnt = 0
      execute ":normal $G"
      execute "normal i" . a:lines[0]
      let cnt += 1
      while cnt < len
        execute ":normal $G"
        execute "normal o" . a:lines[cnt]

        let cnt += 1
      endwhile
endif
    endif
  finally
    q
  endtry
endfunction

function! vimside#preview#Display(lines)
  if ! s:is_init
    call vimside#preview#Init()
  endif

  if type(a:lines) == type('')
    let lines = [ a:lines ]
  elseif type(a:lines) == type([])
    let lines = a:lines
  else
    echoerr "g:Display Bad arg type: " .string(a:lines)
  endif

  let len = len(lines)
  if &previewheight != len
    let &previewheight = len
  endif

  call s:Clear()
  call s:Write(lines)

  execute "pclose"
  execute "botright pedit " . s:buffer_name

"  http://vim.1045645.n5.nabble.com/Creating-using-background-hidden-buffers-td1143991.html

  "call setbufvar(s:buffer_id, '&cursorline', 0)
  "call setbufvar(s:buffer_id, '&nu', 0)
  "call setbufvar(s:buffer_id, '&statusline', '%=')
  
  redraw

if 1
  augroup VIMSIDE_PREVIEW
    autocmd!
    autocmd CursorMoved * call s:CloseAt()
    autocmd TabLeave * call s:CloseAt()
  augroup END
endif
  let s:close_cnt = 0

  let s:is_open = 1
endfunction

function! s:CloseAt()
  let s:close_cnt += 1
  if s:close_cnt == s:close_at
    call vimside#preview#Close()
  endif
endfunction

function!  vimside#preview#Close()
  if s:is_open
    execute "pclose"
    let s:is_open = 0

    set previewheight=2
if 1
    augroup VIMSIDE_PREVIEW
      autocmd!
    augroup END
endif

    set previewheight=2
  endif
endfunction

function! vimside#preview#DOIT()
  let lines = [
      \ "PREVIEW LINE ONE",
      \ "PREVIEW LINE TWO",
      \ "PREVIEW LINE THREE",
      \ "PREVIEW LINE FOUR",
      \ "PREVIEW LINE FIVE"
      \ ]
  silent call vimside#preview#Display(lines)
  sleep 1
  let lines = [
      \ "ANOTHER LINE ONE",
      \ "ANOTHER LINE TWO",
      \ "ANOTHER LINE THREE",
      \ "ANOTHER LINE FOUR",
      \ "ANOTHER LINE FIVE"
      \ ]
  silent call vimside#preview#Display(lines)
endfunction
