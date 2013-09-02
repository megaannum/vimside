
"
" cdata
"  abbreviation: ""
"  category: name
"  kinds = { kname: { text, texthl, linehl } }
"  ids = {id:  [typetag, file/buffer, line, kind] }
"
" :exe ":sign place 2 line=23 name=qfx_error file=" . expand("%:p")
" :sign unplace 2

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:is_sign_init = 0
let s:sign_toggle_name = 'empty'

let s:categories = {}

try
let [found, s:sign_start_place_id] = g:vimside.GetOption('sign-start-place-id')
if ! found
  throw "Option not found: sign-start-place-id"
endif
catch /.*/
  let s:sign_start_place_id = 42
endtry

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

    execute ":sign define ".  s:sign_toggle_name

    let s:is_sign_init = 1
  endif
endfunction


" ==============================================
" API
" ==============================================

function! vimside#sign#HasCategory(category)
  return has_key(s:categories, a:category)
endfunction

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

  let l:kinds = a:cdata.kinds
  if type(l:kinds) != type({})
    throw "Category kinds attribute not a Dictionary"
  endif

  for [kname, kdata] in items(l:kinds)
    if has_key(kdata, 'linehl') 
      if hlexists(kdata.linehl) == 0
        throw "Category kind data: ". kname ." bad linehl attribute: ". kdata.linehl
      endif
    else
      let kdata['linehl'] = ""
    endif
    if has_key(kdata, 'texthl') 
      if hlexists(kdata.texthl) == 0
        throw "Category kind data: ". kname ." bad texthl attribute: ". kdata.texthl
      endif
    else
      let kdata['texthl'] = ""
    endif
    if has_key(kdata, 'text') 
      if len(kdata.text) > 2
        throw "Category kind data: ". kname ." bad text attribute length"
      endif
    else
      let kdata['text'] = ""
    endif

  endfor

  let s:categories[a:category] = a:cdata
  call s:LoadCategory(a:cdata)
call s:LOG("vimside#sign#AddCategory: BOTTOM")
endfunction

" ==============================================
" LOAD
" ==============================================

function! s:LoadCategory(cdata)
call s:LOG("s:LoadCategory: TOP")
  let l:cdata = a:cdata
  let l:kinds = a:cdata.kinds
  let l:abbrev = l:cdata.abbreviation
  for [kname, kdata] in items(kinds)
    let cmd = ':sign define '. l:abbrev .'_'. kname
    if kdata.linehl != ""
      let cmd .= ' linehl='. kdata.linehl
    endif
    if kdata.texthl != ""
      let cmd .= ' texthl='. kdata.texthl
    endif
    if kdata.text != ""
      let cmd .= ' text='. kdata.text
    endif
" echo "cmd=" . cmd
call s:LOG("s:LoadCategory cmd=". cmd)
    execute cmd
  endfor

  if has_key(l:cdata, 'toggle')
    let l:toggle = l:cdata.toggle
    if type(l:toggle) == type("")
      let l:category = l:cdata.category

" call s:LOG("s:LoadCategory: toggle=" . l:toggle)
" call s:LOG("s:LoadCategory: category=" . l:category)

" call s:LOG("s:LoadCategory: map= :nnoremap <silent> <Leader>" . l:toggle . " :call vimside#sign#Toggle('". l:category ."')<CR>")

      execute ":nnoremap <silent> <Leader>" . l:toggle . " :call vimside#sign#Toggle('". l:category ."')<CR>"

      let l:cdata['is_toggle'] = 0
call s:LOG("s:LoadCategory: toggle mapping made")
    endif
  endif

call s:LOG("s:LoadCategory: BOTTOM")
endfunction


" ==============================================
" Helpers
" ==============================================

" returns [found, kdata]
function! s:GetKindData(cdata, kind)
  let l:kinds = a:cdata.kinds
  if has_key(l:kinds, a:kind) 
    return [1, l:kinds[a:kind]]
  else 
    return [0, {}]
  endif

