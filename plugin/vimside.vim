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
  nmap <silent> <Leader>vs :call vimside#command#StartEnsime()<CR>
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
  inoremap <tab> <c-r>=TabToOmni()<CR>


  " C-c C-v i or Control+Right-Click
  "   Inspect the type of the expression under the cursor.

  " M-. (dot) or Control+Left-Click 
  "   Jump to definition of symbol under cursor.
  nmap <silent> <Leader>v. :call vimside#command#SymbolAtPoint()<CR>

  " M-, (comma)
  "   Pop back to previously visited position.
  nmap <silent> <Leader>v, :call vimside#command#PreviousPosition()<CR>

  " C-c C-v .
  "   Select the surrounding syntactic context. Subsequent taps of '.' 
  "   and ',' will grow and shrink the selection, respectively.

  " C-c C-v v
  "   Search globally for methods or types.

  " Control+Right-Click(on an imported package)
  "   Inspect the package under cursor.

  " Mouse Hover
  "   Echo the type of the expression under the cursor.
  nmap <silent> <Leader>vh :call vimside#command#HoverToSymbol()<CR>

  " C-c C-v p
  "   Inspect the package of the current source file.

  " C-c C-v o
  "   Inspect the package specified in .ensime as :package.

  " C-c C-v r
  "   List all references to the symbol under the cursor.
  nmap <silent> <Leader>vr :call vimside#command#UsesOfSymbolAtPoint()<CR>

  " .
  "   Forward one page in the inspector history.

  " ,
  "   Backward one page in the inspector history.

  " C-n or TAB
  "   Forward one link in the inspector.

  " C-p
  "   Backward one link in the inspector.

  " C-c C-v s
  "   Switch to the sbt command-line (works for sbt projects only)

  " C-c C-v z
  "   Switch to the scala interpreter, with project classes in the classpath.
  nmap <silent> <Leader>vz :call vimside#command#Repl()<CR>

  " C-c C-v c
  "   Typecheck the current file.
  nmap <silent> <Leader>vc :call vimside#command#TypecheckFile()<CR>

  " C-c C-v a
  "   Typecheck all files in the project.
  nmap <silent> <Leader>va :call vimside#command#TypecheckAll()<CR>

  " C-c C-v e
  "   Show all errors and warnings in the project.

  " C-c C-v f
  "   Format the current Scala source file.
  nmap <silent> <Leader>vf :call vimside#command#FormatSource()<CR>

  " C-c C-v u
  "   Undo a refactoring or formatting change.

  " M-n
  "   Go to the next compilation note in the current buffer.

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

  " C-c C-r x
  "   Where x is one of:
  "     r Rename the symbol at point.
  "     o Organize imports.
  "     l Extract local.
  "     m Extract method.
  "     i Inline local.
  "     t Add import for type at point.
  
  " C-c C-b x
  "   Where x is one of:
  "     b Build the entire project.
  "     r Rebuild the project, incrementally.

  " M-x ensime-reload
  "   Reload the .ensime file and recompile the project. Useful if you hit 
  "   a server bug.

  " M-x ensime-config-get
  "   Start the automatic configuration file generator.



  nmap <silent> <Leader>vp :call vimside#command#MapPopUp('n')<CR>
  vmap <silent> <Leader>vp :call vimside#command#MapPopUp('v')<CR>

  nmap <silent> <Leader>voe :call vimside#command#OptionEditor()<CR>

  nmap <silent> <Leader>vbs :call vimside#command#BrowseSourceRoots()<CR>
  nmap <silent> <Leader>vbr :call vimside#command#BrowseReferenceSourceRoots()<CR>

  augroup VIMSIDE
    au!
    autocmd VimLeave * call vimside#StopEnsime()
  augroup END
endif
