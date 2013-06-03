" ============================================================================
" symbol_at_point.vim
"
" File:          vimside#swank#rpc#symbol_at_point.vim
" Summary:       Vimside RPC symbol-at-point
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Get a description of the symbol at given location.
"
" Arguments:
"   String:A source filename.
"   Int:A character offset in the file.
"
" Return:
"   A SymbolInfo
"
" Example:
"
" (:swank-rpc (swank:symbol-at-point "SwankProtocol.scala" 36483) 42)
"
" (:return (:ok 
" (:name "file" :type (:name "String" :type-id 25
" :full-name "java.lang.String" :decl-as class) :decl-pos
" (:file "SwankProtocol.scala" :offset 36404)))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#symbol_at_point#Run(...)

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-symbol-at-point-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-symbol-at-point-caller')
  endif

  let [found, fn] = vimside#util#GetCurrentFilename()
  if ! found
    " TODO better error message display and logging
    echoerr fn
    return
  endif

  let offset = vimside#util#GetCurrentOffset()

  let l:args = { }
  let l:args['filename'] = fn
  let l:args['offset'] = offset
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  call vimside#ensime#swank#dispatch(l:rr)

endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:SymbolAtPointCaller(args)
  let cmd = "swank:symbol-at-point"
  let fn = a:args.filename
  let offset = a:args.offset

  return '('. cmd .' "'. fn .'" '. offset .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

"
" Get a description of the symbol at given location.
"
" Request: File and Offset
" Response: SymbolInfo
"  (
"    :name //String:Name of this symbol.
"    :type //TypeInfo:The type of this symbol.
"  O :decl-pos //Position:Source location of this symbol's declaration.
"  O :is-callable //Bool:Is this symbol a method or function?
"    :owner-type-id //Int: (optional) Type id of owner type.
"  )
"
" Options
"  display type info only
"    name, 
"    type.name, 
"    type.decl_as, 
"    type.full_name
"    ...
"
"    cmndline
"    preview buffer
"    info form
"
"  location
"   in file
"     jump to location
"     split window 
"   diff file
"     jump to file
"     tab to file
"     split window to file
"
function! g:SymbolAtPointHandler()

  function! g:SymbolAtPointHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:SymbolAtPointHandler_Ok(dic, ...)
    let dic = a:dic
call s:LOG("SymbolAtPointHandler_Ok ".  string(dic)) 

    call vimside#command#position#Set()

    let current_file = expand('%:p')
" call s:LOG("SymbolAtPointHandler_Ok current_file=".  current_file) 
    if has_key(dic, ":decl-pos")
      let declpos = dic[':decl-pos']
      let file = declpos[':file']
" call s:LOG("SymbolAtPointHandler_Ok file=".  file) 
      let offset = declpos[':offset']

      if current_file == file
" call s:LOG("SymbolAtPointHandler_Ok same file") 
        let [found, location] = g:vimside.GetOption('tailor-symbol-at-point-location-same-file')
        if ! found
          call s:ERROR("Option not found 'tailor-symbol-at-point-location-same-file'") 
          let location = 'same_window'
        elseif location != 'same_window' 
            \ && location != 'split_window'
            \ && location != 'vsplit_window'
          call s:ERROR("Option 'tailor-symbol-at-point-location-same-file' has bad location value '". location ."'") 
          let location = 'same_window'

        endif

        if location == 'same_window'
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        elseif location == 'split_window'
          execute "split ". file
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        else " location == 'vsplit_window'
          execute "vsplit ". file
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        endif

        return 1

      else
" call s:LOG("SymbolAtPointHandler_Ok diff file") 
        let [found, location] = g:vimside.GetOption('tailor-symbol-at-point-location-diff-file')
        if ! found
          call s:ERROR("Option not found 'tailor-symbol-at-point-location-diff-file'") 
          let location = 'same_window'
        elseif location != 'same_window' 
            \ && location != 'split_window'
            \ && location != 'vsplit_window'
            \ && location != 'tab_window'
          call s:ERROR("Option 'tailor-symbol-at-point-location-diff-file' has bad location value '". location ."'") 

          let location = 'same_window'
        endif

        if location == 'same_window'
          execute "edit ". file
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        elseif location == 'split_window'
          execute "split ". file
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        elseif location == 'vsplit_window'
          execute "vsplit ". file
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        else  " location == 'tab_window'
          execute "tabnew ". file
          let [line, column] = vimside#util#GetLineColumnFromOffset(offset)
          execute ":normal ". line  ."G". column ." "
        endif

        return 1
      endif
    endif

    let lines = []
    if has_key(dic, ":name")
      let value = dic[':name']
      call add(lines, "name: " . string(value))
      unlet value
    endif
    if has_key(dic, ":type")
      let tdic = dic[':type']
      if has_key(tdic, ":name")
        let value = tdic[':name']
        call add(lines, "typename: " . string(value))
        unlet value
      endif
      if has_key(tdic, ":full-name")
        let value = tdic[':full-name']
        call add(lines, "fulltypename: " . string(value))
        unlet value
      endif
      if has_key(tdic, ":decl-as")
        let value = tdic[':decl-as']
        call add(lines, "declared as: " . string(value))
        unlet value
      endif
    endif
    if has_key(dic, ":is-callable")
      let value = dic[':is-callable']
      call add(lines, "Is Method: " . string(value))
      unlet value
    endif

call s:LOG("SymbolAtPointHandler_Ok lines=".  string(lines)) 
    call vimside#preview#Display(lines)
    return 1
  endfunction

  return { 
    \ 'abort': function("g:SymbolAtPointHandler_Abort"),
    \ 'ok': function("g:SymbolAtPointHandler_Ok") 
    \ }
endfunction


