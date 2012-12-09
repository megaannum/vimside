"============================================================================
" File:         sourcebrowser.vim
" Brief:        Vimside Plugin: Root Sources Manager
" Author:       Ming Bai <mbbill AT gmail DOT com>
" ModifiedBy:   Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Change:  2012
" BasedUponVersion:      0.99
" Licence:               LGPL
" Modifications:
"  Instead of having one or more top-level directories, the directories
"    can not only be top-level but also any particular place in the
"    system's directory hierarchies. This is used to seed the viewer
"    with what Ensime calls the 'source root' directories and the 
"    'reference source root' directories.
"  Values that can be set by a user are not set using the Vimside option
"    approach.
"  The names of the 'classes' have been changed.
"  Selecting a source file, basically any non-executable file in one of 
"    the seed directories, results in a tab or split-window being opened
"    on that file or a new instance of Vim/GVim being invoked (and,
"    for a 'source root', connected to Ensime server).
"  Logging has been added.
"
"
"============================================================================
" Info:
"============================================================================

if 0
let s:CWD = getcwd()
function! s:LOG(msg)
  execute "redir >> ". s:CWD ."/SR_LOG"
  silent echo "INFO: ". a:msg
  execute "redir END"
endfunction
function! s:ERROR(msg)
  execute "redir >> ". s:CWD ."/SR_LOG"
  silent echo "ERROR: ". a:msg
  execute "redir END"
endfunction

else

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")
endif


if 0 " TOPSTUFF
" See if we are already loaded, thanks to Dennis Hostetler.
if exists("loaded_vimExplorer")
  finish
endif
let loaded_vimExplorer = 1


" Vim version 7.x is needed.
if v:version < 700
   echohl ErrorMsg | echomsg "VimExplorer needs vim version >= 7.0!" | echohl None
   finish
endif
endif " TOPSTUFF

if 0 " SOURCEROOTS
" ------------------------------
"  source root
" ------------------------------
let s:base_dir = "/home/emberson/.vim/data/vimside/"
let s:source_roots = [ 
                \ s:base_dir . "src/main/java/",
                \ s:base_dir . "src/main/scala/"
                \ ]

let s:java_home = $JAVA_HOME
let s:scala_home = $SCALA_HOME

let s:reference_source_roots = [
                \ s:java_home . "/src/",
                \ s:scala_home . "/src/library/",
                \ s:scala_home . "/src/compiler/"
                \ ]
endif " SOURCEROOTS


"Load config {{{1
"#######################################################################
"VimExplorer configuration.

let g:conf = {}

"Normal configurations.

"Common settings
"==========================================

let g:conf.system_encoding = ''

let g:conf.browser_history = 100
let g:conf.preview_split_location = "belowright"
let g:conf.show_hidden_files = 1

"External explorer name
" TODO remove
" if (has("win32") || has("win95") || has("win64") || has("win16") || has("dos32"))
if g:vimside.os.is_mswin
    let g:conf.external_explorer = "explorer.exe"
else
    let g:conf.external_explorer = "nautilus"
endif

let g:conf.sort_case_sensitive = 0
let g:conf.favorite = ".ve_favorite"
let g:conf.over_write_existing = 0
let g:conf.recycle_path = ''

"Kde or gonme.
if !exists("g:VEConf_usingKDE")
    let g:VEConf_usingKDE = 0
endif
if !exists("g:VEConf_usingGnome")
    let g:VEConf_usingGnome = 0
endif


"Tree panel settings
"==========================================

let g:conf.show_folder_status = 1
let g:conf.tree_panel_width = 30
let g:conf.tree_panel_split_mode = "vertical"
let g:conf.tree_panel_split_location = "leftabove"
let g:conf.tree_sort_direction = 1

"File panel settings
"==========================================
let g:conf.file_group_sort_direction = 1
let g:conf.file_delete_confirm = 1
let g:conf.file_panel_width = 40
let g:conf.file_panel_split_mode = "vertical"
let g:conf.file_panel_split_location = "belowright"
let g:conf.file_panel_sort_type = 0
let g:conf.show_file_size_in_mkb = 1
    let g:conf.file_panel_filter = ''


"#######################################################################
"Tree panel hot key bindings.
let g:conf.tree_panel_hotkey = {}
let g:conf.tree_panel_hotkey.help            = '?'
let g:conf.tree_panel_hotkey.toggleNode      = '<cr>'
let g:conf.tree_panel_hotkey.toggleNodeMouse = '<2-LeftMouse>'
let g:conf.tree_panel_hotkey.refresh         = 'r'
let g:conf.tree_panel_hotkey.favorite        = 'f'
let g:conf.tree_panel_hotkey.addToFavorite   = 'F'
let g:conf.tree_panel_hotkey.browser_history   = 'b'
let g:conf.tree_panel_hotkey.toggleFilePanel = 't'
let g:conf.tree_panel_hotkey.toUpperDir      = '<bs>'
let g:conf.tree_panel_hotkey.switchPanel     = '<c-tab>'
let g:conf.tree_panel_hotkey.gotoPath        = '<c-g>'
let g:conf.tree_panel_hotkey.quitVE          = 'Q'

if exists("g:VEConf_treeHotkey")
  if type(g:VEConf_treeHotkey) != type({})
    echohl WarningMsg | echo "g:VEConf_treeHotkey is not dictionary type!" | echohl None
    finish
  endif
  for i in keys(g:VEConf_treeHotkey)
    let g:conf.tree_panel_hotkey[i] = g:VEConf_treeHotkey[i]
  endfor
endif

"File panel hot key bindings.
"normal mode hotkeys
let g:conf.file_panel_hotkey = {}
"normal
let g:conf.file_panel_hotkey.help            = '?'
let g:conf.file_panel_hotkey.itemClicked     = '<cr>'
let g:conf.file_panel_hotkey.itemClickMouse  = '<2-LeftMouse>'
let g:conf.file_panel_hotkey.refresh         = 'r'
let g:conf.file_panel_hotkey.toggleTreePanel = 't'
let g:conf.file_panel_hotkey.toggleModes     = 'i'
let g:conf.file_panel_hotkey.newFile         = '+f'
let g:conf.file_panel_hotkey.newDirectory    = '+d'
let g:conf.file_panel_hotkey.switchPanel     = '<c-tab>'
let g:conf.file_panel_hotkey.quitVE          = 'Q'
let g:conf.file_panel_hotkey.toggleHidden    = 'H'
let g:conf.file_panel_hotkey.search          = 'g/'
let g:conf.file_panel_hotkey.markPlace       = 'm'
let g:conf.file_panel_hotkey.gotoPlace       = "'"
let g:conf.file_panel_hotkey.viewMarks       = 'J'
let g:conf.file_panel_hotkey.contextMenuN    = '<rightmouse>'
"Browsing
let g:conf.file_panel_hotkey.toUpperDir      = '<bs>'
let g:conf.file_panel_hotkey.gotoForward     = '<c-i>'
let g:conf.file_panel_hotkey.gotoBackward    = '<c-o>'
let g:conf.file_panel_hotkey.favorite        = 'f'
let g:conf.file_panel_hotkey.addToFavorite   = 'F'
let g:conf.file_panel_hotkey.browser_history   = 'b'
let g:conf.file_panel_hotkey.gotoPath        = '<c-g>'
"single file actions
let g:conf.file_panel_hotkey.rename          = 'R'
let g:conf.file_panel_hotkey.yankSingle      = 'yy'
let g:conf.file_panel_hotkey.cutSingle       = 'xx'
let g:conf.file_panel_hotkey.showYankList    = 'yl'
let g:conf.file_panel_hotkey.deleteSingle    = 'dd'
let g:conf.file_panel_hotkey.deleteSingleF   = 'DD'
let g:conf.file_panel_hotkey.openPreview     = 'u'
let g:conf.file_panel_hotkey.closePreview    = 'U'
"mark
let g:conf.file_panel_hotkey.toggleSelectUp  = '<s-space>'
let g:conf.file_panel_hotkey.toggleSelectDown= '<space>'
let g:conf.file_panel_hotkey.toggleSelMouse  = '<c-LeftMouse>'
let g:conf.file_panel_hotkey.markViaRegexp   = 'Mr'
let g:conf.file_panel_hotkey.markVimFiles    = 'Mv'
let g:conf.file_panel_hotkey.markDirectory   = 'Md'
let g:conf.file_panel_hotkey.markExecutable  = 'Me'
let g:conf.file_panel_hotkey.clearSelect     = 'Mc'
"multiple file actions
let g:conf.file_panel_hotkey.deleteSelected  = 'sd'
let g:conf.file_panel_hotkey.deleteSelectedF = 'sD'
let g:conf.file_panel_hotkey.yankSelected    = 'sy'
let g:conf.file_panel_hotkey.cutSelected     = 'sx'
let g:conf.file_panel_hotkey.tabViewMulti    = 'se'
let g:conf.file_panel_hotkey.paste           = 'p'
let g:conf.file_panel_hotkey.diff2files      = '='
"visual mode hotkeys.
let g:conf.file_panel_hotkey.visualSelect    = '<space>'
let g:conf.file_panel_hotkey.visualDelete    = 'd'
let g:conf.file_panel_hotkey.visualDeleteF   = 'D'
let g:conf.file_panel_hotkey.visualYank      = 'y'
let g:conf.file_panel_hotkey.visualCut       = 'x'
"User defined hotkeys, see below.
let g:conf.file_panel_hotkey.tabView         = 'e'
let g:conf.file_panel_hotkey.openRenamer     = ';r'
let g:conf.file_panel_hotkey.startShell      = ';c'
let g:conf.file_panel_hotkey.startExplorer   = ';e'

if exists("g:VEConf_fileHotkey")
  if type(g:VEConf_fileHotkey) != type({})
    echohl WarningMsg | echo "g:VEConf_fileHotkey is not dictionary type!" | echohl None
    finish
  endif
  for i in keys(g:VEConf_fileHotkey)
    let g:conf.file_panel_hotkey[i] = g:VEConf_fileHotkey[i]
  endfor
endif

"#######################################################################
"User defined file actions.
if !exists("g:VEConf_normalActions")
  let g:VEConf_normalActions = {}
endif
if !exists("g:VEConf_normalHotKeys")
  let g:VEConf_normalHotKeys = {}
endif
if !exists("g:VEConf_singleFileActions")
  let g:VEConf_singleFileActions = {}
endif
if !exists("g:VEConf_singleFileHotKeys")
  let g:VEConf_singleFileHotKeys = {}
endif

if !exists("g:VEConf_multiFileActions")
  let g:VEConf_multiFileActions = {}
endif
if !exists("g:VEConf_multiFileHotKeys")
  let g:VEConf_multiFileHotKeys = {}
endif

"Template
"   let g:VEConf_singleFileHotKeys['actionName'] = '<hot_key>'
"   function! g:VEConf_singleFileActions['actionName'](path)
"       "do some jobs here.
"   endfunction
"
"the 'path' is the file name under cursor in the file panel, you
"can use this path to do some actions.
"Pay attention to the hotKeys you have defined, dont conflict
"whth the default hotKey bindings.
"Normal Actions just run in current path, no path needed to
"pass.

"There are some examples:
"Open current file using vim in a new tab.
let g:VEConf_singleFileHotKeys['openInNewTab'] = g:conf.file_panel_hotkey.tabView
function! g:VEConf_singleFileActions['openInNewTab'](path)
  if !isdirectory(a:path)
    exec "tabe " . g:platform.escape(a:path)
  else
    exec "VE " . g:platform.escape(a:path)
  endif
endfunction

"Renamer is a very good plugin.
let g:VEConf_normalHotKeys['openRenamer'] = g:conf.file_panel_hotkey.openRenamer
function! g:VEConf_normalActions['openRenamer']()
  Renamer
endfunction

"start shell in current directory.
let g:VEConf_normalHotKeys['startShell'] = g:conf.file_panel_hotkey.startShell
function! g:VEConf_normalActions['startShell']()
  call g:platform.startShell()
