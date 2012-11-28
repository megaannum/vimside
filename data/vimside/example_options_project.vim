" ============================================================================
" This file, example_options_project.vim will NOT be read by the Vimside 
" code. 
" To adjust option values, copy this file to a project directory,
" call the file the value of the Option:
" 'vimside-project-options-user-file-name'
" and add Option setter calls, e.g.:
"    call owner.Set("vimside-scala-version", "2.10.0")
"    call owner.Set("ensime-dist-dir", "ensime_2.10.0-SNAPSHOT-0.9.7")
"    call owner.Set("ensime-config-file-name", "_ensime")
" These Option values will be used to configure Vimside and can be
" project specific
" ============================================================================

" full path to this file
let s:full_path=expand('<sfile>:p')

" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')

function! g:VimsideOptionsProjectLoad(owner)
  let owner = a:owner

  " call owner.Update("vimside-scala-version", "2.10.0")
  " call owner.Update("ensime-dist-dir", "ensime_2.10.0-SNAPSHOT-0.9.7")
  " call owner.Update("ensime-config-file-name", "_ensime")

endfunction

