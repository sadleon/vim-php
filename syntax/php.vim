" Vim syntax file
" Language: PHP 5.3 & up
" Maintainer: Paul Garvin <paul@paulgarvin.net>
" Last Change:  April 2, 2010
" URL: 
"
" Former Maintainer:  Peter Hodge <toomuchphp-vim@yahoo.com>
" Former URL: http://www.vim.org/scripts/script.php?script_id=1571
"
" Note: All of the switches for VIM 5.X and 6.X compatability were removed.
"       DO NOT USE THIS FILE WITH A VERSION OF VIM < 7.0.
"
" Note: If you are using a colour terminal with dark background, you will probably find
"       the 'elflord' colorscheme is much better for PHP's syntax than the default
"       colourscheme, because elflord's colours will better highlight the break-points
"       (Statements) in your code.
"
" Options:  php_sql_query = 1  for SQL syntax highlighting inside strings
"           php_html_in_strings = 1  for HTML syntax highlighting inside strings
"           php_parent_error_close = 1  for highlighting parent error ] or )
"           php_parent_error_open = 1  for skipping an php end tag,
"                                      if there exists an open ( or [ without a closing one
"           php_no_shorttags = 1  don't sync <? ?> as php
"           php_folding = 1  for folding classes and functions
"           php_sync_method = x
"                             x=-1 to sync by search ( default )
"                             x>0 to sync at least x lines backwards
"                             x=0 to sync from start
"
" Note:
" Setting php_folding=1 will match a closing } by comparing the indent
" before the class or function keyword with the indent of a matching }.
" Setting php_folding=2 will match all of pairs of {,} ( see known
" bugs ii )
"
" Known Bugs:
"  - setting  php_parent_error_close  on  and  php_parent_error_open  off
"    has these two leaks:
"     i) A closing ) or ] inside a string match to the last open ( or [
"        before the string, when the the closing ) or ] is on the same line
"        where the string started. In this case a following ) or ] after
"        the string would be highlighted as an error, what is incorrect.
"    ii) Same problem if you are setting php_folding = 2 with a closing
"        } inside an string on the first line of this string.
"
"  - A double-quoted string like this:
"      "$foo->someVar->someOtherVar->bar"
"    will highight '->someOtherVar->bar' as though they will be parsed
"    as object member variables, but PHP only recognizes the first
"    object member variable ($foo->someVar).
"
"
"
if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'php'
endif

runtime syntax/html.vim
unlet b:current_syntax

" Set sync method if none declared
if !exists("php_sync_method")
  if exists("php_minlines")
    let php_sync_method=php_minlines
  else
    let php_sync_method=-1
  endif
endif

syn cluster htmlPreproc add=phpRegion

syn include @sqlTop syntax/sql.vim

syn sync clear
unlet b:current_syntax
syn cluster sqlTop remove=sqlString,sqlComment
if exists("php_sql_query")
  syn cluster phpAddStrings contains=@sqlTop
endif

if exists("php_html_in_strings")
  syn cluster phpAddStrings add=@htmlTop
endif

syn case match
 
" Superblobals
syn keyword phpSuperglobals GLOBALS _GET _POST _REQUEST _FILES _COOKIE _SERVER _SESSION _ENV HTTP_RAW_POST_DATA php_errormsg http_response_header argc argv contained

" Magic Constants
syn keyword phpMagicConstants __LINE__ __FILE__ __DIR__ __FUNCTION__ __CLASS__ __METHOD__ __NAMESPACE__ contained

" $_SERVER Variables
syn keyword phpServerVars GATEWAY_INTERFACE SERVER_NAME SERVER_SOFTWARE SERVER_PROTOCOL REQUEST_METHOD QUERY_STRING DOCUMENT_ROOT HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_CONNECTION HTTP_HOST HTTP_REFERER HTTP_USER_AGENT REMOTE_ADDR REMOTE_PORT SCRIPT_FILENAME SERVER_ADMIN SERVER_PORT SERVER_SIGNATURE PATH_TRANSLATED SCRIPT_NAME REQUEST_URI PHP_SELF contained

" Source auto-generated syntax from PHP reflection
source ~/.vim/bundle/vim-php/syntax/php_syntax_vimgen.vim

" The following is needed afterall it seems.
syntax keyword phpClasses containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar

" Control Structures
syn keyword phpStatement if else elseif while do for foreach break switch case default continue return goto as endif endwhile endfor endforeach endswitch declare endeclare contained

" Class Keywords
syn keyword phpType class abstract extends interface implements static final var public private protected const contained

" Magic Methods
syn keyword phpStatement __construct __destruct __call __callStatic __get __set __isset __unset __sleep __wakeup __toString __invoke __set_state __clone contained

" Exception Keywords
syn keyword phpStatement try catch throw contained

" Language Constructs
syn keyword phpStatement die exit eval empty isset unset list instanceof contained

" These special keywords have traditionally received special colors
syn keyword phpSpecial function echo print new clone contained

" Include & friends
syn keyword phpInclude include include_once require require_once namespace use contained

" Types
syn keyword phpType bool[ean] int[eger] real double float string array object null self parent global this stdClass contained

