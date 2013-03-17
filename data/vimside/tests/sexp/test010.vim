"---------------------------
" test swank protocol
"---------------------------

call vimtap#SetOutputFile('test010.tap')
call vimtap#Plan(1)

let in = '(:root-dir "/home/emberson/.vim/data/vimside" :name "test" :package "com.megaannum" :version 1 :compile-jars ("/home/emberson/scala/scala-2.10.0-M7/lib/scala-library.jar" "/home/emberson/scala/scala-2.10.0-M7/lib/scala-compiler.jar" "/home/emberson/.vim/data/vimside/build/classes") :compiler-args ("-Ywarn-dead-code") :disable-index-on-startup nil :source-roots ("/home/emberson/.vim/data/vimside/src/main/java" "/home/emberson/.vim/data/vimside/src/main/scala") :reference-source-roots ("/usr/local/java/src" "/home/emberson/scala/scala-2.10.0-M7/src/library" "/home/emberson/scala/scala-2.10.0-M7/src/compiler") :target "/home/emberson/.vim/data/vimside/build/classes" :only-include-in-index ("com\\.megaannum\\.\*") :exclude-from-index ("com\\.megaannum\\.core\\.xmlconfig\\.compiler\\*"))'

let sexp = vimside#sexp#Parse(in)
let [ok, v] = vimside#sexp#Convert_KeywordValueList2Dictionary(sexp)

" echo "v=" . string(v)

call vimtap#Is("","",'vimside#sexp#ToWireString(1)', 'envime file ToWireString')
" call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'envime file ToWireString')

call vimtap#FlushOutput()
quit!
