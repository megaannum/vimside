" ============================================================================
" vimside#options#manager.vim
"
" File:          vimside#options#manager.vim
" Summary:       Options for Vimside
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"   Steps:
"     Vimside sources this file.    
"     Check if Vimside global dictionary exists
"     This file sources file "options_user.vim" if the file exists
"     This file loads file "optionsdefault.vim"
"     This file makes sure all required options have valid values.
"     This file makes sure all required options have valid values.
"
"
"OLD
" g:vimside {
"   has option methods
"   options {
"     has option methods
"     defined {
"       definition of options
"     }
"     default {
"       has option methods
"       default values for some optiosn
"     }
"     user {
"       has option methods
"       user override for some optiosn
"     }
"   }
" }
"NEW
" owner == {
"    methods
"    keyvals {}
" }
" g:vimside {
"   has 'public' option methods
"   options {
"     keyvals {}
"     methods
"     defined {
"       definition of options
"     }
"     default (== owner){
"       methods
"       keyvals {} default values
"     }
"     user (== owner){
"       keyvals {}
"       methods and check
"     }
"   }
" }
"
"
" ============================================================================

" Load Once: {{{1
if &cp || exists("g:vimside_options_loaded")
  finish
endif
let g:vimside_options_loaded = 'v1.0'
let s:keepcpo = &cpo
set cpo&vim


" full path to this file
let s:full_path=expand('<sfile>:p')

" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')


if ! exists("g.vimside.options")
  let g:vimside['options'] = {}
endif
if ! exists("g.vimside.options.keyvals")
  let g:vimside.options['keyvals'] = {}
endif
if ! exists("g.vimside.options.defined")
  let g:vimside.options['defined'] = {}
endif
if ! exists("g.vimside.options.user")
  let g:vimside.options['user'] = {}
endif
if ! exists("g.vimside.options.user.keyvals")
  let g:vimside.options.user['keyvals'] = {}
endif
if ! exists("g.vimside.options.default")
  let g:vimside.options['default'] = {}
endif
if ! exists("g.vimside.options.default.keyvals")
  let g:vimside.options.default['keyvals'] = {}
endif

function! vimside#options#manager#SetOptionPrivate(key, value) dict
  let keyvals = self.keyvals
  if ! has_key(keyvals, a:key)
    if has_key(self, 'check')
      call self.check(a:key, a:value)
    endif

    let keyvals[a:key] = a:value
  endif
endfunction
function! vimside#options#manager#UpdateOptionPrivate(key, value) dict
  let keyvals = self.keyvals
  if has_key(keyvals, a:key)
    unlet keyvals[a:key]
  endif
  let keyvals[a:key] = a:value
endfunction
function! vimside#options#manager#HasOptionPrivate(key) dict
  let keyvals = self.keyvals
  return has_key(keyvals, a:key)
endfunction
function! vimside#options#manager#GetOptionPrivate(key) dict
  let keyvals = self.keyvals
  return has_key(keyvals, a:key) ? [1, keyvals[a:key]] : [0, '']
endfunction
function! vimside#options#manager#RemoveOptionPrivate(key) dict
  let keyvals = self.keyvals
  if has_key(keyvals, a:key)
    unlet keyvals[a:key]
  endif
endfunction

function! s:DefineOptionMethods(owner)
  let owner = a:owner
  let owner.Set = function("vimside#options#manager#SetOptionPrivate")
  let owner.Update = function("vimside#options#manager#UpdateOptionPrivate")
  let owner.Has = function("vimside#options#manager#HasOptionPrivate")
  let owner.Get = function("vimside#options#manager#GetOptionPrivate")
  let owner.Remove = function("vimside#options#manager#RemoveOptionPrivate")
endfunction

call s:DefineOptionMethods(g:vimside.options)
call s:DefineOptionMethods(g:vimside.options.user)
call s:DefineOptionMethods(g:vimside.options.default)


" g:vimside  'public' option methods
function! vimside#options#manager#SetOption(key, value) dict
  let keyvals = self.options.keyvals
  if ! has_key(keyvals, a:key)
    let keyvals[a:key] = a:value
  endif
endfunction

function! vimside#options#manager#UpdateOption(key, value) dict
  let keyvals = self.options.keyvals
  if has_key(keyvals, a:key)
    unlet keyvals[a:key]
  endif
  let keyvals[a:key] = a:value
endfunction

function! vimside#options#manager#GetOption(key) dict
  let [found, value_top] = self.options.Get(a:key)
  if found
    return [1, value_top]
  endif
  let [found, value_user] = self.options.user.Get(a:key)
  if found
    call self.options.Set(a:key, value_user)
    return [1, value_user]
  endif
  let [found, value_default] = self.options.default.Get(a:key)
  if found
    call self.options.Set(a:key, value_default)
    return [1, value_default]
  endif

  let defined = g:vimside.options.defined
  if has_key(defined, a:key)
    let def = defined[a:key]
    if has_key(def, "parent")
      let parent_key = def.parent
      let [found, value_parent] = g:vimside.GetOption(parent_key)
      if found
        return [1, value_parent]
      endif
    endif
  endif

  return [0, '']
