" ============================================================================
" xterm256.vim
"
" File:          xterm256.vim
" Summary:       XTerm 256 (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" ------------------------------------------------------------ 
" Define Int_2_Name Dictionary: {{{2
" Refs:
"   http://www.opensource.apple.com/source/ncurses/ncurses-27/ncurses/test/xterm-88color.dat
"   xterm-281/xter/charproc.c
"   NOTE: color for 12 does not have name!!
" ------------------------------------------------------------ 
let s:Int_2_Name = {
    \ '0': 'black',
    \ '1': 'red3',
    \ '2': 'green3',
    \ '3': 'yellow3',
    \ '4': 'blue2',
    \ '5': 'magenta3',
    \ '6': 'cyan3',
    \ '7': 'gray90',
    \ '8': 'gray50',
    \ '9': 'red',
    \ '10': 'green',
    \ '11': 'yellow',
    \ '12': 'UnknownBlue',
    \ '13': 'magenta',
    \ '14': 'cyan',
    \ '15': 'white'
    \ }

" ------------------------------------------------------------ 
" Define Int_2_RGB Dictionary: {{{2
" Refs:
"   https://en.wikipedia.org/wiki/File:Xterm_color_chart.png
"   rxvt-unicode-9.1.5 src/init.C
"   xterm-281/256colres.h
" TODO: should #8 be '4d4d4d' or '7f7f7f'
" ------------------------------------------------------------ 
let s:Int_2_RGB = {
    \ '0': '000000',
    \ '1': 'cd0000',
    \ '2': '00cd00',
    \ '3': 'cdcd00',
    \ '4': '0000ee',
    \ '5': 'cd00cd',
    \ '6': '00cdcd',
    \ '7': 'e5e5e5',
    \ '8': '4d4d4d',
    \ '9': 'ff0000',
    \ '10': '00ff00',
    \ '11': 'ffff00',
    \ '12': '5c5cff',
    \ '13': 'ff00ff',
    \ '14': '00ffff',
    \ '15': 'ffffff',
    \ '16': '000000',
    \ '17': '00005f',
    \ '18': '000087',
    \ '19': '0000af',
    \ '20': '0000d7',
    \ '21': '0000ff',
    \ '22': '005f00',
    \ '23': '005f5f',
    \ '24': '005f87',
    \ '25': '005faf',
    \ '26': '005fd7',
    \ '27': '005fff',
    \ '28': '008700',
    \ '29': '00875f',
    \ '30': '008787',
    \ '31': '0087af',
    \ '32': '0087d7',
    \ '33': '0087ff',
    \ '34': '00af00',
    \ '35': '00af5f',
    \ '36': '00af87',
    \ '37': '00afaf',
    \ '38': '00afd7',
    \ '39': '00afff',
    \ '40': '00d700',
    \ '41': '00d75f',
    \ '42': '00d787',
    \ '43': '00d7af',
    \ '44': '00d7d7',
    \ '45': '00d7ff',
    \ '46': '00ff00',
    \ '47': '00ff5f',
    \ '48': '00ff87',
    \ '49': '00ffaf',
    \ '50': '00ffd7',
    \ '51': '00ffff',
    \ '52': '5f0000',
    \ '53': '5f005f',
    \ '54': '5f0087',
    \ '55': '5f00af',
    \ '56': '5f00d7',
    \ '57': '5f00ff',
    \ '58': '5f5f00',
    \ '59': '5f5f5f',
    \ '60': '5f5f87',
    \ '61': '5f5faf',
    \ '62': '5f5fd7',
    \ '63': '5f5fff',
    \ '64': '5f8700',
    \ '65': '5f875f',
    \ '66': '5f8787',
    \ '67': '5f87af',
    \ '68': '5f87d7',
    \ '69': '5f87ff',
    \ '70': '5faf00',
    \ '71': '5faf5f',
    \ '72': '5faf87',
    \ '73': '5fafaf',
    \ '74': '5fafd7',
    \ '75': '5fafff',
    \ '76': '5fd700',
    \ '77': '5fd75f',
    \ '78': '5fd787',
    \ '79': '5fd7af',
    \ '80': '5fd7d7',
    \ '81': '5fd7ff',
    \ '82': '5fff00',
    \ '83': '5fff5f',
    \ '84': '5fff87',
    \ '85': '5fffaf',
    \ '86': '5fffd7',
    \ '87': '5fffff',
    \ '88': '870000',
    \ '89': '87005f',
    \ '90': '870087',
    \ '91': '8700af',
    \ '92': '8700d7',
    \ '93': '8700ff',
    \ '94': '875f00',
    \ '95': '875f5f',
    \ '96': '875f87',
    \ '97': '875faf',
    \ '98': '875fd7',
    \ '99': '875fff',
    \ '100': '878700',
    \ '101': '87875f',
    \ '102': '878787',
    \ '103': '8787af',
    \ '104': '8787d7',
    \ '105': '8787ff',
    \ '106': '87af00',
    \ '107': '87af5f',
    \ '108': '87af87',
    \ '109': '87afaf',
    \ '110': '87afd7',
    \ '111': '87afff',
    \ '112': '87d700',
    \ '113': '87d75f',
    \ '114': '87d787',
    \ '115': '87d7af',
    \ '116': '87d7d7',
    \ '117': '87d7ff',
    \ '118': '87ff00',
    \ '119': '87ff5f',
    \ '120': '87ff87',
    \ '121': '87ffaf',
    \ '122': '87ffd7',
    \ '123': '87ffff',
    \ '124': 'af0000',
    \ '125': 'af005f',
    \ '126': 'af0087',
    \ '127': 'af00af',
    \ '128': 'af00d7',
    \ '129': 'af00ff',
    \ '130': 'af5f00',
    \ '131': 'af5f5f',
    \ '132': 'af5f87',
    \ '133': 'af5faf',
    \ '134': 'af5fd7',
    \ '135': 'af5fff',
    \ '136': 'af8700',
    \ '137': 'af875f',
    \ '138': 'af8787',
    \ '139': 'af87af',
    \ '140': 'af87d7',
    \ '141': 'af87ff',
    \ '142': 'afaf00',
    \ '143': 'afaf5f',
    \ '144': 'afaf87',
    \ '145': 'afafaf',
    \ '146': 'afafd7',
    \ '147': 'afafff',
    \ '148': 'afd700',
    \ '149': 'afd75f',
    \ '150': 'afd787',
    \ '151': 'afd7af',
    \ '152': 'afd7d7',
    \ '153': 'afd7ff',
    \ '154': 'afff00',
    \ '155': 'afff5f',
    \ '156': 'afff87',
    \ '157': 'afffaf',
    \ '158': 'afffd7',
    \ '159': 'afffff',
    \ '160': 'd70000',
    \ '161': 'd7005f',
    \ '162': 'd70087',
    \ '163': 'd700af',
    \ '164': 'd700d7',
    \ '165': 'd700ff',
    \ '166': 'd75f00',
    \ '167': 'd75f5f',
    \ '168': 'd75f87',
    \ '169': 'd75faf',
    \ '170': 'd75fd7',
    \ '171': 'd75fff',
    \ '172': 'd78700',
    \ '173': 'd7875f',
    \ '174': 'd78787',
    \ '175': 'd787af',
    \ '176': 'd787d7',
    \ '177': 'd787ff',
    \ '178': 'd7af00',
    \ '179': 'd7af5f',
    \ '180': 'd7af87',
    \ '181': 'd7afaf',
    \ '182': 'd7afd7',
    \ '183': 'd7afff',
    \ '184': 'd7d700',
    \ '185': 'd7d75f',
    \ '186': 'd7d787',
    \ '187': 'd7d7af',
    \ '188': 'd7d7d7',
    \ '189': 'd7d7ff',
    \ '190': 'd7ff00',
    \ '191': 'd7ff5f',
    \ '192': 'd7ff87',
    \ '193': 'd7ffaf',
    \ '194': 'd7ffd7',
    \ '195': 'd7ffff',
    \ '196': 'ff0000',
    \ '197': 'ff005f',
    \ '198': 'ff0087',
    \ '199': 'ff00af',
    \ '200': 'ff00d7',
    \ '201': 'ff00ff',
    \ '202': 'ff5f00',
    \ '203': 'ff5f5f',
    \ '204': 'ff5f87',
    \ '205': 'ff5faf',
    \ '206': 'ff5fd7',
    \ '207': 'ff5fff',
    \ '208': 'ff8700',
    \ '209': 'ff875f',
    \ '210': 'ff8787',
    \ '211': 'ff87af',
    \ '212': 'ff87d7',
    \ '213': 'ff87ff',
    \ '214': 'ffaf00',
    \ '215': 'ffaf5f',
    \ '216': 'ffaf87',
    \ '217': 'ffafaf',
    \ '218': 'ffafd7',
    \ '219': 'ffafff',
    \ '220': 'ffd700',
    \ '221': 'ffd75f',
    \ '222': 'ffd787',
    \ '223': 'ffd7af',
    \ '224': 'ffd7d7',
    \ '225': 'ffd7ff',
    \ '226': 'ffff00',
    \ '227': 'ffff5f',
    \ '228': 'ffff87',
    \ '229': 'ffffaf',
    \ '230': 'ffffd7',
    \ '231': 'ffffff',
    \ '232': '080808',
    \ '233': '121212',
    \ '234': '1c1c1c',
    \ '235': '262626',
    \ '236': '303030',
    \ '237': '3a3a3a',
    \ '238': '444444',
    \ '239': '4e4e4e',
    \ '240': '585858',
    \ '241': '626262',
    \ '242': '6c6c6c',
    \ '243': '767676',
    \ '244': '808080',
    \ '245': '8a8a8a',
    \ '246': '949494',
    \ '247': '9e9e9e',
    \ '248': 'a8a8a8',
    \ '249': 'b2b2b2',
    \ '250': 'bcbcbc',
    \ '251': 'c6c6c6',
    \ '252': 'd0d0d0',
    \ '253': 'dadada',
    \ '254': 'e4e4e4',
    \ '255': 'eeeeee'
    \ }

