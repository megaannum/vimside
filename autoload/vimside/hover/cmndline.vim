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
  let [found, msec] = g:vimside.GetOption('vimside-hover-cmdline-job-time')
  if ! found
    throw "Vimside: Option not found: "'vimside-hover-cmdline-job-time'"
  endif
  let s:hover_cmdline_sec = (msec >= 1000) ? msec/1000 : 0 
  let s:hover_cmdline_msec = msec - s:hover_cmdline_sec
call s:LOG("s:LoadJobTimes: sec=". s:hover_cmdline_sec .", msec=". s:hover_cmdline_msec) 
endfunction

call s:LoadJobTimes()


function! vimside#hover#cmdline#Handler_Ok(symbolinfo)
" call s:LOG("vimside#hover#cmdline#Handler_Ok ". string(a:symbolinfo)) 
  let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:symbolinfo)
  if ! found
    echoe "SymbolAtPoint ok: Badly formed Response"
    call s:ERROR("SymbolAtPoint ok: Badly formed Response: ". string(a:symbolinfo))
    return 0
  endif

  let text = vimside#hover#util#GetHoverText(dic)
  echo text

  call vimside#scheduler#SetUpdateTime(g:vimside_hover_save_updatetime)
  call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_max_mcounter)

  call vimside#scheduler#RemoveJob(g:vimside_hover_motion_name)
  let FuncMotion = function("vimside#hover#cmdline#JobMotion")
  let charcnt = 0
  let repeat = 0
  call vimside#scheduler#AddMotionJob(g:vimside_hover_motion_name, FuncMotion, charcnt, repeat)

  return 1
endfunction

function! vimside#hover#cmdline#JobTime()
  let dic = {
        \ 'handler': {
        \ 'ok': function("vimside#hover#cmdline#Handler_Ok")
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)
endfunction

function! vimside#hover#cmdline#JobMotion()
  call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_save_max_mcounter)
  call vimside#scheduler#SetUpdateTime(g:vimside_hover_updatetime)

  call vimside#scheduler#RemoveJob(g:vimside_hover_time_name)
  let Func = function("vimside#hover#cmdline#JobTime")
  let sec = s:hover_cmdline_sec
  let msec = s:hover_cmdline_msec
  let repeat = 0
  call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, Func, sec, msec, repeat)
endfunction

function! vimside#hover#cmdline#Start()
  " save currnet time/motion settings
  let g:vimside_hover_save_updatetime = vimside#scheduler#GetUpdateTime()
  let g:vimside_hover_save_max_mcounter = vimside#scheduler#GetMaxMotionCounter()

  call vimside#scheduler#SetUpdateTime(g:vimside_hover_updatetime)

  let FuncTime = function("vimside#hover#cmdline#JobTime")
  let sec = s:hover_cmdline_sec
  let msec = s:hover_cmdline_msec
  let repeat = 0
  call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, FuncTime, sec, msec, repeat)

  return function("vimside#hover#cmdline#Stop")
endfunction

function! vimside#hover#cmdline#Stop()
  call vimside#scheduler#RemoveJob(g:vimside_hover_motion_name)
  call vimside#scheduler#RemoveJob(g:vimside_hover_time_name)
  
  " restore time/motion settings
  call vimside#scheduler#SetUpdateTime(g:vimside_hover_save_updatetime)
  call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_save_max_mcounter)
endfunction