endfunction

function! vimside#options#manager#HasOption(key) dict
  if self.options.Has(a:key)
    return 1
  elseif self.options.user.Has(a:key)
    return 1
  elseif self.options.default.Has(a:key)
    return 1
  else
    return 0
  endif
endfunction
function! vimside#options#manager#CheckOption(key) dict
  if ! self.options.Has(a:key)
    \ && ! self.options.user.Has(a:key)
    \ && ! self.options.default.Has(a:key)
    echoerr "ERROR: Vimside missing option: " . a:key
  endif
endfunction
function! vimside#options#manager#GetOptionDefinitions() dict
  return self.options.defined
endfunction

let g:vimside.SetOption = function("vimside#options#manager#SetOption")
let g:vimside.UpdateOption = function("vimside#options#manager#UpdateOption")
let g:vimside.GetOption = function("vimside#options#manager#GetOption")
let g:vimside.HasOption = function("vimside#options#manager#HasOption")
let g:vimside.CheckOption = function("vimside#options#manager#CheckOption")
let g:vimside.GetOptionDefinitions = function("vimside#options#manager#GetOptionDefinitions")






if 0

function! g:VimsideSetOption(key, value)
  if ! has_key(g:vimside, a:key)
    let g:vimside[a:key] = a:value
  endif
endfunction
function! g:VimsideCheckOptionSet(key)
  if ! has_key(g:vimside, a:key)
    echoerr "ERROR: Vimside missing option: " . a:key
  endif
endfunction
endif


function! g:VimsideCheckDirectoryExists(dir, perms, errors)
  let dir = a:dir
  let perms = a:perms
  let l:errors = a:errors
  let ok = 1

  if isdirectory(dir)
    let dperms = getfperm(dir)[0:2]
    if perms[0] != '-'
      if perms[0] != dperms[0]
        call add(l:errors, "Directory: '". dir . "' does not have read permissions")
        let ok = 0
      endif
    endif
    if perms[1] != '-'
      if perms[1] != dperms[1]
        call add(l:errors, "Directory: '". dir . "' does not have write permissions")
        let ok = 0
      endif
    endif

  else
    call add(l:errors, "Not a directory: '". dir . "'")
    let ok = 0
  endif
  return ok
endfunction






function! vimside#options#manager#LoadUser()

  function! s:CheckDefinedFunc(key, value) dict
    let defined = g:vimside.options.defined
    if has_key(defined, a:key)
      let def = defined[a:key]
      call vimside#options#defined#CheckValue(def, a:value, g:vimside.errors)
    else
      call add(g:vimside.errors, "Undefined User option: '". a:key . "'")
    endif
  endfunction

  let g:vimside.options.user['check'] = function("s:CheckDefinedFunc")

  " Source "options_user.vim" file if it exists
  let l:tmpfile = s:full_dir . '/../../../data/vimside/' . "options_user.vim"
  if filereadable(l:tmpfile)
    execute ":source " . l:tmpfile
    call g:VimsideOptionsUserLoad(g:vimside.options.user)
  endif
endfunction


" ===========================================================================
"
"
" ===========================================================================
function! vimside#options#manager#Load()

  " loads option definitions at g:vimside.options.defined
  call vimside#options#defined#Load(g:vimside.options)

  call vimside#options#manager#LoadUser()

  " This file loads default options values from "default.vim"
  " at g:vimside.options.default.options
  call vimside#options#default#Load(g:vimside.options.default)



  " ---------------------------------------------------------------------
  " Make sure all required options have valid values.
  " ---------------------------------------------------------------------

  let l:errors = g:vimside.errors

  " ---------------------------------------------
  " Locate the dot ensime file and directory
  " ---------------------------------------------

  let [found, l:efname] = g:vimside.GetOption('ensime-config-file-name')
  if found
    let [found, l:use_test_efile] = g:vimside.GetOption('test-ensime-file-use')
    if found
      if l:use_test_efile
        let [found, l:test_dir] = g:vimside.GetOption('test-ensime-file-dir')
        if found
          if g:VimsideCheckDirectoryExists(l:test_dir, "r-x", l:errors)
            let l:ensime_config_file = l:test_dir . "/" . l:efname
          endif

        else
          call add(l:errors, "Option not found: 'test-ensime-file-dir'")
        endif

      else

        " look in current directory and walk up directories until ensime
        " config file is found.
        let dir = s:full_dir
        while dir != '/'
          let l:tmp_config_file = dir . '/' . l:efname
          if filereadable(l:tmp_config_file)
            break
          endif
          let dir = fnamemodify(dir, ":h")
        endwhile

        if dir == ''
          call add(l:errors, "Can find ensime config file: '" . l:efname ."'")
        else
          if g:VimsideCheckDirectoryExists(dir, "r-x", l:errors)
            let l:ensime_config_file = dir . "/" . l:efname
          endif
        endif

      endif

    else
      call add(l:errors, "Option not found: 'test-ensime-file-use'")
    endif

  else
    call add(l:errors, "Option not found: 'ensime-config-file-name'")
  endif

  if exists("l:ensime_config_file")

    if ! filereadable(l:ensime_config_file)
      call add(l:errors, "Can not read ensime config file: '". l:ensime_config_file ."'")
    endif

    let l:ensime_config_dir = fnamemodify(l:ensime_config_file, ':h')
    call g:vimside.SetOption("ensime_config_dir", l:ensime_config_dir)
    call g:vimside.SetOption("ensime_config_file", l:ensime_config_file)
  endif


