" ============================================================================
" term.vim
"
" File:          term.vim
" Summary:       Vimside Hover output to Terminal/Linux commands
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let s:hover_term_sec = 0
let s:hover_term_msec = 0

function! s:LoadJobTimes()
  let [found, msec] = g:vimside.GetOption('tailor-hover-term-job-time')
  if ! found
    throw "Option not found: "'tailor-hover-term-job-time'"
  endif

  let s:hover_term_sec = (msec >= 1000) ? msec/1000 : 0 
  let s:hover_term_msec = msec - s:hover_term_sec
call s:LOG("s:LoadJobTimes: sec=". s:hover_term_sec .", msec=". s:hover_term_msec) 
endfunction

call s:LoadJobTimes()

let s:hover_term_supported = -1
let s:hover_term_xwininfo_path = ''
let s:hover_term_xdotool_path = ''
let s:hover_term_dzen2_path = ''

function! vimside#command#hover#term#Enabled()
  let [found, enabled] = g:vimside.GetOption('vimside-hover-term-balloon-enabled')
  if ! found
    throw "Option not found: "'vimside-hover-term-balloon-enabled'"
  endif
  return enabled
endfunction

function! vimside#command#hover#term#IsSupported()
  if s:hover_term_supported == -1
    let s:hover_term_supported = s:CheckHoverTermRequiredExecutables()
  endif
  return s:hover_term_supported
endfunction

function! s:CheckHoverTermRequiredExecutables()
  let l:requirements_met = 1
  "- xwininfo
  let [status, path] = vimside#vimproc#ExistsExecutable('xwininfo')
  if status
    let s:hover_term_xwininfo_path = path
  else
    call s:ERROR("s:CheckHoverTermRequiredExecutables: err msg=". path)
    let l:requirements_met = 0
  endif

  "- xdotool
  let [status, path] = vimside#vimproc#ExistsExecutable('xdotool')
  if status
    let s:hover_term_xdotool_path = path
  else
    call s:ERROR("s:CheckHoverTermRequiredExecutables: err msg=". path)
    let l:requirements_met = 0
  endif

  "- dzen2
  let [status, path] = vimside#vimproc#ExistsExecutable('dzen2')
  if status
    let s:hover_term_dzen2_path = path
  else
    call s:ERROR("s:CheckHoverTermRequiredExecutables: err msg=". path)
    let l:requirements_met = 0
  endif

  return l:requirements_met
endfunction


" --------------

" xdotool getmouselocation -> 
" return [1, x_pixel, y_pixel]
" return [0, -1, -11]
function! s:GetMouseLocation()
  let cmdline = 'xdotool getmouselocation'
  let [status, out, err] = vimside#vimproc#execute_cmd(cmdline)
  if status == 0
" call s:LOG("s:GetMouseLocation: out=". out)
    let lines = split(out, ' ')
    let xpx = 0 + lines[0][len('x:'):]
    let ypx = 0 + lines[1][len('y:'):]
" call s:LOG("s:GetMouseLocation: xpx=". xpx .", ypx=". ypx)
    return [1, xpx, ypx]
  else
    call s:ERROR("s:GetMouseLocation: status=". status .", err=". err)
    return [0, -1, -1]
  endif
endfunction

" xdotool getactivewindow -> 
" return [1, window_id]
" return [0, -1]
function! s:GetActiveWindowId()
  let cmdline = 'xdotool getactivewindow'
  let [status, out, err] = vimside#vimproc#execute_cmd(cmdline)
  if status == 0
    let windowid = 0 + substitute(out, "\n", "", "g")
    return [0, windowid]
  else
    call s:ERROR("s:GetActiveWindowId: status=". status .", err=". err)
    return [0, -1]
  endif
endfunction

" xwininfo -id WID ->
" return [1, upperX, upperY, width, height]
" return [0, -1, -1, -1, -1]
function! s:GetWinInfo()
  let cmdline = 'xwininfo -id '. $WINDOWID
  let [status, out, err] = vimside#vimproc#execute_cmd(cmdline)
  if status == 0
