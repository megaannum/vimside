" ============================================================================
" eterm.vim
"
" File:          eterm.vim
" Summary:       ETerm (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" ------------------------------------------------------------ 
" Define Int256_2_RGB Dictionary: {{{2
" Refs:
"   http://www.gnu-darwin.org/www001/src/ports/x11/eterm/work/Eterm-0.9.4/src/term.c.html
" ------------------------------------------------------------ 
let s:Int256_2_RGB = {
    \ '0': '000000',
    \ '1': 'cc0000',
    \ '2': '00cc00',
    \ '3': 'cccc00',
    \ '4': '0000cc',
    \ '5': 'cc00cc',
    \ '6': '00cccc',
    \ '7': 'aaaaaa',
    \ '8': '333333',
    \ '9': 'ff0000',
    \ '10': '00ff00',
    \ '11': 'ffff00',
    \ '12': '0000ff',
    \ '13': 'ff00ff',
    \ '14': '00ffff',
    \ '15': 'ffffff',
    \ '16': '000000',
    \ '17': '00002a',
    \ '18': '000055',
    \ '19': '00007f',
    \ '20': '0000aa',
    \ '21': '0000d4',
    \ '22': '002a00',
    \ '23': '002a2a',
    \ '24': '002a55',
    \ '25': '002a7f',
    \ '26': '002aaa',
    \ '27': '002ad4',
    \ '28': '005500',
    \ '29': '00552a',
    \ '30': '005555',
    \ '31': '00557f',
    \ '32': '0055aa',
    \ '33': '0055d4',
    \ '34': '007f00',
    \ '35': '007f2a',
    \ '36': '007f55',
    \ '37': '007f7f',
    \ '38': '007faa',
    \ '39': '007fd4',
    \ '40': '00aa00',
    \ '41': '00aa2a',
    \ '42': '00aa55',
    \ '43': '00aa7f',
    \ '44': '00aaaa',
    \ '45': '00aad4',
    \ '46': '00d400',
    \ '47': '00d42a',
    \ '48': '00d455',
    \ '49': '00d47f',
    \ '50': '00d4aa',
    \ '51': '00d4d4',
    \ '52': '2a0000',
    \ '53': '2a002a',
    \ '54': '2a0055',
    \ '55': '2a007f',
    \ '56': '2a00aa',
    \ '57': '2a00d4',
    \ '58': '2a2a00',
    \ '59': '2a2a2a',
    \ '60': '2a2a55',
    \ '61': '2a2a7f',
    \ '62': '2a2aaa',
    \ '63': '2a2ad4',
    \ '64': '2a5500',
    \ '65': '2a552a',
    \ '66': '2a5555',
    \ '67': '2a557f',
    \ '68': '2a55aa',
    \ '69': '2a55d4',
    \ '70': '2a7f00',
    \ '71': '2a7f2a',
    \ '72': '2a7f55',
    \ '73': '2a7f7f',
    \ '74': '2a7faa',
    \ '75': '2a7fd4',
    \ '76': '2aaa00',
    \ '77': '2aaa2a',
    \ '78': '2aaa55',
    \ '79': '2aaa7f',
    \ '80': '2aaaaa',
    \ '81': '2aaad4',
    \ '82': '2ad400',
    \ '83': '2ad42a',
    \ '84': '2ad455',
    \ '85': '2ad47f',
    \ '86': '2ad4aa',
    \ '87': '2ad4d4',
    \ '88': '550000',
    \ '89': '55002a',
    \ '90': '550055',
    \ '91': '55007f',
    \ '92': '5500aa',
    \ '93': '5500d4',
    \ '94': '552a00',
    \ '95': '552a2a',
    \ '96': '552a55',
    \ '97': '552a7f',
    \ '98': '552aaa',
    \ '99': '552ad4',
    \ '100': '555500',
    \ '101': '55552a',
    \ '102': '555555',
    \ '103': '55557f',
    \ '104': '5555aa',
    \ '105': '5555d4',
    \ '106': '557f00',
    \ '107': '557f2a',
    \ '108': '557f55',
    \ '109': '557f7f',
    \ '110': '557faa',
    \ '111': '557fd4',
    \ '112': '55aa00',
    \ '113': '55aa2a',
    \ '114': '55aa55',
    \ '115': '55aa7f',
    \ '116': '55aaaa',
    \ '117': '55aad4',
    \ '118': '55d400',
    \ '119': '55d42a',
    \ '120': '55d455',
    \ '121': '55d47f',
    \ '122': '55d4aa',
    \ '123': '55d4d4',
    \ '124': '7f0000',
    \ '125': '7f002a',
    \ '126': '7f0055',
    \ '127': '7f007f',
    \ '128': '7f00aa',
    \ '129': '7f00d4',
    \ '130': '7f2a00',
    \ '131': '7f2a2a',
    \ '132': '7f2a55',
    \ '133': '7f2a7f',
    \ '134': '7f2aaa',
    \ '135': '7f2ad4',
    \ '136': '7f5500',
    \ '137': '7f552a',
    \ '138': '7f5555',
    \ '139': '7f557f',
    \ '140': '7f55aa',
    \ '141': '7f55d4',
    \ '142': '7f7f00',
    \ '143': '7f7f2a',
    \ '144': '7f7f55',
    \ '145': '7f7f7f',
    \ '146': '7f7faa',
    \ '147': '7f7fd4',
    \ '148': '7faa00',
    \ '149': '7faa2a',
    \ '150': '7faa55',
    \ '151': '7faa7f',
    \ '152': '7faaaa',
    \ '153': '7faad4',
    \ '154': '7fd400',
    \ '155': '7fd42a',
    \ '156': '7fd455',
    \ '157': '7fd47f',
    \ '158': '7fd4aa',
    \ '159': '7fd4d4',
    \ '160': 'aa0000',
    \ '161': 'aa002a',
    \ '162': 'aa0055',
    \ '163': 'aa007f',
    \ '164': 'aa00aa',
    \ '165': 'aa00d4',
    \ '166': 'aa2a00',
    \ '167': 'aa2a2a',
    \ '168': 'aa2a55',
    \ '169': 'aa2a7f',
    \ '170': 'aa2aaa',
    \ '171': 'aa2ad4',
    \ '172': 'aa5500',
    \ '173': 'aa552a',
    \ '174': 'aa5555',
    \ '175': 'aa557f',
    \ '176': 'aa55aa',
    \ '177': 'aa55d4',
    \ '178': 'aa7f00',
    \ '179': 'aa7f2a',
    \ '180': 'aa7f55',
    \ '181': 'aa7f7f',
    \ '182': 'aa7faa',
    \ '183': 'aa7fd4',
    \ '184': 'aaaa00',
    \ '185': 'aaaa2a',
    \ '186': 'aaaa55',
    \ '187': 'aaaa7f',
    \ '188': 'aaaaaa',
    \ '189': 'aaaad4',
    \ '190': 'aad400',
    \ '191': 'aad42a',
    \ '192': 'aad455',
    \ '193': 'aad47f',
    \ '194': 'aad4aa',
    \ '195': 'aad4d4',
    \ '196': 'd40000',
    \ '197': 'd4002a',
    \ '198': 'd40055',
    \ '199': 'd4007f',
    \ '200': 'd400aa',
    \ '201': 'd400d4',
    \ '202': 'd42a00',
    \ '203': 'd42a2a',
    \ '204': 'd42a55',
    \ '205': 'd42a7f',
    \ '206': 'd42aaa',
    \ '207': 'd42ad4',
    \ '208': 'd45500',
    \ '209': 'd4552a',
    \ '210': 'd45555',
    \ '211': 'd4557f',
    \ '212': 'd455aa',
    \ '213': 'd455d4',
    \ '214': 'd47f00',
    \ '215': 'd47f2a',
    \ '216': 'd47f55',
    \ '217': 'd47f7f',
    \ '218': 'd47faa',
    \ '219': 'd47fd4',
    \ '220': 'd4aa00',
    \ '221': 'd4aa2a',
    \ '222': 'd4aa55',
    \ '223': 'd4aa7f',
    \ '224': 'd4aaaa',
    \ '225': 'd4aad4',
    \ '226': 'd4d400',
    \ '227': 'd4d42a',
    \ '228': 'd4d455',
    \ '229': 'd4d47f',
    \ '230': 'd4d4aa',
    \ '231': 'd4d4d4',
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
    \ '255': 'eeeeee',
    \ }

