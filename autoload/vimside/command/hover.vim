" ============================================================================
" hover.vim
"
" File:          hover.vim
" Summary:       Vimside Hover to Symbol
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Supports two types of Hover to Symbol name approaches.
" For both GVim and Vim, one can have the Symbol name displayed on
" the Command Line. Place cursor, over value, wait for the time
" given by the option 'tailor-hover-updatetime', and the value's
" Symbol name appears on the Command Line.
" The second approach the mouse pointer is used to select the value
" whose Symbol is to be displayed in, what Vim, calls
" a balloon. For GVim, the built-in balloon mechanism is used; 
" wait for the time given by the option 'tailor-hover-updatetime', 
" and the Symbol name appears in a balloon.
" For Vim (running on a Linux system which has both xdotool and dzen2 
" installed) placing the mouse pointer over the value and the
" Symbol appears in a "balloon" (actually, a dzen2 window).
" Running in Hover mode is optional; the same call that start Hover
" mode also is called to stop Hover mode.
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

let g:vimside_hover_save_updatetime = 0
let g:vimside_hover_updatetime = 0
let g:vimside_hover_time_name = 'hover_time_job'

let g:vimside_hover_save_max_mcounter = 0
let g:vimside_hover_max_mcounter = 0
let g:vimside_hover_motion_name = 'hover_motion_job'

function! s:LoadUpdateTimes()
  let [found, value] = g:vimside.GetOption('tailor-hover-updatetime')
  if ! found
    throw "Option not found: "'tailor-hover-updatetime'"
  endif
  let g:vimside_hover_updatetime = value

  let [found, value] = g:vimside.GetOption('tailor-hover-max-char-mcounter')
  if ! found
    throw "Option not found: "'tailor-hover-max-char-mcounter'"
  endif
  let g:vimside_hover_max_mcounter = value

endfunction

call s:LoadUpdateTimes()

let s:vimside_hover_started = 0

function! vimside#command#hover#ToSymbol()
  if s:vimside_hover_started
call s:LOG("vimside#command#hover#ToSymbol: STOP") 
    try 
      call s:Hover_Stop()
    finally
      let s:vimside_hover_started = 0
    endtry

  else
    try 
      if vimside#command#hover#balloon#Enabled() && vimside#command#hover#balloon#IsSupported()
call s:LOG("vimside#command#hover#ToSymbol: DO BALLOON") 
        let s:Hover_Stop = vimside#command#hover#balloon#Start()
      elseif vimside#command#hover#term#Enabled() && vimside#command#hover#term#IsSupported()
call s:LOG("vimside#command#hover#ToSymbol: DO TERM HOVER") 
        let s:Hover_Stop = vimside#command#hover#term#Start()
      else
call s:LOG("vimside#command#hover#ToSymbol: DO CMDLINE") 
        let s:Hover_Stop = vimside#command#hover#cmdline#Start()
      endif
    finally
      let s:vimside_hover_started = 1
    endtry

  endif
endfunction