if 0
"OLD
  let [found, l:efname] = g:vimside.GetOption('ensime-config-file-name')
  if ! found
    echoerr "Option not found: " . 'ensime-config-file-name'
  endif

  let [found, l:use_test_efile] = g:vimside.GetOption('test-ensime-file-use')
  if ! found
    echoerr "Option not found: " . 'test-ensime-file-use'
  endif

  if l:use_test_efile
    let [found, l:test_dir] = g:vimside.GetOption('test-ensime-file-dir')
    if ! found
      echoerr "Option not found: " . 'test-ensime-file-dir'
    endif
    call g:VimsideCheckDirectoryExists(l:test_dir)

    let l:ensime_config_file = l:test_dir . "/" . l:efname
  else
    " look in current directory and walk up directories until ensime
    " config file is found.
    let dir = s:full_dir
    while dir != '/'
      let l:ensime_config_file = dir . '/' . l:efname
      if filereadable(l:ensime_config_file)
        break
      endif
      unlet l:ensime_config_file
      let dir = fnamemodify(dir, ":h")
    endwhile
    " let l:ensime_config_file = findfile("l:efname", ".;")

    if dir == ''
      echoerr "Vimside: can find ensime config file: " . l:efname
    endif
  endif

  if ! filereadable(l:ensime_config_file)
    echoerr "Vimside: can not read ensime config file: " . l:ensime_config_file
  endif

  let l:ensime_config_dir = fnamemodify(l:ensime_config_file, ':h')
  call g:vimside.SetOption("ensime_config_dir", l:ensime_config_dir)
  call g:vimside.SetOption("ensime_config_file", l:ensime_config_file)
"OLD
endif




  " Do we have the Ensime Distribution path
  if g:vimside.HasOption("ensime-install-path")
    let [found, l:path] = g:vimside.GetOption('ensime-install-path')
    if ! found
      call add(l:errors, "Option not found: '". 'ensime-install-path' ."'")
    endif

    call g:VimsideCheckDirectoryExists(l:path, "r-x", l:errors)

    " envim uses: ensime-common/src/main/python/Helper.py findLastDist
    "   to look for latest distribution directory
    call g:vimside.CheckOption('ensime-dist-dir')

    let [found, l:distdir] = g:vimside.GetOption('ensime-dist-dir')
    if ! found
      call add(l:errors, "Option not found: '". 'ensime-dist-dir' ."'")
    endif

    let l:distdirpath = l:path  . '/' . l:distdir
    call g:VimsideCheckDirectoryExists(l:distdirpath, "r-x", l:errors)
  
    call g:vimside.SetOption("ensime-dist-path", l:distdirpath)

  elseif g:vimside.HasOption("ensime-dist-path")
    let [found, l:distdirpath] = g:vimside.GetOption('ensime-dist-path')
    if ! found
      call add(l:errors, "Option not found: '". 'ensime-dist-path' ."'")
    endif

    call g:VimsideCheckDirectoryExists(l:distdirpath, "r-x", l:errors)

  else
    call add(l:errors, "No Ensime Distribution path, set options 'ensime-install-path' or 'ensime-dist-path'")
  endif

  let [found, l:use_cwd] = g:vimside.GetOption('use-cwd-as-default-output-dir')
  if ! found
    call add(l:errors, "Option not found: '". 'use-cwd-as-default-output-dir' ."'")
  endif


  " Is the Ensime port file (the file where Ensime writes it socket 
  "   listener port number)
  if g:vimside.HasOption("ensime-port-file-path")
    let [found, l:pfilepath] = g:vimside.GetOption('ensime-port-file-path')
    if ! found
      call add(l:errors, "Option not found: '". 'ensime-port-file-path' ."'")
    endif

    if filewritable(l:pfilepath) != 1
      let s:pfiledir=fnamemodify(l:pfilepath, ':h')
      if filewritable(s:pfiledir) != 2
        call add(l:errors, "Can not create Ensime port file in directory: '". s:pfiledir ."'")
      endif
    endif
  else
    if l:use_cwd
      let cwd = getcwd()
      if filewritable(cwd) == 2
        let portdir = cwd
      else
        let portdir = $HOME
      endif
    else
      if filewritable(l:ensime_config_dir) == 2
        let portdir = l:ensime_config_dir
      else
        let portdir = $HOME
      endif
    endif

    let [found, l:pfilename] = g:vimside.GetOption('ensime-port-file-name')
    if ! found
        call add(l:errors, "Option not found: '". 'ensime-port-file-name' ."'")
    endif

    let value = portdir . '/' . l:pfilename
    call g:vimside.SetOption('ensime-port-file-path', value)