" ------------------------------------------------------------ 
" Generate RGB_2_Int256 Dictionary: {{{2
" ------------------------------------------------------------ 
let s:RGB_2_Int256 = {}
for key in sort(keys(s:Int256_2_RGB))
  let s:RGB_2_Int256[s:Int256_2_RGB[key]] = key
endfor

" eterm number to rgb string
let s:ColorTable256 = []
" TODO make into list of [r,g,b] values
let cnt = 0
while cnt < 256
  let rgb = s:Int256_2_RGB[cnt]
  let r = rgb[0:1]
  let g = rgb[2:3]
  let b = rgb[4:5]
  let rn = str2nr(r, 16)
  let gn = str2nr(g, 16)
  let bn = str2nr(b, 16)
  call add(s:ColorTable256, [rn,gn,bn])

  let cnt += 1
endwhile

" 6 intensity RGB
" intensities = [0, 42, 85, 127, 170, 212]
" intensities = (0x00, 0x2a, 0x55, 0x7f, 0xaa, 0xd4)
let s:intensities = [
          \ str2nr("0x00",16),
          \ str2nr("0x2a",16),
          \ str2nr("0x55",16),
          \ str2nr("0x7f",16),
          \ str2nr("0xaa",16),
          \ str2nr("0xd4",16)
          \ ]

