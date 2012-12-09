" ============================================================================
" refactor.vim
"
" File:          refactor.vim
" Summary:       Vimside Search
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:procedure_id = 0

" dic={
" ':procedure-id': 0, 
" ':changes': 
" [
" {':from': 627, ':text': 'XXXX', ':file': '/home/emberson/.vim/data/vimside/src/main/scala/com/megaanum/Foo.scala', ':to': 638}, 
" {':from': 538, ':text': 'XXXX', ':file': '/home/emberson/.vim/data/vimside/src/main/scala/com/megaanum/Foo.scala', ':to': 549}], 
" ':status': 'success', 
" ':refactor-type': 'rename'
" }

" sort by ':file'
" if ':file' equal, sort ':from' from biggest offset to smallest
" if ':from' equal, sort ':to' from biggest offset to smallest
function! s:SortChanges(c1, c2)
  let file1 = a:c1[':file']
  let file2 = a:c2[':file']

  if file1 == file2
    let f1 = a:c1[':from']
    let f2 = a:c2[':from']

    if f1 == f2
      let t1 = a:c1[':to']
      let t2 = a:c2[':to']

      if f1 == f2
        return 0
      elseif f1 == f2
        return -1
      else
        return 1
      endif

    elseif f1 > f2
      return -1
    else
      return 1
    endif

  elseif file1 > file2
    return 1
  else
    return -1
  endif
endfunction

" return [found, buffer_number]
function! s:GetBuffer(name)
call s:LOG("s:GetBuffer name=". a:name) 
  let cnt = 1
  let end = bufnr("$")
call s:LOG("s:GetBuffer end=". end) 
  while cnt <= end
call s:LOG("s:GetBuffer cnt=". cnt) 
    if bufexists(cnt)
      " full path of buffer name
      let bname = fnamemodify(bufname(cnt), ":p")
call s:LOG("s:GetBuffer bname=". bname) 
      if bname == a:name
call s:LOG("s:GetBuffer found cnt=". cnt) 
        return [1, cnt] 
      endif
    endif
    let cnt += 1
  endwhile
  return [0, -1] 
endfunction

" {':from': 627, ':text': 'XXXX', ':file': '/home/emberson/.vim/data/vimside/src/main/scala/com/megaanum/Foo.scala', ':to': 638}, 
function! s:ProcessChange(change)
  let change = a:change
  let file = change[':file']
  let from = change[':from']
  let to = change[':to']
  let text = change[':text']
  let text = substitute(text, '\\"', '"', "g")
"call s:LOG("s:ProcessChange file=". file) 
"call s:LOG("s:ProcessChange from=". from) 
"call s:LOG("s:ProcessChange to=". to) 
"call s:LOG("s:ProcessChange text=". text) 

  let [found, cfile] = vimside#util#GetCurrentFilename()
  if ! found
    call s:LOG("s:ProcessChange: no current file") 
    return
  endif
"call s:LOG("s:ProcessChange cfile=". cfile) 

  if file == cfile
    let [fline, fcolumn] = vimside#util#GetLineColumnFromOffset(from)
    let [tline, tcolumn] = vimside#util#GetLineColumnFromOffset(to)
  else
    let [fline, fcolumn] = vimside#util#GetLineColumnFromOffset(from, file)
    let [tline, tcolumn] = vimside#util#GetLineColumnFromOffset(to, file)
  endif
"call s:LOG("s:ProcessChange fline=". fline) 
"call s:LOG("s:ProcessChange fcolumn=". fcolumn) 
"call s:LOG("s:ProcessChange tline=". tline) 
"call s:LOG("s:ProcessChange tcolumn=". tcolumn) 

  let offset_diff = to - from
"call s:LOG("s:ProcessChange offset_diff=". offset_diff) 
  let line_diff = tline - fline
"call s:LOG("s:ProcessChange line_diff=". line_diff) 

  let ai_save = &ai
  let &ai = 0
  let cindent_save = &cindent
  let &cindent = 0
  let smartindent_samve = &smartindent
  let &smartindent = 0
  let indentexpr_save = &indentexpr
  let &indentexpr = ''
  let comments_save = &comments
  let &comments = ''

  try
    " Is the start offset at the end of a line. If so, goto next line
    let [fnline, fncolumn] = vimside#util#GetLineColumnFromOffset(from+1)
