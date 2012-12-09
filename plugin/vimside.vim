" -----------------------------------------------------------------------
" Vimside plugin.vim file.
" -----------------------------------------------------------------------

" full path to this file
let s:full_path=expand('<sfile>:p')
" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')
" file name
let s:file_name=fnamemodify(s:full_path, ':t')

let s:plugin_user_file = 'plugin_user.vim'
let s:plugin_user_path = '../data/vimside/'. s:plugin_user_file

if filereadable(s:plugin_user_path)
  source s:plugin_user_path
else
  " Start Vimside 
  " M-x ensime
  if has("gui_running")
    nmap <silent> <m-x> :call vimside#command#StartEnsime()<CR>
  else
    nmap <silent> <Leader>vs :call vimside#command#StartEnsime()<CR>
  endif
  " Stop Vimside 
  nmap <silent> <Leader>vS :call vimside#command#StopEnsime()<CR>

  " TAB
  "   Start completing a method/variable.
  " inoremap <tab> <c-r>=feedkeys("\<c-x>\<c-o>")<CR>
  " imap <tab> <c-r>=feedkeys("\<c-x>\<c-o>")<CR>
  " imap <tab> <c-x><c-o>

  function! TabToOmni()
    return "\<c-x>\<c-o>"
  endfunction
  autocmd FileType scala inoremap <tab> <c-r>=TabToOmni()<CR>


  " C-c C-v i or Control+Right-Click
  "   Inspect the type of the expression under the cursor.

  " M-. (dot) or Control+Left-Click 
  "   Jump to definition of symbol under cursor.
  "   Note that the Meta/Alt keys, while easy to use with GVim, are,
  "   at best, an advanture and, at worst, impossible, to get working
  "   with non-GVim - thus the mapping is different for non-gui-running.
  if has("gui_running")
    autocmd FileType scala nmap <silent> <m-.> :call vimside#command#SymbolAtPoint()<CR>
  else
    autocmd FileType scala nmap <silent> <Leader>m. :call vimside#command#SymbolAtPoint()<CR>
  endif

  " M-, (comma)
  "   Pop back to previously visited position.
  if has("gui_running")
    autocmd FileType scala nmap <silent> <m-,> :call vimside#command#PreviousPosition()<CR>
  else
    autocmd FileType scala nmap <silent> <Leader>m, :call vimside#command#PreviousPosition()<CR>
  endif

  " C-c C-v .
  "   Select the surrounding syntactic context. Subsequent taps of '.' 
  "   and ',' will grow and shrink the selection, respectively.
  autocmd FileType scala map <silent> <Leader>v. :call vimside#command#ExpandSelection()<CR>
  autocmd FileType scala map <silent> <Leader>v, :call vimside#command#ContractSelection()<CR>

  " C-c C-v v
  "   Search globally for methods or types.
  autocmd FileType scala map <silent> <Leader>vv :call vimside#command#Search()<CR>

  " C-c C-v x
  "   Scalex search for methods or types.
  " NOT IMPLEMENTED YET
  
  " C-c C-v t
  "   Show (web api) documentation for symbol at point
  autocmd FileType scala map <silent> <Leader>vt :call vimside#command#ShowDocSymbolAtPoint()<CR>

  " Control+Right-Click(on an imported package)
  "   Inspect the package under cursor.
  " NOT IMPLEMENTED YET

  " Mouse Hover
  "   Echo the type of the expression under the cursor.
  autocmd FileType scala nmap <silent> <Leader>vh :call vimside#command#HoverToSymbol()<CR>

  " C-c C-v p
  "   Inspect the package of the current source file.
  " NOT IMPLEMENTED YET

  " C-c C-v o
  "   Inspect the package specified in .ensime as :package.
  " NOT IMPLEMENTED YET

  " C-c C-v r
  "   List all references to the symbol under the cursor.
  autocmd FileType scala nmap <silent> <Leader>vr :call vimside#command#UsesOfSymbolAtPoint()<CR>

  " .
  "   Forward one page in the inspector history.
  " NOT IMPLEMENTED YET

  " ,
  "   Backward one page in the inspector history.
  " NOT IMPLEMENTED YET

  " C-n or TAB
  "   Forward one link in the inspector.
  " NOT IMPLEMENTED YET

  " C-p
  "   Backward one link in the inspector.
  " NOT IMPLEMENTED YET

  " C-c C-v s
  "   Switch to the sbt command-line (works for sbt projects only)
  " NOT IMPLEMENTED YET

  " C-c C-v z
  "   Switch to the scala interpreter, with project classes in the classpath.
  autocmd FileType scala nmap <silent> <Leader>vz :call vimside#command#Repl()<CR>

  " C-c C-v c
  "   Typecheck the current file.
  autocmd FileType scala nmap <silent> <Leader>vc :call vimside#command#TypecheckFile()<CR>

  augroup VIMSIDE_ON_WRITE
    au!
    autocmd BufWritePost scala call vimside#command#TypecheckFileOnWrite()
  augroup END


  " C-c C-v a
  "   Typecheck all files in the project.
  autocmd FileType scala nmap <silent> <Leader>va :call vimside#command#TypecheckAll()<CR>

  " C-c C-v e
  "   (Re-)Show all errors and warnings in the project.
  autocmd FileType scala nmap <silent> <Leader>ve :call vimside#command#ShowErrorsAndWarning()<CR>

  " C-c C-v f
  "   Format the current Scala source file.
  autocmd FileType scala nmap <silent> <Leader>vf :call vimside#command#FormatSource()<CR>

  " C-c C-v u
  "   Undo a refactoring or formatting change.
  " NOT IMPLEMENTED YET

  " M-n
  "   Go to the next compilation note in the current buffer.
  " NOT IMPLEMENTED YET

  " C-c C-d x
  "   Where x is one of:
  "     d Start and run the debugger.
  "     r Start and run the debugger.
  "     b Set a breakpoint.
  "     u Clear a breakpoint.
  "     s Step.
  "     n Step over.
  "     o Step out.
  "     c Continue from a breakpoint.
  "     q Kill the debug session.
  "     i Inspect the local variable at cursor.
  "     t Show backtrace.
  "     a Clear all breakes
  " NOT IMPLEMENTED YET

  " C-c C-r x
  "   Where x is one of:
  "     r Rename the symbol at point.
  autocmd FileType scala nmap <silent> <Leader>rr :call vimside#command#RefactorRename('n')<CR>
  autocmd FileType scala vmap <silent> <Leader>rr :call vimside#command#RefactorRename('v')<CR>

  "     o Organize imports.
  autocmd FileType scala nmap <silent> <Leader>ro :call vimside#command#RefactorOrganizeImports()<CR>

  "     l Extract local.
  autocmd FileType scala nmap <silent> <Leader>rl :call vimside#command#RefactorExtractLocal('n')<CR>
  autocmd FileType scala vmap <silent> <Leader>rl :call vimside#command#RefactorExtractLocal('v')<CR>

  "     m Extract method.
  autocmd FileType scala nmap <silent> <Leader>rm :call vimside#command#RefactorExtractMethod('n')<CR>
  autocmd FileType scala vmap <silent> <Leader>rm :call vimside#command#RefactorExtractMethod('v')<CR>

  "     i Inline local.
  autocmd FileType scala nmap <silent> <Leader>ri :call vimside#command#RefactorInlineLocal('n')<CR>
  autocmd FileType scala vmap <silent> <Leader>ri :call vimside#command#RefactorInlineLocal('v')<CR>

  "     t Add import for type at point.
  autocmd FileType scala nmap <silent> <Leader>rt :call vimside#command#RefactorAddImport()<CR>
  
  autocmd FileType scala nmap <silent> <Leader>vi :call vimside#command#ImportSuggestions('n')<CR>
  autocmd FileType scala vmap <silent> <Leader>vi :call vimside#command#ImportSuggestions('v')<CR>

  " C-c C-b x
  "   Where x is one of:
  "     b Build the entire project.
  "     r Rebuild the project, incrementally.
  "
  "     s sbt switch
  "     c sbt do complete
  "     n sbt do clean
  "     p sbt do package
  " NOT IMPLEMENTED YET

  " M-x ensime-reload
  "   Reload the .ensime file and recompile the project. Useful if you hit 
  "   a server bug.
  " NOT IMPLEMENTED YET

  " M-x ensime-config-get
  "   Start the automatic configuration file generator.
  " NOT IMPLEMENTED YET



  autocmd FileType scala nmap <silent> <Leader>vp :call vimside#command#MakePopUp('n')<CR>
  autocmd FileType scala vmap <silent> <Leader>vp :call vimside#command#MapkeopUp('v')<CR>

  autocmd FileType scala nmap <silent> <Leader>vbs :call vimside#command#BrowseSourceRoots()<CR>
  autocmd FileType scala nmap <silent> <Leader>vbr :call vimside#command#BrowseReferenceSourceRoots()<CR>

  autocmd FileType scala nmap <silent> <Leader>voe :call vimside#command#OptionEditor()<CR>

  augroup VIMSIDE_STOP
    au!
    autocmd VimLeave * call vimside#StopEnsime()
    " autocmd VimLeave scala call vimside#StopEnsime()
  augroup END
endif
