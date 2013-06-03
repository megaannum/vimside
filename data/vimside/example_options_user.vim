" ============================================================================
" This file, example_options_user.vim will NOT be read by the Vimside 
" code. 
" To adjust option values, copy this file to a file called 'options_user.vim' 
"   in the same dirctory (or into a directory "data/vimside/" in the
"   runtime-path (see :runtimepath),
"   and then make changes. A file with this name will only be sourced once
"   even if it appears in multiple location, local directory and runtime path.
" ============================================================================

" full path to this file
let s:full_path=expand('<sfile>:p')

" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')

function! g:VimsideOptionsUserLoad(owner)
  let owner = a:owner

  "--------------
  " Enable logging
  " call owner.Set("ensime-log-enabled", 1)
  " call owner.Set("vimside-log-enabled", 1)
  "--------------

  "--------------
  " Output logs and ensime port file to local dir
  " If you start Vim is some project sub-directory, this will place
  " things in that directory (which may not be what you want).
  " call owner.Set("vimside-use-cwd-as-output-dir", 0)
  "--------------
  
  "--------------
  " Also load project specific options
  " call owner.Set("vimside-project-options-enabled", 1)
  " call owner.Set("vimside-project-options-file-name", "options_project.vim")
  "--------------

  "--------------
  " Defined Java versions: '1.5', '1.6', '1.7'
  " Defined Scala versions: '2.9.2', '2.10.0'
  " Minor version numbers not needed
  " Scala version MUST match 'ensime-dist-dir' used.
  " call owner.Set("vimside-java-version", "1.6")
  " call owner.Set("vimside-scala-version", "2.9.2")
  "--------------

  "--------------
  " Where is Ensime installed
  " call owner.Set("ensime-install-path", $HOME . "/.vim/vim-addons/ensime")
  " call owner.Set("ensime-install-path", $HOME . "/vimfiles/vim-addons/ensime")

  " Which build version of Ensime to use. 
  " Must be directory under 'ensime-install-path' directory
  " call owner.Set("ensime-dist-dir", "ensime_2.9.2-0.9.8.9")
  " call owner.Set("ensime-dist-dir", "ensime_2.10.0-0.9.8.9")

  " Or, full path to Ensime build version
  " call owner.Set("ensime-dist-path", "SOME_PATH_TO_ENSIME_BUILD_DIR")
  "--------------


  "--------------
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
  " call owner.Set("forms-use", 1)
  "--------------
   
  "--------------
  " Open source brower in its own tab
  " call owner.Set("tailor-forms-sourcebrowser-open-in-tab", 1)
  "--------------
   
  "--------------
  " Hover Options
  " call owner.Set("vimside-hover-balloon-enabled", 1)
  " call owner.Set("vimside-hover-term-balloon-enabled", 1)
  " call owner.Set("tailor-hover-term-balloon-fg", "red")
  " call owner.Set("tailor-hover-term-balloon-bg", "white")
  "
  " The following Hover Options should normally not be changed
  " call owner.Set("tailor-hover-updatetime", 600)
  " one character and hover move triggered
  " call owner.Set("tailor-hover-max-char-mcounter", 0)
  " call owner.Set("tailor-hover-cmdline-job-time", 300)
  " call owner.Set("tailor-hover-term-job-time", 300)
  "--------------


  "--------------
  " Selection using 'highlight' or 'visual'
  " call owner.Set("tailor-expand-selection-information", 'visual')
  "--------------

  "--------------
  " Search options
  " call owner.Set("tailor-symbol-search-do-incremental", 0)
  " call owner.Set("tailor-symbol-search-close-empty-display", 1)
  " call owner.Set("tailor-symbol-search-maximum-return", 50)
  "--------------
  
  "--------------
  " Re-order which unix browser command to try first
  " call owner.Set("tailor-browser-unix-commands", ['firefox', 'xdg-open', 'opera'])
  "--------------

  "--------------
  " Typecheck file on write
  " call owner.Set('tailor-type-check-file-on-write', 0)
  "--------------

  "--------------
  " Refactor rename, extract local and extract metod
  " call owner.Set('tailor-refactor-rename-pattern-enable', 1)
  " call owner.Set('tailor-refactor-rename-pattern', '[^ =:;()[\]]\+')
  " call owner.Set('tailor-refactor-extract-local-pattern-enable', 1)
  " call owner.Set('tailor-refactor-extract-local-pattern', '[^ =:;()[\]]\+')
  " call owner.Set('tailor-refactor-extract-method-pattern-enable', 1)
  " call owner.Set('tailor-refactor-extract-method-pattern', '[^ =:;()[\]]\+')
  "--------------


  " call owner.Set("tailor-symbol-at-point-location-same-file", "same_window.vim")
  " call owner.Set("tailor-symbol-at-point-location-same-file", "split_window.vim")
  " call owner.Set("tailor-symbol-at-point-location-same-file", "vsplit_window.vim")
  
  " call owner.Set("tailor-symbol-at-point-location-diff-file", "same_window.vim")
  " call owner.Set("tailor-symbol-at-point-location-diff-file", "split_window.vim")
  " call owner.Set("tailor-symbol-at-point-location-diff-file", "vsplit_window.vim")
  " call owner.Set("tailor-symbol-at-point-location-diff-file", "tab")
  
   
  " call owner.Set("tailor-uses-of-symbol-at-point-location", "same_window")
  " call owner.Set("tailor-uses-of-symbol-at-point-location", "split_window")
  " call owner.Set("tailor-uses-of-symbol-at-point-location", "vsplit_window")
  " call owner.Set("tailor-uses-of-symbol-at-point-location", "tab")
  
  " call owner.Set("tailor-repl-config-location", "same_window")
  " call owner.Set("tailor-repl-config-location", "split_window")
  " call owner.Set("tailor-repl-config-location", "vsplit_window")
  " call owner.Set("tailor-repl-config-location", "tab")
  "
  " call owner.Set("tailor-sbt-config-location", "same_window")
  " call owner.Set("tailor-sbt-config-location", "split_window")
  " call owner.Set("tailor-sbt-config-location", "vsplit_window")
  " call owner.Set("tailor-sbt-config-location", "tab")
  "
  " call owner.Set("tailor-sbt-use-signs", "0")

  " call owner.Set("tailor-show-errors-and-warnings-use-signs", '0')
  " call owner.Set("tailor-full-typecheck-finished-use-signs", '0')
  " call owner.Set("tailor-uses-of-symbol-at-point-use-signs", '0')

  "--------------
  " Sign Option tailoring
  "
  " call owner.Set('sign-quickfix-error-linehl', 'Error')
  " call owner.Set('sign-quickfix-error-text', 'E>')
  " call owner.Set('sign-quickfix-error-texthl', 'Todo')
  " call owner.Set('sign-quickfix-warn-linehl', 'StatusLine')
  " call owner.Set('sign-quickfix-warn-text', 'W>')
  " call owner.Set('sign-quickfix-warn-texthl', 'Todo')
  " 
  " call owner.Set('sign-quickfix-info-linehl', 'DiffAdd')
  " call owner.Set('sign-quickfix-info-text', 'I>')
  " call owner.Set('sign-quickfix-info-texthl', 'TODO')
  " 
  " call owner.Set('sign-quickfix-marker-linehl', 'Search')
  " call owner.Set('sign-quickfix-marker-text', 'M>')
  " call owner.Set('sign-quickfix-marker-texthl', 'Ignore')
  " 
  " call owner.Set('sign-locationlist-info-linehl', 'DiffAdd')
  " call owner.Set('sign-locationlist-info-text', 'I>')
  " call owner.Set('sign-locationlist-info-texthl', 'TODO')
  " 
  " call owner.Set('sign-locationlist-marker-linehl', 'Search')
  " call owner.Set('sign-locationlist-marker-text', 'M>')
  " call owner.Set('sign-locationlist-marker-texthl', 'Ignore')
  " 
  " call owner.Set('sign-debug-active-linehl', 'DiffText')
  " call owner.Set('sign-debug-active-text', 'A>')
  " call owner.Set('sign-debug-active-texthl', 'SpellCap')
  " 
  " call owner.Set('sign-debug-pending-linehl', 'DiffAdd')
  " call owner.Set('sign-debug-pending-text', 'P>')
  " call owner.Set('sign-debug-pending-texthl', 'DiffDelete')
  " 
  " call owner.Set('sign-debug-marker-linehl', 'Search')
  " call owner.Set('sign-debug-marker-text', 'M>')
  " call owner.Set('sign-debug-marker-texthl', 'Ignore')
  "--------------




endfunction