" ------------------------------------------------------------ 
" Generate RGB_2_Int Dictionary: {{{2
" ------------------------------------------------------------ 
let s:RGB_2_Int = {}
for key in sort(keys(s:Int_2_RGB))
  let s:RGB_2_Int[s:Int_2_RGB[key]] = key
endfor

" xterm number to rgb string
let s:ColorTable = []
" TODO make into list of [r,g,b] values
let cnt = 0
while cnt < 256
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

" http://root.cern.ch/svn/root/tags/v5-30-06/core/textinput/src/textinput/TerminalDisplayUnix.cpp
" http://crunchbanglinux.org/forums/topic/20674/view-images-and-gifs-in-the-terminal/
" 6 intensity RGB
" intensities=[0, 95, 135, 175, 215, 255]
" intensities = (0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff)
let s:intensities = [
          \ str2nr("0x00",16),
          \ str2nr("0x5f",16),
          \ str2nr("0x87",16),
          \ str2nr("0xaf",16),
          \ str2nr("0xd7",16),
          \ str2nr("0xff",16)
          \ ]


" ------------------------------------------------------------ 
" ConvertRGB_2_Int: {{{2
"  Converts an rgb String to a xterm 256 Number
"    Tried to make this fast.
"    Returns the xterm 256 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 

