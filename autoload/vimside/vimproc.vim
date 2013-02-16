" ============================================================================
" vimproc.vim
"
" File:          vimproc.vim
" Summary:       Vimside Vimproc functions
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
" Functions that call Vimproc.
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

" return [1, path] or [0, err_msg]
function! vimside#vimproc#ExistsExecutable(cmd)
  let [status, out, err] = vimside#vimproc#execute_which(a:cmd)
" call s:LOG("vimside#vimproc#ExistsExecutable: status=". status .", out=". out .", err=". err)
  return (status == 0) ? [1, out] : [0, err]
endfunction



function! vimside#vimproc#execute_cmd(cmdline, ...)
  " Expand % and #.
  let cmdline = join(map(vimproc#parser#split_args_through(
           \ vimproc#util#iconv(a:cmdline, vimproc#util#termencoding(), &encoding)), 
            \ 'substitute(expand(v:val), "\n", " ", "g")'))

  " Open pipe.
  let subproc = vimproc#pgroup_open(cmdline, 1)

  if a:0 == 1
    call subproc.stdin.write(a:1)
  elseif a:0 > 1
    throw "vimside#vimproc#execute_cmd TOO many arguments: ". string(a:000)
  endif

  call subproc.stdin.close()

  let stdout = ''
  let stderr = ''

  while !subproc.stdout.eof || !subproc.stderr.eof
    if !subproc.stdout.eof
      let output = subproc.stdout.read(10000, 0)
      if output != ''
        let output = vimproc#util#iconv(output, vimproc#util#stdoutencoding(), &encoding)
        let stdout .= output
        sleep 1m
      endif
    endif

    if !subproc.stderr.eof
      let output = subproc.stderr.read(10000, 0)
      if output != ''
        let output = vimproc#util#iconv(output, vimproc#util#stderrencoding(), &encoding)
        let stderr .= output
        sleep 1m
      endif
    endif
  endwhile

  call subproc.stdout.close()
  call subproc.stderr.close()

  let [cond, last_status] = subproc.waitpid()

  return [last_status, stdout, stderr]
endfunction

function! vimside#vimproc#start_cmd(cmdline, ...)
  " Expand % and #.
  let cmdline = join(map(vimproc#parser#split_args_through(
           \ vimproc#util#iconv(a:cmdline, vimproc#util#termencoding(), &encoding)), 
            \ 'substitute(expand(v:val), "\n", " ", "g")'))

  " Open pipe.
  let subproc = vimproc#pgroup_open(cmdline, 1)

  if a:0 == 1
    call subproc.stdin.write(a:1)
  elseif a:0 > 1
    throw "vimside#vimproc#start_cmd TOO many arguments: ". string(a:000)
  endif

  call subproc.stdin.close()

  return subproc
endfunction

function! vimside#vimproc#execute_which(cmd)
  let cmdline = "which ". a:cmd

  " Expand % and #.
  let cmdline = join(map(vimproc#parser#split_args_through(
           \ vimproc#util#iconv(cmdline, vimproc#util#termencoding(), &encoding)), 
            \ 'substitute(expand(v:val), "\n", " ", "g")'))

  " Open pipe.
  let subproc = vimproc#pgroup_open(cmdline, 1)

  call subproc.stdin.close()

  let stdout = ''
  let stderr = ''

  while !subproc.stdout.eof || !subproc.stderr.eof
    if !subproc.stdout.eof
      let output = subproc.stdout.read(10000, 0)
      if output != ''
        let output = vimproc#util#iconv(output, vimproc#util#stdoutencoding(), &encoding)
        let stdout .= output
        sleep 1m
      endif
    endif

    if !subproc.stderr.eof
      let output = subproc.stderr.read(10000, 0)
      if output != ''
        let output = vimproc#util#iconv(output, vimproc#util#stderrencoding(), &encoding)
        let stderr .= output
        sleep 1m
      endif
    endif
  endwhile

  call subproc.stdout.close()
  call subproc.stderr.close()

  let [cond, last_status] = subproc.waitpid()

  let stdout = substitute(stdout, "\n", "", "g")
  let stderr = substitute(stderr, "\n", "", "g")

  return [last_status, stdout, stderr]
endfunction

