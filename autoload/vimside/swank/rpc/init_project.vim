" ============================================================================
" init_project.vim
"
" File:          vimside#swank#rpc#conection_info.vim
" Summary:       Vimside RPC init-project
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Initialize the server with a project configuration. The server returns
" it's own knowledge about the project, including source roots which can 
" be used by clients to determine whether a given source file belongs 
" to this project.
"
" Arguments:
"   A complete ENSIME configuration property list. See manual.
"
" Return:
" (
"   :project-name //String:The name of the project.
"   :source-roots //List of Strings:The source code directory roots..
" )
"
" Example:
"
" (:swank-rpc (swank:init-project (:use-sbt t :compiler-args
" (-Ywarn-dead-code -Ywarn-catches -Xstrict-warnings)
" :root-dir /Users/aemon/projects/ensime/)) 42)
"
" (:return (:ok (:project-name "ensime"
" :source-roots
" ("/Users/aemon/projects/ensime/src/main/scala"
" "/Users/aemon/projects/ensime/src/test/scala"
" "/Users/aemon/projects/ensime/src/main/java")))
" 42)
"
" Events:
"
" (:background-message 105 "Initializing Analyzer. Please wait...")
" (:java-notes (:is-full nil :notes ((...))))
" (:indexer-ready)
" (:compiler-ready)
" (:full-typecheck-finished) 
"
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

" public API
function! vimside#swank#rpc#init_project#Run(...)
call s:LOG("InitProject TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-init-project-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-init-project-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  let l:rr.events = 'many'
  call vimside#ensime#swank#dispatch(l:rr)

  call vimside#scheduler#StartAuto()


if 0 " AAAAA TEST
call s:LOG("InitProject l:rr=". string(l:rr)) 

  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, {}, s:Handler, [l:rr])
call s:LOG("InitProject l:rr=". string(l:rr)) 

let l:dd={'caller': 'g:InitProjectCaller', 'args': {}, 'handler': {'abort': 'g:InitProjectHandler_Abort', 'ok': 'g:InitProjectHandler_Ok'}}
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, {}, s:Handler, [l:dd])
call s:LOG("InitProject l:rr=". string(l:rr)) 
endif " AAAAA
  
call s:LOG("InitProject BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:InitProjectCaller(args)
  let cmd = "swank:init-project"

  let [found, ensime_config_file] = g:vimside.GetOption('ensime_config_file')
  if ! found
    throw "Option not found: " . 'ensime_config_file'
  endif

call s:LOG("InitProject ensime_config_file=". string(ensime_config_file)) 
  
  let sexp = vimside#sexp#LoadFile(ensime_config_file)

  let [ok, errmsgs] = vimside#ensime#config#Check(sexp)
  if ! ok
    throw "ERROR: Ensime Config: " . string(errmsgs)
  endif

  let ensime_config = vimside#sexp#ToWireString(sexp)

  return '('. cmd .' '. ensime_config .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:InitProjectHandler()

  function! g:InitProjectHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:InitProjectHandler_Ok(projectInfo)
call s:LOG("InitProjectHandler_Ok ".  vimside#sexp#ToString(a:projectInfo)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:projectInfo) 
    if ! found 
      echoe "InitProject ok: Badly formed Response"
      call s:ERROR("InitProject ok: Badly formed Response: ". string(a:projectInfo)) 
      return 0
    endif
call s:LOG("InitProjectHandler_Ok dic=".  string(dic)) 

    let l:name = dic[':project-name']

    let g:vimside.project.info['name'] = l:name
if 0
" this includes both sourceRoots and referenceSourceRoots
    let l:source_roots = dic[':source-roots']
    let g:vimside.project.info['source_roots'] = l:source_roots
endif

    return 1
  endfunction

  return { 
    \ 'abort': function("g:InitProjectHandler_Abort"),
    \ 'ok': function("g:InitProjectHandler_Ok") 
    \ }
endfunction
