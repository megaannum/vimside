"---------------------------
" test swank protocol
"---------------------------

call vimtap#SetOutputFile('test008.tap')
call vimtap#Plan(1)

let file = "ensime"
let sexp = vimside#sexp#ParseFile(file)
let s = vimside#sexp#ToWireString(sexp)

let out = '(:root-dir "/home/emberson/MEGAANNUM/scala/core" :name "core" :package "com.megaannum.core" :version "$component.version" :compile-jars ("/home/emberson/scala/scala-2.10.0-M7/lib/scala-library.jar" "/home/emberson/scala/scala-2.10.0-M7/lib/scala-compiler.jar" "/home/emberson/MEGAANNUM/scala/core/build/classes") :sources ("/home/emberson/MEGAANNUM/scala/core/src/main/java" "/home/emberson/MEGAANNUM/scala/core/src/main/scala") :target "/home/emberson/MEGAANNUM/scala/core/build/classes" :disable-index-on-startup nil :only-include-in-index ("com\\.megaannum\\.\*") :exclude-from-index ("com\\.megaannum\\.core\\.xmlconfig\\.compiler\*") :compiler-args ("-Ywarn-dead-code") :formatting-prefs (:alignParameters t :alignSingleLineCaseStatements nil :alignSingleLineCaseStatements_maxArrowIndent 20 :compactControlReadability t :compactStringConcatenation t :doubleIndentClassDeclaration t :indentLocalDefs nil :indentPackageBlocks nil :indentSpaces 2 :indentWithTabs nil :multilineScaladocCommentsStartOnFirstLine nil :preserveDanglingCloseParenthesis t :placeScaladocAsterisksBeneathSecondAsterisk nil :preserveSpaceBeforeArguments nil :rewriteArrowSymbols nil :spaceBeforeColon nil :spaceInsideBrackets nil :spaceInsideParentheses nil :spacesWithinPatternBinders t))'

call vimtap#Is(s,out,'vimside#sexp#ToWireString(1)', 'envime file ToWireString')

call vimtap#FlushOutput()
quit!
