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

" ----------------------------------------------------------------------
" See bottom of the plugin/vimside.vim file for the usage of these.
let s:enable_logging = exists("g:Vimside_Enable_Pre_Initialization_Logging")
\ && g:Vimside_Enable_Pre_Initialization_Logging

if s:enable_logging
  let s:LOG_DIR = g:Vimside_Enable_Pre_Initialization_Logging_Dir
  if ! isdirectory(s:LOG_DIR)
    throw "Not a directory for pre-init logging: ". s:LOG_DIR
  endif
  let s:LOG_FILE = s:LOG_DIR .'/'. g:Vimside_Enable_Pre_Initialization_Logging_File
endif

function! s:LOG(msg)
  if s:enable_logging
    execute "redir >> ". s:LOG_FILE
    silent echo "INFO: ". a:msg
    execute "redir END"
  endif
endfunction
" ----------------------------------------------------------------------


" full path to this file
let s:full_path=expand('<sfile>:p')
call s:LOG("vimside#options#manager: s:full_path=". s:full_path)

" full path to this file's directory
let s:full_dir=fnamemodify(s:full_path, ':h')
call s:LOG("vimside#options#manager: s:full_dir=". s:full_dir)

let s:data_vimside_dir = resolve(s:full_dir . '/../../../data/vimside/')
call s:LOG("vimside#options#manager: s:data_vimside_dir=". s:data_vimside_dir)

if ! exists("g:vimside")
  let g:vimside = {}
endif
if ! exists("g:vimside.options")
  let g:vimside['options'] = {}
endif
if ! exists("g:vimside.options.keyvals")
  let g:vimside.options['keyvals'] = {}
endif
if ! exists("g:vimside.options.defined")
  let g:vimside.options['defined'] = {}
endif
if ! exists("g:vimside.options.user")
  let g:vimside.options['user'] = {}
endif
if ! exists("g:vimside.options.user.keyvals")
  let g:vimside.options.user['keyvals'] = {}
endif
if ! exists("g:vimside.options.default")
  let g:vimside.options['default'] = {}
endif
if ! exists("g:vimside.options.default.keyvals")
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

let s:option_user_file_name = "options_user.vim"
let s:vimside_properties_file_name = "vimside.properties"

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
  let [found, Value_top] = self.options.Get(a:key)
  if found
    return [1, Value_top]
  endif
  let [found, Value_user] = self.options.user.Get(a:key)
  if found
    call self.options.Set(a:key, Value_user)
    return [1, Value_user]
  endif
  let [found, Value_default] = self.options.default.Get(a:key)
  if found
    call self.options.Set(a:key, Value_default)
    return [1, Value_default]
  endif

  let defined = g:vimside.options.defined
  if has_key(defined, a:key)
    let def = defined[a:key]
    if has_key(def, "parent")
      let parent_key = def.parent
      let [found, Value_parent] = g:vimside.GetOption(parent_key)
      if found
        return [1, Value_parent]
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






" Global user overrides of default values
function! vimside#options#manager#LoadUser()
  call s:LOG("vimside#options#manager#LoadUser: TOP")

  function! s:CheckDefinedFunc(key, value) dict
    let l:defined = g:vimside.options.defined
    let l:default = g:vimside.options.default
    if has_key(l:defined, a:key)
      let l:def = l:defined[a:key]
      call vimside#options#option#CheckValue(a:key, l:def, a:value, g:vimside.errors)

    elseif has_key(l:default.keyvals, a:key)
      " TODO when OPTION_KEY_KIND templates carries type/kind info, checkit
    else
call s:LOG("vimside#options#manager#LoadUser.CheckDefinedFunc: key=". a:key)
      call add(g:vimside.errors, "Undefined User option: '". a:key . "'")
    endif
  endfunction

  let g:vimside.options.user['check'] = function("s:CheckDefinedFunc")

  "
  " load options from options file
  "
  function! s:UserOptionsFile()
    let l:user_options = g:vimside.options.user

    let l:tmpfile = s:data_vimside_dir .'/'. s:option_user_file_name
call s:LOG("vimside#options#manager#LoadUser: UserOptionsFile l:tmpfile=". l:tmpfile)
    if filereadable(l:tmpfile)
call s:LOG("vimside#options#manager#LoadUser: UserOptionsFile sourcing=". l:tmpfile)
      execute ":source " . l:tmpfile
      call g:VimsideOptionsUserLoad(l:user_options)
    else
      let l:files = split(globpath(&rtp, 'data/vimside/'. s:option_user_file_name), "\n")
