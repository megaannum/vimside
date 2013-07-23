" ============================================================================
" urxvt.vim
"
" File:          urxvt.vim
" Summary:       Rxvt-Unicode (part of Forms Library)
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
    \ '7': 'AntiqueWhite',
    \ '8': 'gray25',
    \ '9': 'red',
    \ '10': 'green',
    \ '11': 'yellow',
    \ '12': 'SteelBlue1',
    \ '13': 'magenta',
    \ '14': 'cyan',
    \ '15': 'white'
    \ }

" ------------------------------------------------------------ 
" Define Int_2_RGB Dictionary: {{{2
" Refs:
"   rxvt-unicode-9.1.5 src/init.C
" ------------------------------------------------------------ 
let s:Int_2_RGB = {
    \ '0': '000000',
    \ '1': 'cd0000',
    \ '2': '00cd00',
    \ '3': 'cdcd00',
    \ '4': '0000cd',
    \ '5': 'cd00cd',
    \ '6': '00cdcd',
    \ '7': 'faebd7',
    \ '8': '404040',
    \ '9': 'ff0000',
    \ '10': '00ff00',
    \ '11': 'ffff00',
    \ '12': '0000ff',
    \ '13': 'ff00ff',
    \ '14': '00ffff',
    \ '15': 'ffffff',
    \ '16': '000000',
    \ '17': '00008b',
    \ '18': '0000cd',
    \ '19': '0000ff',
    \ '20': '008b00',
    \ '21': '008b8b',
    \ '22': '008bcd',
    \ '23': '008bff',
    \ '24': '00cd00',
    \ '25': '00cd8b',
    \ '26': '00cdcd',
    \ '27': '00cdff',
    \ '28': '00ff00',
    \ '29': '00ff8b',
    \ '30': '00ffcd',
    \ '31': '00ffff',
    \ '32': '8b0000',
    \ '33': '8b008b',
    \ '34': '8b00cd',
    \ '35': '8b00ff',
    \ '36': '8b8b00',
    \ '37': '8b8b8b',
    \ '38': '8b8bcd',
    \ '39': '8b8bff',
    \ '40': '8bcd00',
    \ '41': '8bcd8b',
    \ '42': '8bcdcd',
    \ '43': '8bcdff',
    \ '44': '8bff00',
    \ '45': '8bff8b',
    \ '46': '8bffcd',
    \ '47': '8bffff',
    \ '48': 'cd0000',
    \ '49': 'cd008b',
    \ '50': 'cd00cd',
    \ '51': 'cd00ff',
    \ '52': 'cd8b00',
    \ '53': 'cd8b8b',
    \ '54': 'cd8bcd',
    \ '55': 'cd8bff',
    \ '56': 'cdcd00',
    \ '57': 'cdcd8b',
    \ '58': 'cdcdcd',
    \ '59': 'cdcdff',
    \ '60': 'cdff00',
    \ '61': 'cdff8b',
    \ '62': 'cdffcd',
    \ '63': 'cdffff',
    \ '64': 'ff0000',
    \ '65': 'ff008b',
    \ '66': 'ff00cd',
    \ '67': 'ff00ff',
    \ '68': 'ff8b00',
    \ '69': 'ff8b8b',
    \ '70': 'ff8bcd',
    \ '71': 'ff8bff',
    \ '72': 'ffcd00',
    \ '73': 'ffcd8b',
    \ '74': 'ffcdcd',
    \ '75': 'ffcdff',
    \ '76': 'ffff00',
    \ '77': 'ffff8b',
    \ '78': 'ffffcd',
    \ '79': 'ffffff',
    \ '80': '2e2e2e',
    \ '81': '5c5c5c',
    \ '82': '737373',
    \ '83': '8b8b8b',
    \ '84': 'a2a2a2',
    \ '85': 'b9b9b9',
    \ '86': 'd0d0d0',
    \ '87': 'e7e7e7'
    \ }