" binary search over possible intensities256
function! s:GetPartial_Int(n)
  " intensities=[0, 95, 135, 175, 215, 255]
  " intensities = (0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff)
  let n = a:n
  let n2 = n+n

  if n <= 135
    if n <= 95
      return (n2 <= 95) ? 0 : 95
    else
      return (n2 <= 230) ? 95 : 135 
    endif
  else
    if n <= 215
      if n <= 175
        return (n2 <= 310) ? 135 : 175
      else
        return (n2 <= 390) ? 175 : 215
      endif
    else
      return (n2 <= 470) ? 215 : 255
    endif
  endif
endfunction

function! vimside#color#xterm256#ConvertRGB_2_Int(rn, gn, bn)
"let start = reltime()
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

" call vimside#log("ConvertRGB_2_Int: in rn=". rn)
" call vimside#log("ConvertRGB_2_Int: in gn=". gn)
" call vimside#log("ConvertRGB_2_Int6: in bn=". bn)

  " special case 
  "  '1': 'cd0000',
  "  '2': '00cd00',
  "  '3': 'cdcd00',
  "  '4': '0000ee',
  "  '5': 'cd00cd',
  "  '6': '00cdcd',
  "  '7': 'e5e5e5',
  "  '8': '4d4d4d',
  "  '12': '5c5cff',
  if (rn == 205) && (gn == 0) && (bn == 0)
    return 1
  elseif (rn == 0) && (gn == 205) && (bn == 0)
    return 2
  elseif (rn == 205) && (gn == 205) && (bn == 0)
    return 3
  elseif (rn == 0) && (gn == 0) && (bn == 238)
    return 4
  elseif (rn == 205) && (gn == 0) && (bn == 205)
    return 5
  elseif (rn == 0) && (gn == 205) && (bn == 205)
    return 6
  elseif (rn == 229) && (gn == 229) && (bn == 229)
    return 7
  elseif (rn == 77) && (gn == 77) && (bn == 77)
    return 8
  elseif (rn == 92) && (gn == 92) && (bn == 255)
    return 12
  endif
  
  let rnx = s:GetPartial_Int(rn)
  let gnx = s:GetPartial_Int(gn)
  let bnx = s:GetPartial_Int(bn)