if 0 " REMOVE
  for [kname, kdata] in items(kinds)
    if kname == a:kind
      return [1, kdata]
    endif
  endfor
  return [0, {}]
endif " REMOVE
endfunction

" returns [found, id]
function! s:GetId(linenos, tag, ids)
  for [id, finfo] in items(a:ids)
    let [tagtype, tag, ln, kind] = finfo
    if tag == a:tag && ln == a:linenos
      return [1, id]
    endif
    unlet tag
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
"           and { "buffer": nr, "line": line }
" return 0 or 1
function! vimside#sign#PlaceMany(line_tag_List, category, kind)
call s:LOG("vimside#sign#PlaceMany: TOP")
call s:LOG("vimside#sign#PlaceMany: category=". a:category)
  if ! has_key(s:categories, a:category)
    echo "PlaceMany Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if ! has_key(l:kinds, a:kind) 
    echo "Bad Kind: ". a:kind ." for Category " . a.category
    return 0
  endif

  let l:abbrev = cdata.abbreviation
  let ids = l:cdata.ids

  for l:dic in a:line_tag_List 
    let l:line = l:dic["line"]
    let l:id = s:GetNextId()
    let l:name = l:abbrev .'_'. a:kind

    if has_key(l:dic, 'file') && bufnr(l:dic.file) > 0
      let l:file = l:dic.file

      let l:file = fnamemodify(l:file, ":p")
      execute ':sign place '. l:id .' line='. l:line .' name='. l:name .' file='. l:file
      let ids[l:id] = ['file', l:file, l:line, a:kind]

    elseif has_key(l:dic, 'buffer')
      let l:buffer = l:dic["buffer"]

      execute ':sign place '. l:id .' line='. l:line .' name='. l:name .' buffer='. l:buffer
      let ids[l:id] = ["buffer", l:buffer, l:line, a:kind]

    else
      throw "Missing sign place file/buffer"
    endif

  endfor
call s:LOG("vimside#sign#PlaceMany: BOTTOM")
  return 1
endfunction

" return 0 or 1
function! vimside#sign#PlaceFile(linenos, filename, category, kind)
  let l:filename = fnamemodify(a:filename, ":p")
  return s:PlaceTag(a:linenos, "file", l:filename, a:category, a:kind)
endfunction
function! vimside#sign#PlaceBuffer(linenos, buffer, category, kind)
  return s:PlaceTag(a:linenos, "buffer", a:buffer, a:category, a:kind)
endfunction

function! s:PlaceTag(linenos, tagtype, tag, category, kind)
  if ! has_key(s:categories, a:category)
    echo "PlaceTag Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if ! has_key(l:kinds, a:kind) 
    echo "Bad Kind: ". a:kind ." for Category " . a:category
    return 0
  endif

  let l:abbrev = cdata.abbreviation

  let l:id = s:GetNextId()
  let l:name = l:abbrev .'_'. a:kind
call s:LOG("s:PlaceTag: l:id=". l:id)
call s:LOG("s:PlaceTag: l:line=". a:linenos)
call s:LOG("s:PlaceTag: l:name=". l:name)
call s:LOG("s:PlaceTag: a:tagtype=". a:tagtype)
call s:LOG("s:PlaceTag: a:tag=". a:tag)

  execute ':sign place '. l:id .' line='. a:linenos .' name='. l:name .' '. a:tagtype .'='. a:tag

  let ids = l:cdata.ids
  let ids[l:id] = [a:tagtype, a:tag, a:linenos, a:kind]

  return 1
endfunction


" ==============================================
" UnPlace by file and optionally by line
" ==============================================

" TODO seems to be the same as the Clear function
" return 0 or 1
function! vimside#sign#UnPlaceFile(filename, category, kind, ...)
  let l:filename = fnamemodify(a:filename, ":p")
  if a:0 > 0
    return s:UnPlaceTag('file', l:filename, a:category, a:kind, a:1)
  else
    return s:UnPlaceTag('file', l:filename, a:category, a:kind)
  endif
