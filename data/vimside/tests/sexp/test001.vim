"---------------------------
" test boolean
"---------------------------

call vimtap#SetOutputFile('test001.tap')
call vimtap#Plan(12)


let exp = 0
let v = vimside#sexp#Make_Boolean(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'nil','vimside#sexp#ToString(0)', 'boolean false ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'nil','vimside#sexp#ToReadableString(0)', 'boolean false ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'nil','vimside#sexp#ToWireString(0)', 'boolean false ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim(0)', 'boolean false ToVim')
unlet got

let exp = 1
let v = vimside#sexp#Make_Boolean(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'t','vimside#sexp#ToString(1)', 'boolean true ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'t','vimside#sexp#ToReadableString(1)', 'boolean true ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'t','vimside#sexp#ToWireString(1)', 'boolean true ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim(1)', 'boolean true ToVim')
unlet got

let in = "(t)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'boolean true ToWireString')

let in = "(nil)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'boolean true ToWireString')

let in = "(t nil)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'boolean true ToWireString')

let in = "(t nil t (nil t))"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'boolean true ToWireString')

call vimtap#FlushOutput()
quit!
