" ============================================================================
" inspect_package_by_path.vim
"
" File:          vimside#swank#rpc#inspect_package_by_path.vim
" Summary:       Vimside RPC inspect-package-by-path
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2012
"
" ============================================================================
" Intro: {{{1
"
" Get a detailed description of the given package.
"
" Arguments:
"   String:A qualified package name.
" Return:
"   A PackageInfo
"
" Example:
"
" (:swank-rpc (swank:inspect-package-by-path "org.ensime.util" 36483) 42)
"
" (:return 
" (:ok 
" (:name "util" :info-type package :full-name
" "org.ensime.util"
" :members ((:name "BooleanAtom" :type-id 278 :full-name
" "org.ensime.util.BooleanAtom" :decl-as class :pos
" (:file "SExp.scala" :offset 2848)).....))
" 42)
"
" ============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


" public API
function! vimside#swank#rpc#inspect_package_by_path#Run(...)
call s:LOG("inspect_package_by_path TOP") 

  if ! exists("s:Handler")
    let s:Handler = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-inspect-package-by-path-handler')
    let s:Caller = vimside#swank#rpc#util#LoadFuncrefFromOption('swank-rpc-inspect-package-by-path-caller')
  endif

  let l:args = { }
  let l:rr = vimside#swank#rpc#util#MakeRPCEnds(s:Caller, l:args, s:Handler, a:000)
  " call vimside#ensime#swank#dispatch(l:rr)

  let msg = "Not Implemented Yet:" . 'swank-rpc-inspect-package-by-path-handler'
  call s:ERROR(msg)
  echoerr msg

call s:LOG("inspect_package_by_path BOTTOM") 
endfunction


"======================================================================
" Vimside Callers
"======================================================================

function! g:InspectPackageByPathCaller(args)
  let cmd = "swank:inspect-package-by-path"

  return '('. cmd .')'
endfunction


"======================================================================
" Vimside Handlers
"======================================================================

function! g:InspectPackageByPathHandler()

  function! g:InspectPackageByPathHandler_Abort(code, details, ...)
    call call('vimside#swank#rpc#util#Abort', [a:code, a:details] + a:000)
  endfunction

  function! g:InspectPackageByPathHandler_Ok(InspectPackageByPath)
call s:LOG("InspectPackageByPathHandler_Ok ".  vimside#sexp#ToString(a:InspectPackageByPath)) 
    let [found, dic] = vimside#sexp#Convert_KeywordValueList2Dictionary(a:InspectPackageByPath) 
    if ! found 
      echoe "InspectPackageByPath ok: Badly formed Response"
      call s:ERROR("InspectPackageByPath ok: Badly formed Response: ". string(a:InspectPackageByPath)) 
      return 0
    endif
call s:LOG("InspectPackageByPathHandler_Ok dic=".  string(dic)) 

    let l:pid = dic[':pid']



    return 1

  endfunction

  return { 
    \ 'abort': function("g:InspectPackageByPathHandler_Abort"),
    \ 'ok': function("g:InspectPackageByPathHandler_Ok") 
    \ }
endfunction
