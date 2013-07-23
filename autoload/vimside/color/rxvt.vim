" ============================================================================
" rxvt.vim
"
" File:          rxvt.vim
" Summary:       Rxvt 8 colors (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" ------------------------------------------------------------ 
" Define Int_2_Name Dictionary: {{{2
" Refs:
"   rxvt-unicode-9.1.5 src/init.C
" ------------------------------------------------------------ 
let s:Int_2_Name = {
    \ '0': 'black',
    \ '1': 'red3',
    \ '2': 'green3',
    \ '3': 'yellow3',
    \ '4': 'blue3',
    \ '5': 'magenta3',
    \ '6': 'cyan3',
    \ '7': 'AntiqueWhite'
    \ }

" ------------------------------------------------------------ 
" Define Int_2_RGB Dictionary: {{{2
" Refs:
"   rxvt-9.1.5 src/init.C
" ------------------------------------------------------------ 
let s:Int_2_RGB = {
    \ '0': '000000',
    \ '1': 'cd0000',
    \ '2': '00cd00',
    \ '3': 'cdcd00',
    \ '4': '0000cd',
    \ '5': 'cd00cd',
    \ '6': '00cdcd',
    \ '7': 'faebd7'
    \ }

" ------------------------------------------------------------ 
" Generate RGB_2_Int Dictionary: {{{2
" WHAT A HACK!!!
" ------------------------------------------------------------ 
let s:RGB_2_Int = {}
for key in sort(keys(s:Int_2_RGB))
  let s:RGB_2_Int[s:Int_2_RGB[key]] = key
endfor
let s:RGB_2_Int['cdcdcd'] = '7'

let s:RGB_2_Int['cdcdd7'] = '7'
let s:RGB_2_Int['cdebcd'] = '7'
let s:RGB_2_Int['facdcd'] = '7'

let s:RGB_2_Int['cdebd7'] = '7'
let s:RGB_2_Int['facdd7'] = '7'
let s:RGB_2_Int['faebcd'] = '7'

let s:RGB_2_Int['fa0000'] = '1'
let s:RGB_2_Int['00eb00'] = '2'
let s:RGB_2_Int['0000d7'] = '4'

let s:RGB_2_Int['faeb00'] = '3'
let s:RGB_2_Int['cdeb00'] = '3'
let s:RGB_2_Int['facd00'] = '3'

let s:RGB_2_Int['fa00cd'] = '5'
let s:RGB_2_Int['fa00d7'] = '5'
let s:RGB_2_Int['cd00d7'] = '5'

let s:RGB_2_Int['00ebd7'] = '6'
let s:RGB_2_Int['00cdd7'] = '6'
let s:RGB_2_Int['00ebcd'] = '6'


" rxvt number to rgb string
let s:ColorTable= []
" TODO make into list of [r,g,b] values
let cnt = 0
while cnt < 8
  let rgb = s:Int_2_RGB[cnt]
  let r = rgb[0:1]
  let g = rgb[2:3]
  let b = rgb[4:5]
  let rn = str2nr(r, 16)
  let gn = str2nr(g, 16)
  let bn = str2nr(b, 16)
  call add(s:ColorTable, [rn,gn,bn])

  let cnt += 1
endwhile

if 0
" intensities=[0, 139, 205, 255]
" intensities = (0x00, 0x8b, 0xcd, 0xff)
let s:intensities = [
          \ str2nr("0x00",16),
          \ str2nr("0x8b",16),
          \ str2nr("0xcd",16),
          \ str2nr("0xff",16)
          \ ]
endif


" ------------------------------------------------------------ 
" ConvertRGB_2_Int: {{{2
"  Converts an rgb String to a rxvt 8 Number
"    Tried to make this fast.
"    Returns the rxvt 8 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#rxvt#ConvertRGB_2_Int(rn, gn, bn)
"let start = reltime()
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

" call vimside#log("ConvertRGB_2_Int: in rn=". rn)
" call vimside#log("ConvertRGB_2_Int: in gn=". gn)
" call vimside#log("ConvertRGB_2_Int: in bn=". bn)
  
  " red
  if rn <= 205
    let rnx = ((rn+rn) <= 205) ? 0 : 205
  else
    let rnx = ((rn+rn) <= 455) ? 205 : 250
  endif

  " green
  if gn <= 205
    let gnx = ((gn+gn) <= 205) ? 0 : 205
  else
    let gnx = ((gn+gn) <= 440) ? 205 : 235
  endif
  if bn <= 205
    let bnx = ((bn+bn) <= 205) ? 0 : 205
  else
    let bnx = ((bn+bn) <= 420) ? 205 : 215
  endif

" call vimside#log("ConvertRGB_2_Int: outjrnx=". rnx)
" call vimside#log("ConvertRGB_2_Int: outjgnx=". gnx)
" call vimside#log("ConvertRGB_2_Int: outjbnx=". bnx)

  let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
" call vimside#log("ConvertRGB_2_Int: rgbtxt=". rgbtxt)
  let n = s:RGB_2_Int[rgbtxt]
"call vimside#log("ConvertRGB_2_Int:       time=". reltimestr(reltime(start)))
" call vimside#log("ConvertRGB_2_Int: n=". n)
  return n
endfunction

" ------------------------------------------------------------ 
" ConvertInt_2_RGB: {{{2
"  Converts an 8 String or Number to an rgb String
"    Returns the rgb String
"  parameters:
"    nr : String or Number or rxvt 8 value
"           value must be 0 <= value <= 8
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, rgb]
function! vimside#color#rxvt#ConvertInt_2_RGB(nr)
  if (type(a:nr) == g:self#NUMBER_TYPE)
    return [1, s:Int_2_RGB[a:nr]]
  elseif (type(a:nr) == g:self#STRING_TYPE)
    return [1, s:Int_2_RGB[a:nr]]
  else
    return [0, "Bad number: " . string(a:nsstr)]
  endif
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