call s:LOG("vimside#options#manager#LoadUser: UserOptionsFile l:files=". string(l:files))
      for file in l:files
        if file != l:tmpfil &&e filereadable(file)
call s:LOG("vimside#options#manager#LoadUser: UserOptionsFile sourcing=". file)
          execute ":source " . file
          call g:VimsideOptionsUserLoad(l:user_options)
          break
        endif
      endfor
    endif
  endfunction

  "
  " load options from property file
  "
  function! s:UserPropertiesFile()
    let l:user_options = g:vimside.options.user

    let l:tmpfile = s:data_vimside_dir .'/'. s:vimside_properties_file_name
call s:LOG("vimside#options#manager#LoadUser: UserPropertiesFile l:tmpfile=". l:tmpfile)
    let [l:found, l:keys_value_list] = vimside#property#ParseFile(l:tmpfile)
    if l:found
call s:LOG("vimside#options#manager#LoadUser: UserPropertiesFile keys_value_list=". string(l:keys_value_list))
      let l:options = vimside#property#ConvertToOptions(l:keys_value_list)
      for [l:name, l:value] in l:options
call s:LOG("vimside#options#manager#LoadUser: UserPropertiesFile name==". l:name .", value=". string(l:value) . ", type=" . type(l:value))
        call l:user_options.Set(l:name, l:value)
        unlet l:value
      endfor
    else
      let l:files = split(globpath(&rtp, 'data/vimside/'. s:vimside_properties_file_name), "\n")
call s:LOG("vimside#options#manager#LoadUser: UserPropertiesFile l:files=". string(l:files))
      for file in l:files
        let [l:found, l:keys_value_list] = vimside#property#ParseFile(file)
        if l:found
call s:LOG("vimside#options#manager#LoadUser: UserPropertiesFile loading=". file)
          let l:options = vimside#property#ConvertToOptions(l:keys_value_list)
          for [l:name, l:value] in l:options
            call l:user_options.Set(l:name, l:value)
            unlet l:value
          endfor
          break
        endif
      endfor
    endif
  endfunction

  call s:UserOptionsFile()
  call s:UserPropertiesFile()

  call s:LOG("vimside#options#manager#LoadUser: BOTTOM")
endfunction

" ---------------------------------------------------------------------
" See if there is a project local (up the cwd dir-chain) file
" containing additional user set Options.
" This can be used as a project specific override
" ---------------------------------------------------------------------
function! vimside#options#manager#LoadProject(errors)
call s:LOG("vimside#options#manager#LoadProject: TOP")
  let l:errors = a:errors

  function! s:ProjectOptionsFile(errors)
    let l:errors = a:errors
    let l:user_options = g:vimside.options.user

    " look for and read project options file
    let [found, l:file_name] = g:vimside.GetOption('vimside-project-options-file-name')
    if found
call s:LOG("vimside#options#manager#LoadProject: ProjectOptionsFile l:file_name=". l:file_name)

    " Now look in current directory and walk up directories until ensime
    let dir = getcwd()
call s:LOG("vimside#options#manager#LoadProject:  ProjectOptionsFiledir=". dir)

    " Do not want to re-source the data/vimside/options_user.vim file
    if dir == s:data_vimside_dir && s:option_user_file_name == l:file_name
      let dir = fnamemodify(dir, ":h")
call s:LOG("vimside#options#manager#LoadProject:  ProjectOptionsFileup one dir=". dir)
    endif

    while dir != '/'
      let l:tmp_file = dir . '/' . l:file_name
call s:LOG("vimside#options#manager#LoadProject:  ProjectOptionsFilel:tmp_file=". l:tmp_file)
      if filereadable(l:tmp_file)
        break
      endif
      let dir = fnamemodify(dir, ":h")
call s:LOG("vimside#options#manager#LoadProject:  ProjectOptionsFileup one dir=". dir)
    endwhile

    if dir != '/' && dir != s:data_vimside_dir && g:VimsideCheckDirectoryExists(dir, "r-x", l:errors)
      let l:option_file = dir . "/" . l:file_name
