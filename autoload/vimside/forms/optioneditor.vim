"============================================================================
" File:         optioneditor.vim
" Brief:        Vimside Forms Plugin: Edit/View options
" Author:       Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Change:  2012
"
"============================================================================
" Info:
"============================================================================

let s:LOG = function("vimside#log#log")
let s:ERROR = function("vimside#log#error")


function! s:makeValueGlyph(label, value, max_width)
  let offset = len(a:label)
  let val_len = len(a:value)
  if val_len < a:max_width
    let value_glyph = forms#newLabel({'text': a:label . a:value})
  else
    let textlines = []
    let start = 0
    while start < a:max_width
      if start == 0
        let line = a:label .  strpart(a:value, start, a:max_width-offset)
      else
        let line = repeat(' ', offset) .  strpart(a:value, start, a:max_width-offset)
      endif
      call add(textlines, line)
" call s:LOG("line=". line)

      let start += (a:max_width - offset)
    endwhile
    let value_glyph = forms#newText({'textlines': textlines})
  endif
  return value_glyph
endfunction

function! vimside#forms#optioneditor#Run()
" call s:LOG("vimside#forms#optioneditor#Run")

  let win_width = winwidth(0)
  let max_value_width = win_width - 10

  "...........................
  let title = forms#newLabel({'text': "Options"})

  "...........................
  function! StaticAction(...) dict
" call s:LOG("StaticAction")
    call self.deck.setCard(0)
  endfunction
  
  let staticaction = forms#newAction({ 'execute': function("StaticAction")})
  let staticlabel = forms#newLabel({'text': "Static"})
  let staticbutton = forms#newButton({
                              \ 'tag': 'static',
                              \ 'body': staticlabel,
                              \ 'action': staticaction })

  function! DynamicAction(...) dict
" call s:LOG("DynamicAction")
    call self.deck.setCard(1)
  endfunction
  
  let dynamicaction = forms#newAction({ 'execute': function("DynamicAction")})
  let dynamiclabel = forms#newLabel({'text': "Dynamic"})
  let dynamicbutton = forms#newButton({
                              \ 'tag': 'dynamic',
                              \ 'body': dynamiclabel,
                              \ 'action': dynamicaction })

  let hspace = forms#newHSpace({'size': 4})

  let buttonhpoly = forms#newHPoly({ 
                        \ 'children': [staticbutton, hspace, dynamicbutton],
                        \ 'alignment': 'T' 
                        \ })
  
  "...........................
  
  let scopedeck = []
  let vspace = forms#newVSpace({'size': 1})

if 0
for key in keys(g:vimside.options.user.keyvals)
  if key != 'check'
" call s:LOG("key=". key .", value=". string(g:vimside.options.user.keyvals[key]))
  endif
endfor
endif

  let static_defs = {}
  let dynamic_defs = {}
  let definitions = g:vimside.GetOptionDefinitions()
  for key in sort(keys(definitions))
if 0
    let [found, v] = g:vimside.GetOption(key)
    if found
" call s:LOG("key=". key ."=". string(v))
    else
" call s:LOG("key=". key ."=NOT_FOUND")
    endif
endif

    let def = definitions[key]
    if def.scope == g:OPTION_DYNAMIC_SCOPE
      let dynamic_defs[key] = def
    else
      let static_defs[key] = def
    endif
  endfor


  "......
  " static
  let staticlabel = forms#newLabel({'text': "Static Options"})
  let statictext = forms#newText({ 'textlines': [
                    \ 'Options whose values can not be changed and have',
                    \ 'effect at runtime. If changes are saved, the',
                    \ 'application must be re-started to see the change.'
                    \ ]})

  let cardList = []
  let choices = []
  let cnt = 0
  for key in sort(keys(static_defs))
    let label_children = []
    let def_children = []

    let def = static_defs[key]

    let type = vimside#options#option#GetTypeName(def.type)
    let typelabel = forms#newLabel({'text': 'type: '})
    let typevalue = forms#newLabel({'text': type })
    call add(label_children, typelabel)
    call add(def_children, typevalue)

    if has_key(def, 'kind')
      let kind = vimside#options#option#GetKindName(def.kind)
      let kindlabel = forms#newLabel({'text': 'kind: '})
      let kindvalue = forms#newLabel({'text': kind})
      call add(label_children, kindlabel)
      call add(def_children, kindvalue)
    endif

    if has_key(def, 'enum')
      let enum = def.enum 
      let enumlabel = forms#newLabel({'text': 'enum: '})
      let enumvalue = forms#newLabel({'text': string(enum)})
      call add(label_children, enumlabel)
      call add(def_children, enumvalue)
    endif

    if has_key(def, 'parent')
      let parent = def.parent
      let parentlabel = forms#newLabel({'text': 'parent: '})
      let parentvalue = forms#newLabel({'text': parent})
      call add(label_children, parentlabel)
      call add(def_children, parentvalue)
    endif

    let description = copy(def.description)
    call map(description, '" " . v:val')
    let descriptiontext = forms#newText({'textlines': description})

    let [found, val_default] = g:vimside.options.default.Get(key)
    if found
      let value_default = string(val_default)
    else
      let value_default = 'not set'
    endif
    unlet val_default
    " let val_default_glyph = forms#newLabel({'text': 'default: ' . value_default})
