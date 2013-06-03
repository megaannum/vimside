" ============================================================================
" scala_notes.vim
"
" File:          vimside#swank#event#scala_notes.vim
" Summary:       Vimside Event scala-notes
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! vimside#swank#event#scala_notes#Handle(...)
  if a:0 != 1
    call s:ERROR("scala_notes#Handle Bad =". string(a:000)) 
    return
  endif
call s:LOG("scala_notes#Handle=". string(a:1)) 
  let [ok, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:1) 
  if !ok
    call s:ERROR("scala_notes#Handle failure to list dict: ". dic) 
    return
  endif

  let is_full = dic[':is-full']
  let notelist = dic[':notes']

  " Quickfix 
  " {
  "   'filename': ''
  "   'lnum': 4
  "   'pattern' : not needed if lnum is present
  "   'col': 4      optional
  "   'text': line      optional
  "   'kind': severity
  "   'vcol': 1      optional
  "   'type': 'a'      optional 'a' add, 'r' replace
  "   'nr': 1      optional
  " }
  for note in notelist
    let severity = note[':severity']
    let msg = note[':msg']
    let file = note[':file']
    let line = note[':line']
    let col = note[':col']
    let nr = len(g:vimside.project.scala_notes)+1

    let snote = {
      \ 'filename': file,
      \ 'lnum': line,
      \ 'col': col,
      \ 'text': severity .": ". msg,
      \ 'kind': severity,
      \ 'vcol': 1,
      \ 'type': 'a',
      \ 'nr': nr,
      \ }
    call add(g:vimside.project.scala_notes, snote)
  endfor

  let no_java_notes = empty(g:vimside.project.java_notes) 
  let no_scala_notes = empty(g:vimside.project.scala_notes)
  if ! no_scala_notes || ! no_java_notes 
    let msg = "Scala/Java errors and warnings"
    call vimside#cmdline#Display(msg)
  endif

endfunction
