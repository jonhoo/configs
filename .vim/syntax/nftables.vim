" Vim syntax file
" Language:     nftables rules
" Maintainer:   Greg Look
" Filenames:    *.nft
" Version:      1.0

" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
    finish
endif

syntax region NFTSet start=/{/ end=/}/ contains=NFTSetEntry
syntax match NFTSetEntry contained /[a-zA-Z0-9-]\+/
highlight NFTSet ctermfg=Blue
highlight NFTSetEntry ctermfg=White

"syntax region NFTTableDef start=/table \S\+ \S\+/ end=// contains=NFTKeyword
"syntax region NFTChainDef start=/chain / end=/\S\+/ contains=NFTKeyword
"syntax match NFTKeyword contained /table\|chain/
"highlight NFTTableDef ctermfg=White
"highlight NFTChainDef ctermfg=White
"highlight link NFTKeyword Keyword

syntax region Comment start=/#/ end=/$/
syntax region String start=/"/ end=/"/
syntax region Identifier start=/@\|\$/ end=/ \|$/
syntax region Number start=/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\(\/[0-9]*\)*/ end=/ \|,\|$/
syntax region Number start=/[0-9]*\-[0-9]*/ end=/ \|,\|$/
syntax keyword Function saddr sport daddr dport
syntax keyword Keyword flush
syntax keyword Keyword table chain set
syntax keyword Keyword type hook priority
syntax keyword Type ip ip6 inet arp bridge
syntax keyword Type filter nat route
syntax keyword Constant input output forward prerouting postrouting

syntax keyword Special accept drop reject queue
syntax keyword Keyword continue return jump goto
syntax keyword Keyword counter log

syntax match Delimiter /{$\|^\s*}\|;/
syntax match Number / \d\+/
highlight Number ctermfg=DarkCyan

let b:current_syntax = "nftables"
