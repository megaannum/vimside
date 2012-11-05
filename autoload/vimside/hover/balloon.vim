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

function! vimside#hover#balloon#Enabled()
  let [found, enabled] = g:vimside.GetOption('vimside-hover-balloon-enabled')
  if ! found
    throw "Vimside: Option not found: "'vimside-hover-balloon-enabled'"
  endif
  return enabled
endfunction

function! vimside#hover#balloon#IsSupported()
  return (has("gui_running") && has("balloon_eval"))
endfunction

function! s:GetCurrentBalloonOffset()
  return line2byte(v:beval_lnum)+v:beval_col-1
endfunction

function! vimside#hover#balloon#Stop()
  let &ballooneval = 0
endfunction

function! vimside#hover#balloon#Start()
" call s:LOG("vimside#hover#balloon#Start") 
  set bexpr=vimside#hover#balloon#BalloonExpr()
  let &ballooneval = 1
  return function("vimside#hover#balloon#Stop")
endfunction


function! vimside#hover#balloon#Handler_Ok(symbolinfo)
" call s:LOG("vimside#hover#balloon#Handler_Ok ". string(a:symbolinfo)) 
  let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:symbolinfo)
  if ! found
    echoe "vimside#hover#balloon#Handler_Ok: Badly formed Response"
    call s:ERROR("vimside#hover#balloon#Handler_Ok: Badly formed Response: ". string(a:symbolinfo))
    return 0
  endif

  let text = vimside#hover#util#GetHoverText(dic)
  let s:hover_balloon_value = text

  return 1
endfunction



function! vimside#hover#balloon#BalloonExpr()
" call s:LOG("vimside#hover#balloon#BalloonExpr") 
  
  let dic = {
        \ 'handler': {
        \   'ok': function("vimside#hover#balloon#Handler_Ok")
        \ },
        \ 'args': {
        \   'offset': s:GetCurrentBalloonOffset()
        \ }
        \ }
  call vimside#swank#rpc#symbol_at_point#Run(dic)

  return s:hover_balloon_value
endfunction

