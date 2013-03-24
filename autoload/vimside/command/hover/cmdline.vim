" ============================================================================
" cmdline.vim
"
" File:          cmdline.vim
" Summary:       Vimside Hover output to Cmdline
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Show value's Symbol-name on the Command Line.
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


let s:hover_cmdline_sec = 0
let s:hover_cmdline_msec = 0

function! s:LoadJobTimes()
  let [found, msec] = g:vimside.GetOption('tailor-hover-cmdline-job-time')
  if ! found
    throw "Option not found: "'tailor-hover-cmdline-job-time'"
  endif
  let s:hover_cmdline_sec = (msec >= 1000) ? msec/1000 : 0 
  let s:hover_cmdline_msec = msec - s:hover_cmdline_sec
call s:LOG("s:LoadJobTimes: sec=". s:hover_cmdline_sec .", msec=". s:hover_cmdline_msec) 
endfunction

call s:LoadJobTimes()


function! vimside#command#hover#cmdline#Handler_Ok(dic, ...)
" call s:LOG("vimside#command#hover#cmdline#Handler_Ok: TOP") 
  let dic = a:dic

  let text = vimside#command#hover#util#GetHoverText(dic)
  echo text
" call s:LOG("vimside#command#hover#cmdline#Handler_Ok: text=". text) 
  let dic = a:dic

  " call vimside#scheduler#SetUpdateTime(g:vimside_hover_save_updatetime)
  " call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_max_mcounter)

  call vimside#scheduler#RemoveJob(g:vimside_hover_motion_name)
  let FuncMotion = function("vimside#command#hover#cmdline#JobMotion")
  let charcnt = 0
  let repeat = 0
  call vimside#scheduler#AddMotionJob(g:vimside_hover_motion_name, FuncMotion, charcnt, repeat)

  let g:vimside.swank.ping_data.updatetime = g:vimside_hover_updatetime
  let g:vimside.swank.ping_data.char_count = g:vimside_hover_max_mcounter

" call s:LOG("vimside#command#hover#cmdline#Handler_Ok: BOTTOM") 
  return 1
endfunction

function! vimside#command#hover#cmdline#CallSymbolAtPoint()
" call s:LOG("vimside#command#hover#cmdline#CallSymbolAtPoint: TOP") 
  let dic = {
        \ 'handler': {
        \ 'ok': function("vimside#command#hover#cmdline#Handler_Ok")
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)
endfunction

function! vimside#command#hover#cmdline#JobMotion()
" call s:LOG("vimside#command#hover#cmdline#JobMotion: TOP") 
  call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_save_max_mcounter)
  call vimside#scheduler#SetUpdateTime(g:vimside_hover_updatetime)

  call vimside#scheduler#RemoveJob(g:vimside_hover_time_name)
  let Func = function("vimside#command#hover#cmdline#CallSymbolAtPoint")
  let sec = s:hover_cmdline_sec
  let msec = s:hover_cmdline_msec
  let repeat = 0
  call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, Func, sec, msec, repeat)
" call s:LOG("vimside#command#hover#cmdline#JobMotion: BOTTOM") 
endfunction

function! vimside#command#hover#cmdline#Start()
  " save currnet time/motion settings
  let g:vimside_hover_save_updatetime = vimside#scheduler#GetUpdateTime()
  let g:vimside_hover_save_max_mcounter = vimside#scheduler#GetMaxMotionCounter()

  call vimside#scheduler#SetUpdateTime(g:vimside_hover_updatetime)

  let FuncTime = function("vimside#command#hover#cmdline#CallSymbolAtPoint")
  let sec = s:hover_cmdline_sec
  let msec = s:hover_cmdline_msec
  let repeat = 0
  call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, FuncTime, sec, msec, repeat)

  return function("vimside#command#hover#cmdline#Stop")
endfunction

function! vimside#command#hover#cmdline#Stop()
  call vimside#scheduler#RemoveJob(g:vimside_hover_motion_name)
  call vimside#scheduler#RemoveJob(g:vimside_hover_time_name)
  
  " restore time/motion settings
  call vimside#scheduler#SetUpdateTime(g:vimside_hover_save_updatetime)
  call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_save_max_mcounter)
endfunction
