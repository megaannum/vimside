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
let s:do_incremental_search_option = 0
let s:maximum_return = 50

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
  unlet value

  let [found, value] = g:vimside.GetOption('tailor-symbol-search-do-incremental')
  if ! found
    throw "Option not found: "'tailor-symbol-search-do-incremental'"
  endif

  let s:do_incremental_search_option = value
  unlet value

  let [found, value] = g:vimside.GetOption('tailor-symbol-search-maximum-return')
  if ! found
    throw "Option not found: "'tailor-symbol-search-maximum-return'"
  endif

  let s:maximum_return = value

  call setqflist([])
endfunction


function! s:AddToRecord()
  call s:LOG("s:AddToRecord: TOP")
  let new_word_list = split(s:line, ' ')
" call s:LOG("s:AddToRecord: new_word_list=". string(new_word_list))

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

" call s:LOG("s:AddToRecord: s:words=". string(s:words))
" call s:LOG("s:AddToRecord: gotnew; ". gotnew)

  if gotnew
    let dic = {
          \ 'args': {
          \   'terms': copy(s:words),
          \   'maximum': s:maximum_return
          \ }
          \ }
    call vimside#swank#rpc#public_symbol_search#Run(dic)
  endif

" call s:LOG("s:AddToRecord: BOTTOM")

  return gotnew
endfunction

function! s:ResultSorterByNameLength(e1, e2)
  let name1 = a:e1[':name']
  let name2 = a:e2[':name']
  return len(name1) > len(name2) ? 1 : -1
endfunction

function! s:ResultSorterByClass(e1, e2)
  let e1 = a:e1
  let e2 = a:e2

  let t1 = -1
  let decl_as = e1[':decl-as']
  if decl_as == 'class'
    let n1 = e1[':name']
    let t1 = 0
  elseif decl_as == 'trait'
    let n1 = e1[':name']
    let t1 = 0
  elseif decl_as == 'interface'
    let n1 = e1[':name']
    let t1 = 0
  elseif decl_as == 'object'
    let n1 = e1[':name']
    let t1 = 0
  elseif decl_as == 'method'
    if has_key(e1, ':owner-name')
      let n1 = e1[':owner-name']
    else
      let n1 = e1[':name']
    endif
    let t1 = 1
  elseif decl_as == 'field'
    if has_key(e1, ':owner-name')
      let n1 = e1[':owner-name']
    else
      let n1 = e1[':name']
    endif
    let t1 = 2
  else
    let n1 = e1[':name']
    let t1 = 3
  endif

  let t2 = -1
  let decl_as = e2[':decl-as']
  if decl_as == 'class'
    let n2 = e2[':name']
    let t2 = 0
  elseif decl_as == 'trait'
    let n2 = e2[':name']
    let t2 = 0
  elseif decl_as == 'interface'
    let n2 = e2[':name']
    let t2 = 0
  elseif decl_as == 'object'
    let n2 = e2[':name']
    let t2 = 0
  elseif decl_as == 'method'
    if has_key(e2, ':owner-name')
      let n2 = e2[':owner-name']
    else
      let n2 = e2[':name']
    endif
    let t2 = 1
  elseif decl_as == 'field'
    if has_key(e2, ':owner-name')
      let n2 = e2[':owner-name']
    else
      let n2 = e2[':name']
    endif
    let t2 = 2
  else
    let n2 = e2[':name']
    let t2 = 3
  endif

  if n1 == n2 " class names the same, class before method before field
    if t1 < t2
      return -1
    elseif t2 < t1
      return 1
    else
      let ln1 = e1[':local-name']
      let ln2 = e2[':local-name']
      if ln1 == ln2 " local names the same
        return 0
      elseif ln1 < ln2
        return -1
      else
        return 1
      endif

    endif
  else " class names not the same, shorter class first
    let l1 = len(n1)
    let l2 = len(n2)

    if l1 < l2
      return -1
    elseif l2 < l1
      return 1
    elseif n1 < n2
      return -1
    else
      return 1
    endif
  endif
endfunction


function!  vimside#command#search#ProcessSymbolSearchResults(results)
  let results = a:results

  let records = []
  let cnt = 0
  for item in sort(results, function("s:ResultSorterByClass"))
    let pos = item[':pos']
    let file = pos[':file']
    let offset = pos[':offset']
    let name = item[':name']
"call s:LOG("ProcessSymbolSearchResults name=".  string(name)) 


    let decl_as = item[':decl-as']
    let text = ''. decl_as .':'

    if decl_as == 'class'
      let text .= name
    elseif decl_as == 'trait'
      let text .= name
    elseif decl_as == 'interface'
      let text .= name
    elseif decl_as == 'object'
      let text .= name
    elseif decl_as == 'method'
      if has_key(item, ':owner-name')
        let owner_name = item[':owner-name']
        let local_name = item[':local-name']
        let text .= owner_name .':'. local_name
      else
        let text .= name
      endif
    elseif decl_as == 'field'
      if has_key(item, ':owner-name')
        let owner_name = item[':owner-name']
        let local_name = item[':local-name']
        let text .= owner_name .':'. local_name
      else
        let text .= name
      endif
    else
      let text .= name
    endif

    let [line, column] = vimside#util#GetLineColumnFromOffset(offset, file)

    let record = {}
    let record['filename'] = file
    let record['lnum'] = line
    let record['col'] = column
    let record['vcol'] = 1
    let record['text'] = text
    let record['type'] = 'r'
    let record['nr'] = cnt

    call add(records, record)

    let cnt += 1
  endfor

  call vimside#command#search#AddRecords(records)
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
      setlocal nocursorcolumn
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
" call s:LOG("vimside#command#search#Run TOP") 
  call vimside#scheduler#HaltFeedKeys()
  
  try

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
          call s:DisplayText()
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
        call s:DisplayText()
        if s:do_incremental_search_option 
          call s:AddToRecord()
        endif
      endif

"call s:LOG("s:IO: s:line; ". s:line)
    endwhile

  finally
   call vimside#scheduler#ResumeFeedKeys()
  endtry


" call s:LOG("vimside#command#search#Run BOTTOM") 
endfunction