" call vimside#log("ConvertRGB_2_Int: outjrnx=". rnx)
" call vimside#log("ConvertRGB_2_Int: outjgnx=". gnx)
" call vimside#log("ConvertRGB_2_Int: outjbnx=". bnx)

  " must check grey levels which can be a closer match
  " TODO how to tell if we are near a grey level and
  "   only do the following if we are near?
  let diff = abs(rnx-rn) + abs(gnx-gn) + abs(bnx-bn)
" call vimside#log("ConvertRGB_2_Int: diff=". diff)
  let best_match = -1
  let cnt = 232
  while cnt < 256
    let [rx,gx,bx] = s:ColorTable[cnt]
    let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)
" call vimside#log("ConvertRGB_2_Int: d=". d)

    " on equals, prefer gray to color
    if d < diff
      let diff = d
      let best_match = cnt
    endif

    let cnt += 1
  endwhile

  if best_match != -1
" call vimside#log("ConvertRGB_2_Int: best_match=". best_match)
    let n = best_match
  else
    let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
" call vimside#log("ConvertRGB_2_Int: rgbtxt=". rgbtxt)
    let n = s:RGB_2_Int[rgbtxt]
  endif
" call vimside#log("ConvertRGB_2_Int:      time=". reltimestr(reltime(start)))
"call vimside#log("ConvertRGB_2_Int: n=". n)
  return n
endfunction

" ------------------------------------------------------------ 
" ConvertRGB_2_IntGood: {{{2
"  Converts an rgb String to a xterm 256 Number
"    Tried to make this fast.
"    Returns the xterm 256 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
"
function! s:GetPartial_IntGood(n, intensities)
  let n = a:n
  let intensities = a:intensities
  let s = intensities[0]
  let b = intensities[1]
  if s <= n && n <= b
"call vimside#log("ConvertRGB_2_IntGood: 0")
    return (n+n <= s+b) ? s : b
  endif
  let s = b
  let b = intensities[2]
  if s <= n && n <= b
"call vimside#log("ConvertRGB_2_IntGood: 1")
    return (n+n <= s+b) ? s : b
  endif
  let s = b
  let b = intensities[3]
  if s <= n && n <= b