" call s:LOG("value_default=". value_default)
    let val_default_glyph = s:makeValueGlyph('default: ', value_default, max_value_width)

    let [found, val_user] = g:vimside.options.user.Get(key)
    if found
      let value_user = string(val_user)
    else
      let value_user = 'not set'
    endif
    unlet val_user
" call s:LOG("value_user=". value_user)
    let val_user_glyph = s:makeValueGlyph('user: ', value_user, max_value_width)

    let namelabel = forms#newLabel({'text': key})


    let labelvpoly = forms#newVPoly({ 
                        \ 'children': label_children,
                        \ 'alignment': 'L' 
                        \ })


    let valuevpoly = forms#newVPoly({ 
                        \ 'children': def_children,
                        \ 'alignment': 'L' 
                        \ })

    let hpoly = forms#newHPoly({ 
                        \ 'children': [
                          \ labelvpoly, 
                          \ valuevpoly
                        \ ],
                        \ 'alignment': 'C' 
                        \ })

    let vpoly = forms#newVPoly({ 
                        \ 'children': [
                          \ namelabel, 
                          \ val_default_glyph,
                          \ val_user_glyph,
                          \ hpoly,
                          \ descriptiontext
                        \ ],
                        \ 'alignment': 'L' 
                        \ })

    call add(cardList, vpoly)
    call add(choices, [key, cnt])

    let cnt += 1
  endfor

  function! DoStaticDeckSelectAction(...) dict
  let pos = a:1
call forms#log("DoStaticDeckSelectAction.execute: " . pos)
    call self.deck.setCard(pos)
  endfunction
  let saction = forms#newAction({ 'execute': function("DoStaticDeckSelectAction")})

  let attrs = { 'mode': 'mandatory_on_move_single',
              \ 'pos': 0,
              \ 'size': 4,
              \ 'choices': choices,
              \ 'on_selection_action': saction
              \ }
  let sselectlist = forms#newSelectList(attrs)
  let sselectlistb = forms#newBox({ 'body': sselectlist })

  let sdeck = forms#newDeck({ 'children': cardList })
  let sbd = forms#newBorder({ 'body': sdeck })
  let sdeckbox = forms#newBox({ 'body': sbd} )
  let saction['deck'] = sdeck
" XXXXXXXXXXXX



  let vpoly = forms#newVPoly({ 
                        \ 'children': [sselectlistb, sdeckbox],
                        \ 'alignment': 'C' 
                        \ })

  let staticcard = forms#newVPoly({ 
                        \ 'children': [staticlabel, statictext, vspace, vpoly],
                        \ 'alignment': 'C' 
                        \ })
  call add(scopedeck, staticcard)

  "......
  " dynamic
  let dynamiclabel = forms#newLabel({'text': "Dynamic Options"})
  let dynamictext = forms#newText({'textlines': [
                     \ 'Options whose values can be changed and',
                     \ 'have effect at runtime.'
                     \ ]})


  let cardList = []
  let choices = []
  let cnt = 0
  for key in sort(keys(dynamic_defs))
    let label_children = []
    let def_children = []

    let def = dynamic_defs[key]

    let type = vimside#options#option#GetTypeName(def.type)
    let typelabel = forms#newLabel({'text': 'type: '})
    let typevalue = forms#newLabel({'text': type })
    call add(label_children, typelabel)
    call add(def_children, typevalue)

    if has_key(def, 'kind')
      let kind = vimside#options#option#GetKindName(def.kind)
      let kindlabel = forms#newLabel({'text': 'kind: '})
      let kindvalue = forms#newLabel({'text': kind})
      call add(label_children, kindlabel)
      call add(def_children, kindvalue)
    endif

    if has_key(def, 'enum')
      let enum = def.enum 
      let enumlabel = forms#newLabel({'text': 'enum: '})
      let enumvalue = forms#newLabel({'text': string(enum)})
      call add(label_children, enumlabel)
      call add(def_children, enumvalue)
    endif

    if has_key(def, 'parent')
      let parent = def.parent
      let parentlabel = forms#newLabel({'text': 'parent: '})
      let parentvalue = forms#newLabel({'text': parent})
      call add(label_children, parentlabel)
      call add(def_children, parentvalue)
    endif

    let description = copy(def.description)
    call map(description, '" " . v:val')
    let descriptiontext = forms#newText({'textlines': description})

    let [found, val_default] = g:vimside.options.default.Get(key)
    if found
      let value_default = string(val_default)
    else
      let value_default = 'not set'
    endif
    unlet val_default