endfunction

"start file explorer in current directory
"(nautilus, konquer, Explorer.exe and so on).
let g:VEConf_normalHotKeys['startExplorer'] = g:conf.file_panel_hotkey.startExplorer
function! g:VEConf_normalActions['startExplorer']()
  call g:platform.startExplorer()
endfunction

"Multiple file name are contained in the fileList.
let g:VEConf_multiFileHotKeys['openMultiFilesWithVim'] = g:conf.file_panel_hotkey.tabViewMulti
function! g:VEConf_multiFileActions['openMultiFilesWithVim'](fileList)
  if ! empty(a:fileList)
    for i in a:fileList
      exec "tabe " . g:platform.escape(i)
    endfor
  endif
endfunction

"#######################################################################
"Syntax and highlight configuration.
function! g:Conf_tree_panel_syntax() dict
  syn clear
  syn match Title "^.*Directories.*$" 
  syn match WarningMsg "\[[a-zA-Z_\- ]*\/\]" "root node name
  syn match Identifier "^\s*\zs[+-]" "+-
  " syn match SpecialKey "\[current\]$" "current folder
  syn match SpecialKey "<-$" "current folder
endfunction
let g:conf.treePanelSyntax = function("g:Conf_tree_panel_syntax")

function! g:Conf_file_panel_syntax() dict
  syntax clear
  syn match Type "\[ .* \]" "group
  syn match Comment '\t.\{10}' "file size
  syn match Comment '\d\{4}-\d\{2}-\d\{2}\ \d\{2}:\d\{2}:\d\{2}' "time
  syn match Special '^Directory: .*$'         "last directory in path
  syn match WarningMsg '^\~*$' "line
  syn match Function '^.*[\\/]' "directory
  syn match Search '^\*.*$'  "selectedFiles
  syn match LineNr '[rwx-]\{9}' "perm
endfunction
let g:conf.filePanelSyntax = function("g:Conf_file_panel_syntax")

"#######################################################################

" classes relationship
"
" FrameWork
"    TreePanel
"       Tree
"           Node
"    FilePanel
" platform

" class platform {{{1
"=============================
let g:platform = {}

"it's a static class, no constructor

"has win
function! g:platform.haswin32()
  " TODO remove
  " return (has("win32") || has("win95") || has("win64") || has("win16") || has("dos32"))
  return g:vimside.os.is_mswin
endfunction

let s:is_windoz = g:platform.haswin32() 
let s:is_windoz_like = s:is_windoz && !&ssl


"return a path always end with slash.
function! g:platform.getcwd()
  let path = getcwd()
  if s:is_windoz_like
    if path[-1:] != "\\"
      let path = path . "\\"
    endif
  else
    if path[-1:] != "/"
      let path = path . "/"
    endif
  endif
  return path
endfunction

"get home path, end with a slash
function! g:platform.getHome()
  if s:is_windoz_like
    if $HOME[-1:] != "\\"
      return $HOME . "\\"
    else
      return $HOME
    endif
  else
    if $HOME[-1:] != "/"
      return $HOME . "/"
    else
      return $HOME
    endif
  endif
endfunction

function! g:platform.escape(path)
  return s:is_windoz ? escape(a:path, '%#') : escape(a:path, ' %#')
endfunction

"start a program and then return to vim, no wait.
function! g:platform.start(path)
  let platform = self
  let convPath = platform.escape(a:path)
  "escape() function will do iconv to the string, so call it
  "before iconv().
  if s:is_windoz
    let convPath = substitute(convPath, '/', "\\", 'g')
    let convPath = " start \"\" \"" . convPath . "\""
    let ret = platform.system(convPath)
  else
    if g:VEConf_usingKDE
      let convPath = "kfmclient exec " . convPath
      let ret = platform.system(convPath)
    elseif g:VEConf_usingGnome
      let convPath = "gnome-open " . convPath
      let ret = platform.system(convPath)
    else " default using gnome-open.
      let convPath = "gnome-open " . convPath
      let ret = platform.system(convPath)
    endif
  endif

  if ret
    return 1
  else
    echohl ErrorMsg | echomsg "Failed to start " . a:path | echohl None
    return 0
  endif
endfunction

function! g:platform.system(cmd)
  "can not escape here! example: 'rm -r blabla\ bbb'
  "let convCmd = escape(a:cmd, ' %#')
  let convCmd = a:cmd
  if g:conf.system_encoding != ''
    let convCmd = iconv(convCmd, &encoding, g:conf.system_encoding)
  endif
  call system(convCmd)
  return !(v:shell_error)
endfunction

" Return successful copyed file list.
function! g:platform.copyMultiFile(fileList, topath)
  let platform = self
  let boverWrite = g:conf.over_write_existing
  let retList = []
  for i in a:fileList
      "boverWrite 0 ask, 1 allyes, 2 allno
      if boverWrite == 0
          if i[-1:] == "\\" || i[-1:] == "/"
              let i = i[:-2]
          endif
          let tofile = a:topath . matchstr(i, '[\\/]\zs[^\\/]\+$')
          if findfile(tofile) != ''
              "echohl WarningMsg
              "let result = tolower(input("File [ " . tofile . " ] exists! Over write ? (Y)es/(N)o/(A)llyes/A(L)lno/(C)ancel ", "Y"))
              let result = confirm("File [ " . matchstr(i, '[\\/]\zs[^\\/]\+$') .
                          \" ] exists! Over write ? ", "&Yes\n&No\nYes to &All\nNo &To All\n&Cancel ", 1)
              "echohl None
              if result == 1
                  if !platform.copyfile(i, a:topath)
                      echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
                  else
                      let retList += [i]
                  endif
              elseif result == 2
                  continue
              elseif result == 3
                  let boverWrite = 1
                  if !platform.copyfile(i, a:topath)
                      echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
                  else
                      let retList += [i]
                  endif
              elseif result == 4
                  let boverWrite = 2
              else
                  break
              endif
          else
              if !platform.copyfile(i, a:topath)
                  echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
              else
                  let retList += [i]
              endif
          endif
      elseif boverWrite == 1
          if !platform.copyfile(i, a:topath)
              echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
          else
              let retList += [i]
          endif
      elseif boverWrite == 2
          if i[-1:] == "\\" || i[-1:] == "/"
              let i = i[:-2]
          endif
          let tofile = a:topath . matchstr(i, '[\\/]\zs[^\\/]\+$')
          if findfile(tofile) != ''
              continue
          endif
          if !platform.copyfile(i, a:topath)
              echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
          else
              let retList += [i]
          endif
      endif
  endfor
  echohl Special | echomsg " " . len(retList) . " file(s) pasted!" | echohl None
  return retList
endfunction

function! g:platform.copyfile(filename, topath)
  let platform = self
  "return
  let filename = platform.escape(a:filename)
  let topath = platform.escape(a:topath)
  if s:is_windoz
    let filename = substitute(a:filename, '/', "\\", 'g')
    let topath = substitute(a:topath, '/', "\\", 'g')
    if isdirectory(filename)
      if filename[-1:] == "\\"
        let filename = filename[:-2]
      endif
      let topath = "\"" . topath . matchstr(filename, '[^\\]*$') . "\""
      let filename = "\"" . filename . "\""
      let cmd = "xcopy ".filename . " " . topath . " /E /I /H /R /Y"
    else
      let topath = "\"" . topath . "\""
      let filename = "\"" . filename . "\""
      let cmd = "xcopy ". filename . " " . topath . " /I /H /R /Y"
    endif
    return platform.system(cmd)
  else
    let cmd = "cp -r " . filename . " " . topath . "&"
    return platform.system(cmd)
  endif
endfunction

" The "move" command in win32 is so poor..
" So I have no choice but copy then delete.
"function! platform.movefile(filename, topath)
"   let platform = self
"   let filename = self.escape(a:filename)
"   let topath = self.escape(a:topath)
"   if executable("mv")
"      let cmd = "mv -f " . filename . " " . topath
"      return self.system(cmd)
"   else
"      if self.copyfile(a:filename, a:topath)
"        return self.delete(a:filename, 1)
"      else
"        return 0
"      endif
"   endif
"endfunction

function! g:platform.mkdir(path)
  let convPath = (g:conf.system_encoding != '')
        \ ? iconv(a:path, &encoding, g:conf.system_encoding) : a:path
  return mkdir(convPath, 'p')
endfunction

function! g:platform.mkfile(filename)
  if findfile(a:filename) != '' || isdirectory(a:filename)
    return 0
  endif
  if writefile([], a:filename) == 0 "here it is not need to convert filename
    return 1
  else
    return 0
  endif
endfunction

function! g:platform.executable(filename)
  if isdirectory(a:filename)
    return 0
  endif
  if getfperm(a:filename)[2] == 'x'
    return 1
  else
    return 0
  endif
endfunction

function! g:platform.search(filename, path)
  if a:filename == '.' || a:filename == '..'
    return []
  else
    return split(globpath(a:path, "**/" . a:filename), "\n")
  endif
endfunction

function! g:platform.globpath(path)
  if g:conf.show_hidden_files
    let tmp = globpath(a:path, "*") . "\n" . globpath(a:path, ".[^.]*") "need to cut . and ..
    " can not show files start with .. such as ..foo , :(
    " I do not know how to write the shell regexp.
    if tmp == "\n"
      return ''
    else
      return tmp
    endif
  else
    return globpath(a:path, "*")
  endif
endfunction

"globpath used in file panel, including filter.
function! g:platform.globpath_file(path)
  if g:conf.file_panel_filter != ''
    return globpath(a:path, g:conf.file_panel_filter)
  endif
  if g:conf.show_hidden_files
    let tmp = globpath(a:path, "*") . "\n" . globpath(a:path, ".[^.]*") "need to cut . and ..
    " can not show files start with .. such as ..foo , :(
    " I do not know how to write the shell regexp.
    return (tmp == "\n") ? '' : tmp
  else
    return globpath(a:path, "*")
  endif
endfunction

function! g:platform.cdToPath(path)
  try
    "In win32, VE can create folder starts with space. So ...
    exec "lcd " . escape(a:path, ' %#')
  catch
    echohl ErrorMsg | echomsg "Can not cd to path: " . a:path | echohl None
  endtry
endfunction

function! g:platform.startShell()
  if s:is_windoz
    !start cmd.exe
  else
    shell
  endif
endfunction

function! g:platform.startExplorer()
  let platform = self
  let pwd = platform.escape(g:platform.getcwd())
  if s:is_windoz
    let pwd = substitute(pwd, '/', "\\", 'g')
  endif
  if !platform.system(g:conf.external_explorer . " " . pwd)
    "echohl ErrorMsg | echomsg "Failed to start external explorer: " . g:conf.external_explorer | echohl None
    " M$ windows Explorer.exe always return 1 even it starts successfully, shit!
  endif
endfunction

if 0 " NOROOTS
function! g:platform_get_root(rootDict)
call s:LOG("g:platform_get_root TOP")

  let newRootList = s:source_roots 
  for i in newRootList
call s:LOG("g:platform_get_root: i=". string(i))
    if !has_key(a:rootDict, i)
      let a:rootDict[i] = deepcopy(s:Node)
      call a:rootDict[i].init(i)
      let a:rootDict[i].hasOwnChilds = 1
    endif
  endfor

call s:LOG("g:platform_get_root BOTTOM")
endfunction
let g:platform.getRoot = function("g:platform_get_root")
endif " NOROOTS

function! g:platform.pathToName(path)
  let time = strftime("%Y-%m-%d %H:%M:%S", getftime(a:path))
  let size = getfsize(a:path)
  let perm = getfperm(a:path)

  if s:is_windoz_like
    let name = (a:path[-1:] != "\\")
                \ ? substitute(a:path, '^.*\\', '', 'g')
                \ : substitute(a:path, '^.*\\\ze.\+\\$', '', 'g')
  else
    let name = (a:path[-1:] != "/")
                \ ? substitute(a:path, '^.*\/', '', 'g')
                \ : substitute(a:path, '^.*\/\ze.\+\/$', '', 'g')
  endif

  if g:conf.show_file_size_in_mkb
    if size > (1024 * 1024)
      let size = (size / 1024 / 1024) . ' M'
    elseif size > 1024
      let size = (size / 1024) . ' K'
    elseif size > 0
      let size = size . ' B'
    endif
  endif

  let tail = printf("%10.10s ".perm . ' ' .time, size==0?'':size)
  return name . "\t" . tail