" ------------------------------------------------------------ 
" Generate RGB_2_Int Dictionary: {{{2
" ------------------------------------------------------------ 
let s:RGB_2_Int = {}
for key in sort(keys(s:Int_2_RGB))
  let s:RGB_2_Int[s:Int_2_RGB[key]] = key
endfor

" xterm number to rgb string
let s:ColorTable= []
" TODO make into list of [r,g,b] values
let cnt = 0
while cnt < 88
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

" intensities=[0, 139, 205, 255]
" intensities = (0x00, 0x8b, 0xcd, 0xff)
let s:intensities = [
          \ str2nr("0x00",16),
          \ str2nr("0x8b",16),
          \ str2nr("0xcd",16),
          \ str2nr("0xff",16)
          \ ]


" ------------------------------------------------------------ 
" ConvertRGB_2_Int: {{{2
"  Converts an rgb String to a xterm 88 Number
"    Tried to make this fast.
"    Returns the xterm 88 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 

" binary search over possible intensities
function! s:GetPartial_Int(n)
  " intensities=[0, 139, 205, 255]
  " intensities = (0x00, 0x8b, 0xcd, 0xff)
  let n = a:n
  let n2 = n+n

  if n <= 139
    return (n2 <= 139) ? 0 : 139
  elseif n <= 205
    return (n2 <= 344) ? 139 : 205 
  else
    return (n2 <= 460) ? 205 : 255
  endif
endfunction

function! vimside#color#urxvt#ConvertRGB_2_Int(rn, gn, bn)
"let start = reltime()
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

"call vimside#log("ConvertRGB_2_Int: in rn=". rn)
"call vimside#log("ConvertRGB_2_Int: in gn=". gn)
"call vimside#log("ConvertRGB_2_Int: in bn=". bn)
  
  " special case 
  " '7': 'faebd7'
  " '8': '404040',
  if (rn == 250) && (gn == 235) && (bn == 215)
    return 7
  elseif (rn == 64) && (gn == 64) && (bn == 64)
    return 8
  endif

  let rnx = s:GetPartial_Int(rn)
  let gnx = s:GetPartial_Int(gn)
  let bnx = s:GetPartial_Int(bn)
"call vimside#log("ConvertRGB_2_Int: outjrnx=". rnx)
"call vimside#log("ConvertRGB_2_Int: outjgnx=". gnx)
"call vimside#log("ConvertRGB_2_Int: outjbnx=". bnx)

  " must check grey levels which can be a closer match
  " TODO how to tell if we are near a grey level and
  "   only do the following if we are near?
  let diff = abs(rnx-rn) + abs(gnx-gn) + abs(bnx-bn)
"call vimside#log("ConvertRGB_2_Int: diff=". diff)
  let best_match = -1
  let cnt = 80
  while cnt < 88
    let [rx,gx,bx] = s:ColorTable[cnt]
    let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)
"call vimside#log("ConvertRGB_2_Int: d=". d)

    " on equals, prefer gray to color
    if d <= diff
      let diff = d
      let best_match = cnt
    endif

    let cnt += 1
  endwhile

  if best_match != -1
"call vimside#log("ConvertRGB_2_Int: best_match=". best_match)
    let n = best_match
  else
    let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
"call vimside#log("ConvertRGB_2_Int: rgbtxt=". rgbtxt)
    let n = s:RGB_2_Int[rgbtxt]
  endif
"call vimside#log("ConvertRGB_2_Int:       time=". reltimestr(reltime(start)))
"call vimside#log("ConvertRGB_2_Int: n=". n)
  return n
endfunction

" ------------------------------------------------------------ 
" ConvertInt_2_RGB: {{{2
"  Converts an 88 String or Number to an rgb String
"    Returns the rgb String
"  parameters:
"    nr : String or Number or xterm 88 value
"           value must be 0 <= value <= 88
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, rgb]
function! vimside#color#urxvt#ConvertInt_2_RGB(nr)
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
