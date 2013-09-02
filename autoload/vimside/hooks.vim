
" let s:LOG = function("vimside#log#log")

" -------------------------------------------------------
"  Hooks
" -------------------------------------------------------

"
" Internal hooks variables
"

let s:do_logging = 0

function! s:LOG(msg)
if s:do_logging
  execute "redir >> ". "HOOKS_LOG"
  silent echo "INFO: ". a:msg
  execute "redir END"
endif
endfunction

call s:LOG("vimside#hooks: TOP")

let s:hooks_categories = {}
let s:hooks_is_init = 0

"
" Pre-defined hook categories
"
" 
let s:hooks_category_names = [
      \ "PostStartUp",
      \ "PreShutDown",
      \ "PostBufferRead",
      \ "PostBufferWrite",
      \ "PreQuickFix",
      \ "PostQuickFix",
      \ "NetProcessClose",
      \ "DbThreadSuspended",
      \ "VimLeave"
      \ ]

function! s:Hooks_Init()
  for category in s:hooks_category_names
    call vimside#hooks#Register(category)
  endfor
endfunction

function! vimside#hooks#HasCategory(category)
  return has_key(s:hooks_categories, a:category)
endfunction

function! vimside#hooks#Register(category)
  if ! has_key(s:hooks_categories, a:category)
    let l:cat_hooks = []
    let s:hooks_categories[a:category] = l:cat_hooks
  endif
endfunction


function! vimside#hooks#AddHook(category, Hook)
call s:LOG("vimside#hooks#AddHook: category=". a:category)
  if ! has_key(s:hooks_categories, a:category)
    call vimside#hooks#Register(a:category)
  endif

  let l:category = s:hooks_categories[a:category]

  call add(l:category, a:Hook)
endfunction

" return 0 or 1
function! vimside#hooks#Clear(category)
  if has_key(s:hooks_categories, a:category)
    let s:hooks_categories[a:category] = []
    return 1
  else
    return 0
  endif
endfunction

" return 0 or 1
function! vimside#hooks#ClearHook(category, Hook)
  if ! has_key(s:hooks_categories, a:category)
    return 0
  endif

  let l:cat_hooks = s:hooks_categories[a:category]
  let l:len = len(l:cat_hooks)

  let hookname = string(a:Hook)
  let l:ch = []

  " call filter(l:cat_hooks, 'string(v:val) !='. hookname)
  
  for Hook in l:cat_hooks
    if string(Hook) != hookname
      call add(l:ch, HOOK)
    endif
  endfor
  let s:hooks_categories[a:category] = l:ch

  return l:len != len(l:ch)

endfunction

function! vimside#hooks#Run(category)
call s:LOG("vimside#hooks#Run: category=". a:category)
  if has_key(s:hooks_categories, a:category)
    for Hook in s:hooks_categories[a:category]
      try
        call Hook()
      catch /.*/
        let l:ERROR = function("vimside#log#error")
        call l:ERROR("Run: ". v:exception ." at ". v:throwpoint)
      endtry
    endfor
  endif
endfunction





function! vimside#hooks#AssciateHooksAutoCmd()
call s:LOG("vimside#hooks#AssciateHooksAutoCmd")
  augroup VIMSIDE_AUTOCMD_HOOKS
    au!
    autocmd BufReadPost *.scala call vimside#hooks#Run('PostBufferRead')
    autocmd FileReadPost *.scala call vimside#hooks#Run('PostBufferRead')
    autocmd BufWritePost *.scala call vimside#hooks#Run('PostBufferWrite')
    autocmd FileWritePost *.scala call vimside#hooks#Run('PostBufferWrite')
    autocmd VimLeave * call vimside#hooks#Run('VimLeave')
  augroup END
endfunction

function! vimside#hooks#ClearHooksAutoCmd()
call s:LOG("vimside#hooks#ClearHooksAutoCmd")
  augroup VIMSIDE_AUTOCMD_HOOKS
    au!
  augroup END
endfunction


call s:Hooks_Init()

call s:LOG("vimside#hooks: BOTTOM")

















if 0 " BUFFER REMOVE


" -------------------------------------------------------
"  Buffer Saved
" -------------------------------------------------------
let s:hooks_source_buffer_saved_enabled = 1
let s:hooks_source_buffer_saved = []

function! vimside#hooks#BufferSavedEnable()
  let s:hooks_source_buffer_saved_enabled = 1
endfunction
function! vimside#hooks#BufferSavedDisEnable()
  let s:hooks_source_buffer_saved_enabled = 0
endfunction
function! vimside#hooks#BufferSavedRun()
  if s:hooks_source_buffer_saved_enabled
    for Hook in s:hooks_source_buffer_saved
      try
        call Hook()
      catch /.*/
        let l:ERROR = function("vimside#log#error")
        call l:ERROR("RunSaved: ". v:exception ." at ". v:throwpoint)
      endtry
    endfor
  endif
endfunction

function! vimside#hooks#BufferSavedAddHook(Hook)
  call add(s:hooks_source_buffer_saved, a:Hook)
endfunction
function! vimside#hooks#BufferSavedAddHooks()
  call vimside#hooks#BufferSavedAddHook(function("vimside#command#TypecheckFileOnWrite"))
  call vimside#hooks#BufferSavedAddHook(function("vimside#command#BuilderTrackFile"))
endfunction
function! vimside#hooks#BufferSavedRemoveHooks()
  let s:hooks_source_buffer_saved = []
endfunction

call vimside#hooks#BufferSavedAddHooks()

" -------------------------------------------------------
"  Buffer Loaded
" -------------------------------------------------------

let s:hooks_source_buffer_loaded_enabled = 1
let s:hooks_source_buffer_loaded = []

function! vimside#hooks#BufferLoadedEnabled()
  let s:hooks_source_buffer_loaded_enabled = 1
endfunction
function! vimside#hooks#BufferLoadedDisabled()
  let s:hooks_source_buffer_loaded_enabled = 0
endfunction
function! vimside#hooks#BufferLoadedRun()
  if s:hooks_source_buffer_loaded_enabled
    for Hook in s:hooks_source_buffer_loaded
      try
        call Hook()
      catch /.*/
        let l:ERROR = function("vimside#log#error")
        call l:ERROR("RunLoaded: ". v:exception ." at ". v:throwpoint)
      endtry
    endfor
  endif
endfunction

function! vimside#hooks#BufferLoadedAddHook(Hook)
  call add(s:hooks_source_buffer_loaded, a:Hook)
endfunction
function! vimside#hooks#BufferLoadedAddHooks()
  call vimside#hooks#BufferLoadedAddHook(function("vimside#command#TypecheckFileOnWrite"))
endfunction
function! vimside#hooks#BufferLoadedRemoveHooks()
  let s:hooks_source_buffer_loaded = []
endfunction

call vimside#hooks#BufferLoadedAddHooks()

" -------------------------------------------------------
"  Autocmds
" -------------------------------------------------------

function! vimside#hooks#StartAutoCmd()
  augroup VIMSIDE_HOOKS
    au!
    autocmd BufReadPost *.scala call vimside#hooks#BufferLoadedRun()
    autocmd BufWritePost *.scala call vimside#hooks#BufferSavedRun()
  augroup END
endfunction

function! vimside#hooks#StopAutoCmd()
  augroup VIMSIDE_HOOKS
    au!
  augroup END
endfunction

endif " BUFFER REMOVE