endfunction
function! vimside#sign#UnPlaceBuffer(buffer, category, kind, ...)
  if a:0 > 0
    return s:UnPlaceTag('buffer', a:buffer, a:category, a:kind, a:1)
  else
    return s:UnPlaceTag('buffer', a:buffer, a:category, a:kind)
  endif
endfunction

function! s:UnPlaceTag(tagtype, tag, category, kind, ...)
  if ! has_key(s:categories, a:category)
    echo "UnPlaceTag Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if ! has_key(l:kinds, a:kind) 
    echo "Bad Kind: ". a:kind ." for Category " . a.category
    return 0
  endif

call s:LOG("s:UnPlaceTag: a:tagtype=". a:tagtype)
call s:LOG("s:UnPlaceTag: a:tag=". a:tag)
call s:LOG("s:UnPlaceTag: a:category=". a:category)

  if a:0 > 0
    let l:linenos = a:1
    let l:ids = l:cdata.ids
call s:LOG("s:UnPlaceTag: l:linenos=". l:linenos)

    let [l:found, id] = s:GetId(l:linenos, a:tag, l:ids)
    if l:found 
call s:LOG("s:UnPlaceTag: l:id=". l:id)
      execute ':sign unplace '. id .' '. a:tagtype .'='. a:tag
      unlet l:ids[id]
      return 1
    else
      echo "Bad tag: ". a:tag ." and linenos: ". l:linenos
      return 0
    endif
  else
call s:LOG("s:UnPlaceTag: all for =". a:tag)
    execute ':sign unplace * '. a:tagtype .'='. a:tag
    let l:cdata['ids'] = {}
  endif

endfunction

" ==============================================
" Empty
" ==============================================

" TODO seems to be the same as the Clear function
" return 0 or 1
function! vimside#sign#EmptyFile(linenos, filename, category, kind)
  let l:filename = fnamemodify(a:filename, ":p")
  return s:EmptyTag(a:linenos, 'file', l:filename, a:category, a:kind)
endfunction
function! vimside#sign#EmptyBuffer(linenos, buffer, category, kind)
  return s:EmptyTag(a:linenos, 'buffer', a:buffer, a:category, a:kind)
endfunction

function! s:EmptyTag(linenos, tagtype, tag, category, kind)
  if ! has_key(s:categories, a:category)
    echo "EmptyTag Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids


  let [l:found, l:id] = s:GetId(a:linenos, a:tag, l:ids)
  if l:found 
    execute ':sign unplace '. l:id .' '. a:tagtype .'='. a:tag
    unlet l:ids[l:id]

    let l:id = s:GetNextId()
    let l:name = s:sign_toggle_name 
    execute ':sign place '. l:id .' line='. a:linenos .' name='. l:name .' '. a:tagtype .'='. a:tag
    let ids[l:id] = [a:tagtype, a:tag, a:linenos, a:kind]

    return 1
  else
    echo "Bad tag: ". a:tag ." and linenos: ". a:linenos
    return 0
  endif
endfunction

" ==============================================
" Toggle
" ==============================================

" return 0 or 1
function! vimside#sign#Toggle(category, ...)
  if ! has_key(s:categories, a:category)
    echo "Toggle Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  if has_key(l:cdata, 'is_toggle')
    let l:cdata.is_toggle = ! l:cdata.is_toggle
    let l:is_toggle = l:cdata.is_toggle
  elseif a:0 > 0
    let l:is_toggle = a:1
  else
    return 0
  endif

  let l:ids = l:cdata.ids

  if l:is_toggle
    let l:name = s:sign_toggle_name 
    for [id, finfo] in items(l:ids)
      let [tagtype, tag, ln, kind] = finfo
      execute ':sign place '. id .' name='. l:name .' '. tagtype .'='. tag
      unlet tag
    endfor
  else
    let l:abbrev = cdata.abbreviation
    for [id, finfo] in items(l:ids)
      let [tagtype, tag, ln, kind] = finfo
      let l:name = l:abbrev .'_'. kind
      execute ':sign place '. id ' name='. l:name .' '. tagtype .'='. tag
      unlet tag
    endfor
  endif

  return 1
