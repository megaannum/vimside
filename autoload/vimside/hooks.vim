
let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

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
        call s:ERROR("RunSaved: ". v:exception ." at ". v:throwpoint)
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
        call s:ERROR("RunLoaded: ". v:exception ." at ". v:throwpoint)
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