call s:LOG("vimside#options#manager#LoadProject:  ProjectOptionsFilel:option_file=". l:option_file)
      execute ":source " . l:option_file
      call g:VimsideOptionsProjectLoad(l:user_options)
    endif

    else
      call s:LOG("vimside#options#manager#LoadProject:  ProjectOptionsFileOption not found: 'vimside-local-options-user-file-name'")
    endif
  endfunction

  function! s:ProjectPropertiesFile(errors)
    let l:user_options = g:vimside.options.user
    let l:errors = a:errors

    " look for and read project property file
    let [found, l:file_name] = g:vimside.GetOption('vimside-project-properties-file-name')
    if found
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile l:file_name=". l:file_name)

      " Now look in current directory and walk up directories until ensime
      let dir = getcwd()
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile dir=". dir)

      " Do not want to re-source the data/vimside/options_user.vim file
      if dir == s:data_vimside_dir && s:option_user_file_name == l:file_name
        let dir = fnamemodify(dir, ":h")
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile up one dir=". dir)
      endif

      while dir != '/'
        let l:tmp_file = dir . '/' . l:file_name
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile l:tmp_file=". l:tmp_file)
        if filereadable(l:tmp_file)
          break
        endif
        let dir = fnamemodify(dir, ":h")
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile up one dir=". dir)
      endwhile

      if dir != '/' && dir != s:data_vimside_dir && g:VimsideCheckDirectoryExists(dir, "r-x", l:errors)
        let l:property_file = dir . "/" . l:file_name
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile l:property_file=". l:property_file)

        let [l:found, l:keys_value_list] = vimside#property#ParseFile(l:property_file)
        if l:found
call s:LOG("vimside#options#manager#LoadProject: ProjectPropertiesFile loading=". l:property_file)
          let l:options = vimside#property#ConvertToOptions(l:keys_value_list)
          for [l:name, l:value] in l:options
            call l:user_options.Set(l:name, l:value)
            unlet l:value
          endfor
        endif
      endif
    endif
  endfunction

  let [found, l:look_local] = g:vimside.GetOption('vimside-project-options-enabled')
  if found 
call s:LOG("vimside#options#manager#LoadProject: look_local=". l:look_local)
    if l:look_local
      call s:ProjectOptionsFile(l:errors)
    endif
  else
    call s:LOG("vimside#options#manager#LoadProject: Option not found: 'vimside-local-options-user-enabled'")
  endif

  let [found, l:look_local] = g:vimside.GetOption('vimside-project-properties-enabled')
  if found 
call s:LOG("vimside#options#manager#LoadProject: look_local=". l:look_local)
    if l:look_local
      call s:ProjectPropertiesFile(l:errors)
    endif
  else
    call s:LOG("vimside#options#manager#LoadProject: Option not found: 'vimside-local-properties-user-enabled'")
  endif

call s:LOG("vimside#options#manager#LoadProject: BOTTOM")
endfunction

" ===========================================================================
"
"
" ===========================================================================
function! vimside#options#manager#Load()
call s:LOG("vimside#options#manager#Load: TOP")

  " Loads option definitions at g:vimside.options.defined
  " Must be called before loading default values.
  call vimside#options#defined#Load(g:vimside.options)

  " This file loads default options values from "default.vim"
  " at g:vimside.options.default.options

  " REMOVE OLD
  " call vimside#options#default#Load(g:vimside.options.default)



  " Now load the defaults from the Option definitions
  let l:keyvals = g:vimside.options.default.keyvals
  for [l:key, l:definition] in items(g:vimside.options.defined)
    if type(l:definition) == type({})
      if has_key(l:definition, 'value')
        let l:keyvals[l:key] = l:definition.value
      endif
    else
      echoerr "Bad define type for ". l;key
    endif
  endfor
  call vimside#options#defined#SetUndefined(l:keyvals)

  " Global user overrides of default values
  call vimside#options#manager#LoadUser()

  " ---------------------------------------------------------------------
  " Make sure all required options have valid values.
  " ---------------------------------------------------------------------

  let l:errors = g:vimside.errors

  " ---------------------------------------------------------------------
  " First, see if there is a local (up the cwd dir-chain) file
  " containing additional user set Options.
  " This can be used as a project specific override
  " ---------------------------------------------------------------------
  call vimside#options#manager#LoadProject(l:errors)


  " ---------------------------------------------
  " Locate the dot ensime file and directory
  " ---------------------------------------------

  let [found, l:efname] = g:vimside.GetOption('ensime-config-file-name')
  if found
call s:LOG("vimside#options#manager#Load: ensime-config-file-name=". l:efname)
  else
    let l:efname = ".ensime"
  endif

  " look in current directory and walk up directories until ensime
  " config file is found.
  let dir = getcwd()