endfunction

" return 0 or 1
function! vimside#sign#ToggleKind(category, kind, ...)
  if ! has_key(s:categories, a:category)
    echo "ToggleKind Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if has_key(l:kinds, a:kind) 
    let l:kind = l:kinds[a:kind]
  else
    echo "Bad Kind: ". a:kind ." for Category " . a.category
    return 0
  endif

  if has_key(l:kind, 'is_toggle')
    let l:kind.is_toggle = ! l:kind.is_toggle
    let l:is_toggle = l:kind.is_toggle
  elseif a:0 > 0
    let l:is_toggle = a:1
  else
    return 0
  endif

  let l:ids = l:cdata.ids

  if l:is_toggle
    let l:name = s:sign_toggle_name 
    for [id, finfo] in items(l:ids)
      let [tagtype, tag, ln, kind] = finfo
      if kind == a:kind
        execute ':sign place '. id ' name='. l:name .' '. tagtype .'='. tag
      endif
      unlet tag
    endfor
  else
    let l:abbrev = cdata.abbreviation
    for [id, finfo] in items(l:ids)
      let [tagtype, tag, ln, kind] = finfo
      if kind == a:kind
        let l:name = l:abbrev .'_'. kind
        execute ':sign place '. id ' name='. l:name .' '. tagtype .'='. tag
      endif
      unlet tag
    endfor
  endif

  return 1
endfunction

" ==============================================
" Change Kind
" ==============================================

" return 0 or 1
function! vimside#sign#ChangeKindFile(linenos, filename, category, to_kind)
  let l:filename = fnamemodify(a:filename, ":p")
  return s:ChangeKind(a:linenos, 'file', l:filename, a:category, a:to_kind)
endfunction
function! vimside#sign#ChangeKindBuffer(linenos, buffer, category, to_kind)
  return s:ChangeKind(a:linenos, 'buffer', a:buffer, a:category, a:to_kind)
endfunction

function! s:ChangeKind(linenos, tagtype, tag, category, to_kind)
  if ! has_key(s:categories, a:category)
    echo "ChangeKind Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if ! has_key(l:kinds, a:to_kind) 
    echo "Bad Kind: ". a:to_kind ." for Category " . a.category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:abbrev = cdata.abbreviation
  let l:ids = l:cdata.ids

  let [l:found, l:id] = s:GetId(a:linenos, a:tag, l:ids)
  if l:found 
    let l:name = l:abbrev .'_'. a:to_kind

call s:LOG("s:ChangeKind: l:id=". l:id)
call s:LOG("s:ChangeKind: l:name=". l:name)
call s:LOG("s:ChangeKind: a:tagtype=". a:tagtype)
call s:LOG("s:ChangeKind: a:tag=". a:tag)
    execute ':sign place '. l:id ' name='. l:name .' '. a:tagtype .'='. a:tag
    return 1
  else
    echo "Bad filename: ". a:tag ." and linenos: ". a:linenos
    return 0
  endif
endfunction

" return 0 or 1
function! vimside#sign#ChangeKindKind(category, from_kind, to_kind)
  if ! has_key(s:categories, a:category)
    echo "ChangeKindKind Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if ! has_key(l:kinds, a:from_kind) 
    echo "Bad From Kind: ". a:from_kind ." for Category " . a.category
    return 0
  endif
  if ! has_key(l:kinds, a:to_kind) 
    echo "Bad To Kind: ". a:to_kind ." for Category " . a.category
    return 0
  endif

  let l:ids = l:cdata.ids
  let l:name = l:abbrev .'_'. a:to_kind

  for [id, finfo] in items(l:ids)
    let [tagtype, tag, ln, kind] = finfo
    if kind == a:from_kind
      execute ':sign place '. id ' name='. l:name .' '. tagtype .'='. a:tag
      let finfo[2] = a:to_kind
    endif
    unlet tag
  endfor

  return 1
