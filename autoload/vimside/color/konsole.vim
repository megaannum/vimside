" ============================================================================
" konsole.vim
"
" File:          konsole.vim
" Summary:       Konsole (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" ------------------------------------------------------------ 
" Define Int256_2_RGB Dictionary: {{{2
" Refs:
"   https://github.com/vim-scripts/colorsupport.vim/blob/master/plugin/colorsupport.vim
" ------------------------------------------------------------ 
let s:Int256_2_RGB = {
    \ '0': '000000',
    \ '1': 'cd0000',
    \ '2': '00cd00',
    \ '3': 'cdcd00',
    \ '4': '0000cd',
    \ '5': 'cd00cd',
    \ '6': '00cdcd',
    \ '7': 'e5e5e5',
    \ '8': '4d4d4d',
    \ '9': 'ff0000',
    \ '10': '00ff00',
    \ '11': 'ffff00',
    \ '12': '0000ff',
    \ '13': 'ff00ff',
    \ '14': '00ffff',
    \ '15': 'ffffff',
    \ '16': '000000',
    \ '17': '000033',
    \ '18': '000066',
    \ '19': '000099',
    \ '20': '0000cc',
    \ '21': '0000ff',
    \ '22': '003300',
    \ '23': '003333',
    \ '24': '003366',
    \ '25': '003399',
    \ '26': '0033cc',
    \ '27': '0033ff',
    \ '28': '006600',
    \ '29': '006633',
    \ '30': '006666',
    \ '31': '006699',
    \ '32': '0066cc',
    \ '33': '0066ff',
    \ '34': '009900',
    \ '35': '009933',
    \ '36': '009966',
    \ '37': '009999',
    \ '38': '0099cc',
    \ '39': '0099ff',
    \ '40': '00cc00',
    \ '41': '00cc33',
    \ '42': '00cc66',
    \ '43': '00cc99',
    \ '44': '00cccc',
    \ '45': '00ccff',
    \ '46': '00ff00',
    \ '47': '00ff33',
    \ '48': '00ff66',
    \ '49': '00ff99',
    \ '50': '00ffcc',
    \ '51': '00ffff',
    \ '52': '330000',
    \ '53': '330033',
    \ '54': '330066',
    \ '55': '330099',
    \ '56': '3300cc',
    \ '57': '3300ff',
    \ '58': '333300',
    \ '59': '333333',
    \ '60': '333366',
    \ '61': '333399',
    \ '62': '3333cc',
    \ '63': '3333ff',
    \ '64': '336600',
    \ '65': '336633',
    \ '66': '336666',
    \ '67': '336699',
    \ '68': '3366cc',
    \ '69': '3366ff',
    \ '70': '339900',
    \ '71': '339933',
    \ '72': '339966',
    \ '73': '339999',
    \ '74': '3399cc',
    \ '75': '3399ff',
    \ '76': '33cc00',
    \ '77': '33cc33',
    \ '78': '33cc66',
    \ '79': '33cc99',
    \ '80': '33cccc',
    \ '81': '33ccff',
    \ '82': '33ff00',
    \ '83': '33ff33',
    \ '84': '33ff66',
    \ '85': '33ff99',
    \ '86': '33ffcc',
    \ '87': '33ffff',
    \ '88': '660000',
    \ '89': '660033',
    \ '90': '660066',
    \ '91': '660099',
    \ '92': '6600cc',
    \ '93': '6600ff',
    \ '94': '663300',
    \ '95': '663333',
    \ '96': '663366',
    \ '97': '663399',
    \ '98': '6633cc',
    \ '99': '6633ff',
    \ '100': '666600',
    \ '101': '666633',
    \ '102': '666666',
    \ '103': '666699',
    \ '104': '6666cc',
    \ '105': '6666ff',
    \ '106': '669900',
    \ '107': '669933',
    \ '108': '669966',
    \ '109': '669999',
    \ '110': '6699cc',
    \ '111': '6699ff',
    \ '112': '66cc00',
    \ '113': '66cc33',
    \ '114': '66cc66',
    \ '115': '66cc99',
    \ '116': '66cccc',
    \ '117': '66ccff',
    \ '118': '66ff00',
    \ '119': '66ff33',
    \ '120': '66ff66',
    \ '121': '66ff99',
    \ '122': '66ffcc',
    \ '123': '66ffff',
    \ '124': '990000',
    \ '125': '990033',
    \ '126': '990066',
    \ '127': '990099',
    \ '128': '9900cc',
    \ '129': '9900ff',
    \ '130': '993300',
    \ '131': '993333',
    \ '132': '993366',
    \ '133': '993399',
    \ '134': '9933cc',
    \ '135': '9933ff',
    \ '136': '996600',
    \ '137': '996633',
    \ '138': '996666',
    \ '139': '996699',
    \ '140': '9966cc',
    \ '141': '9966ff',
    \ '142': '999900',
    \ '143': '999933',
    \ '144': '999966',
    \ '145': '999999',
    \ '146': '9999cc',
    \ '147': '9999ff',
    \ '148': '99cc00',
    \ '149': '99cc33',
    \ '150': '99cc66',
    \ '151': '99cc99',
    \ '152': '99cccc',
    \ '153': '99ccff',
    \ '154': '99ff00',
    \ '155': '99ff33',
    \ '156': '99ff66',
    \ '157': '99ff99',
    \ '158': '99ffcc',
    \ '159': '99ffff',
    \ '160': 'cc0000',
    \ '161': 'cc0033',
    \ '162': 'cc0066',
    \ '163': 'cc0099',
    \ '164': 'cc00cc',
    \ '165': 'cc00ff',
    \ '166': 'cc3300',
    \ '167': 'cc3333',
    \ '168': 'cc3366',
    \ '169': 'cc3399',
    \ '170': 'cc33cc',
    \ '171': 'cc33ff',
    \ '172': 'cc6600',
    \ '173': 'cc6633',
    \ '174': 'cc6666',
    \ '175': 'cc6699',
    \ '176': 'cc66cc',
    \ '177': 'cc66ff',
    \ '178': 'cc9900',
    \ '179': 'cc9933',
    \ '180': 'cc9966',
    \ '181': 'cc9999',
    \ '182': 'cc99cc',
    \ '183': 'cc99ff',
    \ '184': 'cccc00',
    \ '185': 'cccc33',
    \ '186': 'cccc66',
    \ '187': 'cccc99',
    \ '188': 'cccccc',
    \ '189': 'ccccff',
    \ '190': 'ccff00',
    \ '191': 'ccff33',
    \ '192': 'ccff66',
    \ '193': 'ccff99',
    \ '194': 'ccffcc',
    \ '195': 'ccffff',
    \ '196': 'ff0000',
    \ '197': 'ff0033',
    \ '198': 'ff0066',
    \ '199': 'ff0099',
    \ '200': 'ff00cc',
    \ '201': 'ff00ff',
    \ '202': 'ff3300',
    \ '203': 'ff3333',
    \ '204': 'ff3366',
    \ '205': 'ff3399',
    \ '206': 'ff33cc',
    \ '207': 'ff33ff',
    \ '208': 'ff6600',
    \ '209': 'ff6633',
    \ '210': 'ff6666',
    \ '211': 'ff6699',
    \ '212': 'ff66cc',
    \ '213': 'ff66ff',
    \ '214': 'ff9900',
    \ '215': 'ff9933',
    \ '216': 'ff9966',
    \ '217': 'ff9999',
    \ '218': 'ff99cc',
    \ '219': 'ff99ff',
    \ '220': 'ffcc00',
    \ '221': 'ffcc33',
    \ '222': 'ffcc66',
    \ '223': 'ffcc99',
    \ '224': 'ffcccc',
    \ '225': 'ffccff',
    \ '226': 'ffff00',
    \ '227': 'ffff33',
    \ '228': 'ffff66',
    \ '229': 'ffff99',
    \ '230': 'ffffcc',
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
" Generate RGB_2_Int256 Dictionary: {{{2
" ------------------------------------------------------------ 
let s:RGB_2_Int256 = {}
for key in sort(keys(s:Int256_2_RGB))
  let s:RGB_2_Int256[s:Int256_2_RGB[key]] = key
endfor

" konsole number to rgb string
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
" intensities = [0, 51, 102, 153, 204, 255]
" intensities = (0x00, 0x33, 0x66, 0x99, 0xcc, 0xff )
let s:intensities = [
          \ str2nr("0x00",16),
          \ str2nr("0x33",16),
          \ str2nr("0x66",16),
          \ str2nr("0x99",16),
          \ str2nr("0xcc",16),
          \ str2nr("0xff",16)
          \ ]

" ------------------------------------------------------------ 
" ConvertRGB_2_Int256: {{{2
"  Converts an rgb String to a konsole 256 Number
"    Tried to make this fast.
"    Returns the konsole 256 Number
"  parameters:
"    rgb : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 

" binary search over possible intensities
function! s:GetPartial_Int256(n)
  " intensities = [0, 51, 102, 153, 204, 255]
  " intensities = (0x00, 0x33, 0x66, 0x99, 0xcc, 0xff )
  let n = a:n
  let n2 = n+n

  if n <= 102
    if n <= 51
      return (n2 <= 51) ? 0 : 51
    else
      return (n2 <= 153) ? 51 : 102 
    endif
  else
    if n <= 204
      if n <= 153
        return (n2 <= 255) ? 102 : 153
      else
        return (n2 <= 357) ? 153 : 204
      endif
    else
      return (n2 <= 459) ? 204 : 255
    endif
  endif
endfunction

function! vimside#color#konsole#ConvertRGB_2_Int256(rn, gn, bn)
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
"  Converts an konsole 256 String or Number to an rgb String
"    Returns the rgb String
"  parameters:
"    nr : String or Number or konsole 256 value
"           value must be 0 <= value <= 255
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, rgb]
function! vimside#color#konsole#ConvertInt256_2_RGB(nr)
  if (type(a:nr) == g:self#NUMBER_TYPE)
    return [1, s:Int256_2_RGB[a:nr]]
  elseif (type(a:nr) == g:self#STRING_TYPE)
    return [1, s:Int256_2_RGB[a:nr]]
  else
    return [0, "Bad number: " . string(a:nsstr)]
  endif
endfunction

if 0
" code to unroll cube
let cube = range(0x00, 0xFF, 0x33)
call vimside#log("Konsole: cube=". string(cube))

let cnt = 0
for r in cube
  for g in cube
    for b in cube
      let rgbtxt = printf('%02x%02x%02x',r,g,b)
      call vimside#log("    \\ '". (cnt+16) . "': '" . rgbtxt . "',")
      let cnt += 1
    endfor
 endfor
endfor

function! vimside#color#konsole#DoIT()
endfunction
endif

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