call s:LOG("vimside#options#manager#Load: dir=". dir)
  while dir != '/'
    let l:tmp_config_file = dir . '/' . l:efname
call s:LOG("vimside#options#manager#Load: l:tmp_config_file=". l:tmp_config_file)
    if filereadable(l:tmp_config_file)
      break
    endif
    let dir = fnamemodify(dir, ":h")
call s:LOG("vimside#options#manager#Load: dir=". dir)
  endwhile

  if dir == '/'
    call add(l:errors, "Can find ensime config file: '" . l:efname ."'")
    return
  else
    if g:VimsideCheckDirectoryExists(dir, "r-x", l:errors)
      let l:ensime_config_file = dir . "/" . l:efname
call s:LOG("vimside#options#manager#Load: l:ensime_config_file=". l:ensime_config_file)
    else
      call add(l:errors, "Could not find ensime config file: '". l:efname ."'")
      return
    endif
  endif




  if ! filereadable(l:ensime_config_file)
    call add(l:errors, "Can not read ensime config file: '". l:ensime_config_file ."'")
    return
  endif

  let l:ensime_config_dir = fnamemodify(l:ensime_config_file, ':h')
call s:LOG("vimside#options#manager#Load: l:ensime_config_dir=". l:ensime_config_dir)
  call g:vimside.SetOption("ensime-config-dir", l:ensime_config_dir)
  call g:vimside.SetOption("ensime-config-file", l:ensime_config_file)




  " Do we have the Ensime Distribution path
  let got_ensime_dir = 0

  if g:vimside.HasOption("ensime-dist-path")
    let [found, l:distdirpath] = g:vimside.GetOption('ensime-dist-path')
    if ! found
      call add(l:errors, "Option not found: 'ensime-dist-path'")
    endif

    let got_ensime_dir = g:VimsideCheckDirectoryExists(l:distdirpath, "r-x", l:errors)
  endif
call s:LOG("vimside#options#manager#Load: got_ensime_dir=". got_ensime_dir)

  if ! got_ensime_dir && g:vimside.HasOption("ensime-install-path")
    let [found, l:path] = g:vimside.GetOption('ensime-install-path')
    if ! found
      call add(l:errors, "Option not found: 'ensime-install-path'")
    endif

    if ! g:VimsideCheckDirectoryExists(l:path, "r-x", l:errors)
      return
    endif
call s:LOG("vimside#options#manager#Load: ensime-install-path=". l:path)

    " envim uses: ensime-common/src/main/python/Helper.py findLastDist
    "   to look for latest distribution directory
    call g:vimside.CheckOption('ensime-dist-dir')

    let [found, l:distdir] = g:vimside.GetOption('ensime-dist-dir')
    if ! found
      call add(l:errors, "Option not found: 'ensime-dist-dir'")
      return
    endif
call s:LOG("vimside#options#manager#Load: ensime-dist-dir=". l:distdir)

    " Check that Java and Scala versions agree with Option values
    " Get Scala version from ensime distribution directory name
    let l:ensime_scala_version = matchlist(l:distdir, '[a-zA-Z]*_\(\d\+\.\d\+\.\d\+\)\(.*\)')[1]
call s:LOG("vimside#options#manager#Load: l:ensime_scala_version=". l:ensime_scala_version)
    let [found, l:vimside_scala_version] = g:vimside.GetOption('vimside-scala-version')
    if ! found
      call add(l:errors, "Option not found: 'vimside-scala-version'")
      return
    endif
call s:LOG("vimside#options#manager#Load: l:vimside_scala_version=". l:vimside_scala_version)

    " Only check major versions
    " Need to strip off trailing ".0" or ".1", etc.
    let l:esv = strpart(l:ensime_scala_version, 0, 4)
    let l:vsv = strpart(l:vimside_scala_version, 0, 4)

    if l:esv != l:vsv
      call add(l:errors, "Scala versions do not match: vimside:'". l:vimside_scala_version ."' and ensime:'". l:ensime_scala_version ."'")
      return
    endif

    let l:tmp = split(system("java -version"), "\n")[0]
    let l:ensime_java_version = matchlist(l:tmp, '[a-zA-Z ]* "\(\d\+\.\d\+\)\(.*\)"')[1]
call s:LOG("vimside#options#manager#Load: l:ensime_java_version=". l:ensime_java_version)
    let [found, l:vimside_java_version] = g:vimside.GetOption('vimside-java-version')
    if ! found
      call add(l:errors, "Option not found: 'vimside-java-version'")
      return
    endif