endfunction

function! g:platform.getUpperDir(path)
  return (s:is_windoz_like)
            \ ? substitute(a:path, '\\\zs[^\\]\+\\$', '', 'g')
            \ : substitute(a:path, '\/\zs[^/]\+\/$', '', 'g')
endfunction

"default choice and return value:    1:YES 0:NO
function! g:platform.confirm(text, defaultChoice)
  if a:defaultChoice
    let ret = confirm(a:text, "&Yes\n&No", 1)
  else
    let ret = confirm(a:text, "&Yes\n&No", 2)
  endif
  if ret == 1
    return 1
  else
    return 0
  endif
  "if a:defaultChoice
  "    echohl WarningMsg
  "    let result = tolower(input(a:text . "  ", "Y"))
  "    echohl None
  "else
  "    echohl WarningMsg
  "    let result = tolower(input(a:text . "  "), "N")
  "    echohl None
  "endif
  "if result == "y" || result == "ye" || result == "yes"
  "    return 1
  "else
  "    return 0
  "endif
endfunction

"delete a single file or directory
"return 0:failed  1:success
function! g:platform.deleteSingle(path, bforce)
  let platform = self
  if !isdirectory(a:path)
    if g:conf.file_delete_confirm && !platform.confirm("Delete \n\"".a:path."\" ?", 1)
      echo " "
      "clear the command line
      return 0
    endif
    if platform.delete(a:path, a:bforce)
      echohl Special | echomsg "File: [" . a:path . "] deleted!" | echohl None
      return 1
    else
      echohl ErrorMsg | echomsg "Can not delete the file! [" . a:path . "]" | echohl None
      return 0
    endif
  else
    if g:conf.file_delete_confirm && !platform.confirm("Remove the folder \n\"".a:path."\" and all its contents?", 1)
      echo " "
      return 0
    endif
    echo " "
    return platform.delete(a:path, a:bforce)
  endif
endfunction

"delete multiple files/directory.
"return 0:failed  1:success
function! g:platform.deleteMultiple(fileList, bforce)
  let platform = self
  if g:conf.file_delete_confirm && !platform.confirm("Delete selected file(s) ?", 1)
    echo " "
    return 0
  endif
  for i in a:fileList
    if !platform.delete(i, a:bforce)
      echohl ErrorMsg | echomsg "Failed to delete: " . i | echohl None
    endif
  endfor
  return 1
endfunction

function! g:platform.delete(name, bforce)
  let platform = self
  if  s:is_windoz
    let recPath = tolower(g:conf.recycle_path)
    let delName = tolower(a:name)
  else
    let recPath = g:conf.recycle_path
    let delName = a:name
  endif
  if !a:bforce && g:conf.recycle_path != '' && (stridx(delName, recPath) == -1)
    if !isdirectory(g:conf.recycle_path)
      if !platform.mkdir(g:conf.recycle_path) || !isdirectory(g:conf.recycle_path)
        echohl ErrorMsg | echomsg "Can not access recycle bin!" | echohl None
        return 0
      endif
    endif
    if !platform.copyfile(a:name, g:conf.recycle_path)
        echohl ErrorMsg | echomsg "Failed to move the file: [" . a:name . "] to recycle bin." | echohl None
        return 0
    "else
    "    return 1
    endif
  endif

  if isdirectory(a:name)
    return s:is_windoz
      \ ? g:platform.system(" rmdir /S /Q \"" . platform.escape(a:name) . "\"")
      \ : g:platform.system("rm -r " . platform.escape(a:name) . "&")
  else
    return (delete(a:name) == 0) ? 1 : 0
  endif
endfunction

function! g:platform.select(list, title)
  let selectList = deepcopy(a:list)
  if len(selectList) == 0
    return
  endif
  call insert(selectList, a:title, 0)
  for i in range(1, len(selectList)-1)
    let selectList[i] = i . "  " . selectList[i]
  endfor
  let result = inputlist(selectList)
  if result > len(a:list) || result <= 0
    return -1
  else
    return result-1
  endif
endfunction

" This is not a member of platform, because sort()
" can not use dict function.
function! g:SortCompare(t1, t2)
  return g:conf.sort_case_sensitive
            \ ? a:t1 ==# a:t2 ? 0 : a:t1 ># a:t2 ? 1 : -1
            \ : a:t1 ==? a:t2 ? 0 : a:t1 >? a:t2 ? 1 : -1
endfunction


" class Node {{{1
"=============================
let s:Node = {}
let s:Node.name = ''
let s:Node.path = ''
let s:Node.isopen = 0
let s:Node.hasOwnChilds = 0
let s:Node.childs = {}

"Object Constructor
function! s:Node_init(path) dict
call s:LOG("Node_init: TOP path=". a:path)
  let self.path = a:path
  let self.name = s:is_windoz_like
              \ ? matchstr(a:path, '[^\\]*\\$', '', 'g')
              \ : matchstr(a:path, '[^/]*\/$', '', 'g')
call s:LOG("Node_init: BOTTOM self=". string(self))
endfunction
let s:Node.init = function("s:Node_init")

" return [1, child_node]
" return [0, {}]
" Assumes a:path includes self.path
" a:path     = /a/b/c/d/f/
" self.path  = /a/b/c/
" child.name = d/
function! s:Node_get_child(path) dict
call s:LOG("Node_get_child: TOP path=". a:path)
call s:LOG("Node_get_child: self=". string(self))

  let child = {}
  let found = 0

  let idx = stridx(a:path, self.path)
  if idx != -1
    let len = len(self.path)
    let name = strpart(a:path, len)
    let index = stridx(name, '/')
    if len(name) > index
      let name = strpart(name, 0, index+1)
    endif
call s:LOG("Node_get_child: name=". name)
    if has_key(self.childs, name)
      let child = self.childs[name]
      let found = 1
    endif
call s:LOG("Node_get_child: child=". string(child))
  endif
call s:LOG("Node_get_child: child=". string(child))
call s:LOG("Node_get_child: BOTTOM")
  return [found, child]
endfunction
let s:Node.getChild = function("s:Node_get_child")

"Refresh tree node
function! s:Node_update_node() dict
call s:LOG("Node_update_node: TOP")
    "Once a node is updated, it means that the node has been opened.
    let self.isopen = 1
    "Create new dir list
    let newDirList = []
    for i in split(g:platform.globpath(self.path), "\n")
      if isdirectory(i) == 1
        let i = s:is_windoz_like
                    \ ? matchstr(i, '[^\\]*$', '', 'g') . "\\"
                    \ : matchstr(i, '[^/]*$', '', 'g') . "/"
call s:LOG("Node_update_node: i=". i)
        call add(newDirList, i)
      endif
    endfor

    "Remove nolonger exist dirs.
    for i in keys(self.childs)
      if index(newDirList, i) == -1
        call remove(self.childs, i)
      endif
    endfor

    "Create new nodes
    for i in newDirList
      if !has_key(self.childs, i)
call s:LOG("Node_update_node: create node i=". i)
        let self.childs[i] = deepcopy(s:Node)
        call self.childs[i].init(self.path . i)
      endif
    endfor

    "find out which child has their own childs
    let self.hasOwnChilds = !empty(self.childs)

    if g:conf.show_folder_status == 0
      for i in keys(self.childs)
        let self.childs[i].hasOwnChilds = 1
      endfor
    else
      for i in keys(self.childs)
        let _hasOwnChilds = 0
        for j in split(g:platform.globpath(self.childs[i].path), "\n")
call s:LOG("Node_update_node: j=". j)
          if isdirectory(j)
            let _hasOwnChilds = 1
            break
          endif
        endfor
        if _hasOwnChilds == 1
          let self.childs[i].hasOwnChilds = 1
        endif
      endfor
    endif

    "update opened child nodes
    for i in keys(self.childs)
      if self.childs[i].isopen == 1
        call self.childs[i].updateNode()
      endif
    endfor
call s:LOG("Node_update_node: BOTTOM")
endfunction
let s:Node.updateNode = function("s:Node_update_node")

"Toggle open/close status of one node
"the path should end with '\' such as c:\aaa\bbb\
"example "c:\\aaa\\bbb\\" "aaa\\bbb\\" "bbb\\"
function! s:Node_toggle(path) dict
call s:LOG("Node_toggle: TOP path=". a:path)

  if self.path == a:path
call s:LOG("Node_toggle: paths equal")
    let self.isopen = !self.isopen
    if self.isopen == 1
      call self.updateNode()
    endif
  else
    if ! self.isopen 
      call self.updateNode()
    endif
    let [found, child] = self.getChild(a:path)
    if found
      let self.isopen = 1
      call child.toggle(a:path)
    else
      call s:ERROR("Node_toggle: child not found: ". a:path ." for node: ".  string(self))
    endif
  endif

call s:LOG("Node_toggle: BOTTOM")
endfunction
let s:Node.toggle = function("s:Node_toggle")

"Open the giving path
"the path should end with '\' such as c:\aaa\bbb\
"example "c:\\aaa\\bbb\\" "aaa\\bbb\\" "bbb\\"
function! s:Node_open_path(path) dict
call s:LOG("Node_open_path: TOP path=". a:path)
call s:LOG("Node_open_path: self=". string(self))

  if self.path == a:path
    call self.updateNode()
  else
    let [found, child] = self.getChild(a:path)
    if found
      call child.openPath(a:path)
    else
      call s:ERROR("Node_open_path: child not found: ". a:path ." for node: ".  string(self))
    endif
  endif

call s:LOG("Node_open_path: BOTTOM")
endfunction
let s:Node.openPath = function("s:Node_open_path")


"Draw the tree, depend on the status of every tree node.
function! s:Node_draw(tree, depth) dict
    if self.hasOwnChilds == 0
        let name = repeat(' ', a:depth*2).'  '.self.name
        call add(a:tree, [name, self.path])
        return
    endif
    if self.isopen
        let name = repeat(' ', a:depth*2).'- '.self.name
        if a:depth == 0 "let the root node looks different
            let name = '- [' . self.name . ']'
        endif
        call add(a:tree, [name, self.path])
        let keys = sort(keys(self.childs), "g:SortCompare")
        if !g:conf.tree_sort_direction
            call reverse(keys)
        endif
        for i in keys
            call self.childs[i].draw(a:tree, a:depth+1)
        endfor
    else
        let name = repeat(' ', a:depth*2).'+ '.self.name
        if a:depth == 0 "let the root node looks different
          let name = '+ [' . self.name . ']'
        endif
        call add(a:tree, [name, self.path])
    endif
endfunction
let s:Node.draw = function("s:Node_draw")

" class Tree {{{1
"=============================
let s:Tree = {}
let s:Tree.content = []
let s:Tree.rootNodes = {}

"Object Constructor
function! s:Tree_init(sourceRoots) dict
call s:LOG("Tree_init: TOP sourceRoots=". string(a:sourceRoots))
  " call g:platform.getRoot(self.rootNodes)
  " let self.sourceRoots = copy(a:sourceRoots)
  call self.setRoots(a:sourceRoots)
call s:LOG("Tree_init: BOTTOM rootNodes=". string(self.rootNodes))
endfunction
let s:Tree.init = function("s:Tree_init")

function! s:Tree_set_roots(sourceRoots) dict
call s:LOG("Tree_set_roots: TOP sourceRoots=". string(a:sourceRoots))

  let newRootList = a:sourceRoots 
  let rootDict = self.rootNodes
  for i in newRootList