if 0
      if g:vimside.HasOption("ensime-port-file-name")
        let [found, l:pfilename] = g:vimside.GetOption('ensime-port-file-name')
        if ! found
          call add(l:errors, "Option not found: '". 'ensime-port-file-name' ."'")
        endif

        let value = portdir . '/' . l:pfilename
        call g:vimside.SetOption('ensime-port-file-path', value)
      else
        let value = portdir . '/_ensime_port'
        call g:vimside.SetOption('ensime-port-file-path', value)
      endif
endif
  endif

  let [found, hostname] = g:vimside.GetOption('ensime-host-name')
  if ! found
    call add(l:errors, "Option not found: '". 'ensime-host-name' ."'")
  endif

  if ! vimproc#host_exists(hostname)
    call add(l:errors, "Can not find hostname: '". hostname ."'")
  endif

  let [found, cnt] = g:vimside.GetOption('ensime-port-file-max-wait')
  if ! found
    call add(l:errors, "Option not found: '". 'ensime-port-file-max-wait' ."'")
  endif

  if cnt < 0
    call add(l:errors, "Max port file creationg wait must be positive number: '". cnt ."'")
  endif


  " Log for output of the Ensime Server
  if g:vimside.HasOption("ensime-log-file-path")
    let [found, s:lfilepath] = g:vimside.GetOption('ensime-log-file-path')
    if ! found
      call add(l:errors, "Option not found: '". 'ensime-log-file-path' ."'")
    endif

    if filewritable(s:lfilepath) != 1
      let s:lfiledir=fnamemodify(s:lfilepath, ':h')
      if filewritable(s:lfiledir) != 2
        call add(l:errors, "Can not create Ensime log file in directory: '". s:lfiledir ."'")
      endif
    endif
  else
    if l:use_cwd
      let cwd = getcwd()
      if filewritable(cwd) == 2
        let logdir = cwd
      else
        let logdir = $HOME
      endif
    else
      if filewritable(l:ensime_config_dir) == 2
        let logdir = l:ensime_config_dir
      else
        let logdir = $HOME
      endif
    endif
    let [found, lfname] = g:vimside.GetOption('ensime-log-file-name')
    if ! found
      call add(l:errors, "Option not found: '". 'ensime-log-file-name' ."'")
    endif

    let value = logdir . '/' . lfname

    call g:vimside.SetOption('ensime-log-file-path', value)
  endif

  " Log for output of Vimside
  if g:vimside.HasOption("vimside-log-file-path")
    let [found, s:lfilepath] = g:vimside.GetOption('vimside-log_file-path')
    if ! found
      call add(l:errors, "Option not found: '". 'vimside-log-file-path' ."'")
    endif

    if filewritable(s:lfilepath) != 1
      let s:lfiledir=fnamemodify(s:lfilepath, ':h')
      if filewritable(s:lfiledir) != 2
        call add(l:errors, "Can not create Vimside log file in directory: '". s:lfiledir ."'")
      endif
    endif
  else
    if l:use_cwd
      let cwd = getcwd()
      if filewritable(cwd) == 2
        let logdir = cwd
      else
        let logdir = $HOME
      endif
    else
      if filewritable(l:ensime_config_dir) == 2
        let logdir = l:ensime_config_dir
      else
        let logdir = $HOME
      endif
    endif
    let [found, lfname] = g:vimside.GetOption('vimside-log-file-name')
    if ! found
      call add(l:errors, "Option not found: '". 'vimside-log-file-name' ."'")
    endif

    let value = logdir . '/' . lfname

    call g:vimside.SetOption('vimside-log-file-path', value)
  endif

endfunction



" ==============
"  Restore: {{{1
" ==============
let &cpo= s:keepcpo
unlet s:keepcpo

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
