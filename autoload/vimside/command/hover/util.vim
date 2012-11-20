
function! vimside#command#hover#util#GetHoverText(dic)
  let dic = a:dic
  if vimside#util#IsDictionary(dic)
    if has_key(dic, ":type")
      let tdic = dic[':type']
      if has_key(tdic, ":arrow-type") && tdic[':arrow-type'] 
        let name = dic[':name']
        let tname = tdic[':name']
          return name . tname
      else
        if has_key(tdic, ":full-name")
          let tname = tdic[':name']
          let tfullname = tdic[':full-name']
          if tfullname !~ '<none>.*'
            return tfullname
          else
            return tname
          endif
        endif
      endif
    endif
    return ''
  else
    return ''
  endif
endfunction