call s:LOG("g:platform_get_root: i=". string(i))
    if !has_key(rootDict, i)
      let rootDict[i] = deepcopy(s:Node)
      call rootDict[i].init(i)
      let rootDict[i].hasOwnChilds = 1
    endif
  endfor

call s:LOG("s:Tree_set_roots BOTTOM")
endfunction
let s:Tree.setRoots = function("s:Tree_set_roots")

function! s:Tree_get_root_node(path) dict
call s:LOG("Tree_get_root_node: TOP path=". a:path)
  let found = 0
  let rootnode = {}

  let lenpath = len(a:path)
call s:LOG("Tree_get_root_node: lenpath=". lenpath)
  for key in keys(self.rootNodes)
call s:LOG("Tree_get_root_node: key=". key)
    let lenkey = len(key)
call s:LOG("Tree_get_root_node: lenkey=". lenkey)
    if lenkey == lenpath
      if a:path == key
        let found = 1
        let rootnode = self.rootNodes[key]
        break
      endif
    elseif lenkey < lenpath
      let tmppath = strpart(a:path, 0, lenkey)
call s:LOG("Tree_get_root_node: tmppath=". tmppath)
      if tmppath == key
        let found = 1
        let rootnode = self.rootNodes[key]
        break
      endif
    endif
  endfor

  return [found, rootnode]
endfunction
let s:Tree.getRootNode = function("s:Tree_get_root_node")

function! s:Tree_toggle_path(path) dict
call s:LOG("Tree_toggle_path: TOP path=". a:path)

call s:LOG("Tree_toggle_path: self=". string(self))

  let [found, rootnode] = self.getRootNode(a:path)
  if found
    call rootnode.toggle(a:path)
  else
    echohl ErrorMsg | echomsg "Can not toggle path: ". a:path | echohl None
  endif

endfunction
let s:Tree.togglePath = function("s:Tree_toggle_path")

function! s:Tree_open_path(path) dict
call s:LOG("Tree_open_path: TOP path=". a:path)
call s:LOG("Tree_open_path: rootNodes=". string(self.rootNodes))
  let [found, rootnode] = self.getRootNode(a:path)
  if found
    call rootnode.toggle(a:path)
    if rootnode.path == a:path
      call rootnode.openPath(a:path)
    else
      let [found, child] = rootnode.getChild(a:path)
      if found
        call child.openPath(a:path)
      else
        call s:ERROR("Tree_open_path: child not found: ". a:path ." for node: ".  string(self))
      endif
    endif
  else
    call s:ERROR("Can not open path: ". a:path)
    echohl ErrorMsg | echomsg "Can not open path: ". a:path | echohl None
  endif

call s:LOG("Tree_open_path: BOTTOM")
endfunction
let s:Tree.openPath = function("s:Tree_open_path")

" fill self.content
function! s:Tree_draw() dict
  let keys = sort(keys(self.rootNodes), "g:SortCompare")
  if g:conf.tree_sort_direction == 0
    call reverse(keys)
  endif
  for i in keys
    call self.rootNodes[i].draw(self.content, 0)
  endfor
endfunction
let s:Tree.draw = function("s:Tree_draw")

function! s:Tree_update(path) dict
  " call g:platform.getRoot(self.rootNodes)
  " call self.setRoots()

  "toggle twice to update current directory
  call self.togglePath(a:path)
  call self.togglePath(a:path)

  " costs too much time.
  "for i in keys(self.rootNodes)
  "    call self.rootNodes[i].updateNode()
  "endfor
endfunction
let s:Tree.update = function("s:Tree_update")

" class TreePanel {{{1
"=============================
let s:TreePanel = {}
let s:TreePanel.tree = {}
let s:TreePanel.name = ''
let s:TreePanel.path = ''
let s:TreePanel.width = 0
let s:TreePanel.splitMode = ''
let s:TreePanel.splitLocation = ''

"Object Constructor
function! s:TreePanel_init(ftag, path, sourceRoots) dict
call s:LOG("TreePanel_init: ftag='". a:ftag ."', path='". a:path ."', sourceRoots=". string(a:sourceRoots))
  let tview = self
  "let tview.name = "TreePanel" . a:ftag
  let tview.name = "TreeView" . a:ftag
  let tview.path = a:path
  let tview.width = g:conf.tree_panel_width
  let tview.splitMode = g:conf.tree_panel_split_mode
  let tview.splitLocation = g:conf.tree_panel_split_location
  let tview.tree = deepcopy(s:Tree)
  call tview.tree.init(a:sourceRoots)
  call tview.tree.openPath(a:path)
endfunction
let s:TreePanel.init = function("s:TreePanel_init")

function! s:TreePanel_set_focus() dict
  let tview = self
  let TreeWinNr = bufwinnr(tview.name)
  if TreeWinNr != -1
    exec TreeWinNr . " wincmd w"
    return 1
  else
    let bufNr = bufnr(tview.name)
    if bufNr != -1
      exec "bwipeout " . bufNr
    endif
    return 0
  endif
endfunction
let s:TreePanel.setFocus = function("s:TreePanel_set_focus")

"Sync the tree with filesystem and refresh the tree panel
function! s:TreePanel_refresh() dict
  let tview = self
  if tview.setFocus()
    call tview.tree.update(tview.path)
    call tview.drawTree()
  endif
endfunction
let s:TreePanel.refresh = function("s:TreePanel_refresh")

"Draw the dir tree but do not sync the tree with filesystem
function! s:TreePanel_draw_tree() dict
  let tview = self
  if tview.setFocus()
    if !empty(tview.tree.content)
      call remove(tview.tree.content, 0, -1)
    endif
    call add(tview.tree.content, ["Directories:", ""])
    call tview.tree.draw()
    let tree_lines = []
    let lineNr = line(".")
    for i in tview.tree.content
      if i[1] == tview.path
        let len = len(i[0])
        let n = tview.width - len - 2
        if n >= 0
          let i[0] .= repeat(' ', n) ."<-"
        endif
        let lineNr = index(tview.tree.content, i) + 1
      endif
      call add(tree_lines, i[0])
    endfor
    setlocal noreadonly
    setlocal modifiable
    "Let the cursor go back to right line and right position in
    "the screen.
    normal! H
    let Hline = line(".")
    silent normal! ggdG
    call append(0, tree_lines)
    silent normal! Gddgg
    exec "normal! " . Hline . "G"
    normal! zt
    exec "normal! " . lineNr . "G"
    setlocal readonly
    setlocal nomodifiable
  endif
endfunction
let s:TreePanel.drawTree = function("s:TreePanel_draw_tree")

"Show tree panel
function! s:TreePanel_show() dict
  let tview = self
  if tview.setFocus()
    return
  endif
  let cmd = tview.splitLocation . " " . tview.splitMode . ' ' . tview.width . ' new ' . tview.name
  silent! execute cmd
  let TreeWinNr = bufwinnr(tview.name)
  if TreeWinNr != -1
    exec TreeWinNr . " wincmd w"
    setlocal winfixwidth
    setlocal noswapfile
    setlocal buftype=nowrite
    setlocal bufhidden=delete
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal nobuflisted
    setlocal nospell
    setlocal nonumber
    setlocal cursorline
    setlocal readonly
    setlocal nomodifiable

    setlocal mouse=a

    call tview.drawTree()
    call tview.createActions()
    call tview.createSyntax()
  else
    echoerr "create tree window failed!"
  endif
endfunction
let s:TreePanel.show = function("s:TreePanel_show")

"Hide tree panel
function! s:TreePanel_hide() dict
  let tview = self
  if tview.setFocus()
    "make sure there are no more than 1 buffer has the same name
    let bufNr = bufnr('%')
    "exec "wincmd c"
    quit
    exec "bwipeout ".bufNr
  endif
endfunction
let s:TreePanel.hide = function("s:TreePanel_hide")

function! s:TreePanel_get_path_under_cursor(num) dict
  let tview = self
  return tview.tree.content[a:num][1]
endfunction
let s:TreePanel.getPathUnderCursor = function("s:TreePanel_get_path_under_cursor")

function! s:TreePanel_node_clicked(num) dict
call s:LOG("TreePanel_node_clicked: TOP num=". a:num)
  let tview = self
  if tview.tree.content[a:num][1] == ""
    return
  endif

  let path = tview.tree.content[a:num][1]
call s:LOG("TreePanel_node_clicked: path=". path)
  if tview.path != path
    "let tview.path = path
    call VE_GotoPath(path)
    "Do not toggle if it is the first time switch to another tree node.
    call tview.setFocus()
  else
    call tview.tree.togglePath(path)
    call tview.drawTree()
  endif
call s:LOG("TreePanel_node_clicked: BOTTOM")
endfunction
let s:TreePanel.nodeClicked = function("s:TreePanel_node_clicked")

function! s:TreePanel_path_changed(path) dict
  let tview = self
  if tview.path != a:path
    let tview.path = a:path
    call tview.tree.openPath(tview.path)
    call tview.drawTree()
  endif
endfunction
let s:TreePanel.pathChanged = function("s:TreePanel_path_changed")

function! s:TreePanel.createActions()
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.help .           " :tab h VimExplorer<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.toggleNode .     " :call VE_OnTreeNodeClick()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.toggleNodeMouse. " :call VE_OnTreeNodeClick()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.refresh .        " :call VE_TreeRefresh()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.toggleFilePanel ." :call VE_ToggleFilePanel()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.toUpperDir .     " :call VE_ToUpperDir()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.switchPanel .    " <c-w><c-w>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.favorite .       " :call VE_GotoFavorite()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.addToFavorite .  " :call VE_AddToFavorite('treePanel')<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.browser_history .  " :call VE_BrowseHistory()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.gotoPath .       " :call VE_OpenPath()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.tree_panel_hotkey.quitVE .         " :call VEDestroy()<cr>"
  " autocmd
  au! * <buffer>
  au BufEnter <buffer>  call VE_SyncDir()
  " Status line
  setlocal statusline=%{getcwd()}
endfunction

function! s:TreePanel.createSyntax()
  let tview = self
  if tview.setFocus()
    call g:conf.treePanelSyntax()
  endif
endfunction


" class FilePanel {{{1
"=============================
let s:FilePanel = {}
let s:FilePanel.fileList = []
let s:FilePanel.displayList = []
" displayList [
"    [ "display name", "real path" ],
"    ...
"    ]
let s:FilePanel.selectedFiles = []
let s:FilePanel.leavePosition = {}
let s:FilePanel.name = ''
let s:FilePanel.path = ''
let s:FilePanel.width = 0
let s:FilePanel.splitMode = ""
let s:FilePanel.splitLocation = ""

function! s:FilePanel_init(ftag, path) dict
  let fview = self
"  let fview.name = "[XXX". a:ftag ."]"
  "let self.name = "FilePanel". a:ftag
  "let self.name = "FilePanel". a:ftag
  let self.name = "FileView". a:ftag
  let fview.path = a:path
  let fview.splitMode = g:conf.file_panel_split_mode
  let fview.splitLocation = g:conf.file_panel_split_location
  let fview.width = g:conf.file_panel_width
endfunction
let s:FilePanel.init = function("s:FilePanel_init")

function! s:FilePanel_show() dict
  let fview = self
  if fview.setFocus()
    return
  endif
  let cmd = fview.splitLocation . " " . fview.splitMode . ' ' . fview.width . ' new ' . fview.name
  silent! exec cmd
  if !fview.setFocus()
    echoerr "create file window failed!"
  endif
  setlocal winfixwidth
  setlocal noswapfile
  setlocal buftype=nowrite
  setlocal bufhidden=delete
  setlocal nowrap
  setlocal foldcolumn=0
  setlocal nobuflisted
  setlocal nospell
  setlocal nonumber
  setlocal cursorline
  setlocal readonly
  setlocal nomodifiable
  setlocal tabstop=40

  setlocal mouse=a

  "This is used to display file list more orderliness.
  call fview.refresh()
  call fview.createActions()
  call fview.createSyntax()
endfunction
let s:FilePanel.show = function("s:FilePanel_show")