" ------------------------------------------------------------ 
" ConvertRGB_2_Int256: {{{2
"  Converts an rgb String to a eterm 256 Number
"    Tried to make this fast.
"    Returns the eterm 256 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 

" binary search over possible intensities256
function! s:GetPartial_Int256(n)
  " intensities = [0, 42, 85, 127, 170, 212]
  " intensities = (0x00, 0x2a, 0x55, 0x7f, 0xaa, 0xd4)
  let n = a:n
  let n2 = n+n

  if n <= 85
    if n <= 42
      return (n2 <= 42) ? 0 : 42
    else
      return (n2 <= 127) ? 42 : 85 
    endif
  else
    if n <= 170
      if n <= 127
        return (n2 <= 212) ? 85 : 127
      else
        return (n2 <= 297) ? 127 : 170
      endif
    else
      return (n2 <= 382) ? 170 : 212
    endif
  endif
endfunction

function! vimside#color#eterm#ConvertRGB_2_Int256(rn, gn, bn)
"let start = reltime()
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

"call vimside#log("ConvertRGB_2_Int256: in rn=". rn)
"call vimside#log("ConvertRGB_2_Int256: in gn=". gn)
"call vimside#log("ConvertRGB_2_Int256: in bn=". bn)
  
  let rnx = s:GetPartial_Int256(rn)
  let gnx = s:GetPartial_Int256(gn)
  let bnx = s:GetPartial_Int256(bn)
"call vimside#log("ConvertRGB_2_Int256: outjrnx=". rnx)
"call vimside#log("ConvertRGB_2_Int256: outjgnx=". gnx)
"call vimside#log("ConvertRGB_2_Int256: outjbnx=". bnx)

  " must check grey levels which can be a closer match
  " TODO how to tell if we are near a grey level and
  "   only do the following if we are near?
  let diff = abs(rnx-rn) + abs(gnx-gn) + abs(bnx-bn)
  let best_match = -1
  let cnt = 232
  while cnt < 256
    let [rx,gx,bx] = s:ColorTable256[cnt]
    let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

    " on equals, prefer gray to color
    if d < diff
      let diff = d
      let best_match = cnt
    endif

    let cnt += 1
  endwhile

  if best_match != -1
"call vimside#log("ConvertRGB_2_Int256: best_match=". best_match)
    let n = best_match
  else
    let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
"call vimside#log("ConvertRGB_2_Int256: rgbtxt=". rgbtxt)
    let n = s:RGB_2_Int256[rgbtxt]
  endif
" call vimside#log("ConvertRGB_2_Int256:      time=". reltimestr(reltime(start)))
"call vimside#log("ConvertRGB_2_Int256: n=". n)
  return n
endfunction

" ------------------------------------------------------------ 
" ConvertInt256_2_RGB: {{{2
"  Converts an eterm 256 String or Number to an rgb String
"    Returns the rgb String
"  parameters:
"    nr : String or Number or eterm 256 value
"           value must be 0 <= value <= 255
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, rgb]
function! vimside#color#eterm#ConvertInt256_2_RGB(nr)
  if (type(a:nr) == g:self#NUMBER_TYPE)
    return [1, s:Int256_2_RGB[a:nr]]
  elseif (type(a:nr) == g:self#STRING_TYPE)
    return [1, s:Int256_2_RGB[a:nr]]
  else
    return [0, "Bad number: " . string(a:nsstr)]
  endif
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
