"---------------------------
" test int
"---------------------------

call vimtap#SetOutputFile('test002.tap')
call vimtap#Plan(19)


let exp = 0
let v = vimside#sexp#Make_Int(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'0','vimside#sexp#ToString(0)', 'int 0 ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'0','vimside#sexp#ToReadableString(0)', 'int 0 ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'0','vimside#sexp#ToWireString(0)', 'int 0 ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim(0)', 'int 0 ToVim')
unlet got

let exp = 1
let v = vimside#sexp#Make_Int(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'1','vimside#sexp#ToString(1)', 'int 1 ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'1','vimside#sexp#ToReadableString(1)', 'int 1 ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'1','vimside#sexp#ToWireString(1)', 'int 1 ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim(1)', 'int 1 ToVim')
unlet got

let exp = 7
let v = vimside#sexp#Make_Int(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'7','vimside#sexp#ToString(7)', 'int 7 ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'7','vimside#sexp#ToReadableString(7)', 'int 7 ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'7','vimside#sexp#ToWireString(7)', 'int 7 ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim(7)', 'int 7 ToVim')
unlet got

let exp = -11
let v = vimside#sexp#Make_Int(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'-11','vimside#sexp#ToString(-11)', 'int -11 ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'-11','vimside#sexp#ToReadableString(-11)', 'int -11 ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'-11','vimside#sexp#ToWireString(-11)', 'int -11 ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim(-11)', 'int -11 ToVim')
unlet got

let in = "(7)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'int 7 ToWireString')

let in = "(-7 42)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'int 7 ToWireString')

let in = "((6 6 6) -7 42)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'int 7 ToWireString')

call vimtap#FlushOutput()
quit!
