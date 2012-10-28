"---------------------------
" test swank protocol
"---------------------------

source ../autoload/vimside/sexp.vim

call vimtap#SetOutputFile('test009.tap')
call vimtap#Plan(1)

let file = "ensime_config.vim"
let sexp = vimside#sexp#LoadFile(file)
let s = vimside#sexp#ToWireString(sexp)

let out = "(:root-dir \"/home/emberson/.vim/vimside/test\" :name \"test\" :package \"com.megaannum.vimside\" :version 1 :compile-jar (\"/home/emberson/scala/scala-2.10.0-M6/lib/scala-library.jar\" \"/home/emberson/scala/scala-2.10.0-M6/lib/scala-compiler.jar\" \"/home/emberson/.vim/vimside/test/build/classes\") :sources (\"/home/emberson/.vim/vimside/testsrc/main/java\" \"/home/emberson/.vim/vimside/testsrc/main/scala\") :target \"/home/emberson/.vim/vimside/test/build/classes\" :only-include-in-index (\"com\\.megaannum\\.*\"))"


call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'envime file ToWireString')

call vimtap#FlushOutput()
quit!
