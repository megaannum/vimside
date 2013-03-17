"---------------------------
" test swank protocol
"---------------------------

call vimtap#SetOutputFile('test007.tap')
call vimtap#Plan(112)


let in =  "(:swank-rpc \n (swank:connection-info) 1)"
let out = "(:swank-rpc (swank:connection-info) 1)"
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')

let in = "(:return
          \ (:ok
          \ (:pid nil :server-implementation
          \   (:name \"ENSIMEserver\")
          \     :machine nil :features nil :version \"0.0.1\")) 1)"
let out = '(:return (:ok (:pid nil :server-implementation (:name "ENSIMEserver") :machine nil :features nil :version "0.0.1")) 1)'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')

let in = '(:swank-rpc
      \ (swank:init-project
      \ (:package "org.ensime" :root-dir "/home/aemon/src/misc/ensime/")) 2)'
let out = '(:swank-rpc (swank:init-project (:package "org.ensime" :root-dir "/home/aemon/src/misc/ensime/")) 2)'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')

let in = '(:return
          \ (:ok
          \  (:name "ensime" :source-roots
          \    ("/home/aemon/src/misc/ensime/src/main/scala" 
          \     "/home/aemon/src/misc/ensime/src/main/java" 
          \     "/home/aemon/src/misc/ensime/src/test/scala"))) 2)'
let out = '(:return (:ok (:name "ensime" :source-roots ("/home/aemon/src/misc/ensime/src/main/scala" "/home/aemon/src/misc/ensime/src/main/java" "/home/aemon/src/misc/ensime/src/test/scala"))) 2)' 
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')

let in = '(:background-message "Initializing Analyzer. Please wait...")'
let out = '(:background-message "Initializing Analyzer. Please wait...")'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')

let in = '(:compiler-ready t)'
let out = '(:compiler-ready t)'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')

let in = '(:typecheck-result
              \ (:lang :scala :is-full t :notes nil))'
let out = '(:typecheck-result (:lang :scala :is-full t :notes nil))'
let sexp = vimside#sexp#Parse(in)
let s = vimside#sexp#ToWireString(sexp)
call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')