function! s:FilePanel_only() dict
  let fview = self
  if fview.setFocus()
    only
  endif
endfunction
let s:FilePanel.only = function("s:FilePanel_only")

function! s:FilePanel_get_current_directory() dict
" call s:LOG("55_FilePanel_get_current_directory: fview.path=". self.path)
  let fview = self
  let len = len(fview.path)
" call s:LOG("55_FilePanel_get_current_directory: len=". len)
  let idx = strridx(fview.path, '/', len-2)
" call s:LOG("55_FilePanel_get_current_directory: idx=". idx)
  let dir = strpart(fview.path, idx+1)
" call s:LOG("55_FilePanel_get_current_directory: dir=". dir)
  return dir
endfunction
let s:FilePanel.getCurrentDirectory = function("s:FilePanel_get_current_directory")

function! s:FilePanel_hide() dict
  let fview = self
  if fview.setFocus()
    let bufNr = bufnr('%')
    exec "wincmd c"
    exec "bwipeout ".bufNr
  endif
endfunction
let s:FilePanel.hide = function("s:FilePanel_hide")

function! s:FilePanel_refresh() dict
  let fview = self
  call fview.getFileListFromCwd()
  call fview.updateDisplayList()
  call fview.drawList()
endfunction
let s:FilePanel.refresh = function("s:FilePanel_refresh")

"Draw the displayList on the screen.
function! s:FilePanel_draw_list() dict
  let fview = self
  if fview.setFocus()
    "calculate window width
    let VEFileWinNr = bufwinnr(fview.name)
    let winWidth = winwidth(VEFileWinNr)
    exec "setlocal tabstop=" . ((winWidth-41)<20?20:(winWidth-41))
    setlocal noreadonly
    setlocal modifiable
    let curLine = line(".")
    normal! H
    let Hline = line(".")
    silent normal! ggdG
    let displayContent = []
    for i in fview.displayList "here i is reference, not copy
      if index(fview.selectedFiles, i[1]) != -1
        let tmpi = '*' . substitute(i[0], '^.', '', 'g')
      else
        let tmpi = i[0]
      endif
      call add(displayContent, tmpi)
    endfor
    call append(0, displayContent)
    normal! Gddgg
    exec "normal! " . Hline . "G"
    normal! zt
    exec "normal! " . curLine . "G"
    setlocal readonly
    setlocal nomodifiable
  endif
endfunction
let s:FilePanel.drawList = function("s:FilePanel_draw_list")

"Update the displayList.
function! s:FilePanel_update_display_list() dict
  let fview = self
  if g:conf.file_panel_sort_type == 1
    call fview.sortByName()
  elseif g:conf.file_panel_sort_type == 2
    call fview.sortByTime()
  elseif g:conf.file_panel_sort_type == 3
    call fview.sortBySize()
  else " 0
    call fview.sortByType()
  endif
endfunction
let s:FilePanel.updateDisplayList = function("s:FilePanel_update_display_list")

function! s:FilePanel_toggle_modes() dict
  let fview = self
  let g:conf.file_panel_sort_type = (g:conf.file_panel_sort_type < 3)
              \ ? g:conf.file_panel_sort_type + 1 : 0

  call fview.updateDisplayList()
  call fview.drawList()
endfunction
let s:FilePanel.toggleModes = function("s:FilePanel_toggle_modes")

function! s:FilePanel_get_file_list_from_cwd() dict
  let fview = self
  let fview.fileList = split(g:platform.globpath_file(fview.path), "\n")
endfunction
let s:FilePanel.getFileListFromCwd = function("s:FilePanel_get_file_list_from_cwd")

" sort type == 1
function! s:FilePanel_sort_by_name() dict
  let fview = self
  let fileGroup = {}
  " example
  " {
  "  "name" : "path"
  " }
  for i in fview.fileList
     let name = s:is_windoz_like
                    \ ? matchstr(i, '[^\\]*$', '', 'g')
                    \ : matchstr(i, '[^/]*$', '', 'g')
    if isdirectory(i)
      if s:is_windoz_like
        if i[-1:] != "\\"
          let i .= "\\"
        endif
      else
        if i[-1:] != "/"
          let i .= "/"
        endif
      endif
      " add # before directory to sort separately.
      let name = '#' . name
    endif
    let fileGroup[name] = i
  endfor

  let keys = sort(keys(fileGroup), "g:SortCompare")
  if !g:conf.file_group_sort_direction
    call reverse(keys)
  endif

  let fview.displayList = []
  call add(fview.displayList, ["Directory:  ".fview.getCurrentDirectory(), ''])
  call add(fview.displayList, [repeat("~", 100), ''])
  call add(fview.displayList, ['[ Sort by name ]', ''])

  for i in keys
    call add(fview.displayList, ["  " . g:platform.pathToName(fileGroup[i]), fileGroup[i]])
  endfor
endfunction
let s:FilePanel.sortByName = function("s:FilePanel_sort_by_name")

" sort type == 2
function! s:FilePanel_sort_by_time() dict
  let fview = self
  let fileGroup = {}
  " example
  " {
  "  "name" : "path"
  " }
  for i in fview.fileList
    let time = strftime("%Y-%m-%d %H:%M:%S", getftime(i))
    let time = time . i "let the key of dict unique
    if isdirectory(i)
      if s:is_windoz_like
        if i[-1:] != "\\"
          let i .= "\\"
        endif
      else
        if i[-1:] != "/"
          let i .= "/"
        endif
      endif
    endif
    let fileGroup[time] = i
  endfor

  let keys = sort(keys(fileGroup), "g:SortCompare")
  if !g:conf.file_group_sort_direction
    call reverse(keys)
  endif

  let fview.displayList = []
  call add(fview.displayList, ["Directory:  ".fview.getCurrentDirectory(), ''])
  call add(fview.displayList, [repeat("~", 100), ''])
  call add(fview.displayList, ['[ Sort by time ]', ''])

  for i in keys
      call add(fview.displayList, ["  " . g:platform.pathToName(fileGroup[i]), fileGroup[i]])
  endfor
endfunction
let s:FilePanel.sortByTime = function("s:FilePanel_sort_by_time")

" sort type == 3 not implemented yet
function! s:FilePanel_sort_by_size() dict
  let fview = self
  let fileGroup = {}
  " example
  " {
  "  "name" : "path"
  " }
  for i in fview.fileList
    let size = "" . getfsize(i)
    let size = size . i "let the key of dict unique
    if isdirectory(i)
      if s:is_windoz_like
        if i[-1:] != "\\"
          let i .= "\\"
        endif
      else
        if i[-1:] != "/"
          let i .= "/"
        endif
      endif
    endif
    let fileGroup[size] = i
  endfor
  let keys = sort(keys(fileGroup))
  if !g:conf.file_group_sort_direction
    call reverse(keys)
  endif
  let fview.displayList = []
  call add(fview.displayList, ["Directory:  ".fview.getCurrentDirectory(), ''])
  call add(fview.displayList, [repeat("~", 100), ''])
  call add(fview.displayList, ['[ Sort by size ]', ''])
  for i in keys
    call add(fview.displayList, ["  " . g:platform.pathToName(fileGroup[i]), fileGroup[i]])
  endfor
endfunction
let s:FilePanel.sortBySize = function("s:FilePanel_sort_by_size")

" sort type == 0
function! s:FilePanel_sort_by_type() dict
  let fview = self
  let fileGroup = {}
  " example
  " {
  "  "directory" : [
  "                 "c:\\aaa\\",
  "                 "c:\\bbb\\"
  "                 ]
  "  "txt"       : [
  "                 "c:\\mm.txt",
  "                 "c:\\nn.txt"
  "                 ]
  " }
  for i in fview.fileList
    if isdirectory(i)
      "if the group dos not exist, create it first
      if !has_key(fileGroup, '#Directory') "assert file name does not contain '#'
        let fileGroup['#Directory'] = []
      endif
      if s:is_windoz_like
        if i[-1:] != "\\"
          let i .= "\\"
        endif
      else
        if i[-1:] != "/"
          let i .= "/"
        endif
      endif
      call add(fileGroup['#Directory'], i)
      continue
    endif

    let matchStr = s:is_windoz_like ? '\\\.[^\\]\+$' : '\/\.[^/]\+$'

    if matchstr(i, matchStr) != ''
      if !has_key(fileGroup, '#Hidden files')
        let fileGroup['#Hidden files'] = []
      endif
      call add(fileGroup['#Hidden files'], i)
      continue
    endif

    let fileExtension = s:is_windoz_like 
              \ ? matchstr(substitute(i, '^.*\\', '', 'g'), '\.[^.]\{-}$')
              \ : matchstr(substitute(i, '^.*\/', '', 'g'), '\.[^.]\{-}$')

    if fileExtension == ''  "files have no extensions
      if !has_key(fileGroup, '#Files')
        let fileGroup['#Files'] = []
      endif
      call add(fileGroup['#Files'], i)
      continue
    else "group the file by it's ext.name
      " # is always smaller than $
      " so it can keep dir in the top
      if !has_key(fileGroup, "$".fileExtension)
          let fileGroup["$".fileExtension] = []
      endif
      call add(fileGroup["$".fileExtension], i)
    endif
  endfor

  "update fview.displayList
  let fview.displayList = []
  call add(fview.displayList, ["Directory:  ".fview.getCurrentDirectory(), ''])
  call add(fview.displayList, [repeat("~", 100), ''])

  let keys = sort(keys(fileGroup), "g:SortCompare")
  if !g:conf.file_group_sort_direction
    call reverse(keys)
  endif

  for i in keys
    call add(fview.displayList, ['[ '.i[1:].' ]', ''])
    call sort(fileGroup[i], "g:SortCompare")
    if !g:conf.file_group_sort_direction
      call reverse(fileGroup[i])
    endif
    for j in fileGroup[i]
      call add(fview.displayList, ["  " . g:platform.pathToName(j), j])
    endfor
    call add(fview.displayList, [" ", ''])
  endfor

  if fview.displayList[-1][0] == " "
    call remove(fview.displayList, -1) "remove last empty line
  endif
endfunction
let s:FilePanel.sortByType = function("s:FilePanel_sort_by_type")

function! s:FilePanel_path_changed(path) dict
  let fview = self
  call fview.setFocus()
  if fview.path == a:path
    return
  endif
  "store the current mouse position.
  let linePos = line('.')
  normal! H
  let topPos = line('.')
  let fview.leavePosition[fview.path] = [topPos, linePos]
  
if 0
  call g:platform.cdToPath(a:path)
  let fview.path = g:platform.getcwd()
endif
  let fview.path = a:path

  let fview.selectedFiles = [] "clear the selectedFile list
  call fview.refresh()
  "restore position
  if has_key(fview.leavePosition, fview.path)
    exec "normal! " . fview.leavePosition[fview.path][0] . "G"
    normal! zt
    exec "normal! " . fview.leavePosition[fview.path][1] . "G"
  else
    normal! ggM
    if line('.') < 4 "put the cursor to first dir.
      normal! 4G
    endif
  endif
endfunction
let s:FilePanel.pathChanged = function("s:FilePanel_path_changed")

function! s:FilePanel_set_focus() dict
  let fview = self
  let VEFileWinNr = bufwinnr(fview.name)
  if VEFileWinNr != -1
    exec VEFileWinNr . " wincmd w"
    return 1
  else
    "If the window of buffer was closed by hand and the
    "buffer still in buffer list, wipeout it.
    "In case of bufnr() returns empty when there are two
    "buffers have the same name.
    let bufNr = bufnr(fview.name)
    if bufNr != -1
      exec "bwipeout " . bufNr
    endif
    return 0
  endif
endfunction
let s:FilePanel.setFocus = function("s:FilePanel_set_focus")

function! s:FilePanel_item_clicked(line) dict
  let fview = self
  let path = fview.displayList[a:line][1]
  if path != ''
    if isdirectory(path)
      call VE_GotoPath(path)
      call fview.setFocus()
    elseif executable(path)
      call g:platform.start(path)
    else
      call g:platform.start(path)
    endif
  endif
