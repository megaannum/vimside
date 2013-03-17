
" This check assumes that all directories/files are local to current machine.
" Syntatic check (not semantics)
" return [pass-or-fail, list-of-error-messages]
" return [1, []]
" return [0, ["msg..", "msg..", ...]]
function! vimside#ensime#config#Check(sexp)
  let l:rval = 1
  let l:errmsg = []

  let key = ":root-dir"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if ! isdirectory(value)
      call add(l:errmsg, "Not Directory key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['root_dir'] = value
    endif
  else
    echoerr "Check Ensime Config: not found " . key
    let l:rval = 0
  endif
  unlet value

  let key = ":name"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type('')
      call add(l:errmsg, "Not String key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['name'] = value
    endif
  else
    echoerr "Check Ensime Config: not found " . key
    let l:rval = 0
  endif
  unlet value

  let key = ":module-name"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type('')
      call add(l:errmsg, "Not String key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['module_name'] = value
    endif
  endif
  unlet value

  let key = ":active-subproject"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type('')
      call add(l:errmsg, "Not String key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['active_subproject'] = value
    endif
  endif
  unlet value

  let key = ":version"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type('')
      call add(l:errmsg, "Not String key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['version'] = value
    endif
  endif
  unlet value

  let key = ":package"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type('')
      call add(l:errmsg, "Not String key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['package'] = value
    endif
  endif
  unlet value

  let key = ":compile-deps"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['compiler_deps'] = value
  endif
  unlet value

  let key = ":compile-jars"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['compiler_jars'] = value
  endif
  unlet value

  let key = ":runtime-deps"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['runtime_deps'] = value
  endif
  unlet value

  let key = ":runtime-jars"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['runtime_jars'] = value
  endif
  unlet value

  let key = ":test-deps"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['test_deps'] = value
  endif
  unlet value

  let key = ":source-roots"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let source_roots = []
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          else
            call add(source_roots, strval) 
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
      let g:vimside.project.info['source_roots'] = source_roots
    endif 
  endif
  unlet value

  let key = ":reference-source-roots"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let reference_source_roots = []
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) && ! filereadable(strval)
            call add(l:errmsg, "Not Directory or File key(" . key . ") value:" . string(strval))
            let l:rval = 0
          else
            call add(reference_source_roots, strval) 
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
      let g:vimside.project.info['reference_source_roots'] = reference_source_roots
    endif
  endif
  unlet value

  let key = ":target"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if ! isdirectory(value)
      call add(l:errmsg, "Not Directory key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['target'] = value
    endif
  endif
  unlet value

  let key = ":test-target"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if ! isdirectory(value)
      call add(l:errmsg, "Not Directory key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['test-target'] = value
    endif
  endif
  unlet value

  let key = ":disable-index-on-startup"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type(0)
      call add(l:errmsg, "Not Boolean key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['disable_index_on_startup'] = value
    endif
  endif
  unlet value

  let key = ":disable-source-load-on-startup"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type(0)
      call add(l:errmsg, "Not Boolean key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['disable_source_load_on_startup'] = value
    endif
  endif
  unlet value

  let key = ":disable-scala-jars-on-classpath"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type(0)
      call add(l:errmsg, "Not Boolean key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['disable_scala_jars_on_classpath'] = value
    endif
  endif
  unlet value

  let key = ":only-include-in-index"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if type(strval) != type("")
            call add(l:errmsg, "Not String key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['only_include_in_index'] = value
  endif
  unlet value

  let key = "::exclude-from-index"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if type(strval) != type("")
            call add(l:errmsg, "Not String key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['exclude_from_index'] = value
  endif
  unlet value

  let key = ":compiler-args"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if type(strval) != type("")
            call add(l:errmsg, "Not String key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['compiler_args'] = value
  endif
  unlet value

  let key = ":builder-args"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if type(strval) != type("")
            call add(l:errmsg, "Not String key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['builder_args'] = value
  endif
  unlet value

  let key = ":java-compiler-args"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if type(strval) != type("")
            call add(l:errmsg, "Not String key(" . key . ") value:" . string(strval))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['java_comipler_args'] = value
  endif
  unlet value

  let key = ":java-compiler-version"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type("")
      call add(l:errmsg, "Not String key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let g:vimside.project.info['java_comipler_version'] = value
    endif
  endif
  unlet value

  let key = ":sources"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      for child in value
        let [found, strval] = vimside#sexp#Get_StringValue(child) 
        if found
          if ! isdirectory(strval) 
            call add(l:errmsg, "Not Directory key(" . key . ") value:" . string(child))
            let l:rval = 0
          endif
        else
          call add(l:errmsg, "Not SExp String key(" . key . ") value:" . string(child))
        endif
        unlet strval
      endfor
    endif
    let g:vimside.project.info['sources'] = value
  endif
  unlet value

  let key = ":formatting-prefs"
  let [found, value] = vimside#sexp#ValueOfKey(a:sexp, key) 
  if found
    if type(value) != type([])
      call add(l:errmsg, "Not List key(" . key . ") value:" . string(value))
      let l:rval = 0
    else
      let len = len(value)
      let cnt = 0
      while cnt < len
        let kw_sexp = value[cnt]
        let cnt += 1
        let val_sexp = value[cnt]
        let cnt += 1
        let [found, kw] = vimside#sexp#Get_KeywordValue(kw_sexp) 

        if kw == ':alignParameters'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':alignSingleLineCaseStatements'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':alignSingleLineCaseStatements_maxArrowIndent'
          let [found, val] = vimside#sexp#Get_IntValue(val_sexp) 
          if found
            if val < 1 || val > 100
              call add(l:errmsg, "Not Formatting Preference key(" . kw . ") out of bounds value:" . string(val))
              let l:rval = 0
            endif
          else
            call add(l:errmsg, "Not Int key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':compactControlReadability'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':compactStringConcatenation'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':doubleIndentClassDeclaration'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':indentLocalDefs'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':indentPackageBlocks'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':indentSpaces'
          let [found, val] = vimside#sexp#Get_IntValue(val_sexp) 
          if found
            if val < 1 || val > 10
              call add(l:errmsg, "Not Formatting Preference key(" . kw . ") out of bounds value:" . string(val))
              let l:rval = 0
            endif
          else
            call add(l:errmsg, "Not Int key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':indentWithTabs'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':multilineScaladocCommentsStartOnFirstLine'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':placeScaladocAsterisksBeneathSecondAsterisk'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':preserveDanglingCloseParenthesis'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':preserveSpaceBeforeArguments'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':rewriteArrowSymbols'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':spaceBeforeColon'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':spaceInsideBrackets'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':spaceInsideParentheses'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        elseif kw == ':spacesWithinPatternBinders'
          let [found, val] = vimside#sexp#Get_BoolValue(val_sexp) 
          if ! found
            call add(l:errmsg, "Not Boolean key(" . kw . ") value:" . string(val))
            let l:rval = 0
          endif
        else
            call add(l:errmsg, "Unknown Formatting Preferense key(" . kw . ")")
            let l:rval = 0
        endif

      endwhile
    endif
    let g:vimside.project.info['formatting_prefs'] = value
  endif
  unlet value

  return [l:rval, l:errmsg]
endfunction

