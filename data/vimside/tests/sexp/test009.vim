"---------------------------
" test swank protocol
"---------------------------

call vimtap#SetOutputFile('test009.tap')
call vimtap#Plan(1)

let file = "ensime_config.vim"
let sexp = vimside#sexp#LoadFile(file)
let s = vimside#sexp#ToWireString(sexp)

let s:full_path=expand('<sfile>:p')
let s:full_dir=fnamemodify(s:full_path, ':h')
let s:scala_home = $SCALA_HOME
let out = "(:root-dir \"". s:full_dir ."\" :name \"test\" :package \"com.megaannum.vimside\" :version 1 :compile-jar (\"". s:scala_home ."lib/scala-library.jar\" \"". s:scala_home ."lib/scala-compiler.jar\" \"". s:full_dir ."/build/classes\") :sources (\"". s:full_dir ."/src/main/java\" \"". s:full_dir ."/src/main/scala\") :target \"". s:full_dir ."/build/classes\" :only-include-in-index (\"com\\.megaannum\\.*\"))"

call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'envime file ToWireString')

call vimtap#FlushOutput()
quit!
