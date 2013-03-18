"---------------------------
" test boolean
"---------------------------

call vimtap#SetOutputFile('test001.tap')
call vimtap#Plan(5)

function! Write_to_file(file, lines)
  execute "redir >> " . a:file
  silent echo "("
  for line in a:lines
    silent echo line
  endfor
  silent echo ")"
  execute "redir END"
endfunction


let tempfile = tempname()
let tempdir = fnamemodify(tempfile, ":p:h")

let lines = [
      \ ':server-cmd "bin/server.sh"',
      \ ':dependendency-dirs ("hello" "world")'
    \ ]

call Write_to_file(tempfile, lines)
let [ok, sexp, dic] = vimside#EnsimeConfigLoad(tempfile)
" echo "ok=". ok
" echo "dic=". string(dic)


let got = ok
let exp = "1"
let qgot = ""
let description = "load ensime config file"
call vimtap#Is(got, exp, qgot, description)

let got = dic[":server-cmd"]
let exp = "bin/server.sh"
let qgot = ""
let description = "load ensime config file"
call vimtap#Is(got, exp, qgot, description)

let got = string(dic[":dependendency-dirs"])
let exp = "['hello', 'world']"
let qgot = ""
let description = "load ensime config file"
call vimtap#Is(got, exp, qgot, description)

let got = dic[":root-dir"]
let exp = tempdir
let qgot = ""
let description = "load ensime config file"
call vimtap#Is(got, exp, qgot, description)


unlet dic
unlet sexp


let tempfile = tempname()
let tempdir = fnamemodify(tempfile, ":p:h")

let lines = [
      \ 'adf sdafdfsdasfd'
    \ ]

call Write_to_file(tempfile, lines)
let [ok, sexp, dic] = vimside#EnsimeConfigLoad(tempfile)

let got = ok
let exp = "0"
let qgot = ""
let description = "load ensime config file"
call vimtap#Is(got, exp, qgot, description)



call vimtap#FlushOutput()
quit!

