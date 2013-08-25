" ============================================================================
" version.vim
"
" File:          version.vim
" Summary:       Vimside Version
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
"
" ============================================================================
" Intro: {{{1
" Might attempt to do Semantic Versioning. See http://semver.org/
" ============================================================================

let s:version_major = 0
let s:version_minor = 4
let s:version_patch = 0
let s:version_pre_release = ''
" build version is not applicable

let s:version_str = ''. s:version_major 
let s:version_str .= '.'. s:version_minor
let s:version_str .= '.'. s:version_patch
if s:version_pre_release != ''
  let s:version_str .= '-'. s:version_pre_release
endif

" return list of [major_nos, minor_nos, patch_nos, pre_release_str]
function! vimside#version#Values()
  return [ s:version_major, s:version_minor, s:version_patch, s:version_pre_release ]
endfunction

function! vimside#version#Str()
  return s:version_str
endfunction
