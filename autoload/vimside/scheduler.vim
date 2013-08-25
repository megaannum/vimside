" ============================================================================
" scheduler.vim
"
" File:          scheduler.vim
" Summary:       Schedule Jobs for Vimside
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" This is the Vimside job scheduler. It uses autocmds to implement
" both time-based (CursorHold, CursorHoldI) and 
" motion-based (CursorMoved, CursorMovedI) triggers.
" Any job can be time and/or motion based.
" Any job can be executed only once or have repeated execution.
" If a job has repeated execution, then it repeats for both time and
" motion.
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

"=============================================================================
" General Jobs
"  job = [name, func, sec, msec, rsec, rmsec, charcnt, rcharcnt]
"=============================================================================
let s:jobs = []

let s:outputfeedkeys = 1

" this is set to 1 if the schedule is looping through jobs
"   (time or motion). While looping, adding/removing new/existing
"   jobs from a job being called within the loop, will not be
"   recorded if they are simply added-to/removed-from the s:jobs list.
let s:handling_jobs=0
let s:remove_jobs=[]
let s:add_jobs=[]

" Must only be called when s:handling_jobs == 0
" Outside of code that is processing Time/Motion jobs
function! s:do_queued_add_job()
call s:LOG("s:do_queued_add_job: TOP")
  if ! empty(s:add_jobs)
    for job in s:add_jobs
      call s:add_job(job)
    endfor
    let s:add_jobs=[]
  endif
endfunction
function! s:add_job(job)
call s:LOG("s:add_job: TOP job=". string(a:job))
  if s:handling_jobs
    call add(s:add_jobs, a:job)
  else
    call add(s:jobs, a:job)
  endif
call s:LOG("s:add_job: BOTTOM len(s:jobs)=". len(s:jobs))
endfunction

" Must only be called when s:handling_jobs == 0
" Outside of code that is processing Time/Motion jobs
function! s:do_queued_remove_jobs()
call s:LOG("s:do_queued_remove_jobs: TOP ")
  if ! empty(s:remove_jobs)
    for name in s:remove_jobs
      call s:remove_job(name)
    endfor
    let s:remove_jobs=[]
  endif
endfunction

function! s:remove_job(name)
call s:LOG("s:remove_job: TOP name=". a:name)
  if s:handling_jobs
    call add(s:remove_jobs, a:name)
  else
    let l:jobs = []
    for l:job in s:jobs
      if l:job[0] != a:name
        call add(l:jobs, l:job)
      end
    endfor
    let s:jobs = l:jobs
  endif
call s:LOG("s:remove_job: BOTTOM len(s:jobs)=". len(s:jobs))
endfunction

function! vimside#scheduler#ClearJobs()
  let s:jobs = []
endfunction

function! vimside#scheduler#AddJob(name, func, sec, msec, charcnt, repeat) 
  let [l:sec, l:msec] = vimside#scheduler#GetRealTime()
  let l:tsec = a:sec + l:sec
  let l:tmsec = a:msec + l:msec
  let l:mcnt = a:charcnt + s:total_mcounter

  let l:job = a:repeat
      \ ? [a:name, a:func, l:tsec, l:tmsec, a:sec, a:msec, l:mcnt, a:charcnt]
      \ : [a:name, a:func, l:tsec, l:tmsec, 0,     0,      l:mcnt, 0]

  call s:add_job(l:job)
endfunction

function! vimside#scheduler#RemoveJob(name)
call s:LOG("vimside#scheduler#RemoveJob: TOP name=". a:name)
call s:LOG("vimside#scheduler#RemoveJob: MID len(s:jobs)=". len(s:jobs))
  call s:remove_job(a:name)
call s:LOG("vimside#scheduler#RemoveJob: BOTTOM len(s:jobs)=". len(s:jobs))
endfunction

function! vimside#scheduler#StartAuto() 
  call vimside#scheduler#StartAutoTime()
  call vimside#scheduler#StartAutoMotion() 
endfunction

function! vimside#scheduler#StopAuto() 
  call vimside#scheduler#StopAutoTime() 
  call vimside#scheduler#StopAutoMotion() 
endfunction

function! vimside#scheduler#ResetAuto() 
  call vimside#scheduler#StopAuto() 
  call vimside#scheduler#StartAuto() 
endfunction


function! vimside#scheduler#GetUpdateTime() 
  return &updatetime
endfunction