"call vimside#log("ConvertRGB_2_IntGood: 2")
    return (n+n <= s+b) ? s : b
  endif
  let s = b
  let b = intensities[4]
  if s <= n && n <= b
"call vimside#log("ConvertRGB_2_IntGood: 3")
    return (n+n <= s+b) ? s : b
  endif
  let s = b
  let b = intensities[5]
  if s <= n && n <= b
"call vimside#log("ConvertRGB_2_IntGood: 4")
    return (n+n <= s+b) ? s : b
  endif
  throw "ConvertRGB_2_IntGood.GetPartial_IntGood: Bad partial color: " . string(n)
endfunction

function! vimside#color#xterm256#ConvertRGB_2_IntGood(rn, gn, bn)
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn
"let start = reltime()

"call vimside#log("ConvertRGB_2_IntGood: in rn=". rn)
"call vimside#log("ConvertRGB_2_IntGood: in gn=". gn)
"call vimside#log("ConvertRGB_2_IntGood: in bn=". bn)
  
  let rnx = s:GetPartial_IntGood(rn, s:intensities)
  let gnx = s:GetPartial_IntGood(gn, s:intensities)
  let bnx = s:GetPartial_IntGood(bn, s:intensities)
"call vimside#log("ConvertRGB_2_IntGood: rnx=". rnx)
"call vimside#log("ConvertRGB_2_IntGood: gnx=". gnx)
"call vimside#log("ConvertRGB_2_IntGood: bnx=". bnx)

  " must check grey levels which can be a closer match
  let diff = abs(rnx-rn) + abs(gnx-gn) + abs(bnx-bn)
  let best_match = -1
  let cnt = 232
  while cnt < 256
    let [rx,gx,bx] = s:ColorTable[cnt]
    let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

    if d <= diff
      let diff = d
      let best_match = cnt
    endif

    let cnt += 1
  endwhile

  if best_match != -1
"call vimside#log("ConvertRGB_2_IntGood: best_match=". best_match)
    let n = best_match
  else
    let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
"call vimside#log("ConvertRGB_2_IntGood: rgbtxt=". rgbtxt)
    let n = s:RGB_2_Int[rgbtxt]
  endif
"call vimside#log("ConvertRGB_2_IntGood:  time=". reltimestr(reltime(start)))
"call vimside#log("ConvertRGB_2_IntGood: n=". n)
  return n
endfunction



" http://crunchbanglinux.org/forums/topic/20674/view-images-and-gifs-in-the-terminal/
" ------------------------------------------------------------ 
" ConvertRGB_2_IntSlow: {{{2
"  Converts an rgb String to a xterm 256 Number
"    Tried to make this fast.
"    Returns the xterm 256 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#xterm256#ConvertRGB_2_IntSlow(rn, gn, bn)
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn
"let start = reltime()

"call vimside#log("ConvertRGB_2_IntSlow: in rn=". rn)
"call vimside#log("ConvertRGB_2_IntSlow: in gn=". gn)
"call vimside#log("ConvertRGB_2_IntSlow: in bn=". bn)
  let best_match = 0
  let diff = 10000000

  let cnt = 16
  while cnt < 256
    let [rx,gx,bx] = s:ColorTable[cnt]
    let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

    if d < diff
      let diff = d
      let best_match = cnt
    endif

    let cnt += 1
  endwhile
"call vimside#log("ConvertRGB_2_IntSlow:  time=". reltimestr(reltime(start)))
"call vimside#log("ConvertRGB_2_IntSlow: best_match=". best_match)
  return best_match

endfunction

" ------------------------------------------------------------ 
" ConvertInt_2_RGB: {{{2
"  Converts an xterm 256 String or Number to an rgb String
"    Returns the rgb String
"  parameters:
"    nr : String or Number or xterm 256 value
"           value must be 0 <= value <= 255
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, rgb]
function! vimside#color#xterm256#ConvertInt_2_RGB(nr)
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
