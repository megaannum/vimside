" ============================================================================
" util.vim
"
" File:          util.vim
" Summary:       color utilities (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

"-------------------------------------------------------------------------------
" Forms Color Utilities: {{{1
"  Gets Color Utility object that has numerous support methods
"    This utility deals with rgb and xterm 256 and rxvtu 88 color values.
"    for eterm kconole see
"     https://github.com/vim-scripts/colorsupport.vim/commits/master
"     http://www.gnu-darwin.org/www001/src/ports/x11/eterm/work/Eterm-0.9.4/src/term.c.html
"  parameters: NONE
"-------------------------------------------------------------------------------

" ------------------------------------------------------------ 
" ParseRGB: {{{2
"  Parses arguments into List of Number
"  parameters:
"    rgb     : String rgb value "0fe012"
"              String rgb with '#' value "#0fe012"
"              List ["r","g", "b"] triplet of Strings ["0f","e0","12"]
"              List [rn,gn, bn] triplet of Numbers (0 <= n < 256)
"              List [rf,gf, bf] triplet of Floats (0.0 <= f < 256.0)
"              String r value "0f"
"              Number (0 <= n < 256) representing r value
"              Float (0.0 <= f < 256.0) representing r value
"    g       : optional 
"              String g value "e0"
"              Number (0 <= n < 256)
"              Float (0.0 <= f < 256.0)
"    b       : optional
"              String b value "12"
"              Number (0 <= n < 256)
"              Float (0.0 <= f < 256.0)
" ------------------------------------------------------------ 
" return [0, errormsg] or [1, [r,g,b]]
function! vimside#color#util#ParseRGB(rgb, ...)
"call vimside#log("ParseRGB: TOP rgb=". string(a:rgb) . " a:0=" . a:0)
"let start = reltime()
  let needs_extra_args = 0

  if type(a:rgb) == g:self#STRING_TYPE
    " remove hash
    let rgb = (a:rgb[0] == '#') ? a:rgb[1:] : a:rgb

    if len(rgb) == 2
      let rs = rgb
      let rn = str2nr(rs, 16)
      let needs_extra_args = 1

    elseif len(rgb) == 6
      let rs = rgb[0:1]
      let gs = rgb[2:3]
      let bs = rgb[4:5]
      let rn = str2nr(rs, 16)
      let gn = str2nr(gs, 16)
      let bn = str2nr(bs, 16)

    else
      return [0, "Bad String rgb value: ".  string(a:rgb) ]
    endif

  elseif type(a:rgb) == g:self#LIST_TYPE
    let rgb = a:rgb
    if len(rgb) != 3
      return [0, "Bad List rgb value: ".  string(rgb)]
    endif

    let rx = rgb[0]
    if type(rx) == g:self#NUMBER_TYPE
      let rn = rx
    elseif type(rx) == g:self#FLOAT_TYPE
      let rn = float2nr(rx)
    elseif type(rx) == g:self#STRING_TYPE
      let rs = rx
      let rn = str2nr(rs, 16)
    else
      return [0, "Bad List r type: ".  string(rgb)]
    endif

    let gx = rgb[1]
    if type(gx) == g:self#NUMBER_TYPE
      let gn = gx
    elseif type(gx) == g:self#FLOAT_TYPE
      let gn = float2nr(gx)
    elseif type(gx) == g:self#STRING_TYPE
      let gs = gx
      let gn = str2nr(gs, 16)
    else
      return [0, "Bad List g type: " . string(rgb)]
    endif

    let bx = rgb[2]
    if type(bx) == g:self#NUMBER_TYPE
      let bn = bx
    elseif type(bx) == g:self#FLOAT_TYPE
      let bn = float2nr(bx)
    elseif type(bx) == g:self#STRING_TYPE
      let bs = bx
      let bn = str2nr(bs, 16)
    else
      return [0, "Bad List b type: " . string(rgb)]
    endif

  elseif type(a:rgb) == g:self#NUMBER_TYPE
    let rn = a:rgb
    let needs_extra_args = 1

  elseif type(a:rgb) == g:self#FLOAT_TYPE
    let rn = float2nr(a:rgb)
    let needs_extra_args = 1

  else
    return [0, "Bad rgb type: " . string(a:rgb)]
  endif

  if needs_extra_args == 1
    if a:0 != 2
      return [0, "Bad requires 2 additional arugments: a:0=".  a:0)]
    endif

    let gx = a:1
    if type(gx) == g:self#NUMBER_TYPE
      let gn = gx
    elseif type(gx) == g:self#FLOAT_TYPE
      let gn = float2nr(gx)
    elseif type(gx) == g:self#STRING_TYPE
      let gs = gx
      let gn = str2nr(gs, 16)
    else
      return [0, "Bad g type: ".  string(gx)]
    endif

    let bx = a:2
    if type(bx) == g:self#NUMBER_TYPE
      let bn = bx
    elseif type(bx) == g:self#FLOAT_TYPE
      let bn = float2nr(bx)
    elseif type(bx) == g:self#STRING_TYPE
      let bs = bx
      let bn = str2nr(bs, 16)
    else
      return [0, "Bad b type: " . string(bx)]
    endif

  endif
"call vimside#log("ParseRGB: time=". reltimestr(reltime(start)))
  return [1, [rn,gn,bn]]
endfunction

" ------------------------------------------------------------ 
" TintRGB: {{{2
"  Brighten rgb color returns Number triplet
"  sat/val      brighten/darken
"  '0.25:1',      0.75:0,0
"  '0.5:1',       0.5:0.0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
"  '0.5:0.75',    0.5: -0.25
"  '0.25:0.87'    0.75: -0.13
" brighten 
" adjust saturation
" 1.0      0
" 0.5     50
" 0.0    100
"  parameters:
"    adjust : Float used to brighten or darken rgb color 
"              value must be between 0 <= adujst <= 1
"              if value < 0 treated as value = 0
"              if value > 1 treated as value = 1
"              zero values unchanged
"              positive values brighten
"    rn    : Parameters accepted by ParseRGB
"    gn    : Parameters accepted by ParseRGB
"    bn    : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#util#TintRGB(adjust, rn, gn, bn) 
  let adjust = a:adjust
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  if adjust <= 0.0
    return [rn,gn,bn]
  elseif adjust >= 1.0
    return [255,255,255]
  else
    " float2nr drops part after decimal point
    let rn = float2nr(rn + ((256 - rn) * adjust))
    let gn = float2nr(gn + ((256 - gn) * adjust))
    let bn = float2nr(bn + ((256 - bn) * adjust))
    return [rn,gn,bn]
  endif
endfunction

" ------------------------------------------------------------ 
" ShadeRGB: {{{2
"  Darken rgb color returns Number triplet
"  sat/val      brighten/darken
"  '0.5:1',       0.5:0.0
"  '0.25:1',      0.75:0,0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
"  '0.5:0.75',    0.5: -0.25
"  '0.25:0.87'    0.75: -0.13
" darken 
" adjust value
"  1.0    100
"  0.5     50
"  0.0      0
"  parameters:
"    adjust : Float used to brighten or darken rgb color 
"              value must be between 0 <= adujst <= 1
"              if value < 0 treated as value = 0
"              if value > 1 treated as value = 1
"              negative values darken
"              zero values unchanged
"              positive values brighten
"    rgb    : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#util#ShadeRGB(adjust, rn, gn, bn) 
  let adjust = a:adjust
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  if adjust <= 0.0
    return [rn,gn,bn]
  elseif adjust >= 1.0
    return [0,0,0]
  else
    let f = 1.0 - adjust
    " float2nr drops part after decimal point
    let rn = float2nr(rn * f)
    let gn = float2nr(gn * f)
    let bn = float2nr(bn * f)
    return [rn,gn,bn]
  endif
endfunction


" ------------------------------------------------------------ 
" BrightnessRGB: {{{2
"  Brighten or darken rgb color returns Number triplet
"  sat/val      brighten/darken
"  '0.5:1',       0.5:0.0
"  '0.25:1',      0.75:0,0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
"  '0.5:0.75',    0.5: -0.25
"  '0.25:0.87'    0.75: -0.13
"  parameters:
"    adjust : Float used to brighten or darken rgb color 
"              value must be between -1 <= adujst <= 1
"              negative values darken
"              zero values unchanged
"              positive values brighten
"    rgb    : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#util#BrightnessRGBXX(adjust, rgb, ...) 
" call vimside#log("BrightnessRGB: TOP rgb=". string(a:rgb)." a:0=".a:0)
  if a:0 == 0
    let [rn,gn,bn] = vimside#color#util#ParseRGB(a:rgb)
  elseif a:0 == 2
    let [rn,gn,bn] = vimside#color#util#ParseRGB(a:rgb, a:000[0], a:000[1])
  else
      throw "vimside#color#util.BrightnessRGB: Wrong number of additional arguments: " . a:0
  endif
endfunction

function! vimside#color#util#BrightnessRGB(adjust, rn, gn, bn) 
  let adjust = a:adjust
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  if adjust >= 0
    " brighten 
    " adjust saturation
    " 1.0      0
    " 0.5     50
    " 0.0    100
    let rn = float2nr(rn + ((255 - rn) * adjust))
    let gn = float2nr(gn + ((255 - gn) * adjust))
    let bn = float2nr(bn + ((255 - bn) * adjust))
  else
    " darken 
    " adjust value
    " -1.0     0
    " -0.5    50
    " -0.0   100
    let f = adjust + 1.0
    let rn = float2nr(rn * f)
    let gn = float2nr(gn * f)
    let bn = float2nr(bn * f)
  endif

  return [rn,gn,bn]
endfunction

" ------------------------------------------------------------ 
" MergerRGBs: {{{2
"  Take "average" of two rgb strings
"    Returns List rgb-average of parameter.
"  parameters:
"    rgb1 : Parameters accepted by ParseRGB
"    rgb2 : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! vimside#color#util#MergerRGBs(rgb1, rgb2) 
" call vimside#log("MergerRGBs: TOP rgb1=". a:rgb1)
" call vimside#log("MergerRGBs: TOP rgb2=". a:rgb2)
  let [rn1,gn1,bn1] = vimside#color#util#ParseRGB(a:rgb1)
  let [rn2,gn2,bn2] = vimside#color#util#ParseRGB(a:rgb2)

  let rn = (rn1+rn2)/2
  let gn = (gn1+gn2)/2
  let bn = (bn1+bn2)/2

  return [rn, gn, bn]
endfunction

" ------------------------------------------------------------ 
" ShiftHue: {{{2
"  Shift hue by given adjustment
"  parameters:
"    shift : -0.5 <= float <= 0.5
"    hue   : hue to be adjusted
" ------------------------------------------------------------ 
function! vimside#color#util#ShiftHue(shift, hue) 
" let hues = printf("%f",a:hue)
" call vimside#log("ShiftHue: TOP hue=". hues)
  let hc = a:hue + a:shift
  if (hc >= 1.0) 
    let hc -= 1.0
  elseif (hc < 0.0) 
    let hc += 1.0
  endif
  return hc
endfunction

" ------------------------------------------------------------ 
" ConvertRGB2HSL: {{{2
"  Converts an rgb String HSL triplet [h,s,l]
"     with values 0.0 <= v <= 1.0
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#ConvertRGB2HSL(rn, gn, bn) 
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

" call vimside#log("ConvertRGB2HSL: rn,gn,bn=".rn.",".gn.",".bn)
  let rf = (0.0 + rn)/255
  let gf = (0.0 + gn)/255
  let bf = (0.0 + bn)/255
  
  let minn = min([rn,gn,bn])
  let maxn = max([rn,gn,bn])

  let minf = (0.0 + minn)/255
  let maxf = (0.0 + maxn)/255
  let delf = maxf - minf
" let mins = printf("%f",minf)
" let maxs = printf("%f",maxf)
" call vimside#log("ConvertRGB2HSL: min,max=".mins.",".maxs)

  let l = (maxf + minf)/2.0

  if delf == 0
    let h = 0.0
    let s = 0.0
  else
      if l < 0.5
        let s = delf/(maxf + minf)
      else
        let s = delf/(2 - maxf - minf)
      endif

      if rn == maxn
        let h = ((gf - bf)/delf) + ((gf < bf)? 6 : 0)
      elseif gn == maxn
        let h = ((bf - rf)/delf) + 2
      else 
        let h = ((rf - gf)/delf) + 4
      endif

      let h = h / 6