function! vimside#scheduler#SetUpdateTime(value) 
  let minval = 100
  if a:value < minval
    throw "UpdateTime must be greater-than/equal-to ". minval ."ms: ". a:value
  endif
call s:LOG("vimside#scheduler#SetUpdateTime: value=". a:value)
  let &updatetime = a:value

  " TESTING 12/23/12
  " call vimside#scheduler#FeedKeys()
endfunction

function! vimside#scheduler#GetMaxMotionCounter()
  return s:max_mcounter
endfunction

function! vimside#scheduler#SetMaxMotionCounter(cnt)
  if a:cnt < 0
    throw "Motion counter must be positive: ". a:cnt
  endif
  let s:max_mcounter = a:cnt
  if s:mcounter > s:max_mcounter
    let s:mcounter = s:max_mcounter
  endif
endfunction

"=============================================================================
" Time
"  job = [name, func, sec, msec, rsec, rmsec, -1, _]
"=============================================================================

function! vimside#scheduler#ClearTimeJob()
  let l:js = s:jobs
  let s:jobs = []

  for l:job in l:js
    if l:job[2] == -1
      call s:add_job(l:job)
    endif
  endfor
endfunction

function! vimside#scheduler#AddTimeJob(name, func, sec, msec, repeat) 
call s:LOG("AddTimeJob: TOP name=". a:name .", sec=". a:sec .", msec=". a:msec .", repeat=". a:repeat)
  let [l:sec, l:msec] = vimside#scheduler#GetRealTime()
  let l:tsec = a:sec + l:sec
  let l:tmsec = a:msec + l:msec

  let l:job = a:repeat
          \ ? [a:name, a:func, l:tsec, l:tmsec, a:sec, a:msec, -1, -1]
          \ : [a:name, a:func, l:tsec, l:tmsec, 0,     0,      -1, -1]

  " call add(s:jobs, l:job)
  call s:add_job(l:job)
endfunction


function! vimside#scheduler#ReplaceTimeJob(name, func, sec, msec, repeat)
  call vimside#scheduler#RemoveJob(a:name)
  call vimside#scheduler#AddTimeJob(a:name, a:func, a:sec, a:msec, a:repeat)
endfunction

function! vimside#scheduler#TimeTrigger()
  let [l:sec, l:msec] = vimside#scheduler#GetRealTime()
" call s:LOG("TimeTrigger: TOP [sec,msec]=[". l:sec .",". l:msec ."]")
" call s:LOG("TimeTrigger: TOP2 len(s:jobs)=". len(s:jobs))
  let l:js = s:jobs
  let s:jobs = []
  let l:jobs = []

  let s:handling_jobs=1
  try
  for l:job in l:js
    let l:jsec = l:job[2]
    let l:jmsec = l:job[3]
    " is it a time job
    if l:jsec != -1
" call s:LOG("TimeTrigger:   [jsec,jmsec]=[". l:jsec .",". l:jmsec ."]")
      if (l:jsec < sec) || (l:jsec == sec && l:jmsec <= msec)
        try
          call l:job[1]()
        catch /.*/
          call s:ERROR("TimeTrigger: ". v:exception ." at ". v:throwpoint)
        endtry

        " Is this a repeat
        let l:jrsec = l:job[4]
        let l:jrmsec = l:job[5]
        if l:jrsec != 0 || l:jrmsec != 0
" call s:LOG("TimeTrigger: [jrsec,jrmsec]=[". l:jrsec .",". l:jrmsec ."]")
          let m = msec + l:jrmsec
          if m >= 1000
            let l:job[2] = sec + l:jrsec + m/1000
            let l:job[3] = m - 1000
          else
            let l:job[2] = sec + l:jrsec
            let l:job[3] = m
          endif

          " reset motion if it is repeat
          let rcnt = l:job[7]
          if rcnt > 0
            let l:job[6] = rcnt + s:total_mcounter
          endif

" XXXXXXXXXXXXXXXXXXXXXX
          call add(l:jobs, l:job)
        endif
      else
        call add(l:jobs, l:job)
      endif
    else
      call add(l:jobs, l:job)
    endif
  endfor
  finally
    let s:handling_jobs=0
  endtry

  " One of the jobs might have added a job so we add to s:jobs
  let s:jobs += l:jobs

  call s:do_queued_remove_jobs()
  call s:do_queued_add_job()

  call vimside#scheduler#FeedKeys()
" call s:LOG("TimeTrigger: BOTTOM len(s:jobs)=". len(s:jobs))
endfunction