" Operator
syn match phpOperator       "[-=+%^&|*!.~?:]" contained display
syn match phpOperator       "[-+*/%^&|.]="  contained display
syn match phpOperator       "/[^*/]"me=e-1  contained display
syn match phpOperator       "\$"  contained display
syn match phpOperator       "&&\|\<and\>" contained display
syn match phpOperator       "||\|\<x\=or\>" contained display
syn match phpOperator       "[!=<>]=" contained display
syn match phpOperator       "[<>]"  contained display
syn match phpMemberSelector "->"  contained display
syn match phpVarSelector    "\$"  contained display
" highlight object variables inside strings
syn match phpMethodsVar     "->\h\w*" contained contains=phpMethods,phpMemberSelector display containedin=phpStringDouble

" Identifier
syn match  phpIdentifier         "$\h\w*"  contained contains=phpEnvVar,phpIntVar,phpVarSelector display
syn match  phpIdentifierSimply   "${\h\w*}"  contains=phpOperator,phpParent  contained display
syn region phpIdentifierComplex  matchgroup=phpParent start="{\$"rs=e-1 end="}"  contains=phpIdentifier,phpMemberSelector,phpVarSelector,phpIdentifierArray contained extend
syn region phpIdentifierArray    matchgroup=phpParent start="\[" end="]" contains=@phpClInside contained

" Boolean
syn keyword phpBoolean true false  contained

" Number
syn match phpNumber "-\=\<\d\+\>" contained display
syn match phpNumber "\<0x\x\{1,8}\>"  contained display

" Float
syn match phpNumber "\(-\=\<\d+\|-\=\)\.\d\+\>" contained display

" SpecialChar
syn match phpSpecialChar "\\[fnrtv\\]" contained display
syn match phpSpecialChar "\\\d\{3}"  contained contains=phpOctalError display
syn match phpSpecialChar "\\x\x\{2}" contained display
" corrected highlighting for an escaped '\$' inside a double-quoted string
syn match phpSpecialChar "\\\$"  contained display
syn match phpSpecialChar +\\"+   contained display
syn match phpStrEsc      "\\\\"  contained display
syn match phpStrEsc      "\\'"   contained display

" Error
syn match phpOctalError "[89]"  contained display
if exists("php_parent_error_close")
  syn match phpParentError "[)\]}]"  contained display
endif

" Todo
syn keyword phpTodo todo fixme xxx note contained

" Comment
if exists("php_parent_error_open")
  syn region phpComment start="/\*" end="\*/" contained contains=phpTodo
else
  syn region phpComment start="/\*" end="\*/" contained contains=phpTodo extend
endif
if version >= 600
  syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained contains=phpTodo
  syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained contains=phpTodo
else
  syn match phpComment  "#.\{-}$" contained contains=phpTodo
  syn match phpComment  "#.\{-}?>"me=e-2  contained contains=phpTodo
  syn match phpComment  "//.\{-}$"  contained contains=phpTodo
  syn match phpComment  "//.\{-}?>"me=e-2 contained contains=phpTodo
endif

" String
if exists("php_parent_error_open")
  syn region phpStringDouble matchgroup=None start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained keepend
  syn region phpBacktick matchgroup=None start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained keepend
  syn region phpStringSingle matchgroup=None start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@phpAddStrings,phpStrEsc contained keepend
else
  syn region phpStringDouble matchgroup=None start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained extend keepend
  syn region phpBacktick matchgroup=None start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained extend keepend
  syn region phpStringSingle matchgroup=None start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@phpAddStrings,phpStrEsc contained keepend extend
endif

" HereDoc
  syn case match
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\I\i*\)$" end="^\z1\(;\=$\)\@=" contained contains=phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
  syn region phpHereDoc matchgroup=Delimiter start=+\(<<<\)\@<="\z(\I\i*\)"$+ end="^\z1\(;\=$\)\@=" contained contains=phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