endfunction
let s:FilePanel.itemClicked = function("s:FilePanel_item_clicked")

function! s:FilePanel_item_preview(line) dict
  let fview = self
  let path = fview.displayList[a:line][1]
  if path != ''
    exec g:conf.preview_split_location . " pedit " . g:platform.escape(path)
  endif
endfunction
let s:FilePanel.itemPreview = function("s:FilePanel_item_preview")

function! s:FilePanel_single_file_action(line, actionName) dict
  let fview = self
  let path = fview.displayList[a:line][1]
  if path != ''
    call g:VEConf_singleFileActions[a:actionName](path)
  endif
endfunction
let s:FilePanel.singleFileAction = function("s:FilePanel_single_file_action")

function! s:FilePanel_normal_action(actionName) dict
  call g:VEConf_normalActions[a:actionName]()
endfunction
let s:FilePanel.normalAction = function("s:FilePanel_normal_action")

function! s:FilePanel_multi_action(actionName) dict
  let fview = self
  call g:VEConf_multiFileActions[a:actionName](fview.selectedFiles)
endfunction
let s:FilePanel.multiAction = function("s:FilePanel_multi_action")

function! s:FilePanel_delete_single(line, bForce) dict
  let fview = self
  let path = fview.displayList[a:line][1]
  if path != ''
    if g:platform.deleteSingle(path, a:bForce)
      if index(fview.selectedFiles, path) != -1
        call remove(fview.selectedFiles, index(fview.selectedFiles, path))
      endif
      call fview.refresh()
    endif
  endif
endfunction
let s:FilePanel.deleteSingle = function("s:FilePanel_delete_single")

function! s:FilePanel_delete_selected_files(bForce) dict
  let fview = self
  if empty(fview.selectedFiles)
    if g:platform.deleteMultiple(fview.selectedFiles, a:bForce)
      let fview.selectedFiles = []
      call fview.refresh()
    endif
  endif
endfunction
let s:FilePanel.deleteSelectedFiles = function("s:FilePanel_delete_selected_files")

function! s:FilePanel_toggle_select(direction) dict
  let fview = self
  if a:direction == "up"
    exec "norm " . "\<up>"
  endif
  let line = line(".") - 1
  let path = fview.displayList[line][1]
  if path != ''
    let idx = index(fview.selectedFiles, path)
    if idx == -1
      call add(fview.selectedFiles, path)
    else
      call remove(fview.selectedFiles, idx)
    endif
    call fview.drawList()
  endif
  if a:direction == "down"
    exec "norm " . "\<down>"
  endif
endfunction!
let s:FilePanel.toggleSelect = function("s:FilePanel_toggle_select")

function! s:FilePanel_clear_select() dict
  let fview = self
  let fview.selectedFiles = []
  call fview.drawList()
endfunction
let s:FilePanel.clearSelect = function("s:FilePanel_clear_select")

function! s:FilePanel_visual_select(firstLine, lastLine) dict
  let fview = self
  for line in range(a:firstLine, (a:lastLine>=len(fview.displayList)?(len(fview.displayList)-1):a:lastLine))
    let path = fview.displayList[line][1]
    if path == ''
      continue
    endif
    let idx = index(fview.selectedFiles, path)
    if idx == -1
      call add(fview.selectedFiles, path)
    else
      call remove(fview.selectedFiles, idx)
    endif
  endfor
  call fview.drawList()
endfunction
let s:FilePanel.visualSelect = function("s:FilePanel_visual_select")

function! s:FilePanel_visual_delete(firstLine, lastLine, bForce) dict
  let fview = self
  let displayList = []
  for line in range(a:firstLine, (a:lastLine>=len(fview.displayList)?(len(fview.displayList)-1):a:lastLine))
    let path = fview.displayList[line][1]
    if path == ''
      continue
    endif
    call add(displayList, path)
  endfor

  if ! empty(displayList)
    if g:platform.deleteMultiple(displayList, a:bForce)
      call fview.refresh()
    endif
  endif
endfunction
let s:FilePanel.visualDelete = function("s:FilePanel_visual_delete")

function! s:FilePanel_visual_yank(firstLine, lastLine, mode) dict
  let fview = self
  let displayList = []
  for line in range(a:firstLine, (a:lastLine>=len(fview.displayList)?(len(fview.displayList)-1):a:lastLine))
    let path = fview.displayList[line][1]
    if path == ''
      continue
    endif
    call add(displayList, path)
  endfor

  if ! empty(displayList)
    let winName = s:GetWinName()
    let s:Container.yankMode = a:mode
    let s:Container.clipboard = displayList
    call s:Container.showClipboard()
  endif
endfunction
let s:FilePanel.visualYank = function("s:FilePanel_visual_yank")

function! s:FilePanel_yank_single(mode) dict
  let fview = self
  let line = line(".") - 1
  let path = fview.displayList[line][1]
  if path != ''
    let s:Container.yankMode = a:mode
    let s:Container.clipboard = []
    call add(s:Container.clipboard, path)
  endif
  call s:Container.showClipboard()
endfunction
let s:FilePanel.yankSingle = function("s:FilePanel_yank_single")

function! s:FilePanel_paste() dict
  let fview = self
  if s:Container.yankMode == '' || s:Container.clipboard == []
    return
  endif
  let retList = g:platform.copyMultiFile(s:Container.clipboard, fview.path)
  if s:Container.yankMode == 'cut' && len(retList) != 0
    "let tmpRec = g:conf.recycle_path  " save recycle path
    "let g:conf.recycle_path = ''
    for i in retList
      call g:platform.delete(i, 1) "force delete
    endfor
    "let g:conf.recycle_path = tmpRec
    let s:Container.yankMode = ''
    let s:Container.clipboard = []
  endif
  "if s:Container.yankMode == 'cut'
  "    call g:platform.copyMultiFile(s:Container.clipboard, fview.path, 1)
  "else
  "    call g:platform.copyMultiFile(s:Container.clipboard, fview.path, 0)
  "endif
  let s:Container.yankMode = ''
  let s:Container.clipboard = []
  call fview.refresh()
  "call s:Container.showClipboard()
endfunction!
let s:FilePanel.paste = function("s:FilePanel_paste")

function! s:FilePanel_mark_via_regexp(regexp) dict
  let fview = self
  if a:regexp == ''
    echohl Special
    let regexp = vimside#util#Input("Mark files (regexp): ")
    echohl None
  else
    let regexp = a:regexp
  endif
  let fview.selectedFiles = []
  for i in fview.displayList
    let name = s:is_windoz_like
               \ ? matchstr(i[1], '[^\\]*.$', '', 'g') 
               \ :  matchstr(i[1], '[^/]*.$', '', 'g')

    if matchstr(name, regexp) != ''
      call add(fview.selectedFiles, i[1])
    endif
  endfor
  call fview.drawList()
endfunction
let s:FilePanel.markViaRegexp = function("s:FilePanel_mark_via_regexp")

function! s:FilePanel_mark_executable() dict
  let fview = self
  let fview.selectedFiles = []
  for i in fview.displayList
    if g:platform.executable(i[1])
      call add(fview.selectedFiles, i[1])
    endif
  endfor
  call fview.drawList()
endfunction
let s:FilePanel.markExecutable = function("s:FilePanel_mark_executable")

function! s:FilePanel_new_file() dict
  let fview = self
  echohl Special
  let filename = vimside#util#Input("Create file : ", fview.path, "file")
  echohl None
  if filename == ''
    echo " "
  else
    if g:platform.mkfile(filename)
      echohl Special | echomsg "OK" | echohl None
      call fview.refresh()
    else
      echohl ErrorMsg | echomsg "Can not create file!" | echohl None
    endif
  endif
endfunction
let s:FilePanel.newFile = function("s:FilePanel_new_file")

function! s:FilePanel_new_directory() dict
  let fview = self
  if !exists("*mkdir")
    echoerr "mkdir feature not found!"
  endif
  echohl Special
  let dirname = vimside#util#Input("Create directory : ", fview.path, "file")
  echohl None
  if dirname == ''
    echo " "
  else
    if findfile(dirname) == '' && g:platform.mkdir(dirname)
      echohl Special | echomsg "OK" | echohl None
      call fview.refresh()
    else
      echohl ErrorMsg | echomsg "Can not create directory!" | echohl None
    endif
  endif
endfunction
let s:FilePanel.newDirectory = function("s:FilePanel_new_directory")

function! s:FilePanel_rename(line) dict
  let fview = self
  let path = fview.displayList[a:line][1]
  if path != ''
    echohl Special
    let name = vimside#util#Input("Rename to: ", path, "file")
    echohl None

    if name == ''
      echo " "
    else
      if findfile(name) != ''
        echohl ErrorMsg | echomsg "File exists!" | echohl None
        return
      endif
      if rename(path, name) == 0
        echohl Special | echomsg "OK" | echohl None
        call fview.refresh()
      else
        echohl ErrorMsg | echomsg "Can not rename!" | echohl None
      endif
    endif
  endif
endfunction
let s:FilePanel.rename = function("s:FilePanel_rename")

function! s:FilePanel_search() dict
  let fview = self
  echohl Special
  let filename = vimside#util#Input("Search : ")
  echohl None

  if filename == ''
    echo " "
  else
    echohl Special | echomsg "Searching [" . filename . "] in " . fview.path . ", please wait...(Ctrl-C to break)" | echohl None
    let fview.fileList = g:platform.search(filename, fview.path)
    call fview.updateDisplayList()
    call fview.drawList()
  endif
endfunction
let s:FilePanel.search = function("s:FilePanel_search")

function! s:FilePanel_status_file_name() dict
  let fview = self
  let line = line(".") - 1
  let fname = fview.displayList[line][1]
  "let fname = substitute(fname, fview.path, '', 'g')
  let fname = fname[len(fview.path):]
  return fname
endfunction
let s:FilePanel.statusFileName = function("s:FilePanel_status_file_name")

