" ============================================================================
" This file, example_plugin_user.vim will NOT be read by the Vimside 
" code. 
" To adjust key mapping values, copy this file to 'plugin_user.vim' and 
" then make changes.
" ============================================================================

nmap <Leader>vs :call vimside#StartEnsime()<CR>
nmap <Leader>vS :call vimside#StopEnsime()<CR>

nmap <Leader>vp :call vimside#swank#rpc#symbol_at_point#Run()<CR>
nmap <Leader>vu :call vimside#swank#rpc#uses_of_symbol_at_point#Run()<CR>

nmap <Leader>vc :call vimside#swank#rpc#typecheck_file#Run()<CR>
nmap <Leader>vf :call vimside#swank#rpc#format_source#Run()<CR>
nmap <Leader>va :call vimside#swank#rpc#typecheck_all#Run()<CR>
nmap <Leader>vz :call vimside#swank#rpc#repl_config#Run()<CR>


augroup VIMSIDE
  au!
  autocmd VimLeave * call vimside#StopEnsime()
augroup END
