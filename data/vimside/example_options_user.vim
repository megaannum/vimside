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

function! g:VimsideOptionsUserLoad(option)
   call a:option.Set("test-ensime-file-dir", s:full_dir)
   call a:option.Set("ensime-log-enabled", 1)
   call a:option.Set("vimside-log-enabled", 1)

   " call a:option.Set("use-cwd-as-default-output-dir", 1)
   
   " uncomment to run against demonstration test code
   " call a:option.Set("test-ensime-file-use", 1)
   
   " The Ensime Config  information is in a file called '_ensime'
   " call a:option.Set("ensime-config-file-name", "_ensime")
   
   " The Ensime Config  information is in a file called 'ensime_config.vim'
   " call a:option.Set("ensime-config-file-name", "ensime_config.vim")
   
   
   " Vimside uses Forms library 
   " call a:option.Set("vimside-forms-use", 1)
   

   " call a:option.Set("swank-rpc-symbol-at-point-location-same-file", "same_window.vim")
   " call a:option.Set("swank-rpc-symbol-at-point-location-same-file", "split_window.vim")
   " call a:option.Set("swank-rpc-symbol-at-point-location-same-file", "vsplit_window.vim")
   
   " call a:option.Set("swank-rpc-symbol-at-point-location-diff-file", "same_window.vim")
   " call a:option.Set("swank-rpc-symbol-at-point-location-diff-file", "split_window.vim")
   " call a:option.Set("swank-rpc-symbol-at-point-location-diff-file", "vsplit_window.vim")
   " call a:option.Set("swank-rpc-symbol-at-point-location-diff-file", "tab")
   
   
   " call a:option.Set("swank-rpc-uses-of-symbol-at-point-location", "same_window")
   " call a:option.Set("swank-rpc-uses-of-symbol-at-point-location", "split_window")
   " call a:option.Set("swank-rpc-uses-of-symbol-at-point-location", "vsplit_window")
   " call a:option.Set("swank-rpc-uses-of-symbol-at-point-location", "tab")
   
   " call a:option.Set("swank-rpc-repl-config-location", "same_window")
   " call a:option.Set("swank-rpc-repl-config-location", "split_window")
   " call a:option.Set("swank-rpc-repl-config-location", "vsplit_window")
   " call a:option.Set("swank-rpc-repl-config-location", "tab")
endfunction

