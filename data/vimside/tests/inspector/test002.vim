"---------------------------
" test boolean
"---------------------------

call vimtap#SetOutputFile('test002.tap')
call vimtap#Plan(8)

let qgot = ""
let description = "inspector#with_name_parts"



let str = "java.util.List"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['java.util', 'List']"  
call vimtap#Is(got, exp, qgot, description)
     
let str = "scala.tools.nsc.symtab.Types$Type"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['scala.tools.nsc.symtab', 'Types$Type']"
call vimtap#Is(got, exp, qgot, description)
 
let str = "scala.tools.nsc.symtab.Types"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['scala.tools.nsc.symtab', 'Types']"
call vimtap#Is(got, exp, qgot, description)

let str = "scala.tools.nsc.symtab.Types$Dude$AbsType"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['scala.tools.nsc.symtab', 'Types$Dude$AbsType']"
call vimtap#Is(got, exp, qgot, description)
    

let str = "scala.tools.nsc.symtab.Types$$Type$"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['scala.tools.nsc.symtab', 'Types$$Type$']"
call vimtap#Is(got, exp, qgot, description)
     
let str = "Types$$Type$"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['', 'Types$$Type$']"
call vimtap#Is(got, exp, qgot, description)

let str = "java.uti"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['java', 'uti']"
call vimtap#Is(got, exp, qgot, description)

let str = "uti"
let got = string(vimside#command#inspector#with_path_and_name(str))
let exp = "['', 'uti']"
call vimtap#Is(got, exp, qgot, description)

call vimtap#FlushOutput()
quit!

