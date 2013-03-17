"---------------------------
" test string
"---------------------------

call vimtap#SetOutputFile('test003.tap')
call vimtap#Plan(12)


let exp = "Some String"
let v = vimside#sexp#Make_String(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToString("'.exp.'")', 'StringAtom ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'"'.exp.'"','vimside#sexp#ToReadableString("'.exp.'")', 'StringAtom ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'"'.exp.'"','vimside#sexp#ToWireString("'.exp.'")', 'StringAtom ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim("'.exp.'")', 'StringAtom ToVim')
unlet got

let exp = 'A \x "second" String'
let v = vimside#sexp#Make_String(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToString("'.exp.'")', 'StringAtom ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'"A \x "second" String"','vimside#sexp#ToReadableString("'.exp.'")', 'StringAtom ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'"A \x "second" String"','vimside#sexp#ToWireString("'.exp.'")', 'StringAtom ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim("'.exp.'")', 'StringAtom ToVim')
unlet got


let in = '("hi")'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'string ("hi") ToWireString')

let in = '("hi" "Bye")'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'string ("hi") ToWireString')

let in = '("hi \"Bye\" ok")'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'string ("hi") ToWireString')

let in = '("hi" ("Bye") "ok")'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'string ("hi") ToWireString')

call vimtap#FlushOutput()
quit!