if 0
      let delfhalf = delf/2
      
      let dr = (((maxf - rf)/6) + delfhalf)/delf
      let dg = (((maxf - gf)/6) + delfhalf)/delf
      let db = (((maxf - bf)/6) + delfhalf)/delf

      if rn == maxn
        let h = db - dg
      elseif gn == maxn
        let h = 0.3333333 + dr - db
      else
        let h = 0.6666666 + dg - dr
      endif

      if h < 0
        let h += 1
      elseif h > 1 
        let h -= 1
      endif
endif
  endif
  return [h,s,l]
endfunction

" ------------------------------------------------------------ 
" ReduceHSL: {{{2
"  Generates HSL triplets one for each pair of Floats in List.
"  parameters:
"    h           : hue
"    s           : saturation
"    l           : value
"    adjustments : List of List of Float pair to be applied to s and l
" ------------------------------------------------------------ 
function! vimside#color#util#ReduceHSL(h,s,l, adjustments) 
  let r = []
  for adj in a:adjustments
    let sadj = a[0]
    let vadj = a[1]
    call add(r, [a:h, a:s * sadj, a:l * vadj])
  endfor
  return r
endfunction

" ------------------------------------------------------------ 
" ConvertHSL2RGB: {{{2
"  Converts HSL Float triplet to RGB Float triplet 
"  parameters:
"    h           : hue
"    s           : saturation
"    l           : value
" ------------------------------------------------------------ 
function! vimside#color#util#ConvertHSL2RGB(h,s,l) 
"let hstr = printf("%f",a:h)
"let sstr = printf("%f",a:s)
"let lstr = printf("%f",a:l)
" call vimside#log("ConvertHSL2RGB: TOP h,s,l=". hstr.",".sstr.",".lstr)
  let h = a:h
  let s = a:s
  let l = a:l

  if s == 0.0
" call vimside#log("ConvertHSL2RGB: IF")
    let r = 255.0 * l
    let g = 255.0 * l
    let b = 255.0 * l
  else
" call vimside#log("ConvertHSL2RGB: ELSE")
    if l < 0.5
      let v2 = l * (1 + s)
    else
      let v2 = (l + s) - (s * l)
    endif

    " let v1 = l - v2
    let v1 = 2 * l - v2

    function! Hue2RGB(v1, v2, vh)
      let vh = a:vh
      if vh < 0
        let vh += 1
      elseif vh > 1
        let vh -= 1
      endif

      if (6 * vh) < 1
        return a:v1 + (a:v2 - a:v1) * 6 * vh
      elseif (2 * vh) < 1
        return a:v2
      elseif (3 * vh) < 2
        return a:v1 + (a:v2 - a:v1) * (0.6666666 - vh) * 6
      else
        return a:v1
      endif
    endfunction

    let r = 255 * Hue2RGB(v1, v2, h + 0.3333333)
    let g = 255 * Hue2RGB(v1, v2, h)
    let b = 255 * Hue2RGB(v1, v2, h - 0.3333333)

  endif
  return [r,g,b]
endfunction

" ------------------------------------------------------------ 
" ShiftHueRGBusingHSL: {{{2
"  ShiftHues rgb returns rgb triplet using HSL
"  parameters:
"    shift : -0.5 <= float <= 0.5
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#ShiftHueRGBusingHSL(shift, rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)

  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let hc = vimside#color#util#ShiftHue(a:shift, h)
  return vimside#color#util#ConvertHSL2RGB(hc,s,l)
endfunction

" ------------------------------------------------------------ 
" ComplimentRGBusingHSL: {{{2
"  Returns HSL compliment of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#ComplimentRGBusingHSL(rn, gn, bn) 
  let shift = 180.0/360
  return vimside#color#util#ShiftHueRGBusingHSL(shift, a:rgb, a:000)
endfunction

