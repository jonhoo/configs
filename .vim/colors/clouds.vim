" Vim color file
" Converted from Textmate theme Clouds Midnight using Coloration v0.2.4 (http://github.com/sickill/coloration)

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Clouds Midnight"

hi Cursor           guifg=NONE    guibg=#7da5dc gui=NONE
hi Visual           guifg=NONE    guibg=#000000 gui=NONE
hi CursorLine       guifg=NONE    guibg=#1f1f1f gui=NONE
hi CursorColumn     guifg=NONE    guibg=#1f1f1f gui=NONE
hi ColorColumn      guifg=NONE    guibg=#1f1f1f gui=NONE
hi LineNr           guifg=#565656 guibg=#191919 gui=NONE
hi VertSplit        guifg=#303030 guibg=#303030 gui=NONE
hi MatchParen       guifg=#927c5d guibg=NONE    gui=NONE
hi StatusLine       guifg=#929292 guibg=#303030 gui=bold
hi StatusLineNC     guifg=#929292 guibg=#303030 gui=NONE
hi Pmenu            guifg=NONE    guibg=NONE    gui=NONE
hi PmenuSel         guifg=NONE    guibg=#000000 gui=NONE
hi IncSearch        guifg=NONE    guibg=#413a2f gui=NONE
hi Search           guifg=NONE    guibg=#413a2f gui=NONE
hi Directory        guifg=NONE    guibg=NONE    gui=NONE
hi Folded           guifg=#3c403b guibg=#191919 gui=NONE

hi Normal           guifg=#929292 guibg=#191919 gui=NONE
hi Boolean          guifg=#39946a guibg=NONE    gui=NONE
hi Character        guifg=NONE    guibg=NONE    gui=NONE
hi Comment          guifg=#3c403b guibg=NONE    gui=NONE
hi Conditional      guifg=#927c5d guibg=NONE    gui=NONE
hi Constant         guifg=NONE    guibg=NONE    gui=NONE
hi Define           guifg=#927c5d guibg=NONE    gui=NONE
hi ErrorMsg         guifg=#ffffff guibg=#e92e2e gui=NONE
hi WarningMsg       guifg=#ffffff guibg=#e92e2e gui=NONE
hi Float            guifg=#46a609 guibg=NONE    gui=NONE
hi Function         guifg=NONE    guibg=NONE    gui=NONE
hi Identifier       guifg=#e92e2e guibg=NONE    gui=NONE
hi Keyword          guifg=#927c5d guibg=NONE    gui=NONE
hi Label            guifg=#5d90cd guibg=NONE    gui=NONE
hi NonText          guifg=#333333 guibg=NONE    gui=NONE
hi Number           guifg=#46a609 guibg=NONE    gui=NONE
hi Operator         guifg=#4b4b4b guibg=NONE    gui=NONE
hi PreProc          guifg=#927c5d guibg=NONE    gui=NONE
hi Special          guifg=#929292 guibg=NONE    gui=NONE
hi SpecialKey       guifg=#bfbfbf guibg=#1f1f1f gui=NONE
hi Statement        guifg=#927c5d guibg=NONE    gui=NONE
hi StorageClass     guifg=#e92e2e guibg=NONE    gui=NONE
hi String           guifg=#5d90cd guibg=NONE    gui=NONE
hi Tag              guifg=#606060 guibg=NONE    gui=NONE
hi Title            guifg=#929292 guibg=NONE    gui=bold
hi Todo             guifg=#3c403b guibg=NONE    gui=inverse,bold
hi Type             guifg=NONE    guibg=NONE    gui=NONE
hi Underlined       guifg=NONE    guibg=NONE    gui=underline
hi rubyClass  guifg=#927c5d guibg=NONE gui=NONE
hi rubyFunction  guifg=NONE guibg=NONE gui=NONE
hi rubyInterpolationDelimiter  guifg=NONE guibg=NONE gui=NONE
hi rubySymbol  guifg=NONE guibg=NONE gui=NONE
hi rubyConstant  guifg=NONE guibg=NONE gui=NONE
hi rubyStringDelimiter  guifg=#5d90cd guibg=NONE gui=NONE
hi rubyBlockParameter  guifg=NONE guibg=NONE gui=NONE
hi rubyInstanceVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyInclude  guifg=#927c5d guibg=NONE gui=NONE
hi rubyGlobalVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyRegexp  guifg=#5d90cd guibg=NONE gui=NONE
hi rubyRegexpDelimiter  guifg=#5d90cd guibg=NONE gui=NONE
hi rubyEscape  guifg=NONE guibg=NONE gui=NONE
hi rubyControl  guifg=#927c5d guibg=NONE gui=NONE
hi rubyClassVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyOperator  guifg=#4b4b4b guibg=NONE gui=NONE
hi rubyException  guifg=#927c5d guibg=NONE gui=NONE
hi rubyPseudoVariable  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsUserClass  guifg=NONE guibg=NONE gui=NONE
hi rubyRailsARAssociationMethod  guifg=#e92e2e guibg=NONE gui=NONE
hi rubyRailsARMethod  guifg=#e92e2e guibg=NONE gui=NONE
hi rubyRailsRenderMethod  guifg=#e92e2e guibg=NONE gui=NONE
hi rubyRailsMethod  guifg=#e92e2e guibg=NONE gui=NONE
hi erubyDelimiter  guifg=#e92e2e guibg=NONE gui=NONE
hi erubyComment  guifg=#3c403b guibg=NONE gui=NONE
hi erubyRailsMethod  guifg=#e92e2e guibg=NONE gui=NONE
hi htmlTag  guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag  guifg=NONE guibg=NONE gui=NONE
hi htmlTagName  guifg=NONE guibg=NONE gui=NONE
hi htmlArg  guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar  guifg=#a165ac guibg=NONE gui=NONE
hi javaScriptFunction  guifg=#e92e2e guibg=NONE gui=NONE
hi javaScriptRailsFunction  guifg=#e92e2e guibg=NONE gui=NONE
hi javaScriptBraces  guifg=NONE guibg=NONE gui=NONE
hi yamlKey  guifg=#606060 guibg=NONE gui=NONE
hi yamlAnchor  guifg=NONE guibg=NONE gui=NONE
hi yamlAlias  guifg=NONE guibg=NONE gui=NONE
hi yamlDocumentHeader  guifg=#5d90cd guibg=NONE gui=NONE
hi cssURL  guifg=NONE guibg=NONE gui=NONE
hi cssFunctionName  guifg=#e92e2e guibg=NONE gui=NONE
hi cssColor  guifg=#a165ac guibg=NONE gui=NONE
hi cssPseudoClassId  guifg=#606060 guibg=NONE gui=NONE
hi cssClassName  guifg=#e92e2e guibg=NONE gui=NONE
hi cssValueLength  guifg=#46a609 guibg=NONE gui=NONE
hi cssCommonAttr  guifg=#a165ac guibg=NONE gui=NONE
hi cssBraces  guifg=NONE guibg=NONE gui=NONE