let inputs = [
  \ '(:swank-rpc (swank:connection-info) 42)',
  \ '(:return (:ok (:pid nil :implementation (:name "ENSIME - Reference Server") :version "0.7")) 42)',
  \ '(:swank-rpc (swank:init-project (:use-sbt t :compiler-args (-Ywarn-dead-code -Ywarn-catches -Xstrict-warnings) :root-dir /Users/aemon/projects/ensime/)) 42)',
  \ '(:return (:ok (:project-name "ensime" :source-roots ("/Users/aemon/projects/ensime/src/main/scala" "/Users/aemon/projects/ensime/src/test/scala" "/Users/aemon/projects/ensime/src/main/java"))) 42)',
  \ '(:swank-rpc (swank:peek-undo) 42)',
  \ '(:return (:ok (:id 1 :changes ((:file "/ensime/src/main/scala/org/ensime/server/RPCTarget.scala" :text "rpcInitProject" :from 2280 :to 2284)) :summary "Refactoring of type: rename") 42)',
  \ '(:swank-rpc (swank:exec-undo 1) 42)',
  \ '(:return (:ok (:id 1 :touched-files ("/src/main/scala/org/ensime/server/RPCTarget.scala"))) 42)',
  \ '(:swank-rpc (swank:repl-config) 42)',
  \ '(:return (:ok (:classpath "lib1.jar:lib2.jar:lib3.jar")) 42)',
  \ '(:swank-rpc (swank:builder-init) 42)',
  \ '(:return (:ok ()) 42)',
  \ '(:swank-rpc (swank:builder-update-files ("/ensime/src/main/scala/org/ensime/server/Analyzer.scala")) 42)',
  \ '(:return (:ok ()) 42)',
  \ '(:swank-rpc (swank:builder-add-files ("/ensime/src/main/scala/org/ensime/server/Analyzer.scala")) 42)',
  \ '(:return (:ok ()) 42)',
  \ '(:swank-rpc (swank:builder-remove-files ("/ensime/src/main/scala/org/ensime/server/Analyzer.scala")) 42)',
  \ '(:swank-rpc (swank:typecheck-file "Analyzer.scala") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:typecheck-files ("Analyzer.scala")) 42)',
  \ '(:return (:ok t) 42)',
  \ '(swank:patch-source "Analyzer.scala" (("+" 6461 "Inc") ("-" 7127 7128)))',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:typecheck-all) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:format-source ("/ensime/src/Test.scala")) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:public-symbol-search ("java" "io" "File") 50) 42)',
  \ '(:return (:ok ((:name "java.io.File" :local-name "File" :decl-as class :pos (:file "/Classes/classes.jar" :offset -1))) 42)',
  \ '(:swank-rpc (swank:import-suggestions "/ensime/src/main/scala/org/ensime/server/Analyzer.scala" 2300 (Actor) 10) 42)',
  \ '(:return (:ok (((:name "scala.actors.Actor" :local-name "Actor" :decl-as trait :pos (:file "/lib/scala-library.jar" :offset -1))))) 42)',
  \ '(:swank-rpc (swank:completions "/ensime/src/main/scala/org/ensime/protocol/SwankProtocol.scala 22626 0 t) 42)',
  \ '(:return (:ok (:prefix "form" :completions ((:name "form" :type-sig "SExp" :type-id 10) (:name "format" :type-sig "(String, <repeated>[Any]) => String" :type-id 11 :is-callable t))) 42))',
  \ '(:swank-rpc (swank:package-member-completion org.ensime.server Server) 42)',
  \ '(:return (:ok ((:name "Server$") (:name "Server"))) 42)',
  \ '(:swank-rpc (swank:call-completion 1)) 42)',
  \ '(:return (:ok (:result-type (:name "Unit" :type-id 7 :full-name "scala.Unit" :decl-as class) :param-sections ((:params (("id" (:name "Int" :type-id 74 :full-name "scala.Int" :decl-as class)) ("callId" (:name "Int" :type-id 74 :full-name "scala.Int" :decl-as class))))))) 42)',
  \ '(:swank-rpc (swank:uses-of-symbol-at-point "Test.scala" 11334) 42)',
  \ '(:return (:ok ((:file "RichPresentationCompiler.scala" :offset 11442 :start 11428 :end 11849) (:file "RichPresentationCompiler.scala" :offset 11319 :start 11319 :end 11339))) 42)',
  \ '(:swank-rpc (swank:type-by-id 1381) 42)',
  \ '(:return (:ok (:name "Option" :type-id 1381 :full-name "scala.Option" :decl-as class :type-args ((:name "Int" :type-id 1129 :full-name "scala.Int" :decl-as class)))) 42)',
  \ '(:swank-rpc (swank:type-by-name "java.lang.String") 42)',
  \ '(:return (:ok (:name "String" :type-id 1188 :full-name "java.lang.String" :decl-as class)) 42)',
  \ '(:swank-rpc (swank:type-by-name-at-point "String" "SwankProtocol.scala" 31680) 42)',
  \ '(:return (:ok (:name "String" :type-id 1188 :full-name "java.lang.String" :decl-as class)) 42)',
  \ '(:swank-rpc (swank:type-at-point "SwankProtocol.scala" 32736) 42)',
  \ '(:return (:ok (:name "String" :type-id 1188 :full-name "java.lang.String" :decl-as class)) 42)',
  \ '(:swank-rpc (swank:inspect-type-at-point "SwankProtocol.scala" 32736) 42)',
  \ '(:return (:ok (:type (:name "SExpList$" :type-id 1469 :full-name "org.ensime.util.SExpList$" :decl-as object :pos (:file "SExp.scala" :offset 1877)))) 42)',
  \ '(:swank-rpc (swank:inspect-type-by-id 232) 42)',
  \ '(:return (:ok (:type (:name "SExpList$" :type-id 1469 :full-name "org.ensime.util.SExpList$" :decl-as object :pos (:file "SExp.scala" :offset 1877)))) 42)',
  \ '(:swank-rpc (swank:symbol-at-point "SwankProtocol.scala" 36483) 42)',
  \ '(:return (:ok (:name "file" :type (:name "String" :type-id 25 :full-name "java.lang.String" :decl-as class) :decl-pos (:file "SwankProtocol.scala" :offset 36404))) 42)',
  \ '(:swank-rpc (swank:inspect-package-by-path "org.ensime.util" 36483) 42)',
  \ '(:return (:ok (:name "util" :info-type package :full-name "org.ensime.util" :members ((:name "BooleanAtom" :type-id 278 :full-name "org.ensime.util.BooleanAtom" :decl-as class :pos (:file "SExp.scala" :offset 2848))))) 42)',
  \ '(:swank-rpc (swank:prepare-refactor 6 rename (file "SwankProtocol.scala" start 39504 end 39508 newName "dude") t) 42)',
  \ '(:return (:ok (:procedure-id 6 :refactor-type rename :status success :changes ((:file "SwankProtocol.scala" :text "dude" :from 39504 :to 39508)))) 42)',
  \ '(:swank-rpc (swank:exec-refactor 7 rename) 42)',
  \ '(:return (:ok (:procedure-id 7 :refactor-type rename :touched-files ("SwankProtocol.scala"))) 42)',
  \ '(:swank-rpc (swank:cancel-refactor 1) 42)',
  \ '(:return (:ok t))',
  \ '(:swank-rpc (swank:symbol-designations "SwankProtocol.scala" 0 46857 (var val varField valField)) 42)',
  \ '(:return (:ok (:file "SwankProtocol.scala" :syms ((varField 33625 33634) (val 33657 33661) (val 33663 33668) (varField 34369 34378) (val 34398 34400)))) 42)',
  \ '(:swank-rpc (swank:expand-selection "Model.scala" 4648 4721) 42)',
  \ '(:return (:ok (:file "Model.scala" :start 4374 :end 14085)) 42)',
  \ '(:swank-rpc (swank:method-bytecode "hello.scala" 12) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-active-vm) 42)',
  \ '(:return (:ok nil) 42)',
  \ '(:swank-rpc (swank:debug-start "org.hello.HelloWorld arg") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-attach "localhost" "9000") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-stop) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-set-break "hello.scala" 12) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-clear "hello.scala" 12) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-clear-all-breaks) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-list-breakpoints) 42)',
  \ '(:return ((:file "hello.scala" :line 1) (:file "hello.scala" :line 23)) 42)',
  \ '(:swank-rpc (swank:debug-run) 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-continue "1") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-step "982398123") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-next "982398123") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-step-out "982398123") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-locate-name "thread-2" "apple") 42)',
  \ '(:return (:ok (:slot :thread-id "thread-2" :frame 2 :offset 0)) 42)',
  \ '(:swank-rpc (swank:debug-value (:type element :object-id "23" :index 2)) 42)',
  \ '(:return (:ok (:val-type prim :summary "23" :type-name "Integer")) 42)',
  \ '(:swank-rpc (swank:debug-to-string (:type element :object-id "23" :index 2)) 42)',
  \ '(:return (:ok "A little lamb") 42)',
  \ '(:swank-rpc (swank:debug-set-stack-var (:type element :object-id "23" :index 2) "1") 42)',
  \ '(:return (:ok t) 42)',
  \ '(:swank-rpc (swank:debug-backtrace "23" 0 2) 42)',
  \ '(:return (:ok (:frames () :thread-id "23" :thread-name "main")) 42)',
  \ '(:swank-rpc (swank:shutdown-server) 42)',
  \ '(:return (:ok t) 42)'
  \ ]

for input in inputs 
  let out = input
  let sexp = vimside#sexp#Parse(in)
  let s = vimside#sexp#ToWireString(sexp)
  call vimtap#Is(input,out,'vimside#sexp#ToWireString(1)', 'swank protocol ToWireString')
endfor


call vimtap#FlushOutput()
quit!
