"============================================================================
" File:         sourcebrowser.vim
" Brief:        Vimside Forms Plugin: Root Sources Manager
" Author:       Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Change:  2012
"
"============================================================================
" Info:
"============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")

function! s:FnameEscape(fname)
  return exists('*fnameescape')
          \ ? fnameescape(a:fname)
          \ : escape(a:fname, " \t\n*?[{`$\\%#'\"|!<")
endfunc

function! vimside#forms#sourcebrowser#Run(sourceRoots)
" call s:LOG("vimside#forms#sourcebrowser#Run TOP")

  let paths = a:sourceRoots

  let trees = []
  for path in paths
    let pathlist = split(path, '/')
    let node = forms#CreateNode()
    call node.init(pathlist, 0)
    let tree = forms#CreateTree(node)
    call add(trees, tree)
  endfor

  let forest = forms#CreateForest()

  " returns list of [name, isleaf] pairs
  function! Generate_sub_path_info(path) dict
    let l:path = '/' . join(a:path, '/')
" call forms#log("Generate_sub_path_info path=". string(l:path))
    let files = split(globpath(l:path, "*"), "\n")
" call forms#log("Generate_sub_path_info files=". string(files))
    let rval = []
    for file in files
      let isleaf = !isdirectory(file)
      let idx = strridx(file, '/')
      let name = strpart(file, idx+1)
      call add(rval, [name, isleaf])
    endfor
    return rval
  endfunction
  let forest.generateSubPathInfo = function("Generate_sub_path_info")

  function! Has_sub_path_info(path) dict
    let l:path = '/' . join(a:path, '/')
" call forms#log("Has_sub_path_info path=". string(l:path))
    let files = split(globpath(l:path, "*"), "\n")
" call forms#log("Has_sub_path_info files=". string(files))
    let rval = 0
    for file in files
      if isdirectory(file)
        let rval = 1
        break
      endif
    endfor
    return rval
  endfunction
  let forest.hasSubPathInfo = function("Has_sub_path_info")

  function! Path_to_string(path) dict
    return '/' . join(a:path, '/')
  endfunction
  let forest.pathToString = function("Path_to_string")


  function! ForestOnOpenAction(tree, node) dict
    call forms#log("OPEN: ". a:node.name)
    call self.nv.setNode(a:tree, a:node, 1)
  endfunction
  let fooa = forms#newAction({ 'execute': function("ForestOnOpenAction")})

  function! ForestOnCloseAction(tree, node) dict
    call forms#log("CLOSE: ". a:node.name)
    let [found, parent_node] = a:node.getParent(a:tree)
    if found
      call self.nv.setNode(a:tree, parent_node, 1)
    else
      " no parent, must be at top
      call self.nv.setNode(a:tree, a:node, 1)
    endif
  endfunction
  let foca = forms#newAction({ 'execute': function("ForestOnCloseAction")})

  function! ForestOnSelectionAction(tree, node) dict
    call forms#log("SELECT: ". a:node.name)
  endfunction
  let fosa = forms#newAction({ 'execute': function("ForestOnSelectionAction")})

  for tree in trees
    call forest.addTree(tree)
  endfor

  let wwidth = winwidth(0)
  let width = wwidth - 5
  let fvwidth = width/2
  let nvwidth = width/2
  let tewidth = width

  let wheight = winheight(0)
  let teheight = 5
  let vheight = wheight - teheight - 8

  let fvheight = vheight
  let nvheight = vheight

  let attrs = { 'width': fvwidth,
              \ 'height': fvheight,
              \ 'forest': forest,
              \ 'content_order': 'non-leaf-only',
              \ 'on_open_action': fooa,
              \ 'on_close_action': foca,
              \ 'on_selection_action': fosa
              \ }
  let fv = forms#newForestViewer(attrs)
  let fvbox = forms#newBox({ 'body': fv } )



  function! NodeOnOpenAction(tree, node) dict
call forms#log("NODE OPEN: ". a:node.name)
    call self.fv.setNode(a:tree, a:node)
  endfunction
  let nooa = forms#newAction({ 'execute': function("NodeOnOpenAction")})

  function! NodeOnCloseAction(tree, node) dict
call forms#log("NODE CLOSE: ". a:node.name)
   call self.fv.setNode(a:tree, a:node)
  endfunction
  let noca = forms#newAction({ 'execute': function("NodeOnCloseAction")})

  function! NodeOnSelectionAction(tree, node) dict
call forms#log("NODE SELECT: ". a:node.name)
    let filepath = a:tree.forest.pathToString(a:node.path)
  
    let lines = []
    let found = 0
    let te = self.texteditor
    for line in te.__textlines
      if line == filepath
        let found = 1
      else
        call add(lines, line)
      endif
    endfor

    if ! found
      call add(lines, filepath)
    endif

    let te.__textlines = lines

    call forms#ViewerRedrawListAdd(te)
  endfunction
  let nosa = forms#newAction({ 'execute': function("NodeOnSelectionAction")})

  let attrs = { 'width': nvwidth,
              \ 'height': nvheight,
              \ 'node': node,
              \ 'tree': tree,
              \ 'top_node_full_name': 0,
              \ 'on_open_action': nooa,
              \ 'on_close_action': noca,
              \ 'on_selection_action': nosa
              \ }
  let nv = forms#newNodeViewer(attrs)
  let nvbox = forms#newBox({ 'body': nv } )


  let fooa.nv = nv
  let foca.nv = nv
  let fosa.nv = nv

  let nooa.fv = fv
  let noca.fv = fv

  let hpoly = forms#newHPoly({ 'children': [fvbox, nvbox] })
  "...........................

  let texteditor_tag = 'files'
  let attrs = { 'tag': texteditor_tag,
              \ 'width': tewidth,
              \ 'height': teheight,
              \ 'status': g:IS_DISABLED
              \ }
  let texteditor = forms#newTextEditor(attrs)
  let tebox = forms#newBox({ 'body': texteditor } )

  let nosa.texteditor = texteditor

  "...........................
  let cancellabel = forms#newLabel({'text': "Cancel"})
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel',
                              \ 'body': cancellabel,
                              \ 'action': g:forms#cancelAction})
  let hspace = forms#newHSpace({'size': 1})
  let label = forms#newLabel({'text': "Submit"})
  let submitbutton = forms#newButton({
                              \ 'tag': 'submit',
                              \ 'body': label,
                              \ 'action': g:forms#submitAction})
  let buttonhpoly = forms#newHPoly({ 'children': [
                                      \ cancelbutton,
                                      \ hspace,
                                      \ submitbutton],
                                      \ 'alignment': 'T' })
  "...........................

  let vpoly = forms#newVPoly({ 
                        \ 'children': [hpoly, tebox, buttonhpoly],
                        \  'alignment': 'R' 
                        \ })

  let bg = forms#newBackground({ 'body': vpoly} )

  let [found, in_tab] = g:vimside.GetOption('tailor-forms-sourcebrowser-open-in-tab')
  let attrs = { 'open_in_tab': (found && in_tab),
              \ 'body': bg
              \ }
  let form = forms#newForm(attrs)

  call vimside#scheduler#HaltFeedKeys()
  try
    let rval = form.run()
  finally
    call vimside#scheduler#ResumeFeedKeys()
  endtry

" call s:LOG("rval=". string(rval))

  if type(rval) == g:self#DICTIONARY_TYPE
    if has_key(rval, texteditor_tag)
      let files = rval[texteditor_tag]
      for line in files
        if filereadable(line)
          exec "tabe " . line
        endif
      endfor
    endif
  endif

endfunction

