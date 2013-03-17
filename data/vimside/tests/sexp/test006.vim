"---------------------------
" test list
"---------------------------

call vimtap#SetOutputFile('test006.tap')
call vimtap#Plan(8)


let i = 5
let ia = vimside#sexp#Make_Int(i)
let v = vimside#sexp#Make_List([ia])
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'(5)','vimside#sexp#ToString(0)', 'list [5] ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'(5)','vimside#sexp#ToReadableString(0)', 'list [5] ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'(5)','vimside#sexp#ToWireString(0)', 'list [5] ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,"(5)",'vimside#sexp#ToVim(0)', 'list [5] ToVim')
unlet got

let i = 5
let ia = vimside#sexp#Make_Int(i)
let s = "Hi there"
let sa = vimside#sexp#Make_String(s)

let v = vimside#sexp#Make_List([ia, sa])
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,'(5 Hi there)','vimside#sexp#ToString(1)', 'list [5, "Hi there"] ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,'(5 "Hi there")','vimside#sexp#ToReadableString(1)', 'list [5, "Hi there"] ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,'(5 "Hi there")','vimside#sexp#ToWireString(1)', 'list [5, "Hi there"] ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,'(5 Hi there)','vimside#sexp#ToVim(1)', 'list [5, "Hi there"] ToVim')
unlet got

call vimtap#FlushOutput()
quit!