" call s:LOG("value_default=". value_default)
    let val_default_glyph = s:makeValueGlyph('default: ', value_default, max_value_width)

    let [found, val_user] = g:vimside.options.user.Get(key)
    if found
      let value_user = string(val_user)
    else
      let value_user = 'not set'
    endif
    unlet val_user
" call s:LOG("value_user=". value_user)
    
    let val_user_glyph = s:makeValueGlyph('user: ', value_user, max_value_width)

    let namelabel = forms#newLabel({'text': key})


    let labelvpoly = forms#newVPoly({ 
                        \ 'children': label_children,
                        \ 'alignment': 'L' 
                        \ })


    let valuevpoly = forms#newVPoly({ 
                        \ 'children': def_children,
                        \ 'alignment': 'L' 
                        \ })

    let hpoly = forms#newHPoly({ 
                        \ 'children': [
                          \ labelvpoly, 
                          \ valuevpoly
                        \ ],
                        \ 'alignment': 'C' 
                        \ })

    let vpoly = forms#newVPoly({ 
                        \ 'children': [
                          \ namelabel, 
                          \ val_default_glyph,
                          \ val_user_glyph,
                          \ hpoly,
                          \ descriptiontext
                        \ ],
                        \ 'alignment': 'L' 
                        \ })

    call add(cardList, vpoly)
    call add(choices, [key, cnt])

    let cnt += 1
  endfor

  function! DoDynamicDeckSelectAction(...) dict
  let pos = a:1
call forms#log("DoDynamicDeckSelectAction.execute: " . pos)
    call self.deck.setCard(pos)
  endfunction
  let daction = forms#newAction({ 'execute': function("DoDynamicDeckSelectAction")})

  let attrs = { 'mode': 'mandatory_on_move_single',
              \ 'pos': 0,
              \ 'size': 4,
              \ 'choices': choices,
              \ 'on_selection_action': daction
              \ }
  let dselectlist = forms#newSelectList(attrs)
  let dselectlistb = forms#newBox({ 'body': dselectlist })

  let ddeck = forms#newDeck({ 'children': cardList })
  let dbd = forms#newBorder({ 'body': ddeck })
  let ddeckbox = forms#newBox({ 'body': dbd} )
  let daction['deck'] = ddeck
" XXXXXXXXXXXX

  let vpoly = forms#newVPoly({ 
                        \ 'children': [dselectlistb, ddeckbox],
                        \ 'alignment': 'C' 
                        \ })

  let dynamiccard = forms#newVPoly({ 
                        \ 'children': [dynamiclabel, dynamictext, vspace, vpoly],
                        \ 'alignment': 'C' 
                        \ })
  call add(scopedeck, dynamiccard)




if 0

  let dselectlist = forms#newLabel({'text': "SelectList"})
  let ddeck = forms#newLabel({'text': "Deck"})
  let ddeckbox = forms#newBox({ 'body': ddeck} )
  let hpoly = forms#newHPoly({ 
                        \ 'children': [dselectlist, ddeckbox],
                        \ 'alignment': 'T' 
                        \ })

  let dynamiccard = forms#newVPoly({ 
                        \ 'children': [dynamiclabel, dynamictext, vspace, hpoly],
                        \ 'alignment': 'C' 
                        \ })
  call add(scopedeck, dynamiccard)
endif

  "......
  let deck = forms#newDeck({ 'children': scopedeck })
  let deckbox = forms#newBox({ 'body': deck} )

  let staticaction.deck = deck
  let dynamicaction.deck = deck
  
  "..........................
  let cancellabel = forms#newLabel({'text': "Close"})
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel',
                              \ 'body': cancellabel,
                              \ 'action': g:forms#cancelAction})

  "...........................
  
  let vpoly = forms#newVPoly({ 
                        \ 'children': [title, buttonhpoly, deckbox, cancelbutton],
                        \ 'alignments': [[3,'R']],
                        \  'alignment': 'C' 
                        \ })

  let box = forms#newBox({ 'body': vpoly} )
  let bg = forms#newBackground({ 'body': box} )

  let [found, in_tab] = g:vimside.GetOption('tailor-forms-sourcebrowser-open-in-tab')
  let attrs = { 'open_in_tab': (found && in_tab),
              \ 'body': bg
              \ }
  let form = forms#newForm(attrs)

  call vimside#scheduler#HaltFeedKeys()
  try
    call form.run()
  finally
    call vimside#scheduler#ResumeFeedKeys()
  endtry
endfunction

