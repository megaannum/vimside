"---------------------------
" test keyword
"---------------------------

call vimtap#SetOutputFile('test005.tap')
call vimtap#Plan(10)


let exp = ":proc"
let v = vimside#sexp#Make_Keyword(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToString("'.exp.'")', 'KeywordAtom ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToReadableString("'.exp.'")', 'KeywordAtom ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToWireString("'.exp.'")', 'KeywordAtom ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim("'.exp.'")', 'KeywordAtom ToVim')
unlet got

let exp = ':val-r03'
let v = vimside#sexp#Make_Keyword(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToString("'.exp.'")', 'KeywordAtom ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToReadableString("'.exp.'")', 'KeywordAtom ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToWireString("'.exp.'")', 'KeywordAtom ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim("'.exp.'")', 'KeywordAtom ToVim')
unlet got

let in = "(:proc)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'KeywordAtom ToWireString')

let in = "(:proc :ff (:aa) :One1-2:3)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'KeywordAtom ToWireString')

call vimtap#FlushOutput()
quit!
