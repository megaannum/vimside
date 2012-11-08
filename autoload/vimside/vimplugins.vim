" ============================================================================
" vimplugins.vim
"
" File:          vimplugins.vim
" Summary:       Check is require Vim plugins exist and warn about optional ones
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" ============================================================================

function! vimside#vimplugins#Check()
  let errors = g:vimside.errors
  let warns = g:vimside.warns

  " Required plugins
  silent! call vimproc#version()
  if ! exists("*vimproc#version")
    call add(errors, "Requires Vimproc plugin: https://github.com/Shougo/vimproc")
  endif


  silent! call vimshell#version()
  if ! exists("*vimshell#version")
    call add(errors, "Requires Vimshell plugin: https://github.com/Shougo/vimshell")
  endif
  
  " Optional plugins
  silent! call forms#version()
  if exists("*forms#version")
    let g:vimside.plugins.forms = 1
  else
    let g:vimside.plugins.forms = 0

    call add(warns, "Less functiona without Forms plugin: https://github.com/megaannum/forms")
    silent! call self#version()
    if ! exists("*self#version")
      call add(warns, "Forms plugin requires Self: https://github.com/megaannum/self")
    endif
  endif

endfunction