" including HTML,JavaScript,SQL even if not enabled via options
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(sql\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@=" contained contains=@sqlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlJavascript,phpIdentifierSimply,phpIdentifier,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
  syn case ignore

" NowDoc
  syn region phpNowDoc matchgroup=Delimiter start=+\(<<<\)\@<='\z(\I\i*\)'$+ end="^\z1\(;\=$\)\@=" contained keepend extend

" Parent
if exists("php_parent_error_close") || exists("php_parent_error_open")
  syn match  phpParent "[{}]"  contained
  syn region phpParent matchgroup=Delimiter start="(" end=")"  contained contains=@phpClInside transparent
  syn region phpParent matchgroup=Delimiter start="\[" end="\]"  contained contains=@phpClInside transparent
  if !exists("php_parent_error_close")
    syn match phpParent "[\])]" contained
  endif
else
  syn match phpParent "[({[\]})]" contained
endif

" Clusters
syn cluster phpClConst contains=phpFunctions,phpClasses,phpIdentifier,phpStatement,phpOperator,phpStringSingle,phpStringDouble,phpBacktick,phpNumber,phpType,phpBoolean,phpStructure,phpMethodsVar,phpConstants,phpException,phpSuperglobals,phpMagicConstants,phpServerVars
syn cluster phpClInside contains=@phpClConst,phpComment,phpParent,phpParentError,phpInclude,phpHereDoc,phpNowDoc
syn cluster phpClFunction contains=@phpClInside,phpDefine,phpParentError,phpStorageClass,phpSpecial
syn cluster phpClTop contains=@phpClFunction,phpFoldFunction,phpFoldClass,phpFoldInterface,phpFoldTry,phpFoldCatch

" Php Region
if exists("php_parent_error_open")
  syn region phpRegion matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop
else
  syn region phpRegion matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop keepend
endif

" Fold
if exists("php_folding") && php_folding==1
" match one line constructs here and skip them at folding
  syn keyword phpSCKeyword  abstract final private protected public static  contained
  syn keyword phpFCKeyword  function  contained
  syn match phpDefine "\(\s\|^\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\(\s\+.*[;}]\)\@="  contained contains=phpSCKeyword
  syn match phpStructure "\(\s\|^\)\(abstract\s\+\|final\s\+\)*class\(\s\+.*}\)\@="  contained
  syn match phpStructure "\(\s\|^\)interface\(\s\+.*}\)\@="  contained
  syn match phpException "\(\s\|^\)try\(\s\+.*}\)\@="  contained
  syn match phpException "\(\s\|^\)catch\(\s\+.*}\)\@="  contained

  set foldmethod=syntax
  syn region phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region phpFoldFunction matchgroup=Storageclass start="^\z(\s*\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\s\([^};]*$\)\@="rs=e-9 matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldHtmlInside,phpFCKeyword contained transparent fold extend
  syn region phpFoldFunction matchgroup=Define start="^function\s\([^};]*$\)\@=" matchgroup=Delimiter end="^}" contains=@phpClFunction,phpFoldHtmlInside contained transparent fold extend
  syn region phpFoldClass matchgroup=Structure start="^\z(\s*\)\(abstract\s\+\|final\s\+\)*class\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction,phpSCKeyword contained transparent fold extend
  syn region phpFoldInterface matchgroup=Structure start="^\z(\s*\)interface\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region phpFoldCatch matchgroup=Exception start="^\z(\s*\)catch\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region phpFoldTry matchgroup=Exception start="^\z(\s*\)try\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
elseif exists("php_folding") && php_folding==2
"  syn keyword phpDefine function  contained
"  syn keyword phpStructure  abstract class interface  contained
"  syn keyword phpException  catch throw try contained
"  syn keyword phpStorageClass final global private protected public static  contained

  set foldmethod=syntax
  syn region phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region phpParent matchgroup=Delimiter start="{" end="}"  contained contains=@phpClFunction,phpFoldHtmlInside transparent fold
else
"  syn keyword phpDefine function  contained
"  syn keyword phpStructure  abstract class interface  contained
"  syn keyword phpException  catch throw try contained
"  syn keyword phpStorageClass final global private protected public static  contained
endif

" Sync
if php_sync_method==-1
  syn sync match phpRegionSync grouphere phpRegion "^\s*<?\(php\)\=\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*?>\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match phpRegionSync grouphere phpRegion "function\s.*(.*\$"
  "syn sync match phpRegionSync grouphere NONE "/\i*>\s*$"
elseif php_sync_method>0
  exec "syn sync minlines=" . php_sync_method
else
  exec "syn sync fromstart"
endif

" Define the default highlighting.
" For version 5.8 and later: only when an item doesn't have highlighting yet
if !exists("did_php_syn_inits")

  hi def link phpComment          Comment
  hi def link phpSuperglobals     Constant
  hi def link phpMagicConstants   Constant
  hi def link phpServerVars       Constant
  hi def link phpConstants        Constant
  hi def link phpBoolean          Constant
  hi def link phpNumber           Constant
  hi def link phpStringSingle     String
  hi def link phpStringDouble     String
  hi def link phpBacktick         String
  hi def link phpHereDoc          String
  hi def link phpNowDoc           String
  hi def link phpFunctions        Identifier
  hi def link phpClasses          Identifier
  hi def link phpMethods          Identifier
  hi def link phpIdentifier       Identifier
  hi def link phpIdentifierSimply Identifier
  hi def link phpStatement        Statement
  hi def link phpStructure        Statement
  hi def link phpException        Statement
  hi def link phpOperator         Operator
  hi def link phpVarSelector      Operator
  hi def link phpInclude          PreProc
  hi def link phpDefine           PreProc
  hi def link phpSpecial          PreProc
  hi def link phpFCKeyword        PreProc
  hi def link phpType             Type
  hi def link phpSCKeyword        Type
  hi def link phpMemberSelector   Type
  hi def link phpSpecialChar      Special
  hi def link phpStrEsc           Special
  hi def link phpParent           Special
  hi def link phpParentError      Error
  hi def link phpOctalError       Error
  hi def link phpTodo             Todo

endif

let b:current_syntax = "php"

if main_syntax == 'php'
  unlet main_syntax
endif

" vim: ts=8 sts=2 sw=2 expandtab
