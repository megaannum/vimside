" ============================================================================
" This file, example_options_project.vim will NOT be read by the Vimside 
" code. 
"
" This is a mechanism for having project-specific Vimside Option values.
" By default, the Option: 'vimside-project-options-enabled' is 1 (true).
"   This controls if Vimside attempts to locate and load a project-
"   specific Optiosn file.
"
" To adjust option values on a per-project basis: 
"   copy this file to a project directory, 
"   call the file the value of the Option:
"     'vimside-project-options-file-name'
"   which, by default, has the value: 'options_project.vim'
"   and add Option setter calls, e.g.:
"    call owner.Set("vimside-scala-version", "2.10.0")
"    call owner.Set("ensime-dist-dir", "ensime_2.10.0-0.9.8.9")
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

  " call owner.Set("ensime-log-enabled", 1)
  " call owner.Set("vimside-log-enabled", 1)

  " call owner.Update("vimside-scala-version", "2.10.0")
  " call owner.Update("ensime-dist-dir", "ensime_2.10.0-0.9.8.9")
  " call owner.Update("ensime-config-file-name", "_ensime")

  " call owner.Set("forms-use", 1)

  " To use command line hover, disable (0) both
  " To use GVim hover, enable (1) balloon
  " To use Vim term hover, enable (1) term-balloon
  " call owner.Set("vimside-hover-balloon-enabled", 0)
  " call owner.Set("vimside-hover-term-balloon-enabled", 0)

endfunction

