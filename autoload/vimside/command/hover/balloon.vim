" ============================================================================
" balloon.vim
"
" File:          balloon.vim
" Summary:       Vimside Hover output to Balloon
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Uses built-in GVim balloon capability.
"
" From Vim debugger.txt conerning setting balloon colors:
" The Balloon Evaluation has some settable parameters too.  For Motif the font
" list and colors can be set via X resources (XmNballoonEvalFontList,
" XmNballoonEvalBackground, and XmNballoonEvalForeground).
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")




let s:hover_balloon_value = ''

function! vimside#command#hover#balloon#Enabled()
  let [found, enabled] = g:vimside.GetOption('vimside-hover-balloon-enabled')
  if ! found
    throw "Option not found: "'vimside-hover-balloon-enabled'"
  endif
  return enabled
endfunction

function! vimside#command#hover#balloon#IsSupported()
  return (has("gui_running") && has("balloon_eval"))
endfunction

function! s:GetCurrentBalloonOffset()
  return line2byte(v:beval_lnum)+v:beval_col-1
endfunction

function! vimside#command#hover#balloon#Stop()
  let &ballooneval = 0
endfunction

function! vimside#command#hover#balloon#Start()
" call s:LOG("vimside#command#hover#balloon#Start") 
  set bexpr=vimside#command#hover#balloon#BalloonExpr()
  let &ballooneval = 1
  return function("vimside#command#hover#balloon#Stop")
endfunction


function! vimside#command#hover#balloon#Handler_Ok(dic, ...)
  let dic = a:dic

  let text = vimside#command#hover#util#GetHoverText(dic)
  let s:hover_balloon_value = text

  return 1
endfunction



function! vimside#command#hover#balloon#BalloonExpr()
" call s:LOG("vimside#command#hover#balloon#BalloonExpr") 
  
  let dic = {
        \ 'handler': {
        \   'ok': function("vimside#command#hover#balloon#Handler_Ok")
        \ },
        \ 'args': {
        \   'offset': s:GetCurrentBalloonOffset()
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)

  return s:hover_balloon_value
endfunction