" ------------------------------------------------------------ 
" AnalogicRGBusingHSL: {{{2
"  Returns HSL analogic values (+30,-30) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#AnalogicRGBusingHSL(rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let shift = 30.0/360
  let hc1 = vimside#color#util#ShiftHue(shift, h)
  let hc2 = vimside#color#util#ShiftHue(-shift, h)
  return [vimside#color#util#ConvertHSL2RGB(hc1,s,l), vimside#color#util#ConvertHSL2RGB(hc2,s,l)]
endfunction

" ------------------------------------------------------------ 
" SplitComplimentaryRGBusingHSL: {{{2
"  Returns HSL split complimentary values 
"  (180+30,180-30) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#SplitComplimentaryRGBusingHSL(rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let half = 180.0/360
  let shift = 30.0/360
  let hc2 = vimside#color#util#ShiftHue(half-shift, h)
  let hc1 = vimside#color#util#ShiftHue(half+shift, h)
  return [vimside#color#util#ConvertHSL2RGV(hc1,s,v), vimside#color#util#ConvertHSL2RGV(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" TriadicRGBusingHSL: {{{2
"  Returns HSL triadic values 
"  (180+60,180-60) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#TriadicRGBusingHSL(rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let half = 180.0/360
  let shift = 60.0/360
  let hc2 = vimside#color#util#ShiftHue(half-shift, h)
  let hc1 = vimside#color#util#ShiftHue(half+shift, h)
  return [vimside#color#util#ConvertHSL2RGV(hc1,s,v), vimside#color#util#ConvertHSL2RGV(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" ConvertRGB2HSV: {{{2
"  Converts an rgb values HSV Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#ConvertRGB2HSV(rn, gn, bn) 
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  let rf = (0.0 + rn)/255
  let gf = (0.0 + gn)/255
  let bf = (0.0 + bn)/255

  if rf < gf
    if rf < bf
      let x = rf
    else
      let x = bf
    endif
  else
    if gf < bf
      let x = gf
    else
      let x = bf
    endif
  endif

  if rf > gf
    if rf > bf
      let val = rf
    else
      let val = bf
    endif
  else
    if gf > bf
      let val = gf
    else
      let val = bf
    endif
  endif

  if x == val
    return [0.0, 0.0, val]
  else

    if rf == x
      let f = gf-bf
      let i = 3
    elseif gf == x
      let f = bf-rf
      let i = 5
    else
      let f = rf-gf
      let i = 1
    endif

    let d = val - x
    let hue = (i - f/d) / 6
    let sat = d/val

    return [hue,sat,val]
  endif
endfunction


" ReduceHSV: {{{2
"  Generates HSV triplets one for each pair of Floats in List.
"  parameters:
"    h           : hue
"    s           : saturation
"    v           : value
"    adjustments : List of List of Float pair to be applied to s and v
" ------------------------------------------------------------ 
function! vimside#color#util#ReduceHSV(h,s,v, adjustments) 
  let r = []
  for adj in a:adjustments
    let sadj = a[0]
    let vadj = a[1]
    call add(r, [a:h, a:s * sadj, a:v * vadj])
  endfor
  return r
endfunction

" ------------------------------------------------------------ 
" ConvertHSV2RGB: {{{2
"  Converts HSV Float triplet to RGB Float triplet
"  parameters:
"    h : hue
"    s : saturation
"    v : value
" ------------------------------------------------------------ 
function! vimside#color#util#ConvertHSV2RGB(h,s,v) 
"let hstr = printf("%f",a:h)
"let sstr = printf("%f",a:s)
"let vstr = printf("%f",a:v)
"call vimside#log("ConvertHSV2RGB: TOP h,s,v=". hstr.",".sstr.",".vstr)
  let h = a:h
  let s = a:s
  let v = a:v

  let i = floor(h*6)
  let f = h * 6 - i
  let p = v * (1 - s)
  let q = v * (1 - f*s) 
  let t = v * (1 - (1-f)*s)

  let im = float2nr(i) % 6
  if im == 0
    let r = v
    let g = t
    let b = p
  elseif im == 1
    let r = q
    let g = v
    let b = p
  elseif im == 2
    let r = p
    let g = v
    let b = t
  elseif im == 3
    let r = p
    let g = q
    let b = v
  elseif im == 4
    let r = t
    let g = p
    let b = v
  else
    let r = v
    let g = p
    let b = q
  endif
  let offset = 0.000000000001
  return [
          \ float2nr((r * 255)+offset), 
          \ float2nr((g * 255)+offset), 
          \ float2nr((b * 255)+offset)]
endfunction

" ------------------------------------------------------------ 
" ShiftHueRGBusingHSV: {{{2
"  ShiftHues rgb returns RGB Float triplet using HSV
"  parameters:
"    shift : -0.5 <= float <= 0.5
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#ShiftHueRGBusingHSV(shift, rn, gn, bn) 
" call vimside#log("ShiftHueRGBusingHSV: TOP rgbstr=". a:rgb)
  let hsl = vimside#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let hc = vimside#color#util#ShiftHue(a:shift, h)
  return vimside#color#util#ConvertHSV2RGB(hc,s,l)
endfunction

" ------------------------------------------------------------ 
" ComplimentRGBusingHSV: {{{2
"  Returns HSV compliment of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#ComplimentRGBusingHSV(rn, gn, bn) 
  let shift = 180.0/360
  return vimside#color#util#ShiftHueRGBusingHSV(shift, a:rn, a:gn, a:bn)
endfunction

" ------------------------------------------------------------ 
" AnalogicRGBusingHSV: {{{2
"  Returns HSV analogic values shifted (for example: +30,-30) 
"     of pair of RGB Float triplet
"  parameters:
"    shift  : Float how much to shift hue + and -.
"               Should be from 0.0 to 0.5
"    rn     : red Number
"    gn     : green Number
"    bn     : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#AnalogicRGBusingHSV(shift, rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let hc1 = vimside#color#util#ShiftHue(a:shift, h)
  let hc2 = vimside#color#util#ShiftHue(-a:shift, h)
  return [vimside#color#util#ConvertHSV2RGB(hc1,s,v), vimside#color#util#ConvertHSV2RGB(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" SplitComplimentaryRGBusingHSV: {{{2
"  Returns HSV split complimentary values 
"  (for example: 180+30,180-30) of pair of RGB Float triplet
"  parameters:
"    shift  : Float how much to shift hue + and -.
"               Should be from 0.0 to 0.5
"    rn     : red Number
"    gn     : green Number
"    bn     : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#SplitComplimentaryRGBusingHSV(shift, rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let half = 180.0/360
  let hc2 = vimside#color#util#ShiftHue(half-a:shift, h)
  let hc1 = vimside#color#util#ShiftHue(half+a:shift, h)
  return [vimside#color#util#ConvertHSV2RGB(hc1,s,v), vimside#color#util#ConvertHSV2RGB(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" TriadicRGBusingHSV: {{{2
"  Returns HSV triadic values 
"  (+120,-120) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#TriadicRGBusingHSV(rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let third = 120.0/360
  let hc2 = vimside#color#util#ShiftHue(-third, h)
  let hc1 = vimside#color#util#ShiftHue(+third, h)
  return [vimside#color#util#ConvertHSV2RGB(hc1,s,v), vimside#color#util#ConvertHSV2RGB(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" DoubleContrastRGBusingHSV: {{{2
"  Returns RGB triple of values.
"  (for example: -30,180,180-30) of triplets of RGB Float triplet
"  parameters:
"    shift  : Float how much to shift hue and compliment.
"               Should be from 0.0 to 0.5
"    rn     : red Number
"    gn     : green Number
"    bn     : blue Number
" ------------------------------------------------------------ 
function! vimside#color#util#DoubleContrastRGBusingHSV(shift, rn, gn, bn) 
  let hsl = vimside#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let minus = -a:shift
  let minusHue = vimside#color#util#ShiftHue(minus, h)
  let half = 180.0/360
  let halfHue = vimside#color#util#ShiftHue(half, h)
  let halfminus = half - a:shift
  let halfminusHue = vimside#color#util#ShiftHue(halfminus, h)
  return [
          \ vimside#color#util#ConvertHSV2RGB(minusHue,s,v), 
          \ vimside#color#util#ConvertHSV2RGB(halfHue,s,v), 
          \ vimside#color#util#ConvertHSV2RGB(halfminusHue,s,v)]
endfunction

" map from names to rgb numbers
let s:Name_2_RGB = {}
let s:Name_2_RGB['snow'] = 'fffafa'
let s:Name_2_RGB['ghost white'] = 'f8f8ff'
let s:Name_2_RGB['GhostWhite'] = 'f8f8ff'
let s:Name_2_RGB['ghostwhite'] = 'f8f8ff'
let s:Name_2_RGB['white smoke'] = 'f5f5f5'
let s:Name_2_RGB['WhiteSmoke'] = 'f5f5f5'
let s:Name_2_RGB['whitesmoke'] = 'f5f5f5'
let s:Name_2_RGB['gainsboro'] = 'dcdcdc'
let s:Name_2_RGB['floral white'] = 'fffaf0'
let s:Name_2_RGB['FloralWhite'] = 'fffaf0'
let s:Name_2_RGB['floralwhite'] = 'fffaf0'
let s:Name_2_RGB['old lace'] = 'fdf5e6'
let s:Name_2_RGB['OldLace'] = 'fdf5e6'
let s:Name_2_RGB['oldlace'] = 'fdf5e6'
let s:Name_2_RGB['linen'] = 'faf0e6'
let s:Name_2_RGB['antique white'] = 'faebd7'
let s:Name_2_RGB['AntiqueWhite'] = 'faebd7'
let s:Name_2_RGB['antiquewhite'] = 'faebd7'
let s:Name_2_RGB['papaya whip'] = 'ffefd5'
let s:Name_2_RGB['PapayaWhip'] = 'ffefd5'
let s:Name_2_RGB['papayawhip'] = 'ffefd5'
let s:Name_2_RGB['blanched almond'] = 'ffebcd'
let s:Name_2_RGB['BlanchedAlmond'] = 'ffebcd'
let s:Name_2_RGB['blanchedalmond'] = 'ffebcd'
let s:Name_2_RGB['bisque'] = 'ffe4c4'
let s:Name_2_RGB['peach puff'] = 'ffdab9'
let s:Name_2_RGB['PeachPuff'] = 'ffdab9'
let s:Name_2_RGB['peachpuff'] = 'ffdab9'
let s:Name_2_RGB['navajo white'] = 'ffdead'
let s:Name_2_RGB['NavajoWhite'] = 'ffdead'
let s:Name_2_RGB['navajowhite'] = 'ffdead'
let s:Name_2_RGB['moccasin'] = 'ffe4b5'
let s:Name_2_RGB['cornsilk'] = 'fff8dc'
let s:Name_2_RGB['ivory'] = 'fffff0'
let s:Name_2_RGB['lemon chiffon'] = 'fffacd'
let s:Name_2_RGB['LemonChiffon'] = 'fffacd'
let s:Name_2_RGB['lemonchiffon'] = 'fffacd'
let s:Name_2_RGB['seashell'] = 'fff5ee'
let s:Name_2_RGB['honeydew'] = 'f0fff0'
let s:Name_2_RGB['mint cream'] = 'f5fffa'
let s:Name_2_RGB['MintCream'] = 'f5fffa'
let s:Name_2_RGB['mintcream'] = 'f5fffa'
let s:Name_2_RGB['azure'] = 'f0ffff'
let s:Name_2_RGB['alice blue'] = 'f0f8ff'
let s:Name_2_RGB['AliceBlue'] = 'f0f8ff'
let s:Name_2_RGB['aliceblue'] = 'f0f8ff'
let s:Name_2_RGB['lavender'] = 'e6e6fa'
let s:Name_2_RGB['lavender blush'] = 'fff0f5'
let s:Name_2_RGB['LavenderBlush'] = 'fff0f5'
let s:Name_2_RGB['lavenderblush'] = 'fff0f5'
let s:Name_2_RGB['misty rose'] = 'ffe4e1'
let s:Name_2_RGB['MistyRose'] = 'ffe4e1'
let s:Name_2_RGB['mistyrose'] = 'ffe4e1'
let s:Name_2_RGB['white'] = 'ffffff'
let s:Name_2_RGB['black'] = '000000'
let s:Name_2_RGB['dark slate gray'] = '2f4f4f'
let s:Name_2_RGB['DarkSlateGray'] = '2f4f4f'
let s:Name_2_RGB['darkslategray'] = '2f4f4f'
let s:Name_2_RGB['dark slate grey'] = '2f4f4f'
let s:Name_2_RGB['DarkSlateGrey'] = '2f4f4f'
let s:Name_2_RGB['darkslategrey'] = '2f4f4f'
let s:Name_2_RGB['dim gray'] = '696969'
let s:Name_2_RGB['DimGray'] = '696969'
let s:Name_2_RGB['dimgray'] = '696969'
let s:Name_2_RGB['dim grey'] = '696969'
let s:Name_2_RGB['DimGrey'] = '696969'
let s:Name_2_RGB['dimgrey'] = '696969'
let s:Name_2_RGB['slate gray'] = '708090'
let s:Name_2_RGB['SlateGray'] = '708090'
let s:Name_2_RGB['slategray'] = '708090'
let s:Name_2_RGB['slate grey'] = '708090'
let s:Name_2_RGB['SlateGrey'] = '708090'
let s:Name_2_RGB['slategrey'] = '708090'
let s:Name_2_RGB['light slate gray'] = '778899'
let s:Name_2_RGB['LightSlateGray'] = '778899'
let s:Name_2_RGB['lightslategray'] = '778899'
let s:Name_2_RGB['light slate grey'] = '778899'
let s:Name_2_RGB['LightSlateGrey'] = '778899'
let s:Name_2_RGB['lightslategrey'] = '778899'
let s:Name_2_RGB['gray'] = 'bebebe'
let s:Name_2_RGB['grey'] = 'bebebe'
let s:Name_2_RGB['light grey'] = 'd3d3d3'
let s:Name_2_RGB['LightGrey'] = 'd3d3d3'
let s:Name_2_RGB['lightgrey'] = 'd3d3d3'
let s:Name_2_RGB['light gray'] = 'd3d3d3'
let s:Name_2_RGB['LightGray'] = 'd3d3d3'
let s:Name_2_RGB['lightgray'] = 'd3d3d3'
let s:Name_2_RGB['midnight blue'] = '191970'
let s:Name_2_RGB['MidnightBlue'] = '191970'
let s:Name_2_RGB['midnightblue'] = '191970'
let s:Name_2_RGB['navy'] = '000080'
let s:Name_2_RGB['navy blue'] = '000080'
let s:Name_2_RGB['NavyBlue'] = '000080'
let s:Name_2_RGB['navyblue'] = '000080'
let s:Name_2_RGB['cornflower blue'] = '6495ed'
let s:Name_2_RGB['CornflowerBlue'] = '6495ed'
let s:Name_2_RGB['cornflowerblue'] = '6495ed'
let s:Name_2_RGB['dark slate blue'] = '483d8b'
let s:Name_2_RGB['DarkSlateBlue'] = '483d8b'
let s:Name_2_RGB['darkslateblue'] = '483d8b'
let s:Name_2_RGB['slate blue'] = '6a5acd'
let s:Name_2_RGB['SlateBlue'] = '6a5acd'
let s:Name_2_RGB['slateblue'] = '6a5acd'
let s:Name_2_RGB['medium slate blue'] = '7b68ee'
let s:Name_2_RGB['MediumSlateBlue'] = '7b68ee'
let s:Name_2_RGB['mediumslateblue'] = '7b68ee'
let s:Name_2_RGB['light slate blue'] = '8470ff'
let s:Name_2_RGB['LightSlateBlue'] = '8470ff'
let s:Name_2_RGB['lightslateblue'] = '8470ff'
let s:Name_2_RGB['medium blue'] = '0000cd'
let s:Name_2_RGB['MediumBlue'] = '0000cd'
let s:Name_2_RGB['mediumblue'] = '0000cd'
let s:Name_2_RGB['royal blue'] = '4169e1'
let s:Name_2_RGB['RoyalBlue'] = '4169e1'
let s:Name_2_RGB['royalblue'] = '4169e1'
let s:Name_2_RGB['blue'] = '0000ff'
let s:Name_2_RGB['dodger blue'] = '1e90ff'
let s:Name_2_RGB['DodgerBlue'] = '1e90ff'
let s:Name_2_RGB['dodgerblue'] = '1e90ff'
let s:Name_2_RGB['deep sky blue'] = '00bfff'
let s:Name_2_RGB['DeepSkyBlue'] = '00bfff'
let s:Name_2_RGB['deepskyblue'] = '00bfff'
let s:Name_2_RGB['sky blue'] = '87ceeb'
let s:Name_2_RGB['SkyBlue'] = '87ceeb'
let s:Name_2_RGB['skyblue'] = '87ceeb'
let s:Name_2_RGB['light sky blue'] = '87cefa'
let s:Name_2_RGB['LightSkyBlue'] = '87cefa'
let s:Name_2_RGB['lightskyblue'] = '87cefa'
let s:Name_2_RGB['steel blue'] = '4682b4'
let s:Name_2_RGB['SteelBlue'] = '4682b4'
let s:Name_2_RGB['steelblue'] = '4682b4'
let s:Name_2_RGB['light steel blue'] = 'b0c4de'
let s:Name_2_RGB['LightSteelBlue'] = 'b0c4de'
let s:Name_2_RGB['lightsteelblue'] = 'b0c4de'
let s:Name_2_RGB['light blue'] = 'add8e6'
let s:Name_2_RGB['LightBlue'] = 'add8e6'
let s:Name_2_RGB['lightblue'] = 'add8e6'
let s:Name_2_RGB['powder blue'] = 'b0e0e6'
let s:Name_2_RGB['PowderBlue'] = 'b0e0e6'
let s:Name_2_RGB['powderblue'] = 'b0e0e6'
let s:Name_2_RGB['pale turquoise'] = 'afeeee'
let s:Name_2_RGB['PaleTurquoise'] = 'afeeee'
let s:Name_2_RGB['paleturquoise'] = 'afeeee'
let s:Name_2_RGB['dark turquoise'] = '00ced1'
let s:Name_2_RGB['DarkTurquoise'] = '00ced1'
let s:Name_2_RGB['darkturquoise'] = '00ced1'
let s:Name_2_RGB['medium turquoise'] = '48d1cc'
let s:Name_2_RGB['MediumTurquoise'] = '48d1cc'
let s:Name_2_RGB['mediumturquoise'] = '48d1cc'
let s:Name_2_RGB['turquoise'] = '40e0d0'
let s:Name_2_RGB['cyan'] = '00ffff'
let s:Name_2_RGB['light cyan'] = 'e0ffff'
let s:Name_2_RGB['LightCyan'] = 'e0ffff'
let s:Name_2_RGB['lightcyan'] = 'e0ffff'
let s:Name_2_RGB['cadet blue'] = '5f9ea0'
let s:Name_2_RGB['CadetBlue'] = '5f9ea0'
let s:Name_2_RGB['cadetblue'] = '5f9ea0'
let s:Name_2_RGB['medium aquamarine'] = '66cdaa'
let s:Name_2_RGB['MediumAquamarine'] = '66cdaa'
let s:Name_2_RGB['mediumaquamarine'] = '66cdaa'
let s:Name_2_RGB['aquamarine'] = '7fffd4'
let s:Name_2_RGB['dark green'] = '006400'
let s:Name_2_RGB['DarkGreen'] = '006400'
let s:Name_2_RGB['darkgreen'] = '006400'
let s:Name_2_RGB['dark olive green'] = '556b2f'
let s:Name_2_RGB['DarkOliveGreen'] = '556b2f'
let s:Name_2_RGB['darkolivegreen'] = '556b2f'
let s:Name_2_RGB['dark sea green'] = '8fbc8f'
let s:Name_2_RGB['DarkSeaGreen'] = '8fbc8f'
let s:Name_2_RGB['darkseagreen'] = '8fbc8f'
let s:Name_2_RGB['sea green'] = '2e8b57'
let s:Name_2_RGB['SeaGreen'] = '2e8b57'
let s:Name_2_RGB['seagreen'] = '2e8b57'
let s:Name_2_RGB['medium sea green'] = '3cb371'
let s:Name_2_RGB['MediumSeaGreen'] = '3cb371'
let s:Name_2_RGB['mediumseagreen'] = '3cb371'
let s:Name_2_RGB['light sea green'] = '20b2aa'
let s:Name_2_RGB['LightSeaGreen'] = '20b2aa'
let s:Name_2_RGB['lightseagreen'] = '20b2aa'
let s:Name_2_RGB['pale green'] = '98fb98'
let s:Name_2_RGB['PaleGreen'] = '98fb98'
let s:Name_2_RGB['palegreen'] = '98fb98'
let s:Name_2_RGB['spring green'] = '00ff7f'
let s:Name_2_RGB['SpringGreen'] = '00ff7f'
let s:Name_2_RGB['springgreen'] = '00ff7f'
let s:Name_2_RGB['lawn green'] = '7cfc00'
let s:Name_2_RGB['LawnGreen'] = '7cfc00'
let s:Name_2_RGB['lawngreen'] = '7cfc00'
let s:Name_2_RGB['green'] = '00ff00'
let s:Name_2_RGB['chartreuse'] = '7fff00'
let s:Name_2_RGB['medium spring green'] = '00fa9a'
let s:Name_2_RGB['MediumSpringGreen'] = '00fa9a'
let s:Name_2_RGB['mediumspringgreen'] = '00fa9a'
let s:Name_2_RGB['green yellow'] = 'adff2f'
let s:Name_2_RGB['GreenYellow'] = 'adff2f'
let s:Name_2_RGB['greenyellow'] = 'adff2f'
let s:Name_2_RGB['lime green'] = '32cd32'
let s:Name_2_RGB['LimeGreen'] = '32cd32'
let s:Name_2_RGB['limegreen'] = '32cd32'
let s:Name_2_RGB['yellow green'] = '9acd32'
let s:Name_2_RGB['YellowGreen'] = '9acd32'
let s:Name_2_RGB['yellowgreen'] = '9acd32'
let s:Name_2_RGB['forest green'] = '228b22'
let s:Name_2_RGB['ForestGreen'] = '228b22'
let s:Name_2_RGB['forestgreen'] = '228b22'
let s:Name_2_RGB['olive drab'] = '6b8e23'
let s:Name_2_RGB['OliveDrab'] = '6b8e23'
let s:Name_2_RGB['olivedrab'] = '6b8e23'
let s:Name_2_RGB['dark khaki'] = 'bdb76b'
let s:Name_2_RGB['DarkKhaki'] = 'bdb76b'
let s:Name_2_RGB['darkkhaki'] = 'bdb76b'
let s:Name_2_RGB['khaki'] = 'f0e68c'
let s:Name_2_RGB['pale goldenrod'] = 'eee8aa'
let s:Name_2_RGB['PaleGoldenrod'] = 'eee8aa'
let s:Name_2_RGB['palegoldenrod'] = 'eee8aa'
let s:Name_2_RGB['light goldenrod yellow'] = 'fafad2'
let s:Name_2_RGB['LightGoldenrodYellow'] = 'fafad2'
let s:Name_2_RGB['lightgoldenrodyellow'] = 'fafad2'
let s:Name_2_RGB['light yellow'] = 'ffffe0'
let s:Name_2_RGB['LightYellow'] = 'ffffe0'
let s:Name_2_RGB['lightyellow'] = 'ffffe0'
let s:Name_2_RGB['yellow'] = 'ffff00'
let s:Name_2_RGB['gold'] = 'ffd700'
let s:Name_2_RGB['light goldenrod'] = 'eedd82'
let s:Name_2_RGB['LightGoldenrod'] = 'eedd82'
let s:Name_2_RGB['lightgoldenrod'] = 'eedd82'
let s:Name_2_RGB['goldenrod'] = 'daa520'
let s:Name_2_RGB['dark goldenrod'] = 'b8860b'
let s:Name_2_RGB['DarkGoldenrod'] = 'b8860b'
let s:Name_2_RGB['darkgoldenrod'] = 'b8860b'
let s:Name_2_RGB['rosy brown'] = 'bc8f8f'
let s:Name_2_RGB['RosyBrown'] = 'bc8f8f'
let s:Name_2_RGB['rosybrown'] = 'bc8f8f'
let s:Name_2_RGB['indian red'] = 'cd5c5c'
let s:Name_2_RGB['IndianRed'] = 'cd5c5c'
let s:Name_2_RGB['indianred'] = 'cd5c5c'
let s:Name_2_RGB['saddle brown'] = '8b4513'
let s:Name_2_RGB['SaddleBrown'] = '8b4513'
let s:Name_2_RGB['saddlebrown'] = '8b4513'
let s:Name_2_RGB['sienna'] = 'a0522d'
let s:Name_2_RGB['peru'] = 'cd853f'
let s:Name_2_RGB['burlywood'] = 'deb887'
let s:Name_2_RGB['beige'] = 'f5f5dc'
let s:Name_2_RGB['wheat'] = 'f5deb3'
let s:Name_2_RGB['sandy brown'] = 'f4a460'
let s:Name_2_RGB['SandyBrown'] = 'f4a460'
let s:Name_2_RGB['sandybrown'] = 'f4a460'
let s:Name_2_RGB['tan'] = 'd2b48c'
let s:Name_2_RGB['chocolate'] = 'd2691e'
let s:Name_2_RGB['firebrick'] = 'b22222'
let s:Name_2_RGB['brown'] = 'a52a2a'
let s:Name_2_RGB['dark salmon'] = 'e9967a'
let s:Name_2_RGB['DarkSalmon'] = 'e9967a'
let s:Name_2_RGB['darksalmon'] = 'e9967a'
let s:Name_2_RGB['salmon'] = 'fa8072'
let s:Name_2_RGB['light salmon'] = 'ffa07a'
let s:Name_2_RGB['LightSalmon'] = 'ffa07a'
let s:Name_2_RGB['lightsalmon'] = 'ffa07a'
let s:Name_2_RGB['orange'] = 'ffa500'
let s:Name_2_RGB['dark orange'] = 'ff8c00'
let s:Name_2_RGB['DarkOrange'] = 'ff8c00'
let s:Name_2_RGB['darkorange'] = 'ff8c00'
let s:Name_2_RGB['coral'] = 'ff7f50'
let s:Name_2_RGB['light coral'] = 'f08080'
let s:Name_2_RGB['LightCoral'] = 'f08080'
let s:Name_2_RGB['lightcoral'] = 'f08080'
let s:Name_2_RGB['tomato'] = 'ff6347'
let s:Name_2_RGB['orange red'] = 'ff4500'
let s:Name_2_RGB['OrangeRed'] = 'ff4500'
let s:Name_2_RGB['orangered'] = 'ff4500'
let s:Name_2_RGB['red'] = 'ff0000'
let s:Name_2_RGB['hot pink'] = 'ff69b4'
let s:Name_2_RGB['HotPink'] = 'ff69b4'
let s:Name_2_RGB['hotpink'] = 'ff69b4'
let s:Name_2_RGB['deep pink'] = 'ff1493'
let s:Name_2_RGB['DeepPink'] = 'ff1493'
let s:Name_2_RGB['deeppink'] = 'ff1493'
let s:Name_2_RGB['pink'] = 'ffc0cb'
let s:Name_2_RGB['light pink'] = 'ffb6c1'
let s:Name_2_RGB['LightPink'] = 'ffb6c1'
let s:Name_2_RGB['lightpink'] = 'ffb6c1'
let s:Name_2_RGB['pale violet red'] = 'db7093'
let s:Name_2_RGB['PaleVioletRed'] = 'db7093'
let s:Name_2_RGB['palevioletred'] = 'db7093'
let s:Name_2_RGB['maroon'] = 'b03060'
let s:Name_2_RGB['medium violet red'] = 'c71585'
let s:Name_2_RGB['MediumVioletRed'] = 'c71585'
let s:Name_2_RGB['mediumvioletred'] = 'c71585'
let s:Name_2_RGB['violet red'] = 'd02090'
let s:Name_2_RGB['VioletRed'] = 'd02090'
let s:Name_2_RGB['violetred'] = 'd02090'
let s:Name_2_RGB['magenta'] = 'ff00ff'
let s:Name_2_RGB['violet'] = 'ee82ee'
let s:Name_2_RGB['plum'] = 'dda0dd'
let s:Name_2_RGB['orchid'] = 'da70d6'
let s:Name_2_RGB['medium orchid'] = 'ba55d3'
let s:Name_2_RGB['MediumOrchid'] = 'ba55d3'
let s:Name_2_RGB['mediumorchid'] = 'ba55d3'
let s:Name_2_RGB['dark orchid'] = '9932cc'
let s:Name_2_RGB['DarkOrchid'] = '9932cc'
let s:Name_2_RGB['darkorchid'] = '9932cc'
let s:Name_2_RGB['dark violet'] = '9400d3'
let s:Name_2_RGB['DarkViolet'] = '9400d3'
let s:Name_2_RGB['darkviolet'] = '9400d3'
let s:Name_2_RGB['blue violet'] = '8a2be2'
let s:Name_2_RGB['BlueViolet'] = '8a2be2'
let s:Name_2_RGB['blueviolet'] = '8a2be2'
let s:Name_2_RGB['purple'] = 'a020f0'
let s:Name_2_RGB['medium purple'] = '9370db'
let s:Name_2_RGB['MediumPurple'] = '9370db'
let s:Name_2_RGB['mediumpurple'] = '9370db'
let s:Name_2_RGB['thistle'] = 'd8bfd8'
let s:Name_2_RGB['snow1'] = 'fffafa'
let s:Name_2_RGB['snow2'] = 'eee9e9'
let s:Name_2_RGB['snow3'] = 'cdc9c9'
let s:Name_2_RGB['snow4'] = '8b8989'
let s:Name_2_RGB['seashell1'] = 'fff5ee'
let s:Name_2_RGB['seashell2'] = 'eee5de'
let s:Name_2_RGB['seashell3'] = 'cdc5bf'
let s:Name_2_RGB['seashell4'] = '8b8682'
let s:Name_2_RGB['AntiqueWhite1'] = 'ffefdb'
let s:Name_2_RGB['antiquewhite1'] = 'ffefdb'
let s:Name_2_RGB['AntiqueWhite2'] = 'eedfcc'
let s:Name_2_RGB['antiquewhite2'] = 'eedfcc'
let s:Name_2_RGB['AntiqueWhite3'] = 'cdc0b0'
let s:Name_2_RGB['antiquewhite3'] = 'cdc0b0'
let s:Name_2_RGB['AntiqueWhite4'] = '8b8378'
let s:Name_2_RGB['antiquewhite4'] = '8b8378'
let s:Name_2_RGB['bisque1'] = 'ffe4c4'
let s:Name_2_RGB['bisque2'] = 'eed5b7'
let s:Name_2_RGB['bisque3'] = 'cdb79e'
let s:Name_2_RGB['bisque4'] = '8b7d6b'
let s:Name_2_RGB['PeachPuff1'] = 'ffdab9'
let s:Name_2_RGB['peachpuff1'] = 'ffdab9'
let s:Name_2_RGB['PeachPuff2'] = 'eecbad'
let s:Name_2_RGB['peachpuff2'] = 'eecbad'
let s:Name_2_RGB['PeachPuff3'] = 'cdaf95'
let s:Name_2_RGB['peachpuff3'] = 'cdaf95'
let s:Name_2_RGB['PeachPuff4'] = '8b7765'
let s:Name_2_RGB['peachpuff4'] = '8b7765'
let s:Name_2_RGB['NavajoWhite1'] = 'ffdead'
let s:Name_2_RGB['navajowhite1'] = 'ffdead'
let s:Name_2_RGB['NavajoWhite2'] = 'eecfa1'
let s:Name_2_RGB['navajowhite2'] = 'eecfa1'
let s:Name_2_RGB['NavajoWhite3'] = 'cdb38b'
let s:Name_2_RGB['navajowhite3'] = 'cdb38b'
let s:Name_2_RGB['NavajoWhite4'] = '8b795e'
let s:Name_2_RGB['navajowhite4'] = '8b795e'
let s:Name_2_RGB['LemonChiffon1'] = 'fffacd'
let s:Name_2_RGB['lemonchiffon1'] = 'fffacd'
let s:Name_2_RGB['LemonChiffon2'] = 'eee9bf'
let s:Name_2_RGB['lemonchiffon2'] = 'eee9bf'
let s:Name_2_RGB['LemonChiffon3'] = 'cdc9a5'
let s:Name_2_RGB['lemonchiffon3'] = 'cdc9a5'
let s:Name_2_RGB['LemonChiffon4'] = '8b8970'
let s:Name_2_RGB['lemonchiffon4'] = '8b8970'
let s:Name_2_RGB['cornsilk1'] = 'fff8dc'
let s:Name_2_RGB['cornsilk2'] = 'eee8cd'
let s:Name_2_RGB['cornsilk3'] = 'cdc8b1'
let s:Name_2_RGB['cornsilk4'] = '8b8878'
let s:Name_2_RGB['ivory1'] = 'fffff0'
let s:Name_2_RGB['ivory2'] = 'eeeee0'
let s:Name_2_RGB['ivory3'] = 'cdcdc1'
let s:Name_2_RGB['ivory4'] = '8b8b83'
let s:Name_2_RGB['honeydew1'] = 'f0fff0'
let s:Name_2_RGB['honeydew2'] = 'e0eee0'
let s:Name_2_RGB['honeydew3'] = 'c1cdc1'
let s:Name_2_RGB['honeydew4'] = '838b83'
let s:Name_2_RGB['LavenderBlush1'] = 'fff0f5'
let s:Name_2_RGB['lavenderblush1'] = 'fff0f5'
let s:Name_2_RGB['LavenderBlush2'] = 'eee0e5'
let s:Name_2_RGB['lavenderblush2'] = 'eee0e5'
let s:Name_2_RGB['LavenderBlush3'] = 'cdc1c5'
let s:Name_2_RGB['lavenderblush3'] = 'cdc1c5'
let s:Name_2_RGB['LavenderBlush4'] = '8b8386'
let s:Name_2_RGB['lavenderblush4'] = '8b8386'
let s:Name_2_RGB['MistyRose1'] = 'ffe4e1'
let s:Name_2_RGB['mistyrose1'] = 'ffe4e1'
let s:Name_2_RGB['MistyRose2'] = 'eed5d2'
let s:Name_2_RGB['mistyrose2'] = 'eed5d2'
let s:Name_2_RGB['MistyRose3'] = 'cdb7b5'
let s:Name_2_RGB['mistyrose3'] = 'cdb7b5'
let s:Name_2_RGB['MistyRose4'] = '8b7d7b'
let s:Name_2_RGB['mistyrose4'] = '8b7d7b'
let s:Name_2_RGB['azure1'] = 'f0ffff'
let s:Name_2_RGB['azure2'] = 'e0eeee'
let s:Name_2_RGB['azure3'] = 'c1cdcd'
let s:Name_2_RGB['azure4'] = '838b8b'
let s:Name_2_RGB['SlateBlue1'] = '836fff'
let s:Name_2_RGB['slateblue1'] = '836fff'
let s:Name_2_RGB['SlateBlue2'] = '7a67ee'
let s:Name_2_RGB['slateblue2'] = '7a67ee'
let s:Name_2_RGB['SlateBlue3'] = '6959cd'
let s:Name_2_RGB['slateblue3'] = '6959cd'
let s:Name_2_RGB['SlateBlue4'] = '473c8b'
let s:Name_2_RGB['slateblue4'] = '473c8b'
let s:Name_2_RGB['RoyalBlue1'] = '4876ff'
let s:Name_2_RGB['royalblue1'] = '4876ff'
let s:Name_2_RGB['RoyalBlue2'] = '436eee'
let s:Name_2_RGB['royalblue2'] = '436eee'
let s:Name_2_RGB['RoyalBlue3'] = '3a5fcd'
let s:Name_2_RGB['royalblue3'] = '3a5fcd'
let s:Name_2_RGB['RoyalBlue4'] = '27408b'
let s:Name_2_RGB['royalblue4'] = '27408b'
let s:Name_2_RGB['blue1'] = '0000ff'
let s:Name_2_RGB['blue2'] = '0000ee'
let s:Name_2_RGB['blue3'] = '0000cd'
let s:Name_2_RGB['blue4'] = '00008b'
let s:Name_2_RGB['DodgerBlue1'] = '1e90ff'
let s:Name_2_RGB['dodgerblue1'] = '1e90ff'
let s:Name_2_RGB['DodgerBlue2'] = '1c86ee'
let s:Name_2_RGB['dodgerblue2'] = '1c86ee'
let s:Name_2_RGB['DodgerBlue3'] = '1874cd'
let s:Name_2_RGB['dodgerblue3'] = '1874cd'
let s:Name_2_RGB['DodgerBlue4'] = '104e8b'
let s:Name_2_RGB['dodgerblue4'] = '104e8b'
let s:Name_2_RGB['SteelBlue1'] = '63b8ff'
let s:Name_2_RGB['steelblue1'] = '63b8ff'
let s:Name_2_RGB['SteelBlue2'] = '5cacee'
let s:Name_2_RGB['steelblue2'] = '5cacee'
let s:Name_2_RGB['SteelBlue3'] = '4f94cd'
let s:Name_2_RGB['steelblue3'] = '4f94cd'
let s:Name_2_RGB['SteelBlue4'] = '36648b'
let s:Name_2_RGB['steelblue4'] = '36648b'
let s:Name_2_RGB['DeepSkyBlue1'] = '00bfff'
let s:Name_2_RGB['deepskyblue1'] = '00bfff'
let s:Name_2_RGB['DeepSkyBlue2'] = '00b2ee'
let s:Name_2_RGB['deepskyblue2'] = '00b2ee'
let s:Name_2_RGB['DeepSkyBlue3'] = '009acd'
let s:Name_2_RGB['deepskyblue3'] = '009acd'
let s:Name_2_RGB['DeepSkyBlue4'] = '00688b'
let s:Name_2_RGB['deepskyblue4'] = '00688b'
let s:Name_2_RGB['SkyBlue1'] = '87ceff'
let s:Name_2_RGB['skyblue1'] = '87ceff'
let s:Name_2_RGB['SkyBlue2'] = '7ec0ee'
let s:Name_2_RGB['skyblue2'] = '7ec0ee'
let s:Name_2_RGB['SkyBlue3'] = '6ca6cd'
let s:Name_2_RGB['skyblue3'] = '6ca6cd'
let s:Name_2_RGB['SkyBlue4'] = '4a708b'
let s:Name_2_RGB['skyblue4'] = '4a708b'
let s:Name_2_RGB['LightSkyBlue1'] = 'b0e2ff'
let s:Name_2_RGB['lightskyblue1'] = 'b0e2ff'
let s:Name_2_RGB['LightSkyBlue2'] = 'a4d3ee'
let s:Name_2_RGB['lightskyblue2'] = 'a4d3ee'
let s:Name_2_RGB['LightSkyBlue3'] = '8db6cd'
let s:Name_2_RGB['lightskyblue3'] = '8db6cd'
let s:Name_2_RGB['LightSkyBlue4'] = '607b8b'
let s:Name_2_RGB['lightskyblue4'] = '607b8b'
let s:Name_2_RGB['SlateGray1'] = 'c6e2ff'
let s:Name_2_RGB['slategray1'] = 'c6e2ff'
let s:Name_2_RGB['SlateGray2'] = 'b9d3ee'
let s:Name_2_RGB['slategray2'] = 'b9d3ee'
let s:Name_2_RGB['SlateGray3'] = '9fb6cd'
let s:Name_2_RGB['slategray3'] = '9fb6cd'
let s:Name_2_RGB['SlateGray4'] = '6c7b8b'
let s:Name_2_RGB['slategray4'] = '6c7b8b'
let s:Name_2_RGB['LightSteelBlue1'] = 'cae1ff'
let s:Name_2_RGB['lightsteelblue1'] = 'cae1ff'
let s:Name_2_RGB['LightSteelBlue2'] = 'bcd2ee'
let s:Name_2_RGB['lightsteelblue2'] = 'bcd2ee'
let s:Name_2_RGB['LightSteelBlue3'] = 'a2b5cd'
let s:Name_2_RGB['lightsteelblue3'] = 'a2b5cd'
let s:Name_2_RGB['LightSteelBlue4'] = '6e7b8b'
let s:Name_2_RGB['lightsteelblue4'] = '6e7b8b'
let s:Name_2_RGB['LightBlue1'] = 'bfefff'
let s:Name_2_RGB['lightblue1'] = 'bfefff'
let s:Name_2_RGB['LightBlue2'] = 'b2dfee'
let s:Name_2_RGB['lightblue2'] = 'b2dfee'
let s:Name_2_RGB['LightBlue3'] = '9ac0cd'
let s:Name_2_RGB['lightblue3'] = '9ac0cd'
let s:Name_2_RGB['LightBlue4'] = '68838b'
let s:Name_2_RGB['lightblue4'] = '68838b'
let s:Name_2_RGB['LightCyan1'] = 'e0ffff'
let s:Name_2_RGB['lightcyan1'] = 'e0ffff'
let s:Name_2_RGB['LightCyan2'] = 'd1eeee'
let s:Name_2_RGB['lightcyan2'] = 'd1eeee'
let s:Name_2_RGB['LightCyan3'] = 'b4cdcd'
let s:Name_2_RGB['lightcyan3'] = 'b4cdcd'
let s:Name_2_RGB['LightCyan4'] = '7a8b8b'
let s:Name_2_RGB['lightcyan4'] = '7a8b8b'
let s:Name_2_RGB['PaleTurquoise1'] = 'bbffff'
let s:Name_2_RGB['paleturquoise1'] = 'bbffff'
let s:Name_2_RGB['PaleTurquoise2'] = 'aeeeee'
let s:Name_2_RGB['paleturquoise2'] = 'aeeeee'
let s:Name_2_RGB['PaleTurquoise3'] = '96cdcd'
let s:Name_2_RGB['paleturquoise3'] = '96cdcd'
let s:Name_2_RGB['PaleTurquoise4'] = '668b8b'
let s:Name_2_RGB['paleturquoise4'] = '668b8b'
let s:Name_2_RGB['CadetBlue1'] = '98f5ff'
let s:Name_2_RGB['cadetblue1'] = '98f5ff'
let s:Name_2_RGB['CadetBlue2'] = '8ee5ee'
let s:Name_2_RGB['cadetblue2'] = '8ee5ee'
let s:Name_2_RGB['CadetBlue3'] = '7ac5cd'
let s:Name_2_RGB['cadetblue3'] = '7ac5cd'
let s:Name_2_RGB['CadetBlue4'] = '53868b'
let s:Name_2_RGB['cadetblue4'] = '53868b'
let s:Name_2_RGB['turquoise1'] = '00f5ff'
let s:Name_2_RGB['turquoise2'] = '00e5ee'
let s:Name_2_RGB['turquoise3'] = '00c5cd'
let s:Name_2_RGB['turquoise4'] = '00868b'
let s:Name_2_RGB['cyan1'] = '00ffff'
let s:Name_2_RGB['cyan2'] = '00eeee'
let s:Name_2_RGB['cyan3'] = '00cdcd'
let s:Name_2_RGB['cyan4'] = '008b8b'
let s:Name_2_RGB['DarkSlateGray1'] = '97ffff'
let s:Name_2_RGB['darkslategray1'] = '97ffff'
let s:Name_2_RGB['DarkSlateGray2'] = '8deeee'
let s:Name_2_RGB['darkslategray2'] = '8deeee'
let s:Name_2_RGB['DarkSlateGray3'] = '79cdcd'
let s:Name_2_RGB['darkslategray3'] = '79cdcd'
let s:Name_2_RGB['DarkSlateGray4'] = '528b8b'
let s:Name_2_RGB['darkslategray4'] = '528b8b'
let s:Name_2_RGB['aquamarine1'] = '7fffd4'
let s:Name_2_RGB['aquamarine2'] = '76eec6'
let s:Name_2_RGB['aquamarine3'] = '66cdaa'
let s:Name_2_RGB['aquamarine4'] = '458b74'
let s:Name_2_RGB['DarkSeaGreen1'] = 'c1ffc1'
let s:Name_2_RGB['darkseagreen1'] = 'c1ffc1'
let s:Name_2_RGB['DarkSeaGreen2'] = 'b4eeb4'
let s:Name_2_RGB['darkseagreen2'] = 'b4eeb4'
let s:Name_2_RGB['DarkSeaGreen3'] = '9bcd9b'
let s:Name_2_RGB['darkseagreen3'] = '9bcd9b'
let s:Name_2_RGB['DarkSeaGreen4'] = '698b69'
let s:Name_2_RGB['darkseagreen4'] = '698b69'
let s:Name_2_RGB['SeaGreen1'] = '54ff9f'
let s:Name_2_RGB['seagreen1'] = '54ff9f'
let s:Name_2_RGB['SeaGreen2'] = '4eee94'
let s:Name_2_RGB['seagreen2'] = '4eee94'
let s:Name_2_RGB['SeaGreen3'] = '43cd80'
let s:Name_2_RGB['seagreen3'] = '43cd80'
let s:Name_2_RGB['SeaGreen4'] = '2e8b57'
let s:Name_2_RGB['seagreen4'] = '2e8b57'
let s:Name_2_RGB['PaleGreen1'] = '9aff9a'
let s:Name_2_RGB['palegreen1'] = '9aff9a'
let s:Name_2_RGB['PaleGreen2'] = '90ee90'
let s:Name_2_RGB['palegreen2'] = '90ee90'
let s:Name_2_RGB['PaleGreen3'] = '7ccd7c'
let s:Name_2_RGB['palegreen3'] = '7ccd7c'
let s:Name_2_RGB['PaleGreen4'] = '548b54'
let s:Name_2_RGB['palegreen4'] = '548b54'
let s:Name_2_RGB['SpringGreen1'] = '00ff7f'
let s:Name_2_RGB['springgreen1'] = '00ff7f'
let s:Name_2_RGB['SpringGreen2'] = '00ee76'
let s:Name_2_RGB['springgreen2'] = '00ee76'
let s:Name_2_RGB['SpringGreen3'] = '00cd66'
let s:Name_2_RGB['springgreen3'] = '00cd66'
let s:Name_2_RGB['SpringGreen4'] = '008b45'
let s:Name_2_RGB['springgreen4'] = '008b45'
let s:Name_2_RGB['green1'] = '00ff00'
let s:Name_2_RGB['green2'] = '00ee00'
let s:Name_2_RGB['green3'] = '00cd00'
let s:Name_2_RGB['green4'] = '008b00'
let s:Name_2_RGB['chartreuse1'] = '7fff00'
let s:Name_2_RGB['chartreuse2'] = '76ee00'
let s:Name_2_RGB['chartreuse3'] = '66cd00'
let s:Name_2_RGB['chartreuse4'] = '458b00'
let s:Name_2_RGB['OliveDrab1'] = 'c0ff3e'
let s:Name_2_RGB['olivedrab1'] = 'c0ff3e'
let s:Name_2_RGB['OliveDrab2'] = 'b3ee3a'
let s:Name_2_RGB['olivedrab2'] = 'b3ee3a'
let s:Name_2_RGB['OliveDrab3'] = '9acd32'
let s:Name_2_RGB['olivedrab3'] = '9acd32'
let s:Name_2_RGB['OliveDrab4'] = '698b22'
let s:Name_2_RGB['olivedrab4'] = '698b22'
let s:Name_2_RGB['DarkOliveGreen1'] = 'caff70'
let s:Name_2_RGB['darkolivegreen1'] = 'caff70'
let s:Name_2_RGB['DarkOliveGreen2'] = 'bcee68'
let s:Name_2_RGB['darkolivegreen2'] = 'bcee68'
let s:Name_2_RGB['DarkOliveGreen3'] = 'a2cd5a'
let s:Name_2_RGB['darkolivegreen3'] = 'a2cd5a'
let s:Name_2_RGB['DarkOliveGreen4'] = '6e8b3d'
let s:Name_2_RGB['darkolivegreen4'] = '6e8b3d'
let s:Name_2_RGB['khaki1'] = 'fff68f'
let s:Name_2_RGB['khaki2'] = 'eee685'
let s:Name_2_RGB['khaki3'] = 'cdc673'
let s:Name_2_RGB['khaki4'] = '8b864e'
let s:Name_2_RGB['LightGoldenrod1'] = 'ffec8b'
let s:Name_2_RGB['lightgoldenrod1'] = 'ffec8b'
let s:Name_2_RGB['LightGoldenrod2'] = 'eedc82'
let s:Name_2_RGB['lightgoldenrod2'] = 'eedc82'
let s:Name_2_RGB['LightGoldenrod3'] = 'cdbe70'
let s:Name_2_RGB['lightgoldenrod3'] = 'cdbe70'
let s:Name_2_RGB['LightGoldenrod4'] = '8b814c'
let s:Name_2_RGB['lightgoldenrod4'] = '8b814c'
let s:Name_2_RGB['LightYellow1'] = 'ffffe0'
let s:Name_2_RGB['lightyellow1'] = 'ffffe0'
let s:Name_2_RGB['LightYellow2'] = 'eeeed1'
let s:Name_2_RGB['lightyellow2'] = 'eeeed1'
let s:Name_2_RGB['LightYellow3'] = 'cdcdb4'
let s:Name_2_RGB['lightyellow3'] = 'cdcdb4'
let s:Name_2_RGB['LightYellow4'] = '8b8b7a'
let s:Name_2_RGB['lightyellow4'] = '8b8b7a'
let s:Name_2_RGB['yellow1'] = 'ffff00'
let s:Name_2_RGB['yellow2'] = 'eeee00'
let s:Name_2_RGB['yellow3'] = 'cdcd00'
let s:Name_2_RGB['yellow4'] = '8b8b00'
let s:Name_2_RGB['darkyellow'] = '8b8b00'
let s:Name_2_RGB['gold1'] = 'ffd700'
let s:Name_2_RGB['gold2'] = 'eec900'
let s:Name_2_RGB['gold3'] = 'cdad00'
let s:Name_2_RGB['gold4'] = '8b7500'
let s:Name_2_RGB['goldenrod1'] = 'ffc125'
let s:Name_2_RGB['goldenrod2'] = 'eeb422'
let s:Name_2_RGB['goldenrod3'] = 'cd9b1d'
let s:Name_2_RGB['goldenrod4'] = '8b6914'
let s:Name_2_RGB['DarkGoldenrod1'] = 'ffb90f'
let s:Name_2_RGB['darkgoldenrod1'] = 'ffb90f'
let s:Name_2_RGB['DarkGoldenrod2'] = 'eead0e'
let s:Name_2_RGB['darkgoldenrod2'] = 'eead0e'
let s:Name_2_RGB['DarkGoldenrod3'] = 'cd950c'
let s:Name_2_RGB['darkgoldenrod3'] = 'cd950c'
let s:Name_2_RGB['DarkGoldenrod4'] = '8b6508'
let s:Name_2_RGB['darkgoldenrod4'] = '8b6508'
let s:Name_2_RGB['RosyBrown1'] = 'ffc1c1'
let s:Name_2_RGB['rosybrown1'] = 'ffc1c1'
let s:Name_2_RGB['RosyBrown2'] = 'eeb4b4'
let s:Name_2_RGB['rosybrown2'] = 'eeb4b4'
let s:Name_2_RGB['RosyBrown3'] = 'cd9b9b'
let s:Name_2_RGB['rosybrown3'] = 'cd9b9b'
let s:Name_2_RGB['RosyBrown4'] = '8b6969'
let s:Name_2_RGB['rosybrown4'] = '8b6969'
let s:Name_2_RGB['IndianRed1'] = 'ff6a6a'
let s:Name_2_RGB['indianred1'] = 'ff6a6a'
let s:Name_2_RGB['IndianRed2'] = 'ee6363'
let s:Name_2_RGB['indianred2'] = 'ee6363'
let s:Name_2_RGB['IndianRed3'] = 'cd5555'
let s:Name_2_RGB['indianred3'] = 'cd5555'
let s:Name_2_RGB['IndianRed4'] = '8b3a3a'
let s:Name_2_RGB['indianred4'] = '8b3a3a'
let s:Name_2_RGB['sienna1'] = 'ff8247'
let s:Name_2_RGB['sienna2'] = 'ee7942'
let s:Name_2_RGB['sienna3'] = 'cd6839'
let s:Name_2_RGB['sienna4'] = '8b4726'
let s:Name_2_RGB['burlywood1'] = 'ffd39b'
let s:Name_2_RGB['burlywood2'] = 'eec591'
let s:Name_2_RGB['burlywood3'] = 'cdaa7d'
let s:Name_2_RGB['burlywood4'] = '8b7355'
let s:Name_2_RGB['wheat1'] = 'ffe7ba'
let s:Name_2_RGB['wheat2'] = 'eed8ae'
let s:Name_2_RGB['wheat3'] = 'cdba96'
let s:Name_2_RGB['wheat4'] = '8b7e66'
let s:Name_2_RGB['tan1'] = 'ffa54f'
let s:Name_2_RGB['tan2'] = 'ee9a49'
let s:Name_2_RGB['tan3'] = 'cd853f'
let s:Name_2_RGB['tan4'] = '8b5a2b'
let s:Name_2_RGB['chocolate1'] = 'ff7f24'
let s:Name_2_RGB['chocolate2'] = 'ee7621'
let s:Name_2_RGB['chocolate3'] = 'cd661d'
let s:Name_2_RGB['chocolate4'] = '8b4513'
let s:Name_2_RGB['firebrick1'] = 'ff3030'
let s:Name_2_RGB['firebrick2'] = 'ee2c2c'
let s:Name_2_RGB['firebrick3'] = 'cd2626'
let s:Name_2_RGB['firebrick4'] = '8b1a1a'
let s:Name_2_RGB['brown1'] = 'ff4040'
let s:Name_2_RGB['brown2'] = 'ee3b3b'
let s:Name_2_RGB['brown3'] = 'cd3333'
let s:Name_2_RGB['brown4'] = '8b2323'
let s:Name_2_RGB['salmon1'] = 'ff8c69'
let s:Name_2_RGB['salmon2'] = 'ee8262'
let s:Name_2_RGB['salmon3'] = 'cd7054'
let s:Name_2_RGB['salmon4'] = '8b4c39'
let s:Name_2_RGB['LightSalmon1'] = 'ffa07a'
let s:Name_2_RGB['lightsalmon1'] = 'ffa07a'
let s:Name_2_RGB['LightSalmon2'] = 'ee9572'
let s:Name_2_RGB['lightsalmon2'] = 'ee9572'
let s:Name_2_RGB['LightSalmon3'] = 'cd8162'
let s:Name_2_RGB['lightsalmon3'] = 'cd8162'
let s:Name_2_RGB['LightSalmon4'] = '8b5742'
let s:Name_2_RGB['lightsalmon4'] = '8b5742'
let s:Name_2_RGB['orange1'] = 'ffa500'
let s:Name_2_RGB['lightorange'] = 'ffa500'
let s:Name_2_RGB['orange2'] = 'ee9a00'
let s:Name_2_RGB['orange3'] = 'cd8500'
let s:Name_2_RGB['orange4'] = '8b5a00'
let s:Name_2_RGB['DarkOrange1'] = 'ff7f00'
let s:Name_2_RGB['darkorange1'] = 'ff7f00'
let s:Name_2_RGB['DarkOrange2'] = 'ee7600'
let s:Name_2_RGB['darkorange2'] = 'ee7600'
let s:Name_2_RGB['DarkOrange3'] = 'cd6600'
let s:Name_2_RGB['darkorange3'] = 'cd6600'
let s:Name_2_RGB['DarkOrange4'] = '8b4500'
let s:Name_2_RGB['darkorange4'] = '8b4500'
let s:Name_2_RGB['coral1'] = 'ff7256'
let s:Name_2_RGB['coral2'] = 'ee6a50'
let s:Name_2_RGB['coral3'] = 'cd5b45'
let s:Name_2_RGB['coral4'] = '8b3e2f'
let s:Name_2_RGB['tomato1'] = 'ff6347'
let s:Name_2_RGB['tomato2'] = 'ee5c42'
let s:Name_2_RGB['tomato3'] = 'cd4f39'
let s:Name_2_RGB['tomato4'] = '8b3626'
let s:Name_2_RGB['OrangeRed1'] = 'ff4500'
let s:Name_2_RGB['orangered1'] = 'ff4500'
let s:Name_2_RGB['OrangeRed2'] = 'ee4000'
let s:Name_2_RGB['orangered2'] = 'ee4000'
let s:Name_2_RGB['OrangeRed3'] = 'cd3700'
let s:Name_2_RGB['orangered3'] = 'cd3700'
let s:Name_2_RGB['OrangeRed4'] = '8b2500'
let s:Name_2_RGB['orangered4'] = '8b2500'
let s:Name_2_RGB['red1'] = 'ff0000'
let s:Name_2_RGB['lightred'] = 'ff0000'
let s:Name_2_RGB['red2'] = 'ee0000'
let s:Name_2_RGB['red3'] = 'cd0000'
let s:Name_2_RGB['red4'] = '8b0000'
let s:Name_2_RGB['DeepPink1'] = 'ff1493'
let s:Name_2_RGB['deeppink1'] = 'ff1493'
let s:Name_2_RGB['DeepPink2'] = 'ee1289'
let s:Name_2_RGB['deeppink2'] = 'ee1289'
let s:Name_2_RGB['DeepPink3'] = 'cd1076'
let s:Name_2_RGB['deeppink3'] = 'cd1076'
let s:Name_2_RGB['DeepPink4'] = '8b0a50'
let s:Name_2_RGB['deeppink4'] = '8b0a50'
let s:Name_2_RGB['HotPink1'] = 'ff6eb4'
let s:Name_2_RGB['hotpink1'] = 'ff6eb4'
let s:Name_2_RGB['HotPink2'] = 'ee6aa7'
let s:Name_2_RGB['hotpink2'] = 'ee6aa7'
let s:Name_2_RGB['HotPink3'] = 'cd6090'
let s:Name_2_RGB['hotpink3'] = 'cd6090'
let s:Name_2_RGB['HotPink4'] = '8b3a62'
let s:Name_2_RGB['hotpink4'] = '8b3a62'
let s:Name_2_RGB['pink1'] = 'ffb5c5'
let s:Name_2_RGB['pink2'] = 'eea9b8'
let s:Name_2_RGB['pink3'] = 'cd919e'
let s:Name_2_RGB['pink4'] = '8b636c'
let s:Name_2_RGB['LightPink1'] = 'ffaeb9'
let s:Name_2_RGB['lightpink1'] = 'ffaeb9'
let s:Name_2_RGB['LightPink2'] = 'eea2ad'
let s:Name_2_RGB['lightpink2'] = 'eea2ad'
let s:Name_2_RGB['LightPink3'] = 'cd8c95'
let s:Name_2_RGB['lightpink3'] = 'cd8c95'
let s:Name_2_RGB['LightPink4'] = '8b5f65'
let s:Name_2_RGB['lightpink4'] = '8b5f65'
let s:Name_2_RGB['PaleVioletRed1'] = 'ff82ab'
let s:Name_2_RGB['palevioletred1'] = 'ff82ab'
let s:Name_2_RGB['PaleVioletRed2'] = 'ee799f'
let s:Name_2_RGB['palevioletred2'] = 'ee799f'
let s:Name_2_RGB['PaleVioletRed3'] = 'cd6889'
let s:Name_2_RGB['palevioletred3'] = 'cd6889'
let s:Name_2_RGB['PaleVioletRed4'] = '8b475d'
let s:Name_2_RGB['palevioletred4'] = '8b475d'
let s:Name_2_RGB['maroon1'] = 'ff34b3'
let s:Name_2_RGB['maroon2'] = 'ee30a7'
let s:Name_2_RGB['maroon3'] = 'cd2990'
let s:Name_2_RGB['maroon4'] = '8b1c62'
let s:Name_2_RGB['VioletRed1'] = 'ff3e96'
let s:Name_2_RGB['violetred1'] = 'ff3e96'
let s:Name_2_RGB['VioletRed2'] = 'ee3a8c'
let s:Name_2_RGB['violetred2'] = 'ee3a8c'
let s:Name_2_RGB['VioletRed3'] = 'cd3278'
let s:Name_2_RGB['violetred3'] = 'cd3278'
let s:Name_2_RGB['VioletRed4'] = '8b2252'
let s:Name_2_RGB['violetred4'] = '8b2252'
let s:Name_2_RGB['magenta1'] = 'ff00ff'
let s:Name_2_RGB['lightmagenta'] = 'ff00ff'
let s:Name_2_RGB['magenta2'] = 'ee00ee'
let s:Name_2_RGB['magenta3'] = 'cd00cd'
let s:Name_2_RGB['magenta4'] = '8b008b'
let s:Name_2_RGB['orchid1'] = 'ff83fa'
let s:Name_2_RGB['orchid2'] = 'ee7ae9'
let s:Name_2_RGB['orchid3'] = 'cd69c9'
let s:Name_2_RGB['orchid4'] = '8b4789'
let s:Name_2_RGB['plum1'] = 'ffbbff'
let s:Name_2_RGB['plum2'] = 'eeaeee'
let s:Name_2_RGB['plum3'] = 'cd96cd'
let s:Name_2_RGB['plum4'] = '8b668b'
let s:Name_2_RGB['MediumOrchid1'] = 'e066ff'
let s:Name_2_RGB['mediumorchid1'] = 'e066ff'
let s:Name_2_RGB['MediumOrchid2'] = 'd15fee'
let s:Name_2_RGB['mediumorchid2'] = 'd15fee'
let s:Name_2_RGB['MediumOrchid3'] = 'b452cd'
let s:Name_2_RGB['mediumorchid3'] = 'b452cd'
let s:Name_2_RGB['MediumOrchid4'] = '7a378b'
let s:Name_2_RGB['mediumorchid4'] = '7a378b'
let s:Name_2_RGB['DarkOrchid1'] = 'bf3eff'
let s:Name_2_RGB['darkorchid1'] = 'bf3eff'
let s:Name_2_RGB['DarkOrchid2'] = 'b23aee'
let s:Name_2_RGB['darkorchid2'] = 'b23aee'
let s:Name_2_RGB['DarkOrchid3'] = '9a32cd'
let s:Name_2_RGB['darkorchid3'] = '9a32cd'
let s:Name_2_RGB['DarkOrchid4'] = '68228b'
let s:Name_2_RGB['darkorchid4'] = '68228b'
let s:Name_2_RGB['purple1'] = '9b30ff'
let s:Name_2_RGB['purple2'] = '912cee'
let s:Name_2_RGB['purple3'] = '7d26cd'
let s:Name_2_RGB['purple4'] = '551a8b'
let s:Name_2_RGB['MediumPurple1'] = 'ab82ff'
let s:Name_2_RGB['mediumpurple1'] = 'ab82ff'
let s:Name_2_RGB['MediumPurple2'] = '9f79ee'
let s:Name_2_RGB['mediumpurple2'] = '9f79ee'
let s:Name_2_RGB['MediumPurple3'] = '8968cd'
let s:Name_2_RGB['mediumpurple3'] = '8968cd'
let s:Name_2_RGB['MediumPurple4'] = '5d478b'
let s:Name_2_RGB['mediumpurple4'] = '5d478b'
let s:Name_2_RGB['thistle1'] = 'ffe1ff'
let s:Name_2_RGB['thistle2'] = 'eed2ee'
let s:Name_2_RGB['thistle3'] = 'cdb5cd'
let s:Name_2_RGB['thistle4'] = '8b7b8b'
let s:Name_2_RGB['gray0'] = '000000'
let s:Name_2_RGB['grey0'] = '000000'
let s:Name_2_RGB['gray1'] = '030303'
let s:Name_2_RGB['grey1'] = '030303'
let s:Name_2_RGB['gray2'] = '050505'
let s:Name_2_RGB['grey2'] = '050505'
let s:Name_2_RGB['gray3'] = '080808'
let s:Name_2_RGB['grey3'] = '080808'
let s:Name_2_RGB['gray4'] = '0a0a0a'
let s:Name_2_RGB['grey4'] = '0a0a0a'
let s:Name_2_RGB['gray5'] = '0d0d0d'
let s:Name_2_RGB['grey5'] = '0d0d0d'
let s:Name_2_RGB['gray6'] = '0f0f0f'
let s:Name_2_RGB['grey6'] = '0f0f0f'
let s:Name_2_RGB['gray7'] = '121212'
let s:Name_2_RGB['grey7'] = '121212'
let s:Name_2_RGB['gray8'] = '141414'
let s:Name_2_RGB['grey8'] = '141414'
let s:Name_2_RGB['gray9'] = '171717'
let s:Name_2_RGB['grey9'] = '171717'
let s:Name_2_RGB['gray10'] = '1a1a1a'
let s:Name_2_RGB['grey10'] = '1a1a1a'
let s:Name_2_RGB['gray11'] = '1c1c1c'
let s:Name_2_RGB['grey11'] = '1c1c1c'
let s:Name_2_RGB['gray12'] = '1f1f1f'
let s:Name_2_RGB['grey12'] = '1f1f1f'
let s:Name_2_RGB['gray13'] = '212121'
let s:Name_2_RGB['grey13'] = '212121'
let s:Name_2_RGB['gray14'] = '242424'
let s:Name_2_RGB['grey14'] = '242424'
let s:Name_2_RGB['gray15'] = '262626'
let s:Name_2_RGB['grey15'] = '262626'
let s:Name_2_RGB['gray16'] = '292929'
let s:Name_2_RGB['grey16'] = '292929'
let s:Name_2_RGB['gray17'] = '2b2b2b'
let s:Name_2_RGB['grey17'] = '2b2b2b'
let s:Name_2_RGB['gray18'] = '2e2e2e'
let s:Name_2_RGB['grey18'] = '2e2e2e'
let s:Name_2_RGB['gray19'] = '303030'
let s:Name_2_RGB['grey19'] = '303030'
let s:Name_2_RGB['gray20'] = '333333'
let s:Name_2_RGB['grey20'] = '333333'
let s:Name_2_RGB['gray21'] = '363636'
let s:Name_2_RGB['grey21'] = '363636'
let s:Name_2_RGB['gray22'] = '383838'
let s:Name_2_RGB['grey22'] = '383838'
let s:Name_2_RGB['gray23'] = '3b3b3b'
let s:Name_2_RGB['grey23'] = '3b3b3b'
let s:Name_2_RGB['gray24'] = '3d3d3d'
let s:Name_2_RGB['grey24'] = '3d3d3d'
let s:Name_2_RGB['gray25'] = '404040'
let s:Name_2_RGB['grey25'] = '404040'
let s:Name_2_RGB['gray26'] = '424242'
let s:Name_2_RGB['grey26'] = '424242'
let s:Name_2_RGB['gray27'] = '454545'
let s:Name_2_RGB['grey27'] = '454545'
let s:Name_2_RGB['gray28'] = '474747'
let s:Name_2_RGB['grey28'] = '474747'
let s:Name_2_RGB['gray29'] = '4a4a4a'
let s:Name_2_RGB['grey29'] = '4a4a4a'
let s:Name_2_RGB['gray30'] = '4d4d4d'
let s:Name_2_RGB['grey30'] = '4d4d4d'
let s:Name_2_RGB['gray31'] = '4f4f4f'
let s:Name_2_RGB['grey31'] = '4f4f4f'
let s:Name_2_RGB['gray32'] = '525252'
let s:Name_2_RGB['grey32'] = '525252'
let s:Name_2_RGB['gray33'] = '545454'
let s:Name_2_RGB['grey33'] = '545454'
let s:Name_2_RGB['gray34'] = '575757'
let s:Name_2_RGB['grey34'] = '575757'
let s:Name_2_RGB['gray35'] = '595959'
let s:Name_2_RGB['grey35'] = '595959'
let s:Name_2_RGB['gray36'] = '5c5c5c'
let s:Name_2_RGB['grey36'] = '5c5c5c'
let s:Name_2_RGB['gray37'] = '5e5e5e'
let s:Name_2_RGB['grey37'] = '5e5e5e'
let s:Name_2_RGB['gray38'] = '616161'
let s:Name_2_RGB['grey38'] = '616161'
let s:Name_2_RGB['gray39'] = '636363'
let s:Name_2_RGB['grey39'] = '636363'
let s:Name_2_RGB['gray40'] = '666666'
let s:Name_2_RGB['grey40'] = '666666'
let s:Name_2_RGB['gray41'] = '696969'
let s:Name_2_RGB['grey41'] = '696969'
let s:Name_2_RGB['gray42'] = '6b6b6b'
let s:Name_2_RGB['grey42'] = '6b6b6b'
let s:Name_2_RGB['gray43'] = '6e6e6e'
let s:Name_2_RGB['grey43'] = '6e6e6e'
let s:Name_2_RGB['gray44'] = '707070'
let s:Name_2_RGB['grey44'] = '707070'
let s:Name_2_RGB['gray45'] = '737373'
let s:Name_2_RGB['grey45'] = '737373'
let s:Name_2_RGB['gray46'] = '757575'
let s:Name_2_RGB['grey46'] = '757575'
let s:Name_2_RGB['gray47'] = '787878'
let s:Name_2_RGB['grey47'] = '787878'
let s:Name_2_RGB['gray48'] = '7a7a7a'
let s:Name_2_RGB['grey48'] = '7a7a7a'
let s:Name_2_RGB['gray49'] = '7d7d7d'
let s:Name_2_RGB['grey49'] = '7d7d7d'
let s:Name_2_RGB['gray50'] = '7f7f7f'
let s:Name_2_RGB['grey50'] = '7f7f7f'
let s:Name_2_RGB['gray51'] = '828282'
let s:Name_2_RGB['grey51'] = '828282'
let s:Name_2_RGB['gray52'] = '858585'
let s:Name_2_RGB['grey52'] = '858585'
let s:Name_2_RGB['gray53'] = '878787'
let s:Name_2_RGB['grey53'] = '878787'
let s:Name_2_RGB['gray54'] = '8a8a8a'
let s:Name_2_RGB['grey54'] = '8a8a8a'
let s:Name_2_RGB['gray55'] = '8c8c8c'
let s:Name_2_RGB['grey55'] = '8c8c8c'
let s:Name_2_RGB['gray56'] = '8f8f8f'
let s:Name_2_RGB['grey56'] = '8f8f8f'
let s:Name_2_RGB['gray57'] = '919191'
let s:Name_2_RGB['grey57'] = '919191'
let s:Name_2_RGB['gray58'] = '949494'
let s:Name_2_RGB['grey58'] = '949494'
let s:Name_2_RGB['gray59'] = '969696'
let s:Name_2_RGB['grey59'] = '969696'
let s:Name_2_RGB['gray60'] = '999999'
let s:Name_2_RGB['grey60'] = '999999'
let s:Name_2_RGB['gray61'] = '9c9c9c'
let s:Name_2_RGB['grey61'] = '9c9c9c'
let s:Name_2_RGB['gray62'] = '9e9e9e'
let s:Name_2_RGB['grey62'] = '9e9e9e'
let s:Name_2_RGB['gray63'] = 'a1a1a1'
let s:Name_2_RGB['grey63'] = 'a1a1a1'
let s:Name_2_RGB['gray64'] = 'a3a3a3'
let s:Name_2_RGB['grey64'] = 'a3a3a3'
let s:Name_2_RGB['gray65'] = 'a6a6a6'
let s:Name_2_RGB['grey65'] = 'a6a6a6'
let s:Name_2_RGB['gray66'] = 'a8a8a8'
let s:Name_2_RGB['grey66'] = 'a8a8a8'
let s:Name_2_RGB['gray67'] = 'ababab'
let s:Name_2_RGB['grey67'] = 'ababab'
let s:Name_2_RGB['gray68'] = 'adadad'
let s:Name_2_RGB['grey68'] = 'adadad'
let s:Name_2_RGB['gray69'] = 'b0b0b0'
let s:Name_2_RGB['grey69'] = 'b0b0b0'
let s:Name_2_RGB['gray70'] = 'b3b3b3'
let s:Name_2_RGB['grey70'] = 'b3b3b3'
let s:Name_2_RGB['gray71'] = 'b5b5b5'
let s:Name_2_RGB['grey71'] = 'b5b5b5'
let s:Name_2_RGB['gray72'] = 'b8b8b8'
let s:Name_2_RGB['grey72'] = 'b8b8b8'
let s:Name_2_RGB['gray73'] = 'bababa'
let s:Name_2_RGB['grey73'] = 'bababa'
let s:Name_2_RGB['gray74'] = 'bdbdbd'
let s:Name_2_RGB['grey74'] = 'bdbdbd'
let s:Name_2_RGB['gray75'] = 'bfbfbf'
let s:Name_2_RGB['grey75'] = 'bfbfbf'
let s:Name_2_RGB['gray76'] = 'c2c2c2'
let s:Name_2_RGB['grey76'] = 'c2c2c2'
let s:Name_2_RGB['gray77'] = 'c4c4c4'
let s:Name_2_RGB['grey77'] = 'c4c4c4'
let s:Name_2_RGB['gray78'] = 'c7c7c7'
let s:Name_2_RGB['grey78'] = 'c7c7c7'
let s:Name_2_RGB['gray79'] = 'c9c9c9'
let s:Name_2_RGB['grey79'] = 'c9c9c9'
let s:Name_2_RGB['gray80'] = 'cccccc'
let s:Name_2_RGB['grey80'] = 'cccccc'
let s:Name_2_RGB['gray81'] = 'cfcfcf'
let s:Name_2_RGB['grey81'] = 'cfcfcf'
let s:Name_2_RGB['gray82'] = 'd1d1d1'
let s:Name_2_RGB['grey82'] = 'd1d1d1'
let s:Name_2_RGB['gray83'] = 'd4d4d4'
let s:Name_2_RGB['grey83'] = 'd4d4d4'
let s:Name_2_RGB['gray84'] = 'd6d6d6'
let s:Name_2_RGB['grey84'] = 'd6d6d6'
let s:Name_2_RGB['gray85'] = 'd9d9d9'
let s:Name_2_RGB['grey85'] = 'd9d9d9'
let s:Name_2_RGB['gray86'] = 'dbdbdb'
let s:Name_2_RGB['grey86'] = 'dbdbdb'
let s:Name_2_RGB['gray87'] = 'dedede'
let s:Name_2_RGB['grey87'] = 'dedede'
let s:Name_2_RGB['gray88'] = 'e0e0e0'
let s:Name_2_RGB['grey88'] = 'e0e0e0'
let s:Name_2_RGB['gray89'] = 'e3e3e3'
let s:Name_2_RGB['grey89'] = 'e3e3e3'
let s:Name_2_RGB['gray90'] = 'e5e5e5'
let s:Name_2_RGB['grey90'] = 'e5e5e5'
let s:Name_2_RGB['gray91'] = 'e8e8e8'
let s:Name_2_RGB['grey91'] = 'e8e8e8'
let s:Name_2_RGB['gray92'] = 'ebebeb'
let s:Name_2_RGB['grey92'] = 'ebebeb'
let s:Name_2_RGB['gray93'] = 'ededed'
let s:Name_2_RGB['grey93'] = 'ededed'
let s:Name_2_RGB['gray94'] = 'f0f0f0'
let s:Name_2_RGB['grey94'] = 'f0f0f0'
let s:Name_2_RGB['gray95'] = 'f2f2f2'
let s:Name_2_RGB['grey95'] = 'f2f2f2'
let s:Name_2_RGB['gray96'] = 'f5f5f5'
let s:Name_2_RGB['grey96'] = 'f5f5f5'
let s:Name_2_RGB['gray97'] = 'f7f7f7'
let s:Name_2_RGB['grey97'] = 'f7f7f7'
let s:Name_2_RGB['gray98'] = 'fafafa'
let s:Name_2_RGB['grey98'] = 'fafafa'
let s:Name_2_RGB['gray99'] = 'fcfcfc'
let s:Name_2_RGB['grey99'] = 'fcfcfc'
let s:Name_2_RGB['gray100'] = 'ffffff'
let s:Name_2_RGB['grey100'] = 'ffffff'
let s:Name_2_RGB['dark grey'] = 'a9a9a9'
let s:Name_2_RGB['DarkGrey'] = 'a9a9a9'
let s:Name_2_RGB['darkgrey'] = 'a9a9a9'
let s:Name_2_RGB['dark gray'] = 'a9a9a9'
let s:Name_2_RGB['DarkGray'] = 'a9a9a9'
let s:Name_2_RGB['darkgray'] = 'a9a9a9'
let s:Name_2_RGB['dark blue'] = '00008b'
let s:Name_2_RGB['DarkBlue'] = '00008b'
let s:Name_2_RGB['darkblue'] = '00008b'
let s:Name_2_RGB['dark cyan'] = '008b8b'
let s:Name_2_RGB['DarkCyan'] = '008b8b'
let s:Name_2_RGB['darkcyan'] = '008b8b'
let s:Name_2_RGB['dark magenta'] = '8b008b'
let s:Name_2_RGB['DarkMagenta'] = '8b008b'
let s:Name_2_RGB['darkmagenta'] = '8b008b'
let s:Name_2_RGB['dark red'] = '8b0000'
let s:Name_2_RGB['DarkRed'] = '8b0000'
let s:Name_2_RGB['darkred'] = '8b0000'
let s:Name_2_RGB['light green'] = '90ee90'
let s:Name_2_RGB['LightGreen'] = '90ee90'
let s:Name_2_RGB['lightgreen'] = '90ee90'

" return [0, -] or [1, rrggbb ]
function! vimside#color#util#ConvertName_2_RGB(name) 
  let namelc = tolower(a:name)
  if has_key(s:Name_2_RGB, namelc)
    return [1, s:Name_2_RGB[namelc]]
  else
    return [0, ""]
  endif
endfunction

" ------------------------------------------------------------ 
" ParseHighlight: {{{2
" ------------------------------------------------------------ 
" return [0, ""] or [1, dic]
function! vimside#color#util#ParseHighlight(hi) 
  let l:parts = split(a:hi)
  if empty(l:parts)
    return [0, "Empty highlights"]
  else
    let l:dic = {}
    for l:part in l:parts
      let l:arg = split(l:part, "=")
      if len(l:arg) != 2
        return [0, "Bad highlight part: ". string(l:part)]
      endif
      let [l:key, l:value] = l:arg
      let l:dic[l:key] = l:value
    endfor

    return [1, l:dic]
  endif
endfunction

" ------------------------------------------------------------ 
" AdjustHighlightArgs: {{{2
" ------------------------------------------------------------ 
" return error string or "" and modifies dic parameter
function! vimside#color#util#AdjustHighlightArgs(dic) 
  let l:errorStr = ""
  for [l:key, l:value] in items(a:dic)
    if l:key == "term"
      let l:parts = split(l:value, ",")
      let l:errorStr .= vimside#color#util#CheckHighlightAttrList(l:parts) 

    elseif l:key == "cterm"
      let l:parts = split(l:value, ",")
      let l:errorStr .= vimside#color#util#CheckHighlightAttrList(l:parts) 

    elseif l:key == "ctermfg"
      let [l:n, l:es] = vimside#color#util#GetHighlightCTermNumber(l:value) 
      let a:dic[l:key] = l:n
      let l:errorStr .= l:es

    elseif l:key == "ctermbg"
      let [l:n, l:es] = vimside#color#util#GetHighlightCTermNumber(l:value) 
      let a:dic[l:key] = l:n
      let l:errorStr .= l:es

    elseif l:key == "gui"
      let l:parts = split(l:value, ",")
      let l:errorStr .= vimside#color#util#CheckHighlightAttrList(l:parts) 

    elseif l:key == "guifg"
      " TODO not checked yet
      
    elseif l:key == "guibg"
      " TODO not checked yet
      
    else
      echo "Not supported: ". l:key
    endif
    unlet l:value
  endfor
  return l:errorStr
endfunction

" ------------------------------------------------------------ 
" GetHighlightCTermNumber: {{{2
" ------------------------------------------------------------ 
" return []
function! vimside#color#util#GetHighlightCTermNumber(value) 
  let l:errorStr = ""
  if a:value[0] == "#"
    let l:rgb = a:value[1:]
  else
    let [l:found, l:rgb] = vimside#color#util#ConvertName_2_RGB(a:value)
    if ! l:found
      let l:errorStr .= "Bad color name: '". a:value ."'"
      let l:rgb = "90ee90"
    endif
  endif
  return [ vimside#color#term#ConvertRGBTxt_2_Int(l:rgb), l:errorStr ]
endfunction

" ------------------------------------------------------------ 
" CheckHighlightAttrList: {{{2
" ------------------------------------------------------------ 
" return []
function! vimside#color#util#CheckHighlightAttrList(parts) 
  let l:errorStr = ""
  for l:part in a:parts
    if l:part != 'bold' && 
          \ l:part != 'underline' &&
          \ l:part != 'undercurl' &&
          \ l:part != 'reverse' &&
          \ l:part != 'inverse' &&
          \ l:part != 'italic' &&
          \ l:part != 'standout' &&
          \ l:part != 'NONE' 
      let l:errorStr .= "Error: unrecogninzed attr=". l:part
    endif
  return l:errorStr
endfunction

function! vimside#color#util#GetCurrentHighlight(group)
  if hlexists(a:group)
    redir => l:current_highlight
    execute "silent hi ". a:group
    redir END

    return strpart(l:current_highlight, 20);
  else
    return ""
  endif
endfunction


function! vimside#color#util#DoHighlightTest() 
  let hi="term=bold,underline cterm=NONE ctermfg=Red ctermbg=#334455 guifg=#001100 guibg=#330033"

  let [ok, dic] = vimside#color#util#ParseHighlight(hi) 
  echo string(dic)
  echo vimside#color#util#AdjustHighlightArgs(dic) 
  echo string(dic)
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
