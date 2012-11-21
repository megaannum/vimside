" ============================================================================
" This file, example_options_user.vim will NOT be read by the Vimside 
" code. 
" To adjust option values, copy this file to 'options_user.vim' and 
" then make changes.
" ============================================================================

" full path to this file
let s:full_path=expand('<sfile>:p')

" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')

function! g:VimsideOptionsUserLoad(owner)
  let owner = a:owner

  "--------------
  " Enable logging
  call owner.Set("ensime-log-enabled", 1)
  call owner.Set("vimside-log-enabled", 1)
  "--------------

  "--------------
  " Where is Ensime installed
  " call owner.Set("ensime-install-path", $HOME . "/.vim/vim-addons/ensime")
  " call owner.Set("ensime-install-path", $HOME . "/vimfiles/vim-addons/ensime")

  " Which build version of Ensime to use. 
  " Must be directory under 'ensime-install-path' directory
  " call owner.Set("ensime-dist-dir", "ensime_2.9.2-0.9.8.1")
  " call owner.Set("ensime-dist-dir", "ensime_2.10.0-SNAPSHOT-0.9.7")

  " Or, full path to Ensime build version
  " call owner.Set("ensime-dist-path", "SOME_PATH_TO_ENSIME_BUILD_DIR")
  "--------------


  "--------------
  " To run against ensime test project code
  " Location of test directory
  " call owner.Set("test-ensime-file-dir", s:full_dir)
  " Uncomment to run against demonstration test code
  " call owner.Set("test-ensime-file-use", 1)
  " The Ensime Config information is in a file called 'ensime_config.vim'
  " call owner.Set("ensime-config-file-name", "ensime_config.vim")
  "--------------

  "--------------
  " To run against one of your own projects
  " The Ensime Config  information is in a file called '_ensime'
  "  Emacs Ensime calls the file '.ensime' - you can call it 
  "  whatever you want as long as you set its name here.
  " call owner.Set("ensime-config-file-name", "_ensime")
  "--------------
   
   
  "--------------
  " Vimside uses Forms library 
  " call owner.Set("vimside-forms-use", 1)
  "--------------
   
  " call owner.Set("swank-rpc-expand-selection-information", 'visual')

  " search options
  " call owner.Set("public-symbol-search-do-incremental", 0)
  " call owner.Set("public-symbol-search-close-empty-display", 1)
  

  " call owner.Set("swank-rpc-symbol-at-point-location-same-file", "same_window.vim")
  " call owner.Set("swank-rpc-symbol-at-point-location-same-file", "split_window.vim")
  " call owner.Set("swank-rpc-symbol-at-point-location-same-file", "vsplit_window.vim")
  
  " call owner.Set("swank-rpc-symbol-at-point-location-diff-file", "same_window.vim")
  " call owner.Set("swank-rpc-symbol-at-point-location-diff-file", "split_window.vim")
  " call owner.Set("swank-rpc-symbol-at-point-location-diff-file", "vsplit_window.vim")
  " call owner.Set("swank-rpc-symbol-at-point-location-diff-file", "tab")
  
   
  " call owner.Set("swank-rpc-uses-of-symbol-at-point-location", "same_window")
  " call owner.Set("swank-rpc-uses-of-symbol-at-point-location", "split_window")
  " call owner.Set("swank-rpc-uses-of-symbol-at-point-location", "vsplit_window")
  " call owner.Set("swank-rpc-uses-of-symbol-at-point-location", "tab")
  
  " call owner.Set("swank-rpc-repl-config-location", "same_window")
  " call owner.Set("swank-rpc-repl-config-location", "split_window")
  " call owner.Set("swank-rpc-repl-config-location", "vsplit_window")
  " call owner.Set("swank-rpc-repl-config-location", "tab")
endfunction