function! vimside#scheduler#HaltFeedKeys()
  let s:outputfeedkeys = 0
endfunction
function! vimside#scheduler#ResumeFeedKeys()
  let s:outputfeedkeys = 1
endfunction

function! vimside#scheduler#FeedKeys()
" call s:LOG("FeedKeys: mode=". mode())
  if s:outputfeedkeys
    if mode() == 'i'
      call feedkeys("a\<BS>", 'n') 
    elseif mode() == 'c'
      call feedkeys("\<SPACE>\<BS>", 'n')
    else
      call feedkeys("f\e", 'n') 
    endif
  endif
endfunction

function! vimside#scheduler#GetRealTime() 
  " TODO remove
  " if has("win32") || has("dos32") || has("dos16") || has("os2")

  if g:vimside.os.is_mswin
    " reltimestr -> %10.6lf
    let tstr = reltimestr(reltime())
    let len = len(tstr)
    " echo strpart(printf("%10.6lf", 555555444.333),0, 9)
    let secStr = strpart(tstr, 0, len-7)
    " echo strpart(printf("%10.6lf", 555555444.333), 10, 3)
    let msecStr = strpart(tstr, len-6, 3)
    return [0 + secStr, 0 + msecStr]
  else
    " reltimestr -> %3ld.%06ld
    let [sec, usec] = reltime()
    return [sec, usec/1000]
  endif
endfunction

function! vimside#scheduler#StartAutoTime() 
  augroup VIMSIDE_TIME
    au!
    autocmd CursorHold * call vimside#scheduler#TimeTrigger()
    autocmd CursorHoldI * call vimside#scheduler#TimeTrigger()
  augroup END
endfunction
  
function! vimside#scheduler#StopAutoTime() 
  augroup VIMSIDE_TIME
    au!
  augroup END
endfunction

function! vimside#scheduler#ResetAutoTime() 
  call vimside#scheduler#StopAutoTime()
  call vimside#scheduler#StartAutoTime()
endfunction




"=============================================================================
" Motion
"  job = [name, func, -1, _, _, _, charcnt, rcharcnt]
"=============================================================================

let s:mcounter = 0
let s:max_mcounter = 20
let s:total_mcounter = 0

function! vimside#scheduler#ClearMotionJob()
  let l:js = s:jobs
  let s:jobs = []

  for job in l:js
    if job[6] == -1
      call add(s:jobs, job)
    endif
  endfor
endfunction

function! vimside#scheduler#AddMotionJob(name, func, charcnt, repeat) 
call s:LOG("AddMotionJob: TOP name=". a:name .", charcnt=". a:charcnt .", repeat=". a:repeat)
  let l:mcnt = a:charcnt + s:total_mcounter
  let l:job = a:repeat
          \ ? [a:name, a:func, -1, 0, 0, 0, l:mcnt,  a:charcnt]
          \ : [a:name, a:func, -1, 0, 0, 0, l:mcnt,  0]
  call s:add_job(l:job)
call s:LOG("AddMotionJob: BOTTOM len(s:jobs)=". len(s:jobs))
endfunction

function! vimside#scheduler#ReplaceMotionJob(name, func, charcnt, repeat)
  call vimside#scheduler#RemoveJob(a:name)
  call vimside#scheduler#AddMotionJob(a:name, a:func, a:charcnt, a:repeat)
endfunction

function! vimside#scheduler#MotionTrigger()
" call s:LOG("MotionTrigger: TOP s:total_mcounter=". s:total_mcounter .", s:mcounter=". s:mcounter)
  let s:total_mcounter += 1
  if s:mcounter <= 0
    let l:sec = -1
    let l:ccc = s:total_mcounter
" call s:LOG("MotionTrigger: l:ccc=". l:ccc)
    let l:js = s:jobs
" call s:LOG("MotionTrigger: len(jobs)=". len(l:js))
    let s:jobs = []
    let l:jobs = []

    let s:handling_jobs=1
    try
    for l:job in l:js
" call s:LOG("MotionTrigger: for l:job=". string(l:job))
      let l:cc = l:job[6]
      " is it a motion job
      if l:cc != -1
        if l:cc <= l:ccc
" call s:LOG("MotionTrigger: job=". string(job))
          try
" call s:LOG("MotionTrigger: calling job")
            call l:job[1]()
          catch /.*/
            call s:ERROR("MotionTrigger: ". v:exception ." at ". v:throwpoint)
          endtry

          " Is this a repeat
          let l:rcnt = l:job[7]
          if l:rcnt > 0
            let l:job[6] = l:rcnt + l:ccc

            " reset time if it is repeat
            let l:jrsec = l:job[4]
            let l:jrmsec = l:job[5]
            if l:jrsec != 0 || l:jrmsec != 0
              " only get real time if needed
              if l:sec == -1
                let [l:sec, l:msec] = vimside#scheduler#GetRealTime()
              endif
              let l:m = l:msec + l:jrmsec
              if m >= 1000
                let l:job[2] = l:sec + l:jrsec + l:m/1000
                let l:job[3] = l:m - 1000
              else
                let l:job[2] = l:sec + l:jrsec
                let l:job[3] = l:m
              endif
            endif

" XXXXXXXXXXXXXXXXXXXXXX
            call add(l:jobs, l:job)
          endif
        else
          call add(l:jobs, l:job)
        endif
      else
        call add(l:jobs, l:job)
      endif
    endfor
    finally
      let s:handling_jobs=0
    endtry
    let s:mcounter = s:max_mcounter

    " One of the jobs might have added a job so we add to s:jobs
    let s:jobs += l:jobs

    call s:do_queued_remove_jobs()
    call s:do_queued_add_job()
  else
    let s:mcounter -= 1
  endif
" call s:LOG("MotionTrigger: BOTTOM len(s:jobs)=". len(s:jobs))
endfunction

function! vimside#scheduler#StartAutoMotion() 
  augroup VIMSIDE_MOTION
    au!
    autocmd CursorMoved * call vimside#scheduler#MotionTrigger()
    autocmd CursorMovedI * call vimside#scheduler#MotionTrigger()
  augroup END
endfunction
  
function! vimside#scheduler#StopAutoMotion() 
  augroup VIMSIDE_MOTION
    au!
  augroup END
endfunction

function! vimside#scheduler#ResetAutoMotion() 
  call vimside#scheduler#StopAutoMotion()
  call vimside#scheduler#StartAutoMotion()
endfunction



" --------------------------------------------------------
if 0 " MMMMM

function! g:MJob1() 
call s:LOG("MJob1:")
endfunction
function! g:MJob2() 
call s:LOG("MJob2:")
endfunction
function! g:MJob3() 
call s:LOG("MJob3:")
endfunction
function! g:MJob4() 
call s:LOG("MJob4:")
endfunction
function! g:MJob5() 
call s:LOG("MJob5:")
endfunction
function! g:MJob10() 
call s:LOG("MJob10:")
endfunction
function! g:MJob20() 
call s:LOG("MJob20:")
endfunction

function! g:MJob(name, func, charcnt, repeat) 
  call vimside#scheduler#AddMotionJob(a:name, a:func, a:charcnt, a:repeat) 
endfunction

nmap <Leader>am01 :call g:MJob("j1", function("g:MJob1"), 1,1)<CR>
nmap <Leader>am02 :call g:MJob("j2", function("g:MJob2"), 2,1)<CR>
nmap <Leader>am03 :call g:MJob("j3", function("g:MJob3"), 3,1)<CR>
nmap <Leader>am04 :call g:MJob("j4", function("g:MJob4"), 4,1)<CR>
nmap <Leader>am05 :call g:MJob("j5", function("g:MJob5"), 5,1)<CR>
nmap <Leader>am10 :call g:MJob("j10", function("g:MJob10"), 10,1)<CR>
nmap <Leader>am20 :call g:MJob("j10", function("g:MJob20"), 20,1)<CR>

nmap <Leader>rm1 :call g:RemoveJob("j1")<CR>
nmap <Leader>rm2 :call g:RemoveJob("j2")<CR>
nmap <Leader>rm3 :call g:RemoveJob("j3")<CR>
nmap <Leader>rm4 :call g:RemoveJob("j4")<CR>
nmap <Leader>rm5 :call g:RemoveJob("j5")<CR>
nmap <Leader>rm6 :call g:RemoveJob("j6")<CR>
nmap <Leader>rm7 :call g:RemoveJob("j7")<CR>


nmap <Leader>c01 :call g:SetMaxMotionCounter(1)<CR>
nmap <Leader>c05 :call g:SetMaxMotionCounter(5)<CR>
nmap <Leader>c10 :call g:SetMaxMotionCounter(10)<CR>
nmap <Leader>c20 :call g:SetMaxMotionCounter(20)<CR>

endif " MMMMM
" --------------------------------------------------------

