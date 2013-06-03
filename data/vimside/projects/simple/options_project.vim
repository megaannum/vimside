
" full path to this file
let s:full_path=expand('<sfile>:p')

" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')

function! g:VimsideOptionsProjectLoad(owner)
  let owner = a:owner

  "--------------
  " Enable logging
  call owner.Set("ensime-log-enabled", 1)
  call owner.Set("vimside-log-enabled", 1)
  "--------------

  "--------------
  " Defined Java versions: '1.5', '1.6', '1.7'
  " Defined Scala versions: '2.9.2', '2.10.0'
  " Minor version numbers not needed
  " Scala version MUST match 'ensime-dist-dir' used.
  call owner.Set("vimside-java-version", "1.7")
  call owner.Set("vimside-scala-version", "2.10.0")
  "--------------
  
  "--------------
  " Which build version of Ensime to use. 
  call owner.Set("ensime-dist-dir", "ensime_2.10.0-0.9.8.9")
  "--------------

  "--------------
  " The Ensime Config information is in a file called 'ensime_config.vim'
  call owner.Set("ensime-config-file-name", "ensime_config.vim")
  "--------------

  "--------------
  " Vimside uses Forms library 
  call owner.Set("forms-use", 1)
  "--------------

  "--------------
  " Hover Options
  call owner.Set("vimside-hover-balloon-enabled", 0)
  call owner.Set("vimside-hover-term-balloon-enabled", 0)
  "--------------
endfunction
