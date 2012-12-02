" ============================================================================
" search.vim
"
" File:          search.vim
" Summary:       Vimside Search
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:close_list_when_empty_option = 0
let s:do_incremental_search_option = 1

let s:words = []
let s:list_display_open = 0
let s:min_chars = 2
let s:start_phrase = 'Search Terms> '
let s:line = ''

function! s:Init()
  let [found, value] = g:vimside.GetOption('tailor-symbol-search-close-empty-display')
  if ! found
    throw "Option not found: "'tailor-symbol-search-close-empty-display'"
  endif
  let s:close_list_when_empty_option = value

  let [found, value] = g:vimside.GetOption('tailor-symbol-search-do-incremental')
  if ! found
    throw "Option not found: "'tailor-symbol-search-do-incremental'"
  endif

  let s:do_incremental_search_option = value

  call setqflist([])
endfunction


function! s:AddToRecord()
  call s:LOG("s:AddToRecord: TOP")
  let new_word_list = split(s:line, ' ')
call s:LOG("s:AddToRecord: new_word_list=". string(new_word_list))

  let wslen = len(s:words)
  let nwlen = len(new_word_list)

  let words = []
  let gotnew = 0

  if wslen == 0
    for word in new_word_list
      if len(word) >= s:min_chars
        call add(words, word)
        let gotnew = 1
      endif
    endfor

  elseif wslen == nwlen
    let cnt = 0
    while cnt < wslen
      let word = s:words[cnt]
      let new_word = new_word_list[cnt]
      if word != new_word
        if len(new_word) >= s:min_chars
          call add(words, new_word)
        endif
        let gotnew = 1
      else
        call add(words, word)
      endif

      let cnt += 1
    endwhile

  elseif wslen < nwlen
    let words = copy(s:words)
    let cnt = wslen
    while cnt < nwlen
      let new_word = new_word_list[cnt]
      if len(new_word) >= s:min_chars
        call add(words, new_word)
        let gotnew = 1
      endif

      let cnt += 1
    endwhile

  elseif " wslen > nwlen
    let cnt = 0
    while cnt < nwlen
      let new_word = new_word_list[cnt]
      if len(new_word) >= s:min_chars
        call add(words, new_word)
        let gotnew = 1
      endif

      let cnt += 1
    endwhile
  endif

  let s:words = words

call s:LOG("s:AddToRecord: s:words=". string(s:words))
call s:LOG("s:AddToRecord: gotnew; ". gotnew)

  if gotnew
    let dic = {
          \ 'args': {
          \   'terms': copy(s:words)
          \ }
          \ }
    call vimside#swank#rpc#public_symbol_search#Run(dic)
  endif

call s:LOG("s:AddToRecord: BOTTOM")

  return gotnew
endfunction

function!  vimside#command#search#AddRecords(records)
  if empty(a:records) && s:close_list_when_empty_option
    if s:list_display_open 
      cclose
      let s:list_display_open = 0
    endif
  else
    call setqflist(a:records, 'r')

    if ! s:list_display_open 
      let s:list_display_open = 1
      copen
      setlocal nonu
      setlocal nocursorline
    endif
  endif

  call s:DisplayText()
endfunction

function! s:DisplayText()
  let text = "\r" . s:start_phrase . s:line
  echo text
  redraw
endfunction

function! vimside#command#search#Run()
call s:LOG("vimside#command#search#Run TOP") 
  call s:Init()
  let s:list_display_open = 0

  let s:line = ''
  call s:DisplayText()
  while 1
    let check_add = 0
    let nr = getchar()
    let c = nr2char(nr)
    if c == "\<CR>"
      echo "\r"
      if ! s:do_incremental_search_option && len(s:line) >= s:min_chars
        call s:AddToRecord()
      endif
      break

    elseif c == "\<Esc>"
      cclose
      redraw
      return

    elseif c == ' '
      let llen = len(s:line)
      if llen >= s:min_chars && s:line[llen-1] != ' '
        let s:line .= c
        let check_add = 1
      endif

    elseif nr == "\<Del>" || nr == "\<BS>"
" call s:LOG("vimside#command#search#Run BS") 
      let llen = len(s:line)
" call s:LOG("vimside#command#search#Run s:line=". s:line) 
" call s:LOG("vimside#command#search#Run llen=". llen) 
      if llen == 1
        let s:line = ''
" call s:LOG("vimside#command#search#Run XX s:line=". s:line) 
      elseif llen > 1
        let s:line = s:line[0: llen-2]
" call s:LOG("vimside#command#search#Run YY s:line=". s:line) 
      endif
      let check_add = 1
      
    elseif nr >= 32 && nr < 127
      let s:line .= c
      let check_add = 1
    endif

    if check_add 
      if s:do_incremental_search_option 
        call s:AddToRecord()
      endif
      call s:DisplayText()
    endif

call s:LOG("s:IO: s:line; ". s:line)
  endwhile

call s:LOG("vimside#command#search#Run BOTTOM") 
endfunction