" call s:LOG("s:GetWinInfo: out=". out)
    let lines = split(out, '\n')
    let upperX = 0 + lines[3][len('  Absolute upper-left X:  '):]
    let upperY = 0 + lines[4][len('  Absolute upper-left Y:  '):]
    let width  = 0 + lines[7][len('  Width: '):]
    let height = 0 + lines[8][len('  Height: '):]

    return [1, upperX, upperY, width, height]
  else
    call s:ERROR("s:GetWinInfo: status=". status .", err=". err)
    return [0, -1, -1, -1, -1]
  endif
endfunctio

" return [rows, cols]
function! s:GetTermSize()
  let cols = winwidth(0)
  let rows = winheight(0)
  return [rows, cols]
endfunction

" not used
function! s:GetCharDimension()
  let [found, upperX, upperY, width, height] = s:GetWinInfo()
  let [rows, cols] = s:GetTermSize()
  let cwidth = float2nr((0.0+width)/cols)
  let cheight = float2nr((0.0+height)/rows)

  return [cwidth, cheight]
endfunction

" return [1, line, column]
" return [0, -1, -1]
function! s:GetTermMousePos()
  let [found, xpx, ypx] = s:GetMouseLocation()
"call s:LOG("s:GetTermMousePos: ". string([found, xpx, ypx, windowid]))
  if ! found
    return [0, -1, -1]
  endif

  let [found, windowid] = s:GetActiveWindowId()

  " Must be a bug in xdotool getmouselocation
  if windowid != $WINDOWID
" call s:LOG("s:GetTermMousePos: WINDOWID=". $WINDOWID)
    " mouse not in our window
    return [0, -1, -1]
  endif

  let [found, upperX, upperY, width, height] = s:GetWinInfo()
  if ! found
    return [0, -1, -1]
  endif

  " Note: we could do a bounds chect that the mouse location is
  " within the window bounds, but hopefully, the above windowid
  " check is good enough.

  let [rows, cols] = s:GetTermSize()

  let column = float2nr((1.0 * (xpx - upperX) * cols) / width)
  let lnum = float2nr((1.0 * (ypx - upperY) * rows) / height)

" echo "ypx=". ypx .", upperY=". upperY .", height=". height .", rows=". rows .", y=". y
  let topline = line('w0')
  return [1, lnum + topline, column]
endfunction

" return [1, offset]
" return [0, -1]
function! s:GetCurrentTermOffset()
  let [found, lnum, column] = s:GetTermMousePos()
" call s:LOG("s:GetCurrentTermOffset: lnum,column=". string([lnum, column]))
  return found ? [1, line2byte(lnum)+column-1] : [0, -1]
endfunction

" return [1, lnum, column, word]
" return [0, -1, -1, '']
function! g:GetWord()
  let [found, lnum, column] = s:GetTermMousePos()
  if ! found
    return [0, -1, -1, '']
  endif
  let line = getline(lnum)
" echo "lnum=". lnum .", line=". line

  let llen = len(line)
  if column > llen
    let word = ''
  else
    let c = line[column]
    if c == "\<CR>" || c == "\<Space>"
      let word = ''
    else
      let rpos = column+1
      while rpos < llen
        let c = line[rpos]
        if c == "\<CR>" || c == "\<Space>"
          let rpos -= 1
          break
        else
        endif
        let rpos += 1
      endwhile
      let lpos = column-1
      while rpos >= 0
        let c = line[lpos]
        if c == "\<Space>"
          let lpos += 1
          break
        else
        endif
        let lpos -= 1
      endwhile
" echo "column=". column .", lpos=". lpos .", rpos=". rpos .", word=". line[lpos : rpos]
      let word = line[lpos : rpos]
    endif
  endif

  return [1, lnum, column, word]