"call s:LOG("s:ProcessChange fnline=". fnline) 
"call s:LOG("s:ProcessChange fncolumn=". fncolumn) 
    if fnline == fline+1
      let fline = fnline
      let fcolumn = fncolumn
"call s:LOG("s:ProcessChange new fline=". fline) 
"call s:LOG("s:ProcessChange new fcolumn=". fcolumn) 
    endif

    if line_diff == 0

        if file == cfile
          execute fline
          if fcolumn == 0
            if offset_diff == 0
              execute "norm! s".text.""
            else
              execute "norm! ".offset_diff."s".text.""
            endif
          else
            if offset_diff == 0
              execute "norm! 0".(fcolumn+1)."ls".text.""
            else
              execute "norm! 0".(fcolumn+1)."l".offset_diff."s".text.""
            endif
          endif
        else
          " If the file is already loaded (and not current file) find its
          " buffer number, make changes to that buffer, and then return
          " to the current buffer. Hope this works.
          let [found, bnumber] = s:GetBuffer(file)
          if found
            let l:filetype = &filetype
            let current_bnumber = bufnr("%")
"call s:LOG("s:ProcessChange current_bnumber=". current_bnumber) 
"call s:LOG("s:ProcessChange bnumber=". bnumber) 

            " :execute "2b"
            execute ''. bnumber ."b"
            execute fline
            execute "norm! 0".(fcolumn+1)."l".offset_diff."s".text.""
            " execute "wq"
            
            execute ''. current_bnumber ."b"
            let &filetype = l:filetype
          else
            execute "sp ". file
            execute fline
            execute "norm! 0".(fcolumn+1)."l".n."s".text.""
            execute "wq"
          endif
        endif
      else

        if file == cfile
          execute fline
          if fcolumn == 0
            execute "norm! v". (line_diff-1) ."j". tcolumn ."ls". text
          else
            execute "norm! v". fcolumn ."l". (line_diff-1) ."j". tcolumn ."ls". text
          endif

        else
" call s:LOG("s:ProcessChange NOT SUPPORTED YET: diff lines different files") 

          " If the file is already loaded (and not current file) find its
          " buffer number, make changes to that buffer, and then return
          " to the current buffer. Hope this works.
          let [found, bnumber] = s:GetBuffer(file)
          if found
            let l:filetype = &filetype
            let current_bnumber = bufnr("%")
"call s:LOG("s:ProcessChange current_bnumber=". current_bnumber) 
"call s:LOG("s:ProcessChange bnumber=". bnumber) 

            execute ''. bnumber ."b"

            execute fline
            " execute "norm! 0".(fcolumn+1)."l".offset_diff."s".text.""

            if fcolumn == 0
              execute "norm! v". (line_diff-1) ."j". tcolumn ."ls". text
            else
              execute "norm! v". fcolumn ."l". (line_diff-1) ."j". tcolumn ."ls".text.""
            endif
            
            execute ''. current_bnumber ."b"
            let &filetype = l:filetype

          else
            execute "sp ". file

            execute fline
            "execute "norm! 0".(fcolumn+1)."l".n."s".text.""

            if fcolumn == 0
              execute "norm! v". (line_diff-1) ."j". tcolumn ."ls". text
            else
              execute "norm! v". fcolumn ."l". (line_diff-1) ."j". tcolumn ."ls". text
            endif

            execute "wq"

          endif
        endif
    endif

  finally
    let &ai = ai_save
    let &cindent = cindent_save
    let &smartindent = smartindent_samve
    let &indentexpr = indentexpr_save
    let &comments = comments_save
  endtry
endfunction

function! s:ProcessChanges(changes)
  let changes = a:changes

  for change in sort(changes, "s:SortChanges")
    call s:ProcessChange(change)
  endfor
endfunction

function! vimside#command#refactor#Handler_Ok(dic, ...)
call s:LOG("vimside#command#refactor#Handler_Ok TOP") 
  let dic = a:dic
call s:LOG("vimside#command#refactor#Handler_Ok dic=". string(dic)) 
  if has_key(dic, ':status')
    let status = dic[':status']

    if status == 'failure'
      let reason = dic[':reason']
      call vimside#cmdline#Display(reason)
      return

    elseif status != 'success'
      call s:ERROR("vimside#command#refactor#Handler_Ok: unknown status: ". string(status))
      return
    endif
  else
    call s:ERROR("vimside#command#refactor#Handler_Ok: No status: ". string(dic))
  endif

  if has_key(dic, ':refactor-type') 
    let refactor_type = dic[':refactor-type']
    if refactor_type == 'rename'
      " list of changes
      let changes = dic[':changes']
      call s:ProcessChanges(changes)

    elseif refactor_type == 'extractLocal'
      " list of changes
      let changes = dic[':changes']
      call s:ProcessChanges(changes)

    elseif refactor_type == 'extractMethod'
      " list of changes
      let changes = dic[':changes']
      call s:ProcessChanges(changes)

    elseif refactor_type == 'inlineLocal'
      " list of changes
      let changes = dic[':changes']
      call s:ProcessChanges(changes)
    
    elseif refactor_type == 'organizeImports'
      " list of changes
      let changes = dic[':changes']
      call s:ProcessChanges(changes)

    elseif refactor_type == 'addImport'
      " list of changes
      let changes = dic[':changes']
      call s:ProcessChanges(changes)

    else
      call s:ERROR("vimside#command#refactor#Handler_Ok: Bad refactor-type : ". string(refactor_type))
    endif
  else
    call s:ERROR("vimside#command#refactor#Handler_Ok: no refactor-type: ". string(refactor_type))
  endif
endfunction

" return [found, [file, start, end]]
function! s:GetCWordSelection()
" call s:LOG("s:GetCWordSelection TOP") 
  let old_name = expand("<cword>")
  let old_name_len = len(old_name)
" call s:LOG("s:GetCWordSelection old_name=". old_name) 

  let line = line(".")
" call s:LOG("s:GetCWordSelection line=". line) 
  let col = col(".")
  let start = 0
  let found = 0
  let line_str = getline(line)

  while ! found
    let idx = stridx(line_str, old_name, start)
" call s:LOG("s:GetCWordSelection idx=". idx) 
    if idx == -1
      break
    elseif idx <= col && col <= idx+old_name_len
      let start = idx
      let found = 1
    else
      let start = idx+1
    endif
  endwhile
  if idx == -1
" call s:LOG("s:GetCWordSelection idx=". idx) 
    return [0, ["", -1, -1]]
  endif
  let offset_line = line2byte(line)
  let offset_start = offset_line + idx 
  let offset_end = offset_start + old_name_len - 1

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
" call s:LOG("s:GetCWordSelection NO FILE NAME") 
    return [0, ["", -1, -1]]
  else
" call s:LOG("s:GetCWordSelection fn=". fn) 
    return [1, [fn, offset_start, offset_end]]
  endif
endfunction

function! s:GetText(start, end)
  let [sline, scolumn] = vimside#util#GetLineColumnFromOffset(a:start)
  let [eline, ecolumn] = vimside#util#GetLineColumnFromOffset(a:end)

  if sline == eline
    if scolumn == ecolumn
      return [ '' ]
    elseif scolumn < ecolumn
      return [ getline(sline)[scolumn : ecolumn] ]
    else
      return [ getline(sline)[ecolumn : ccolumn] ]
    endif
  else
    if sline < eline
      let start = sline
      let end = eline
    else
      let start = eline
      let end = sline
    endif
    let lines = []
    call add(lines, getline(start)[scolumn : ])

    let cnt = start + 1
    while cnt < (end - 1)
      call add(lines, getline(cnt))
      let cnt += 1
    endwhile

    call add(lines, getline(end)[0 : ecolumn])

    return lines
  endif
endfunction

function! s:GetInput(prompt, ...)
  let name = ''
  let prompt = a:prompt .": > "

  call vimside#scheduler#HaltFeedKeys()
  try
    if a:0 == 1
      let pattern = a:1
"call s:LOG("s:GetInput: pattern=". pattern) 
      let got_name = 0
      let name = input(prompt)
      while ! got_name
        if name == ''
          let got_name = 1
        else
          let mname = matchstr(name, pattern)
          if mname == name
            let got_name = 1
          else
            echo "\r"
            let name = input("Bad name:'". name ."'\nPattern: '". pattern."'\n". prompt)
          endif
        endif
      endwhile
    else
      let name = input(prompt)
    endif
  finally
    call vimside#scheduler#ResumeFeedKeys()
  endtry

  echo "\r". repeat(' ', len(prompt)+len(name)+1)
  return name
endfunction

"=================================================
function! vimside#command#refactor#Rename()
call s:LOG("vimside#command#refactor#Rename TOP") 
  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#Rename NO FILE") 
    return
  endif

  let [found, offset_start, offset_end] = vimside#command#GetVisualSelection()
  if ! found
    let [found, slist] = vimside#command#selection#Get()
    if ! found 
      let [found, slist] = s:GetCWordSelection()
      if ! found 
call s:ERROR("vimside#command#refactor#Rename failed to get selection") 
        return
      endif
    endif
    let [fn, offset_start, offset_end] = slist
  endif

  let old_name = s:GetText(offset_start, offset_end)[0]
 
  let [found, pattern_use] = g:vimside.GetOption('tailor-refactor-rename-pattern-enable')
  if ! found
    throw "Option not found: "'tailor-refactor-rename-pattern-enable'"
  endif

  let prompt = "Rename: '". old_name ."'"
  if pattern_use
    let [found, pattern] = g:vimside.GetOption('tailor-refactor-rename-pattern')
    if ! found
      throw "Option not found: "'tailor-refactor-rename-pattern'"
    endif

    let name = s:GetInput(prompt, pattern)
  else
    let name = s:GetInput(prompt)
  endif  

  if name == ''
    return
  endif

  let l:procedure_id = s:procedure_id
  let s:procedure_id += 1

  let args = {}
  let args['procedure_id'] = procedure_id
  let args['symbol'] = 'rename'
  let args['params'] = [ 
                  \ 'file', fn,
                  \ 'start', offset_start, 
                  \ 'end', offset_end, 
                  \ 'newName', name
                  \ ]

  let info = {
        \ 'handler': {
        \   'ok': function("vimside#command#refactor#Handler_Ok")
        \ },
        \ 'args': args
        \ }

  call vimside#swank#rpc#prepare_refactor#Run(info)

call s:LOG("vimside#command#refactor#Rename BOTTOM") 
endfunction

function! vimside#command#refactor#OrganizeImports()
call s:LOG("vimside#command#refactor#OrganizeImports TOP") 
  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#OrganizeImports NO FILE") 
    return
  endif

  let l:procedure_id = s:procedure_id
  let s:procedure_id += 1

  let args = {}
  let args['procedure_id'] = procedure_id
  let args['symbol'] = 'organizeImports'
  let args['params'] = [ 
                  \ 'file', fn
                  \ ]

  let info = {
        \ 'handler': {
        \   'ok': function("vimside#command#refactor#Handler_Ok")
        \ },
        \ 'args': args
        \ }

  call vimside#swank#rpc#prepare_refactor#Run(info)
call s:LOG("vimside#command#refactor#OrganizeImports BOTTOM") 
endfunction

"---------------------------------------------------------------------------
" vimside#command#refactor#ExtractLocal: {{{2
"   TODO
"
" parameters: 
"---------------------------------------------------------------------------
function! vimside#command#refactor#ExtractLocal()
call s:LOG("vimside#command#refactor#ExtractLocal TOP") 

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#ExtractLocal NO FILE") 
    return
  endif

  let [found, offset_start, offset_end] = vimside#command#GetVisualSelection()
  if ! found
    let [found, slist] = vimside#command#selection#Get()
    if ! found 
call s:ERROR("vimside#command#refactor#ExtractMethod failed to get selection") 
      return
    endif
    let [fn, offset_start, offset_end] = slist
  else
    " extend visual selection a little
    let offset_start -= 1
  endif

call s:LOG("vimside#command#refactor#ExtractLocal offset_start=". offset_start)
call s:LOG("vimside#command#refactor#ExtractLocal offset_end=". offset_end) 
  
  let [found, pattern_use] = g:vimside.GetOption('tailor-refactor-extract-local-pattern-enable')
  if ! found
    throw "Option not found: "'tailor-refactor-extract-local-pattern-enable'"
  endif

  let prompt = "Extract Local"
  if pattern_use
    let [found, pattern] = g:vimside.GetOption('tailor-refactor-extract-local-pattern')
    if ! found
      throw "Option not found: "'tailor-refactor-extract-local-pattern'"
    endif

    let name = s:GetInput(prompt, pattern)
  else
    let name = s:GetInput(prompt)
  endif  

  if name == ''
    return
  endif

call s:LOG("vimside#command#refactor#ExtractLocal name=". name) 

    let l:procedure_id = s:procedure_id
    let s:procedure_id += 1

    let args = {}
    let args['procedure_id'] = procedure_id
    let args['symbol'] = 'extractLocal'
    let args['params'] = [ 
                    \ 'file', fn,
                    \ 'start', offset_start, 
                    \ 'end', offset_end, 
                    \ 'name', name
                    \ ]

    let info = {
          \ 'handler': {
          \   'ok': function("vimside#command#refactor#Handler_Ok")
          \ },
          \ 'args': args
          \ }

    call vimside#swank#rpc#prepare_refactor#Run(info)

call s:LOG("vimside#command#refactor#ExtractLocal BOTTOM") 
endfunction

function! vimside#command#refactor#ExtractMethod() 
call s:LOG("vimside#command#refactor#ExtractMethod TOP") 

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#ExtractMethod NO FILE") 
    return
  endif

  let [found, pattern_use] = g:vimside.GetOption('tailor-refactor-extract-method-pattern-enable')
  if ! found
    throw "Option not found: "'tailor-refactor-extract-method-pattern-enable'"
  endif

  let prompt = "Extract Method"
  if pattern_use
    let [found, pattern] = g:vimside.GetOption('tailor-refactor-extract-method-pattern')
    if ! found
      throw "Option not found: "'tailor-refactor-extract-method-pattern'"
    endif

    let name = s:GetInput(prompt, pattern)
  else
    let name = s:GetInput(prompt)
  endif  

  if name == ''
    return
  endif
call s:LOG("vimside#command#refactor#ExtractMethod name=". name) 

  let [found, offset_start, offset_end] = vimside#command#GetVisualSelection()
  if ! found
    let [found, slist] = vimside#command#selection#Get()
    if ! found 
call s:ERROR("vimside#command#refactor#ExtractMethod failed to get selection") 
      return
    endif
    let [fn, offset_start, offset_end] = slist
  endif

call s:LOG("vimside#command#refactor#ExtractMethod offset_start=". offset_start)
call s:LOG("vimside#command#refactor#ExtractMethod offset_end=". offset_end) 
  
    let l:procedure_id = s:procedure_id
    let s:procedure_id += 1

    let args = {}
    let args['procedure_id'] = procedure_id
    let args['symbol'] = 'extractMethod'
    let args['params'] = [ 
                    \ 'file', fn,
                    \ 'start', offset_start, 
                    \ 'end', offset_end, 
                    \ 'methodName', name
                    \ ]

    let info = {
          \ 'handler': {
          \   'ok': function("vimside#command#refactor#Handler_Ok")
          \ },
          \ 'args': args
          \ }

    call vimside#swank#rpc#prepare_refactor#Run(info)
call s:LOG("vimside#command#refactor#ExtractMethod BOTTOM") 
endfunction

function! vimside#command#refactor#InlineLocal()
call s:LOG("vimside#command#refactor#InlineLocal TOP") 

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#InlineLocal NO FILE") 
    return
  endif

  let [found, offset_start, offset_end] = vimside#command#GetVisualSelection()
  if ! found
    let [found, slist] = vimside#command#selection#Get()
    if ! found 
call s:ERROR("vimside#command#refactor#InlineLocal failed to get selection") 
      return
    endif
    let [fn, offset_start, offset_end] = slist
  endif

call s:LOG("vimside#command#refactor#InlineLocal offset_start=". offset_start)
call s:LOG("vimside#command#refactor#InlineLocal offset_end=". offset_end) 
  
    let l:procedure_id = s:procedure_id
    let s:procedure_id += 1

    let args = {}
    let args['procedure_id'] = procedure_id
    let args['symbol'] = 'inlineLocal'
    let args['params'] = [ 
                    \ 'file', fn,
                    \ 'start', offset_start, 
                    \ 'end', offset_end
                    \ ]

    let info = {
          \ 'handler': {
          \   'ok': function("vimside#command#refactor#Handler_Ok")
          \ },
          \ 'args': args
          \ }

    call vimside#swank#rpc#prepare_refactor#Run(info)

call s:LOG("vimside#command#refactor#InlineLocal BOTTOM") 
endfunction

function! vimside#command#refactor#AddImport()
call s:LOG("vimside#command#refactor#AddImport: TOP") 

  let name = s:GetInput("Enter Import")
  if name != ''
    call s:DoAddImport(name)
  endif

call s:LOG("vimside#command#refactor#AddImport: BOTTOM") 
endfunction

function! s:DoAddImport(name)

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#AddImport NO FILE") 
    return
  endif


  let l:procedure_id = s:procedure_id
  let s:procedure_id += 1

  let args = {}
  let args['procedure_id'] = procedure_id
  let args['symbol'] = 'addImport'
  let args['params'] = [ 
                  \ 'file', fn,
                  \ 'start', 0, 
                  \ 'end', 0, 
                  \ 'qualifiedName', a:name
                  \ ]

  let info = {
        \ 'handler': {
        \   'ok': function("vimside#command#refactor#Handler_Ok")
        \ },
        \ 'args': args
        \ }

  call vimside#swank#rpc#prepare_refactor#Run(info)

endfunction










function! vimside#command#refactor#ImportSuggestionHandler_Ok(dic, ...)
call s:LOG("vimside#command#refactor#ImportSuggestionHandler_Ok TOP") 
  let dic = a:dic
"call s:LOG("vimside#command#refactor#ImportSuggestionHandler_Ok dic=". string(dic)) 
  if type(dic) != type([])
      call s:ERROR("vimside#command#refactor#ImportSuggestionHandler_Ok: Result not list: ". string(dic))
      return
  endif
  let name_list = dic[0]

  if type(name_list) != type([])
      call s:ERROR("vimside#command#refactor#ImportSuggestionHandler_Ok: Not list of Dictionaries: ". string(name_list))
      return
  endif

  let echos = ''
  let nlen = len(name_list)
  let cnt = 1
  while cnt <= nlen
    if cnt > 1
      let echos .= "\n"
    endif
    let entry = name_list[cnt-1]

    let l = ''
    if cnt < 10
      let l .= ' '
    endif
    let l .= cnt
    let l .= ' "'
    if has_key(entry, ':name')
      let l .= entry[':name']
    else
      let l .= 'ERROR'
    endif
    let l .= '"'

" call s:LOG("vimside#command#refactor#ImportSuggestionHandler_Ok l=". l) 
    " echo l
    let echos .= l

    let cnt += 1
  endwhile

  call vimside#scheduler#HaltFeedKeys()
  try
    while 1
      let rval = input(echos . "\nType number and <Enter> (empty cancels): ")
      if rval == ''
        break
      endif
      let n = 0 + rval
      let s = '' . n
      if s != rval
        echo "Bad number: " . rval
      else
        if n < 1
          echo "Number less than 1: " . rval
        elseif n > nlen
          echo "Number greater than: " . nlen
        else
          break
        endif
      endif
      redraw
    endwhile
  finally
    call vimside#scheduler#ResumeFeedKeys()
  endtry

  if rval != ''
    let entry = name_list[n-1]
    let name = entry[':name']
    call s:DoAddImport(name)
  endif

if 0
  redraw
  if rval == ''
    echo "\r"
  else
    let entry = name_list[n-1]
    echo "\rName: " . entry[':name']
  endif
endif
endfunction

function! vimside#command#refactor#ImportSuggestions()
call s:LOG("vimside#command#refactor#ImportSuggestions: TOP") 

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
call s:LOG("vimside#command#refactor#ImportSuggestions NO FILE") 
    return
  endif

  let [found, offset_start, offset_end] = vimside#command#GetVisualSelection()
  if ! found
    let [found, slist] = vimside#command#selection#Get()
    if ! found 
      let [found, slist] = s:GetCWordSelection()
      if ! found 
call s:ERROR("vimside#command#refactor#ImportSuggestions failed to get selection") 
        return
      endif
    endif
    let [fn, offset_start, offset_end] = slist
  endif

  let name = s:GetText(offset_start, offset_end)[0]
call s:LOG("vimside#command#refactor#ImportSuggestions name=". name) 

  let l:procedure_id = s:procedure_id
  let s:procedure_id += 1

  let args = {}
  let args['filename'] = fn
  let args['offset'] = offset_start
  let args['names'] = [ name ]
  let args['maximum'] = 10

  let info = {
        \ 'handler': {
        \   'ok': function("vimside#command#refactor#ImportSuggestionHandler_Ok")
        \ },
        \ 'args': args
        \ }

  call vimside#swank#rpc#import_suggestions#Run(info)

call s:LOG("vimside#command#refactor#ImportSuggestions: BOTTOM") 
endfunction