call s:LOG("vimside#options#manager#Load: l:vimside_java_version=". l:vimside_java_version)

    if l:ensime_java_version != l:vimside_java_version
      call add(l:errors, "Java versions do not match: vimside:'". l:vimside_java_version ."' and ensime:'". l:ensime_java_version ."'")
      return
    endif

    let l:distdirpath = l:path  . '/' . l:distdir
    let got_ensime_dir = g:VimsideCheckDirectoryExists(l:distdirpath, "r-x", l:errors)
  
    if got_ensime_dir
      call g:vimside.SetOption("ensime-dist-path", l:distdirpath)
    endif
  endif

  if ! got_ensime_dir
    call add(l:errors, "No Ensime Distribution path, set options 'ensime-install-path' or 'ensime-dist-path'")
    return
  endif

  let [found, l:use_cwd] = g:vimside.GetOption('vimside-use-cwd-as-output-dir')
  if ! found
    call add(l:errors, "Option not found: 'vimside-use-cwd-as-output-dir'")
    return
  endif


  " Is the Ensime port file (the file where Ensime writes it socket 
  "   listener port number)
  if g:vimside.HasOption("ensime-port-file-path")
    let [found, l:pfilepath] = g:vimside.GetOption('ensime-port-file-path')
    if ! found
      call add(l:errors, "Option not found: 'ensime-port-file-path'")
      return
    endif

    if filewritable(l:pfilepath) != 1
      let l:pfiledir=fnamemodify(l:pfilepath, ':h')
      if filewritable(l:pfiledir) != 2
        call add(l:errors, "Can not create Ensime port file in directory: '". l:pfiledir ."'")
        return
      endif
    endif
call s:LOG("vimside#options#manager#Load: ensime-port-file-path=". l:pfiledir)
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
      call add(l:errors, "Option not found: 'ensime-port-file-name'")
      return
    endif

    let value = portdir . '/' . l:pfilename
    call g:vimside.SetOption('ensime-port-file-path', value)
call s:LOG("vimside#options#manager#Load: ensime-port-file-path=". value)

  endif

  let [found, hostname] = g:vimside.GetOption('ensime-host-name')
  if ! found
    call add(l:errors, "Option not found: 'ensime-host-name'")
    return
  endif

  if ! vimproc#host_exists(hostname)
    call add(l:errors, "Can not find hostname: '". hostname ."'")
    return
  endif
call s:LOG("vimside#options#manager#Load: ensime-host-name=". hostname)

  let [found, cnt] = g:vimside.GetOption('ensime-port-file-max-wait')
  if ! found
    call add(l:errors, "Option not found: 'ensime-port-file-max-wait'")
    return
  endif

  if cnt < 0
    call add(l:errors, "Max port file creationg wait must be positive number: '". cnt ."'")
    return
  endif


  " Log for output of the Ensime Server
  if g:vimside.HasOption("ensime-log-file-path")
    let [found, l:lfilepath] = g:vimside.GetOption('ensime-log-file-path')
    if ! found
      call add(l:errors, "Option not found: 'ensime-log-file-path'")
      return
    endif

    if filewritable(l:lfilepath) != 1
      let l:lfiledir=fnamemodify(l:lfilepath, ':h')
      if filewritable(l:lfiledir) != 2
        call add(l:errors, "Can not create Ensime log file in directory: '". l:lfiledir ."'")
        return
      endif
    endif
call s:LOG("vimside#options#manager#Load: ensime-log-file-path=". l:lfilepath)
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
      call add(l:errors, "Option not found: 'ensime-log-file-name'")
      return
    endif

    let value = logdir . '/' . lfname

call s:LOG("vimside#options#manager#Load: ensime-log-file-path=". value)
    call g:vimside.SetOption('ensime-log-file-path', value)
  endif

  " Log for output of Vimside
  if g:vimside.HasOption("vimside-log-file-path")
    let [found, l:lfilepath] = g:vimside.GetOption('vimside-log-file-path')
    if ! found
      call add(l:errors, "Option not found: 'vimside-log-file-path'")
      return
    endif

    if filewritable(l:lfilepath) != 1
      let l:lfiledir=fnamemodify(l:lfilepath, ':h')
      if filewritable(l:lfiledir) != 2
        call add(l:errors, "Can not create Vimside log file in directory: '". l:lfiledir ."'")
        return
      endif
    endif
