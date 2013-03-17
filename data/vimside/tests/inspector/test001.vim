"---------------------------
" test boolean
"---------------------------

call vimtap#SetOutputFile('test001.tap')
call vimtap#Plan(7)

let str = "java.util.List"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['java.util', '', 'List']"
let qgot = ""
let description = "inspector#with_name_parts"
call vimtap#Is(got, exp, qgot, description)

let str = "java.util.List"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['java.util', '', 'List']"
call vimtap#Is(got, exp, qgot, description)

let str = "scala.tools.nsc.symtab.Types$Type"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['scala.tools.nsc.symtab', 'Types', 'Type']"
call vimtap#Is(got, exp, qgot, description)

let str = "scala.tools.nsc.symtab.Types"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['scala.tools.nsc.symtab', '', 'Types']"
call vimtap#Is(got, exp, qgot, description)

let str = "scala.tools.nsc.symtab.Types$Dude$AbsType"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['scala.tools.nsc.symtab', 'Types$Dude', 'AbsType']"
call vimtap#Is(got, exp, qgot, description)

let str = "scala.tools.nsc.symtab.Types$$Type$"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['scala.tools.nsc.symtab', 'Types$', 'Type$']"
call vimtap#Is(got, exp, qgot, description)

let str = "Types$$Type$"
let got = string(vimside#command#inspector#with_name_parts(str))
let exp = "['', 'Types$', 'Type$']"
call vimtap#Is(got, exp, qgot, description)

call vimtap#FlushOutput()
quit!

