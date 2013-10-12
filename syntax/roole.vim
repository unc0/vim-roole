" Language:    Roole
" Maintainer:  "UnCO" Lin
" URL:         http://github.com/unc0/vim-roole
" License:     WTFPL

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
elseif exists("b:current_syntax") && b:current_syntax == "roole"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax include @cssGroup syntax/css.vim
syntax include @cssAfter after/syntax/css.vim
" load files from vim-css3-syntax plugin (https://github.com/hail2u/vim-css3-syntax)
" runtime! after/syntax/css/*.vim
unlet b:current_syntax

syn case match
syn region  rooleVariable           start=/{\$/ end=/}/ keepend contained
syn match   rooleVariable           /\%(\\{\?\)\@<!\$\I\%(\i\|-\)*/ display
syn match   rooleVariableAssignment /[?*/+-]\?=/ nextgroup=rooleVariableValue skipwhite
syn match   rooleVariableValue      /.*;/me=e-1 contained contains=rooleString,rooleVariable,rooleParens,cssValue.*,@cssColors display
syn cluster rooleAssign             contains=rooleVariable,rooleVariableAssignment

syn match   rooleSelector           /[^"'@]\+\ze\%({\%(.*[^;]\)\?\|,\)$/ contains=cssTagName,cssClassName,cssIdentifier,rooleAmpersandChar,rooleVariable nextgroup=rooleDefinition skipwhite
syn match   rooleAmpersandChar      "&" contained
syn region  rooleAttribute          matchgroup=rooleBracket start='\[' end='\]' contains=css.*Attr,cssValue.*,cssColor,@cssColors,rooleVariable,rooleString

syn region  rooleDefinition         fold matchgroup=rooleBraces start=/{/ end=/}/ skip=/{\\/ contains=@rooleAll

syn match   rooleProp               /[[:alnum:]_${}-]\+:/me=e-1 transparent contained contains=css.*Attr,css.*Prop,rooleVariable nextgroup=rooleValue skipwhite
syn match   rooleValue              /.*;/me=e-1 contained contains=rooleCssFunctionName,css.*Attr,cssValue.*,cssColor,@cssColors,rooleString,rooleVariable,rooleOperator,rooleParens,rooleCssURL display

syn match   rooleOperator           /\s\+\zs[*/+-]\ze\s\+/ contained
syn region  rooleParens             matchgroup=rooleParen start='(' end=')' contained contains=cssValue.*,cssColor,@cssColors,rooleVariable,rooleOperator,rooleString,rooleComma

syn match   rooleEscape             /\\[${'"]/ contained
syn match   rooleStringURL          /https\?:\/\/.*["']/me=e-1 contained
" A non-interpolated string
syn cluster rooleBasicString        contains=@Spell,rooleEscape,rooleStringURL
" An interpolated string
syn cluster rooleInterpString       contains=@rooleBasicString,rooleVariable
" Regular strings
syn region  rooleString             start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@rooleInterpString keepend
syn region  rooleString             start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@rooleBasicString keepend


syn match   rooleMacro              /@.\+{/me=e-1 contains=rooleMacroKeyword,@rooleMacroOp,rooleVariable,rooleParens,rooleMacroSpecial,rooleString
syn region  rooleVoid               matchgroup=rooleMacroVoid start=/@void\s\+{/ end=/}/ contains=rooleVoidContent
syn match   rooleVoidContent        /.*/ contained display contains=rooleVoidedSelector,rooleMacroImport
syn match   rooleVoidedSelector     /[^"'@]\+\ze\%({\%(.*[^;]\)\?\|,\)$/ contains=cssTagName,cssClassName,cssIdentifier,rooleAmpersandChar,rooleVariable contained

syn match   rooleMacroExtend        /@extend\s\+[^"'@]\+;/me=e-1 contained contains=rooleVariable,rooleAmpersandChar,cssTagName,cssClassName,cssIdentifier
syn match   rooleMacroImport        /@import.\+;/me=e-1 contains=rooleVariable,rooleCssURL,rooleString,rooleParens
syn match   rooleMacroStatement     /@\%(mixin\|return\)/ display
syn match   rooleMacroCall          /\$\S\+(.*)/ contains=rooleVariable,rooleParens,rooleOperator
syn cluster rooleMacroOp            contains=rooleBoolOp,rooleCmpOp,rooleRangeOp
syn match   rooleMacroKeyword       /@\%(block\|keyframes\|module\|media\|if\|else\s\+if\|else\|for\|function\)/ contained display
syn keyword rooleMacroSpecial       null contained
syn keyword rooleBoolOp             is isnt and or in by with contained
syn match   rooleCmpOp              /[<>]=\?/ contained
syn match   rooleRangeOp            /\.\{2,3}/ contained

syn region  rooleCssURL             matchgroup=rooleCssFunctionName contained start="\<url\s*(" end=")" oneline keepend contains=rooleString
syn match   rooleCssFunctionName    /\<\%(url\|clip\|attr\|counter\|rect\|cubic-bezier\|rgb\|rgba\|hsl\|hsla\)\s*(/me=e-1 contained
syn match   rooleCssFunctionName    /\<\%(linear\|radial\)-gradient\s*(/me=e-1 contained
syn match   rooleCssFunctionName    /\<\%(matrix\%(3d\)\=\|scale\%(3d\|X\|Y\|Z\)\=\|translate\%(3d\|X\|Y\|Z\)\=\|skew\%(X\|Y\)\=\|rotate\%(3d\|X\|Y\|Z\)\=\|perspective\)\s*(/me=e-1 contained

syn match   rooleComment            "//.*$" contains=@Spell
syn keyword rooleCommentTodo        TODO FIXME XXX TBD WTF NOTE IMPORTANT DEBUG WARN contained
syn region  rooleComment            start="/\*" end="\*/" contains=@Spell,rooleCommentTodo
syn match   rooleSemicolon          ";"
syn match   rooleComma              ","
syn cluster rooleDelimiters         contains=rooleSemicolon,rooleComma

syn cluster rooleAll                contains=
      \ @rooleAssign,rooleComment,rooleString,
      \ rooleFunction,rooleSelector,rooleMacro,
      \ rooleMacroExtend,rooleMacroImport,rooleMacroStatement,
      \ rooleMacroCall,rooleOperator,@rooleDelimiters,
      \ rooleProp,rooleVoid,rooleDefinition,rooleAttribute

if version >= 508 || !exists("did_css_syn_inits")
  if version < 508
    let did_css_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink  rooleCssFunctionName     Function
  HiLink  rooleCssURL              String
  HiLink  rooleParen               SpecialChar
  HiLink  rooleBracket             SpecialChar
  HiLink  rooleVariable            Identifier
  HiLink  rooleVariableAssignment  Operator
  HiLink  rooleVariableValue       Constant
  HiLink  rooleComment             Comment
  HiLink  rooleVoidContent         Comment
  HiLink  rooleFunction            Function
  HiLink  rooleAmpersandChar       SpecialChar
  HiLink  rooleNestedProperty      Type
  HiLink  rooleSelector            Special
  HiLink  rooleBoolOp              rooleOperator
  HiLink  rooleCmpOp               rooleOperator
  HiLink  rooleOperator            Operator
  HiLink  rooleRangeOp             SpecialChar
  HiLink  rooleMacroStatement      Macro
  HiLink  rooleMacroVoid           Statement
  HiLink  rooleMacroExtend         Statement
  HiLink  rooleMacroImport         Statement
  HiLink  rooleMacroKeyword        Statement
  HiLink  rooleMacroSpecial        Special
  HiLink  rooleSemicolon           Delimiter
  HiLink  rooleComma               Delimiter
  HiLink  rooleEscape              SpecialChar
  HiLink  rooleString              String

  delcommand HiLink
endif

let b:current_syntax = "roole"

let &cpo = s:cpo_save
unlet s:cpo_save