call s:LOG("vimside#options#manager#Load: vimside-log-file-path=". l:lfiledir)
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
      call add(l:errors, "Option not found: 'vimside-log-file-name'")
      return
    endif

    let value = logdir . '/' . lfname
call s:LOG("vimside#options#manager#Load: vimside-log-file-path=". value)

    call g:vimside.SetOption('vimside-log-file-path', value)
  endif

call s:LOG("vimside#options#manager#Load: BOTTOM")
endfunction


" args:
"   optional:
"     filename: file to write to
"     force: 1 overwrite 
" example: call vimside#options#manager#OutputProperties('PROPERTIES', 1)
function! vimside#options#manager#OutputProperties(...)
  let l:call = "call vimside#options#manager#OutputProperties("
  if a:0 == 1
    let l:has_file = 1
    let l:filename = a:1
    let l:force = 0

    let l:call .= "'". l:filename ."'"
  elseif a:0 == 2
    let l:has_file = 1
    let l:filename = a:1
    let l:force = a:2

    let l:call .= "'". l:filename ."', ". l:force
  else
    let l:has_file = 0
  endif
  let l:call .= ")"
    
  if l:has_file
    let l:s = getfsize(l:filename)
    if l:s == 0
      echoerr "Can not write to directory: ". l:filename
      return
    elseif l:s == -1
      " file does not exists
    else
      " file exists
      if ! l:force
        echoerr "Can not overwrite file: ". l:filename ." use force==1"
        return
      endif
    endif

    execute "redir >> ". l:filename

    let l:is_silent = 1
  else
    let l:is_silent = 0
  endif
  " call vimside#options#defined#Load(g:vimside.options)

  let l:datetime = exists("*strftime")
          \ ? strftime("%Y%m%d-%H%M%S: ") : "" . localtime() . ": "
  if l:is_silent
    silent echo "#"
    silent echo "# Vimside Options"
    silent echo "# Generated on: ". l:datetime
    silent echo "# By calling: ". l:call
    silent echo "#"
  else
    echo "#"
    echo "# Vimside Options"
    echo "# Generated on: ". l:datetime
    echo "# By calling: ". l:call
    echo "#"
  endif

  let l:defined = g:vimside.options.defined
  let l:user = g:vimside.options.user
  let l:default = g:vimside.options.default

  let l:no_value_set = '<No Value Set>'

  for l:opt in sort(keys(l:defined))
    let l:key = substitute(l:opt, '-', '.', "g")
    let l:value = l:defined[l:opt] 

    if l:is_silent
      silent echo "# Option: ". l:opt
      if has_key(l:value, 'parent')
        silent echo "# parent: ". l:value.parent
      endif
      silent echo "# description:"
    else
      echo "# Option: ". l:opt
      if has_key(l:value, 'parent')
        echo "# parent: ". l:value.parent
      endif
      echo "# description:"
    endif

    if has_key(l:value, 'description')
      for l:s in l:value['description']
        if l:is_silent
          silent echo "#   ". l:s
        else
          echo "#   ". l:s
        endif
      endfor
    endif

    if has_key(l:default.keyvals, l:opt) 
      let l:current_value= l:default.keyvals[l:opt]
      if l:is_silent
        silent echo "# default value: ". string(l:current_value)
      else
        echo "# default value: ". string(l:current_value)
      endif
    else
      if l:is_silent
        silent echo "# default value: ". l:no_value_set
      else
        echo "# default value: ". l:no_value_set
      endif
    endif

    if has_key(l:user.keyvals, l:opt) 
      let l:current_value= l:user.keyvals[l:opt]
      if l:is_silent
        silent echo "# user value: ". string(l:current_value)
      else
        echo "# user value: ". string(l:current_value)
      endif
    else
      if l:is_silent
        silent echo "# user value: ".  l:no_value_set
      else
        echo "# user value: ".  l:no_value_set
      endif
    endif

    if exists("l:current_value")
      if l:is_silent
        silent echo l:key ."=". string(l:current_value)
      else
        echo l:key ."=". string(l:current_value)
      endif
      unlet l:current_value
    else
      if l:is_silent
        silent echo "# ". l:key ."=". l:no_value_set
      else
        echo "# ". l:key ."=". l:no_value_set
      endif
    endif
    if l:is_silent
      silent echo " "
    else
      echo " "
    endif
  endfor

  if l:has_file
    execute "redir END"
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