function! s:FilePanel_create_actions() dict
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.help .           " :tab h VimExplorer<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.switchPanel .    " <c-w><c-w>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.itemClicked .    " :call VE_OnFileItemClick()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.itemClickMouse.  " :call VE_OnFileItemClick()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toggleTreePanel ." :call VE_ToggleTreePanel()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toUpperDir .     " :call VE_ToUpperDir()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.gotoForward .    " :call VE_GotoForward()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.gotoBackward .   " :call VE_GotoBackward()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.openPreview .    " :call VE_OnFileOpenPreview()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.closePreview .   " :call VE_ClosePreviewPanel()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.deleteSingle .   " :call VE_DeleteSingle(0)<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.deleteSingleF.   " :call VE_DeleteSingle(1)<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.rename .         " :call VE_Rename()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.refresh .        " :call VE_RefreshFilePanel()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toggleSelectUp  ." :call VE_ToggleSelectFile(\"up\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toggleSelectDown." :call VE_ToggleSelectFile(\"down\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.clearSelect .    " :call VE_ClearSelectFile()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.deleteSelected . " :call VE_DeleteSelectedFiles(0)<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.deleteSelectedF. " :call VE_DeleteSelectedFiles(1)<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.yankSelected .   " :call VE_YankSelectedFiles(\"copy\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.cutSelected .    " :call VE_YankSelectedFiles(\"cut\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.yankSingle .     " :call VE_YankSingle(\"copy\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.cutSingle .      " :call VE_YankSingle(\"cut\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.showYankList .   " :call VE_ShowYankList()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toggleModes .    " :call VE_ToggleModes()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.paste .          " :call VE_Paste()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.markViaRegexp .  " :call VE_MarkViaRegexp('')<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.markExecutable . " :call VE_MarkExecutable()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.markVimFiles .   " :call VE_MarkViaRegexp('.*.vim$')<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.markDirectory .  " :call VE_MarkViaRegexp('.*[\\/]$')<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.newFile .        " :call VE_NewFile()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.newDirectory .   " :call VE_NewDirectory()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.markViaRegexp .  " :call VE_MarkViaRegexp('')<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.favorite .       " :call VE_GotoFavorite()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.addToFavorite .  " :call VE_AddToFavorite('filePanel')<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.browser_history .  " :call VE_BrowseHistory()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.gotoPath .       " :call VE_OpenPath()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.diff2files .     " :call VE_Diff()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.quitVE .         " :call VEDestroy()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toggleHidden .   " :call VE_ToggleHidden()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.search .         " :call VE_FileSearch()<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.toggleSelMouse . " <leftmouse>:call VE_ToggleSelectFile(\"\")<cr>"
  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.contextMenuN .   " <leftmouse>:popup  ]FilePanelPopup<cr>"

  let letter = char2nr('a')
  while letter <= char2nr('z')
    exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.markPlace . nr2char(letter) .
                \" :call VE_MarkPlace(\"" . nr2char(letter) . "\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.gotoPlace . nr2char(letter) .
                \" :call VE_MarkSwitchTo(\"" . nr2char(letter) . "\")<cr>"
    let letter = letter + 1
  endwhile

  exec "nnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.viewMarks . " :call VE_MarkList()<cr>"

  " visual mode map
  exec "vnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.visualSelect .   " :call VE_VisualSelect()<cr>"
  exec "vnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.visualDelete .   " :call VE_VisualDelete(0)<cr>"
  exec "vnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.visualDeleteF.   " :call VE_VisualDelete(1)<cr>"
  exec "vnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.visualYank .     " :call VE_VisualYank(\"copy\")<cr>"
  exec "vnoremap <silent> <buffer> " . g:conf.file_panel_hotkey.visualCut .      " :call VE_VisualYank(\"cut\")<cr>"

  " User defined map
  for i in keys(g:VEConf_normalHotKeys)
    exec "nnoremap <silent> <buffer> " . g:VEConf_normalHotKeys[i] .
                  \" :call VE_NormalAction(\"" . i . "\")<cr>"
  endfor
  for i in keys(g:VEConf_singleFileHotKeys)
    exec "nnoremap <silent> <buffer> " . g:VEConf_singleFileHotKeys[i] .
                  \" :call VE_SingleFileAction(\"" . i . "\")<cr>"
  endfor
  for i in keys(g:VEConf_multiFileHotKeys)
    exec "nnoremap <silent> <buffer> " . g:VEConf_multiFileHotKeys[i] .
                  \" :call VE_MultiFileAction(\"" . i . "\")<cr>"
  endfor

  " Auto commands
  au! * <buffer>
  au BufEnter <buffer>  call VE_SyncDir()
  " Status line
  setlocal statusline=%{VE_GetStatusFileName()}%=[%{getcwd()}]\ %{strftime(\"\%Y-\%m-\%d\ \%H:\%M\")}
endfunction
let s:FilePanel.createActions = function("s:FilePanel_create_actions")

function! s:FilePanel_create_syntax() dict
  let fview = self
  let VEFileWinNr = bufwinnr(fview.name)
  if VEFileWinNr != -1
    exec VEFileWinNr . " wincmd w"
    call g:conf.filePanelSyntax()
  endif
endfunction
let s:FilePanel.createSyntax = function("s:FilePanel_create_syntax")

function! s:FilePanel_get_path_under_cursor(num) dict
  let fview = self
  return fview.displayList[a:num][1]
endfunction
let s:FilePanel.getPathUnderCursor = function("s:FilePanel_get_path_under_cursor")




" class PreviewPanel {{{1
"=============================
"let s:PreviewPanel = {}
"let s:PreviewPanel.name = ''
"let s:PreviewPanel.width = 0
"let s:PreviewPanel.splitMode = ''
"let s:PreviewPanel.splitLocation = ''
"
"function! s:PreviewPanel.init(name)
"    let self.name = "PreviewPanel" . a:name
"    let self.width = g:conf.previewPanelWidth
"    let self.splitMode = g:conf.previewPanelSplitMode
"    let self.splitLocation = g:conf.previewPanelSplitLocation
"endfunction

"function! s:PreviewPanel.show()
"    if self.setFocus()
"        return
"    endif
"    let cmd = self.splitLocation . " " . self.splitMode . self.width . ' new '
"    exec cmd
"    if !self.setFocus()
"        echoerr "create file window failed!"
"    else
"        edit self.name
"    endif
"endfunction

"function! s:PreviewPanel.setFocus()
"    let VEPreviewWinNr = bufwinnr(self.name)
"    if VEPreviewWinNr != -1
"        exec VEPreviewWinNr . " wincmd w"
"        return 1
"    else
"        "If the window of buffer was closed by hand and the
"        "buffer still in buffer list, wipeout it.
"        "In case of bufnr() returns empty when there are two
"        "buffers have the same name.
"        let bufNr = bufnr(self.name)
"        if bufNr != -1
"            exec "bwipeout " . bufNr
"        endif
"        return 0
"    endif
"endfunction
"
"function! s:PreviewPanel.hide()
"    if !self.setFocus()
"        return
"    else
"        let bufNr = bufnr('%')
""        exec "wincmd c"
"        exec "bwipeout ".bufNr
"    endif
"endfunction
"
"function! s:PreviewPanel.preview(path)
"    if !self.setFocus()
"        let self.name = a:path
"        let cmd = self.splitLocation . " " . self.splitMode . self.width . ' new'
"        exec cmd
"        exec "edit " . self.name
"        return
"    else
"        let self.name = a:path
"        exec "edit " . self.name
"    endif
"endfunction



" class FrameWork {{{1
"=============================
let s:FrameWork = {}
let s:FrameWork.name = ''
let s:FrameWork.treePanel = {}
let s:FrameWork.filePanel = {}
"let s:FrameWork.previewPanel = {}
let s:FrameWork.pathHistory = []
let s:FrameWork.pathPosition = -1

"Object Constructor
function! s:FrameWork_init(ftag, path, sourceRoots) dict
call s:LOG("FrameWork_init: ftag='". a:ftag ."', path='". a:path ."', sourceRoots=". string(a:sourceRoots))
    " let self.name = "FrameWork".a:ftag
    let self.name = "FrameWork".a:ftag
    let self.filePanel = deepcopy(s:FilePanel)
    let self.treePanel = deepcopy(s:TreePanel)
    "let self.previewPanel = deepcopy(s:PreviewPanel)
    call self.filePanel.init(a:ftag, a:path)
    call self.treePanel.init(a:ftag, a:path, a:sourceRoots)
    "call self.previewPanel.init(a:ftag)
    call add(self.pathHistory, a:path)
    let self.pathPosition += 1
endfunction
let s:FrameWork.init = function("s:FrameWork_init")

function! s:FrameWork_show() dict
    tabnew
    call self.filePanel.show()
    call self.filePanel.only() "so, here it means filePanel should be displayed first
    call self.treePanel.show()
    call self.filePanel.setFocus()
    call self.filePanel.refresh()
    normal! M
endfunction
let s:FrameWork.show = function("s:FrameWork_show")

"Switch to another path, it will change the forward/backward
"history.
function! s:FrameWork_goto_path(path) dict
call s:LOG("FrameWork_goto_path: TOP")
    call self.treePanel.pathChanged(a:path)
    call self.filePanel.pathChanged(a:path)
    if len(self.pathHistory) > self.pathPosition+1
        call remove(self.pathHistory, self.pathPosition+1, -1)
    endif
    call add(self.pathHistory, a:path)
    if len(self.pathHistory) > g:conf.browser_history
        call remove(self.pathHistory, 0)
    else
        let self.pathPosition += 1
    endif
call s:LOG("FrameWork_goto_path: BOTTOM")
endfunction
let s:FrameWork.gotoPath = function("s:FrameWork_goto_path")

"Forward and backward
function! s:FrameWork_goto_forward() dict
    if self.pathPosition >= len(self.pathHistory) ||
                \ self.pathPosition < 0 ||
                \ empty(self.pathHistory)
        return
    endif
    if self.pathPosition+1 == len(self.pathHistory) "Can not forward
        return
    endif
    let self.pathPosition += 1
    "Do not call VE_GotoPath here! It will change pathHistory.
    "Call the follows instead.
    call self.treePanel.pathChanged(self.pathHistory[self.pathPosition])
    call self.filePanel.pathChanged(self.pathHistory[self.pathPosition])
endfunction
let s:FrameWork.gotoForward = function("s:FrameWork_goto_forward")

function! s:FrameWork_goto_backward() dict
    if self.pathPosition >= len(self.pathHistory) ||
                \ self.pathPosition < 0 ||
                \ empty(self.pathHistory)
        return
    endif
    if self.pathPosition == 0 "Can not go back.
        return
    endif
    let self.pathPosition -= 1
    "Do not call VE_GotoPath here! It will change pathHistory.
    "Call the follows instead.
    call self.treePanel.pathChanged(self.pathHistory[self.pathPosition])
    call self.filePanel.pathChanged(self.pathHistory[self.pathPosition])
endfunction
let s:FrameWork.gotoBackward = function("s:FrameWork_goto_backward")

"Object destructor
function! s:FrameWork_destroy() dict
    call self.filePanel.hide()
    call self.treePanel.hide()
endfunction
let s:FrameWork.destroy = function("s:FrameWork_destroy")






"####################################################
"global variables and functions {{{1

let s:frame_tag = 0

let s:Container = {} "contains all FrameWorks
let s:Container.clipboard = [] "shared clipboard
let s:Container.yankMode = ''  "cut or yank
let s:Container.markPlaces = {}

if 0
function! s:VECreatePopMenu()
    silent! unmenu  ]FilePanelPopup
    menu    ]FilePanelPopup.&Open               :call VE_OnFileItemClick()<cr>
    menu    ]FilePanelPopup.-sep0-              :
    menu    ]FilePanelPopup.&Copy               :call VE_YankSingle("copy")<cr>
    menu    ]FilePanelPopup.C&ut                :call VE_YankSingle("cut")<cr>
    menu    ]FilePanelPopup.-sep1-              :
    menu    ]FilePanelPopup.&Rename             :call VE_Rename()<cr>
    menu    ]FilePanelPopup.&Delete             :call VE_DeleteSingle(0)<cr>
    menu    ]FilePanelPopup.Pre&view            :call VE_OnFileOpenPreview()<cr>
    menu    ]FilePanelPopup.&Mark               :call VE_ToggleSelectFile("")<cr>
    menu    ]FilePanelPopup.-sep2-              :
    menu    ]FilePanelPopup.&Paste              :call VE_Paste()<cr>
    menu    ]FilePanelPopup.&New.&File          :call VE_NewFile()<cr>
    menu    ]FilePanelPopup.&New.&Directory     :call VE_NewDirectory()<cr>
    menu    ]FilePanelPopup.-sep3-              :
    menu    ]FilePanelPopup.Re&fresh            :call VE_RefreshFilePanel()<cr>
endfunction
endif

function! s:GetWinName() 
  return matchstr(bufname("%"), '_[^_]*$')
endfunction

function! vimside#plugin#sourcebrowser#Run(sourceRoots)
  call VENew('', a:sourceRoots)
endfunction

function! VENew(path, sourceRoots)
call s:LOG("VENew: path '". a:path ."', sourceRoots= ". string(a:sourceRoots))
"    call s:VECreatePopMenu()
  let ftag = '_' . s:frame_tag
  let s:frame_tag += 1

  let l:sourceRoots = []
  for i in a:sourceRoots
    if isdirectory(i)
      if s:is_windoz_like
        if i[-1:] != "\\"
          let i .= "\\"
        endif
      else
        if i[-1:] != "/"
          let i .= "/"
        endif
      endif
      call add(l:sourceRoots, i)
    else
      call s:ERROR("VENew: Not a directory: '". i ."'")
      return
    endif
  endfor

  if l:sourceRoots == []
    call s:ERROR("VENew: empty sourceRoots")
    return
  endif

  if a:path == ''
    echohl Special
    let workPath = vimside#util#Input("VimExplorer (directory): ", l:sourceRoots[0], "file")
    echohl None
  else
    let workPath = a:path
  endif
  if workPath == ''
    call s:ERROR("VENew: empty path")
    return
  endif

  " workPath must be a sub-directory of one of the root directories
  " which is to say, workPath must contain a root directory
  let idx = -1
  for rootdir in l:sourceRoots
    let idx = stridx(workPath, rootdir)
    if idx != -1
      break
    endif
  endfor

  if idx == -1
    call s:ERROR("VENew: path '". workPath ."' not in root directories")
    return
  endif
  if !isdirectory(workPath)
    "  echohl ErrorMsg | echomsg "Directory not exist!" | echohl None
    call s:ERROR("VENew: path '". workPath ."' not directory")
    return
  endif

