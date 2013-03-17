"---------------------------
" test symbol
"---------------------------

call vimtap#SetOutputFile('test004.tap')
call vimtap#Plan(11)


let exp = "aSymbol"
let v = vimside#sexp#Make_Symbol(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToString("'.exp.'")', 'SymbolAtom ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToReadableString("'.exp.'")', 'SymbolAtom ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToWireString("'.exp.'")', 'SymbolAtom ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim("'.exp.'")', 'SymbolAtom ToVim')
unlet got

let exp = 'symbol-33'
let v = vimside#sexp#Make_Symbol(exp)
let s = vimside#sexp#ToString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToString("'.exp.'")', 'SymbolAtom ToString')
let s = vimside#sexp#ToReadableString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToReadableString("'.exp.'")', 'SymbolAtom ToReadableString')
let s = vimside#sexp#ToWireString(v)
call vimtap#Is(s,exp,'vimside#sexp#ToWireString("'.exp.'")', 'SymbolAtom ToWireString')
let got = vimside#sexp#ToVim(v)
call vimtap#Is(got,exp,'vimside#sexp#ToVim("'.exp.'")', 'SymbolAtom ToVim')
unlet got

let in = '(aSymbol)'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'SymbolAtom (aSymbol) ToWireString')

let in = '(aSymbol s2 s-2:3)'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,in,'vimside#sexp#ToWireString(1)', 'SymbolAtom (aSymbol) ToWireString')

let in = '((aSymbol xx) s2 (s-2:3   yy))'
let out = '((aSymbol xx) s2 (s-2:3 yy))'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'SymbolAtom (aSymbol) ToWireString')

call vimtap#FlushOutput()
quit!