endfunction

" --------------

function! g:ShowBalloon(text)
" call s:LOG("g:ShowBalloon: text='". a:text ."'")
  " NOTE: options
  let [cwidth, cheight] = [8, 10]
  let [found, xpx, ypx] = s:GetMouseLocation()
  if found
    let [found, bg] = g:vimside.GetOption('tailor-hover-term-balloon-bg')
    if ! found
      throw "Option not found: "'tailor-hover-term-balloon-bg'"
    endif
    let [found, fg] = g:vimside.GetOption('tailor-hover-term-balloon-fg')
    if ! found
      throw "Option not found: "'tailor-hover-term-balloon-fg'"
    endif
    let args = ' -w '. (len(a:text) * cwidth + 8)
    let args .= ' -fg '. fg
    let args .= ' -bg '. bg
    let args .= ' -x '. xpx
    let args .= ' -y '. ypx
    let args .= ' -p '
    let cmdline = 'echo '. a:text .' | dzen2 '. args
    let subproc = vimside#vimproc#start_cmd(cmdline)

    let c = nr2char(getchar())
    call feedkeys(c, 't')

    call subproc.stdout.close()
    call subproc.stderr.close()

    let [cond, last_status] = subproc.waitpid()
"echo "cond=". cond .", last_status=". last_status
  endif
endfunction

function! vimside#command#hover#term#Handler_Ok(dic, ...)
  let dic = a:dic

  let [found, lnum, column, word] = g:GetWord()
" call s:LOG("vimside#command#hover#term#Handler_Ok found=". found .", word='". word ."'") 
  if found && word != ''
    let text = vimside#command#hover#util#GetHoverText(dic)
    if text != ''
      call g:ShowBalloon(text)
    endif        
  endif

  let FuncTime = function("vimside#command#hover#term#JobTime")
  let sec = s:hover_term_sec
  let msec = s:hover_term_msec
  let repeat = 0
  call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, FuncTime, sec, msec, repeat)

  let g:vimside.swank.ping_data.updatetime = g:vimside_hover_updatetime

  return 1
endfunction

function! vimside#command#hover#term#JobTime()
  let [found, offset] = s:GetCurrentTermOffset()
  if found
    let dic = {
          \ 'handler': {
          \ 'ok': function("vimside#command#hover#term#Handler_Ok")
          \ },
          \ 'args': {
          \   'offset': offset
          \ }
          \ }
    call vimside#swank#rpc#symbol_at_point#Run(dic)
  else
    let FuncTime = function("vimside#command#hover#term#JobTime")
    let sec = s:hover_term_sec
    let msec = s:hover_term_msec
    let repeat = 0
    call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, FuncTime, sec, msec, repeat)
  endif
endfunction


function! vimside#command#hover#term#Start()
  " save currnet time/motion settings
  let g:vimside_hover_save_updatetime = vimside#scheduler#GetUpdateTime()
  let g:vimside_hover_save_max_mcounter = vimside#scheduler#GetMaxMotionCounter()

  call vimside#scheduler#SetUpdateTime(g:vimside_hover_updatetime)

  let FuncTime = function("vimside#command#hover#term#JobTime")
  let sec = s:hover_term_sec
  let msec = s:hover_term_msec
  let repeat = 0
  call vimside#scheduler#AddTimeJob(g:vimside_hover_time_name, FuncTime, sec, msec, repeat)

  return function("vimside#command#hover#term#Stop")
endfunction

function! vimside#command#hover#term#Stop()
  call vimside#scheduler#RemoveJob(g:vimside_hover_motion_name)
  call vimside#scheduler#RemoveJob(g:vimside_hover_time_name)
  
  " restore time/motion settings
  call vimside#scheduler#SetUpdateTime(g:vimside_hover_save_updatetime)
  call vimside#scheduler#SetMaxMotionCounter(g:vimside_hover_save_max_mcounter)
endfunction