call s:LOG("VENew: workPath=". workPath)
call s:LOG("VENew: ftag=". ftag)
  let s:Container[ftag] = deepcopy(s:FrameWork)
  call s:Container[ftag].init(ftag, workPath, l:sourceRoots)
  call s:Container[ftag].show()

  let letter = char2nr('a')
  while letter <= char2nr('z')
    let s:Container.markPlaces[nr2char(letter)] = ''
    let letter += 1
  endwhile
endfunction

function! VEDestroy()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].destroy()
    call remove(s:Container, winName)
  endif
endfunction

function! s:Container.showClipboard()
  echohl Special
  let msg = len(self.clipboard) . " files in clipboard, Mode: " . self.yankMode . ", "
  let msg = msg . '(press ' . g:conf.file_panel_hotkey.showYankList . ' to show file list)'
  echomsg msg
  echohl None
endfunction

" Get path name under cursor
function! VE_getPathUnderCursor(where)
  let winName = s:GetWinName()
  let path = ''
  if has_key(s:Container, winName)
    if a:where == 'treePanel'
      let path = s:Container[winName].treePanel.getPathUnderCursor(line(".")-1)
    elseif a:where == 'filePanel'
     let path = s:Container[winName].filePanel.getPathUnderCursor(line(".")-1)
    endif
  endif

  return isdirectory(path) ? path : ''
endfunction


"Command handlers
"===================================

"TreePanel command handlers
"----------------------------
"Node click event
function! VE_OnTreeNodeClick()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].treePanel.nodeClicked(line(".")-1)
  endif
endfunction

"Refresh tree command
function! VE_TreeRefresh()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].treePanel.refresh()
  endif
endfunction

"FilePanel command handlers
"----------------------------
"Item click event.
function! VE_OnFileItemClick()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.itemClicked(line(".")-1)
  endif
endfunction

"Open preview.
function! VE_OnFileOpenPreview()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.itemPreview(line(".")-1)
  endif
endfunction

"Refresh the panel.
function! VE_RefreshFilePanel()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.refresh()
  endif
endfunction

"User defined single file actions.
function! VE_SingleFileAction(actionName)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.singleFileAction((line(".")-1), a:actionName)
  endif
endfunction

"User defined normal actions.
function! VE_NormalAction(actionName)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.normalAction(a:actionName)
  endif
endfunction

"Multiple file actions.
function! VE_MultiFileAction(actionName)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.multiAction(a:actionName)
  endif
endfunction

"Delete single file or directory.
function! VE_DeleteSingle(bForce)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.deleteSingle(line(".")-1, a:bForce)
  endif
endfunction

"Rename file or dir
function! VE_Rename()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.rename(line(".")-1)
  endif
endfunction

"Toggle select a file in file panel.
function! VE_ToggleSelectFile(direction)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.toggleSelect(a:direction)
  endif
endfunction

"Clear selection.
function! VE_ClearSelectFile()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.clearSelect()
  endif
endfunction

"Toggle sort mode
function! VE_ToggleModes()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.toggleModes()
  endif
endfunction

"Mark via regexp
function! VE_MarkViaRegexp(regexp)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.markViaRegexp(a:regexp)
  endif
endfunction

"Mark executable files.
function! VE_MarkExecutable()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.markExecutable()
  endif
endfunction

"create file
function! VE_NewFile()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.newFile()
  endif
endfunction

"create directory
function! VE_NewDirectory()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.newDirectory()
  endif
endfunction

"delete selected files.
function! VE_DeleteSelectedFiles(bForce)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.deleteSelectedFiles(a:bForce)
  endif
endfunction

"delete selected files.
function! VE_YankSelectedFiles(mode)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let s:Container.clipboard = s:Container[winName].filePanel.selectedFiles
    let s:Container.yankMode = a:mode
  endif
  call s:Container.showClipboard()
endfunction

function! VE_YankSingle(mode)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.yankSingle(a:mode)
  endif
endfunction

function! VE_Paste()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.paste()
  endif
endfunction

function! VE_FileSearch()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.search()
  endif
endfunction


"visual mode functions.
"visual select
function! VE_VisualSelect() range
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.visualSelect(a:firstline-1, a:lastline-1)
  endif
endfunction

"visual delete
function! VE_VisualDelete(bForce) range
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.visualDelete(a:firstline-1, a:lastline-1, a:bForce)
  endif
endfunction

"visual yank
function! VE_VisualYank(mode) range
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].filePanel.visualYank(a:firstline-1, a:lastline-1, a:mode)
  endif
endfunction

function! VE_ShowYankList()
  if s:Container.clipboard != []
    for i in s:Container.clipboard
      echo i
    endfor
  endif
endfunction

"Common command handlers
"--------------------------
"get file name for status line.
function! VE_GetStatusFileName()
  let winName = s:GetWinName()
  return has_key(s:Container, winName)
        \ ? s:Container[winName].filePanel.statusFileName() : ''
endfunction

"mark palce
function! VE_MarkPlace(char)
  let s:Container.markPlaces[a:char] = g:platform.getcwd()
endfunction

"goto marked place
function! VE_MarkSwitchTo(char)
  call VE_GotoPath(s:Container.markPlaces[a:char])
endfunction

function! VE_MarkList()
  let list = []
  let letter = char2nr('a')
  while letter <= char2nr('z')
    if s:Container.markPlaces[nr2char(letter)] != ''
      echo nr2char(letter) . "  " . s:Container.markPlaces[nr2char(letter)]
    endif
    let letter += 1
  endwhile
endfunction

"Toggle tree panel.
function! VE_ToggleTreePanel()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    if s:Container[winName].treePanel.setFocus()
      call s:Container[winName].treePanel.hide()
    else
      call s:Container[winName].treePanel.show()
    endif
  endif
  exec "wincmd p"
endfunction

"Toggle file panel.
function! VE_ToggleFilePanel()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    if s:Container[winName].filePanel.setFocus()
      call s:Container[winName].filePanel.hide()
    else
      call s:Container[winName].filePanel.show()
    endif
  endif
  call s:Container[winName].treePanel.setFocus()
  exec g:conf.tree_panel_width . " wincmd |"
endfunction

function! VE_ClosePreviewPanel()
  pclose
endfunction


"Go to upper directory.
function! VE_ToUpperDir()
  let winNr = bufwinnr('%')
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let path = s:Container[winName].filePanel.path
    " Assert filePanel.path == treePanel.path
    let upperPath = g:platform.getUpperDir(path)
    if upperPath == path
      return
    endif
    call VE_GotoPath(upperPath)
    let dir = split(path, '/')
    call search("  " . dir[-1] . "/\t")
  endif

  exec winNr . "wincmd w"
endfunction

"Path change event
function! VE_GotoPath(path)
call s:LOG("VE_GotoPath: TOP path=". a:path)
  if !isdirectory(a:path)
   return
  endif
if 0
    call g:platform.cdToPath(a:path)
    let path = g:platform.getcwd()
endif
  let path = a:path
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].gotoPath(path)
  endif
call s:LOG("VE_GotoPath: BOTTOM path=". a:path)
endfunction

"Used in <c-g>
function! VE_OpenPath()
call s:LOG("VE_OpenPath:")
  echohl Special
  let workPath = vimside#util#Input("Change path to (directory): ", '', "file")
  echohl None
  if workPath == ''
    return
  endif
if 0
    call g:platform.cdToPath(workPath)
    let workPath = g:platform.getcwd()
endif
  call VE_GotoPath(workPath)
endfunction

"Goto forward
function! VE_GotoForward()
  let winNr = bufwinnr('%')
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].gotoForward()
  endif

  exec winNr . "wincmd w"
endfunction

"Goto backward
function! VE_GotoBackward()
  let winNr = bufwinnr('%')
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    call s:Container[winName].gotoBackward()
  endif

  exec winNr . "wincmd w"
endfunction

"Favorite
function! VE_GotoFavorite()
  let fav_filename = g:platform.getHome() . g:conf.favorite
  if findfile(fav_filename)=='' || !filereadable(fav_filename)
    return
  endif
  let fav = readfile(fav_filename)
  let result = g:platform.select(fav, "Favorite folder list:")
  if result != -1
    call VE_GotoPath(fav[result])
  endif
endfunction

function! VE_AddToFavorite(where)
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let cwd = s:Container[winName].filePanel.path
  else
    return
  endif
  let pathUnderCursor = VE_getPathUnderCursor(a:where)
  if pathUnderCursor != ''
    " if no path name under cursor, use current working path
    let cwd = pathUnderCursor
  endif
  let fav_filename = g:platform.getHome() . g:conf.favorite
  let fav = []
  if findfile(fav_filename) != ''
    if !filereadable(fav_filename)
      echoerr "Can not read favorite folder list!"
      return
    endif
    if !filewritable(fav_filename)
      echoerr "Can not write favorite folder list to file!"
      return
    endif
    let fav = readfile(fav_filename)
  endif
  if index(fav, cwd) != -1
    "echohl WarningMsg | echomsg "Current directory already in the favorite list." | echohl None
    echohl WarningMsg | echomsg "[ ".cwd." ] already in the favorite!" | echohl None
    return
  endif
  call add(fav, cwd)
  if writefile(fav, fav_filename) == 0
    echohl Special | echomsg "[ ".cwd." ] added to favorite." | echohl None
  else
    echoerr "Can not write favorite folder list to file!"
  endif
endfunction

"forward and backward history
function! VE_BrowseHistory()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let pathlist = s:Container[winName].pathHistory
    let result = g:platform.select(pathlist, "Browse history:")
    if result != -1
      call s:Container[winName].treePanel.pathChanged(pathlist[result])
      call s:Container[winName].filePanel.pathChanged(pathlist[result])
      let s:Container[winName].pathPosition = result
    endif
  endif
endfunction

"sync directory
function! VE_SyncDir()
call s:LOG("VE_SyncDir:")
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let path = s:Container[winName].filePanel.path
    call g:platform.cdToPath(path)
  endif
endfunction

"diff 2 files
function! VE_Diff()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let diffFiles = s:Container[winName].filePanel.selectedFiles
    if len(diffFiles) != 2 || isdirectory(diffFiles[0]) || isdirectory(diffFiles[1])
      echohl WarningMsg | echo "Please select 2 files to diff!" | echohl None
      return
    endif
    exec "tabe " . g:platform.escape(diffFiles[0])
    exec "vertical diffsplit " . g:platform.escape(diffFiles[1])
  endif
endfunction

"toggle show hidden files
function! VE_ToggleHidden()
  let winName = s:GetWinName()
  if has_key(s:Container, winName)
    let g:conf.show_hidden_files = !g:conf.show_hidden_files
    call s:Container[winName].treePanel.refresh()
    call s:Container[winName].filePanel.refresh()
  endif
endfunction


if 0 " SOURCEROOTS
command! -nargs=? -complete=file SR    call VENew('<args>', s:source_roots)
command! -nargs=? -complete=file RSR    call VENew('<args>', s:reference_source_roots)

" command! -nargs=? -complete=file VE    call VENew('<args>', [])
" command! -nargs=0 -complete=file VEC   call VEDestroy()
endif " SOURCEROOTS


" vim: set et fdm=marker sts=2 sw=2 tw=78:
