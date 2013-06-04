
"
" category
"  abbreviation = ""
"  kinds = {}
"  ids = {}
"
"
" :exe ":sign place 2 line=23 name=qfx_error file=" . expand("%:p")
" :sign unplace 2

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:is_sign_init = 0

let s:categories = {}

let [found, s:sign_start_place_id] = g:vimside.GetOption('sign-start-place-id')
if ! found
  throw "Option not found: sign-start-place-id"
endif

let s:next_place_id = s:sign_start_place_id

" ==============================================
" Utils
" ==============================================

function! s:GetNextId()
  let l:id = s:next_place_id
  let s:next_place_id += 1
  return l:id
endfunction

" ==============================================
" INIT
" ==============================================
function! s:sign_init()
  if ! s:is_sign_init 

    " call external function to load additional categories

    let s:is_sign_init = 1
  endif
endfunction


" ==============================================
" API
" ==============================================

function! vimside#sign#AddCategory(category, cdata)
call s:LOG("vimside#sign#AddCategory: TOP")
call s:LOG("vimside#sign#AddCategory: category=". a:category)
  if has_key(s:categories, a:category)
    throw "Category name: ". a:category . " already in use"
  endif
  if ! has_key(a:cdata, 'category')
    throw "Category does not have category attribute"
  endif
  if ! has_key(a:cdata, 'abbreviation')
    throw "Category does not have abbreviation attribute"
  endif
  if ! has_key(a:cdata, 'kinds')
    throw "Category does not have kinds attribute"
  endif
  if ! has_key(a:cdata, 'ids')
    let a:cdata['ids'] = {}
  endif

  let kinds = a:cdata['kinds']
  if type(kinds) != type({})
    throw "Category kinds attribute not a Dictionary"
  endif

  for [kname, kdata] in items(kinds)
    if ! has_key(kdata, 'linehl')
      throw "Category kind data: ". kname ." does not have linehl attribute"
    endif
    if ! has_key(kdata, 'texthl')
      throw "Category kind data: ". kname ." does not have texthl attribute"
    endif
    if ! has_key(kdata, 'text')
      throw "Category kind data: ". kname ." does not have text attribute"
    endif

    let text = kdata['text']
    if len(text) > 2
      throw "Category kind data: ". kname ." text attribute too large: ". len(text)
    endif

  endfor

  let s:categories[a:category] = a:cdata
  call s:loadCategory(a:cdata)
call s:LOG("vimside#sign#AddCategory: BOTTOM")
endfunction

" ==============================================
" LOAD
" ==============================================

function! s:loadCategory(cdata)
call s:LOG("s:loadCategory: TOP")
  let l:cdata = a:cdata
  let l:kinds = a:cdata.kinds
  let l:abbrev = l:cdata.abbreviation
  for [kname, kdata] in items(kinds)
    let cmd = ':sign define '. l:abbrev .'_'. kname
    let cmd .= ' linehl='. kdata.linehl
    let cmd .= ' texthl='. kdata.texthl
    let cmd .= ' text='. kdata.text
" echo "cmd=" . cmd
    execute cmd
  endfor
call s:LOG("s:loadCategory: BOTTOM")
endfunction


" ==============================================
" Helpers
" ==============================================

" returns [found, kdata]
function! s:GetKindData(cdata, kind)
  let l:kinds = a:cdata.kinds
  for [kname, kdata] in items(kinds)
    if kname == a:kind
      return [1, kdata]
    endif
  endfor
  return [0, {}]
endfunction

" returns [found, id]
function! s:GetId(linenos, filename, ids)
  for [id, finfo] in items(a:ids)
    let [fn, ln, kind] = finfo
    if fn == a:filename && ln == a:linenos
      return [1, id]
    endif
  endfor
  return [0, -1]
endfunction

" ==============================================
" Actions
" ==============================================

" ==============================================
" Place
" ==============================================

" takes list of { "file": file, "line": line }
function! vimside#sign#PlaceMany(line_file_List, category, kind)
call s:LOG("vimside#sign#PlaceMany: TOP")
call s:LOG("vimside#sign#PlaceMany: category=". a:category)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:cdata = s:categories[a:category]
  let l:abbrev = cdata.abbreviation
  let ids = l:cdata.ids

  for dic in a:line_file_List 
    let l:file = dic["file"]
    let l:line = dic["line"]

    let l:id = s:GetNextId()
    let l:name = l:abbrev .'_'. a:kind
    let l:file = fnamemodify(l:file, ":p")
    execute ':sign place '. l:id .' line='. l:line .' name='. l:name .' file='. l:file
  let ids[l:id] = [l:file, l:line, a:kind]
  endfor

call s:LOG("vimside#sign#PlaceMany: BOTTOM")
endfunction

function! vimside#sign#Place(linenos, filename, category, kind)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:filename = fnamemodify(a:filename, ":p")
  let l:cdata = s:categories[a:category]
  let l:abbrev = cdata.abbreviation

  let l:id = s:GetNextId()
  let l:name = l:abbrev .'_'. a:kind

  execute ':sign place '. l:id .' line='. a:linenos .' name='. l:name .' file='. l:filename

  let ids = l:cdata.ids
  let ids[l:id] = [l:filename, a:linenos, a:kind]
endfunction

" ==============================================
" UnPlace
" ==============================================

" TODO seems to be the same as the Clear function
function! vimside#sign#UnPlace(linenos, filename, category, kind)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:filename = fnamemodify(a:filename, ":p")
  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids

  let [l:found, id] = s:GetId(a:linenos, l:filename, l:ids)
  if l:found 
    execute ':sign unplace '. id .' file='. l:filename
    unlet l:ids[id]
  else
    echo "Bad filename: ". l:filename ." and linenos: ". a:linenos
  endif
endfunction

" ==============================================
" Change Type
" ==============================================

function! vimside#sign#ChangeKind(linenos, filename, category, to_kind)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:filename = fnamemodify(a:filename, ":p")
  let l:cdata = s:categories[a:category]
  let l:abbrev = cdata.abbreviation
  let l:ids = l:cdata.ids

  let [l:found, id] = s:GetId(a:linenos, l:filename, l:ids)
  if l:found 
    let l:name = l:abbrev .'_'. a:to_kind
    execute ':sign place '. id ' name='. l:name .' file='. l:filename
  else
    echo "Bad filename: ". l:filename ." and linenos: ". a:linenos
  endif
endfunction

function! vimside#sign#ChangeKindKind(category, from_kind, to_kind)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids
  let l:name = l:abbrev .'_'. a:to_kind

  for [id, finfo] in items(l:ids)
    let [fn, ln, kind] = finfo
    if kind == a:from_kind
      execute ':sign place '. id ' name='. l:name .' file='. l:filename
      let finfo[2] = a:to_kind
    endif
  endfor
endfunction

" ==============================================
" Clear
" ==============================================

function! vimside#sign#Clear(linenos, filename, category)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:filename = fnamemodify(a:filename, ":p")
  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids

  let [l:found, id] = s:GetId(a:linenos, l:filename, l:ids)
  if l:found
    execute ':sign unplace '. id .' file='. l:filename
    unlet l:ids[id]
  endif
endfunction

function! vimside#sign#ClearKind(category, kind)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids

  for [id, finfo] in items(l:ids)
    let [fn, ln, kind] = finfo
    if kind == a:kind
      execute ':sign unplace '. id .' file='. fn
      unlet l:ids[id]
    endif
  endfor
endfunction

function! vimside#sign#ClearCategory(category)
  if ! has_key(s:categories, a:category)
    echo "Bad Category: ". a:category
    return
  endif
  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids

  for [id, finfo] in items(l:ids)
    let [fn, ln, kind] = finfo
    execute ':sign unplace '. id .' file='. fn
    unlet l:ids[id]
  endfor
endfunction


function! vimside#sign#ClearAtCursor()
  sign unplace

  let l:line = line(".")
  let l:filename = expand("%:p")

  for [name, cdata] in items(s:categories)
    let l:ids = cdata.ids
    let [l:found, id] = s:GetId(l:linenos, l:filename, l:ids)
    if l:found
      unlet l:ids[id]
    endif
  endfor
endfunction

function! vimside#sign#ClearAll()
  sign unplace *

  for [name, cdata] in items(s:categories)
    let cdata['ids'] = {}
  endfor
endfunction

" Initialize debug module
call s:sign_init()
