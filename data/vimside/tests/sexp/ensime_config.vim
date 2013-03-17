
" this file
" full path
" directory
" name
let s:full_path=expand('<sfile>:p')
let s:full_dir=fnamemodify(s:full_path, ':h')
let s:file_name=fnamemodify(s:full_path, ':t')

let s:scala_home = $SCALA_HOME
if s:scala_home == ''
  throw "SCALA_HOME not set in file " . s:full_path
endif

let s:compile_jars = g:SExp(
                     \ g:Str(s:scala_home . "lib/scala-library.jar"),
                     \ g:Str(s:scala_home . "lib/scala-compiler.jar"), 
                     \ g:Str(s:full_dir . "/build/classes")
                     \ )
let s:sources = g:SExp(
                \ g:Str(s:full_dir . "/src/main/java"),
                \ g:Str(s:full_dir . "/src/main/scala")
                \ )
let s:include_index = g:SExp(
                      \ g:Str("com\\.megaannum\\.\*")
                      \ )

let g:ensime_config = g:SExp([ 
  \ Key(":root-dir"), g:Str(s:full_dir),
  \ Key(":name"), g:Str("test"),
  \ Key(":package"), g:Str("com.megaannum.vimside"),
  \ Key(":version"), g:Int(1),
  \ Key(":compile-jar"), s:compile_jars,
  \ Key(":sources"), s:sources, 
  \ Key(":target"), g:Str(s:full_dir . "/build/classes"),
  \ Key(":only-include-in-index"), s:include_index
  \ ] )

