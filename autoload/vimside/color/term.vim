" ============================================================================
" term.vim
"
" File:          term.vim
" Summary:       Term (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" http://vim.wikia.com/wiki/256_colors_setup_for_console_Vim




" ------------------------------------------------------------ 
"  eterm types:
"      eterm           No Color
"      eterm-color     (8color)
"  Eterm types:
"      Eterm           (8color)
"      Eterm-color     (8color)
"      Eterm-88color  
"      Eterm-256color  
"  Konsole types:
"    * konsole         (8color)
"      konsole-256color
"  Rxvt types:
"      rxvt           (8color)
"    * rxvt-color     (8color)
"    * rxvt-16color   note: map to xterm 16
"      rxvt-88color
"    * rxvt-unicode   (88color)
"      rxvt-unicode-256color
"    * rxvt-256color  
"  XTerm types:
"    * xterm-color    (8color0
"    * xterm-16color
"    * xterm-88color
"    * xterm-256color
"
"  and there are others
" Refs:
"   /usr/share/terminfo/*
" ------------------------------------------------------------ 

" ------------------------------------------------------------ 
" Define konsole and eterm variables: {{{2
" Refs:
" ------------------------------------------------------------ 
if ! exists("g:FORMS_COLOR_TERM_KONSOLE")
  let g:FORMS_COLOR_TERM_KONSOLE = 0
endif
if ! exists("g:FORMS_COLOR_TERM_ETERM")
  let g:FORMS_COLOR_TERM_ETERM = 0
endif

" ------------------------------------------------------------ 
" Set current session Term functions: {{{2
"   There are two independent variables involved, encoding and
"   number of colors. 
"   The encoding can be: 'utf-8' or not 'utf-8'.
"   The colors count can be: 256, 88, 16 or 8 (where gui == 256).
"   This code ONLY deals with the number of colors.
" Refs:
" ------------------------------------------------------------ 
if has("gui_running")
  " Want to support Forms in GVim, so must still set term functions
  " Use Xterm
  let g:FORMS_COLOR_TERM_TYPE = 'gui'
  let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#xterm256#ConvertRGB_2_Int")
  let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#xterm256#ConvertInt_2_RGB")
  let g:FORMS_COLOR_TERM_NUMBER_COLORS = 256


elseif &t_Co == 256
  if &term =~? '^konsole' || g:FORMS_COLOR_TERM_KONSOLE
    let g:FORMS_COLOR_TERM_TYPE = 'konsole'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#konsole#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#konsole#ConvertInt256_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 256

  elseif &term =~? '^eterm' || g:FORMS_COLOR_TERM_ETERM
    let g:FORMS_COLOR_TERM_TYPE = 'eterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#eterm#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#eterm#ConvertInt256_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 256

  elseif &term =~? '^rxvt'
    " Use Xterm functions for rxvt-unicode-256color
    " rxvt-unicode-256color 
    let g:FORMS_COLOR_TERM_TYPE = 'urxvt256'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#xterm256#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#xterm256#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 256

  else
    " xterm
    let g:FORMS_COLOR_TERM_TYPE = 'xterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#xterm256#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#xterm256#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 256
  endif

elseif &t_Co == 88
  if &term =~? '^rxvt'
    " rxvt-unicode
    let g:FORMS_COLOR_TERM_TYPE = 'urxvt'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#urxvt#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#urxvt#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 88

  else
    let g:FORMS_COLOR_TERM_TYPE = 'xterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#xterm88#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#xterm88#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 88

  endif

elseif &t_Co == 16
    let g:FORMS_COLOR_TERM_TYPE = 'xterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#xterm16#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#xterm16#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 16

elseif &t_Co == 8
  if &term =~? '^rxvt'
    let g:FORMS_COLOR_TERM_TYPE = 'rxvt'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#rxvt#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#rxvt#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 8 

  else
    " Punt: for now use rxvt code
    let g:FORMS_COLOR_TERM_TYPE = 'xterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("vimside#color#xterm8#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("vimside#color#xterm8#ConvertInt_2_RGB")
    let g:FORMS_COLOR_TERM_NUMBER_COLORS = 8 

  endif
endif

function! vimside#color#term#ConvertRGBTxt_2_Int(rgbtxt)
  let [l:found, l:value] = vimside#color#util#ParseRGB(a:rgbtxt)
  if l:found
    let [r,g,b] = l:value
    return g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT(r, g, b)
  else
    return 1
  endif
endfunction

function! vimside#color#term#ConvertRGB_2_Int(rn, gn, bn)
  return g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT(a:rn, a:gn, a:bn)
endfunction

" return [0, errormsg] or [1, rgb]
function! vimside#color#term#ConvertInt_2_RGB(n)
  return g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB(a:n)
endfunction

function! vimside#color#term#NumberColors()
  return g:FORMS_COLOR_TERM_NUMBER_COLORS
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