endfunction


" ==============================================
" Clear
" ==============================================

" return 0 or 1
function! vimside#sign#ClearFile(linenos, filename, category)
  let l:filename = fnamemodify(a:filename, ":p")
  return s:Clear(a:linenos, 'file', l:filename, a:category)
endfunction
function! vimside#sign#ClearBuffer(linenos, buffer, category)
  return s:Clear(a:linenos, 'buffer', a:buffer, a:category)
endfunction

function! s:Clear(linenos, tagtype, tag, category)
  if ! has_key(s:categories, a:category)
    echo "Clear Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids

  let [l:found, id] = s:GetId(a:linenos, a:type, l:ids)
  if l:found
    execute ':sign unplace '. id .' '. tagtype .'='. a:type
    unlet l:ids[id]
  endif

  return 1
endfunction

" return 0 or 1
function! vimside#sign#HasCategoryKind(category, kind)

  if ! has_key(s:categories, a:category)
    return 0
  endif
  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']
  return has_key(l:kinds, a:kind) 

endfunction

" return 0 or 1
function! vimside#sign#ClearKind(category, kind)
  if ! has_key(s:categories, a:category)
    echo "ClearKind Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:kinds = l:cdata['kinds']

  if ! has_key(l:kinds, a:kind) 
    echo "Bad To Kind: ". a:kind ." for Category " . a.category
    return 0
  endif

  let l:ids = l:cdata.ids

  for [id, finfo] in items(l:ids)
    let [tagtype, tag, ln, kind] = finfo
    if kind == a:kind
      execute ':sign unplace '. id .' '. tagtype .'='. tag
      unlet l:ids[id]
    endif
    unlet tag
  endfor

  return 1
endfunction

" return 0 or 1
function! vimside#sign#ClearCategory(category)
  if ! has_key(s:categories, a:category)
    echo "ClearCategory Bad Category: ". a:category
    return 0
  endif

  let l:cdata = s:categories[a:category]
  let l:ids = l:cdata.ids

  for [id, finfo] in items(l:ids)
    let [tagtype, tag, ln, kind] = finfo
    execute ':sign unplace '. id .' '. tagtype .'='. tag
    unlet l:ids[id]
    unlet tag
  endfor

  " Remove the toggle key map if it exists
  if has_key(l:cdata, 'toggle')
    let l:toggle = l:cdata.toggle
    if type(l:toggle) == type("")
      let l:key = g:mapleader . l:toggle
      let l:category = l:cdata.category
call s:LOG("vimside#sign#ClearCategory: mapping=" . l:key ."<CR>")
      if ! empty(maparg(l:key, 'n'))
call s:LOG("vimside#sign#ClearCategory: mapping removed")
        execute ":nunmap ". l:key
      endif
    endif
  endif

  return 1
endfunction


function! vimside#sign#ClearAtCursor()
  sign unplace

  let l:line = line(".")
  let l:file= expand("%:p")
  let l:buffer = bufname("%")


  for [name, cdata] in items(s:categories)
    let l:ids = cdata.ids
    let [l:found, id] = s:GetId(l:linenos, l:file, l:ids)
    if l:found
      unlet l:ids[id]
      break
    else
      let [l:found, id] = s:GetId(l:linenos, l:buffer, l:ids)
      if l:found
        unlet l:ids[id]
        break
      endif
    endif
  endfor
endfunction

function! vimside#sign#ClearAll()
  sign unplace *

  for [name, cdata] in items(s:categories)
    let cdata['ids'] = {}
  endfor
endfunction

" return 0 or 1
function! vimside#sign#RemoveCategory(category)
  if ! has_key(s:categories, a:category)
    echo "RemoveCateory Bad Category: ". a:category
    return 0
  endif

  call vimside#sign#ClearCategory(a:category)

  unlet s:categories[a:category]
  return 1
endfunction

" Initialize debug module
call s:sign_init()
