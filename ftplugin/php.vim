" .vim/ftplugin/php.vim by Tobias Schlitt <toby@php.net>.
" No copyright, feel free to use this, as you like.

" My modifications
set dictionary+=~/.vim/bundle/vim-php/ftplugin/funclist.txt
" END My modifications

" Including PDV
source ~/.vim/bundle/vim-php/ftplugin/php-doc.vim

" {{{ Settings

" Correct indentation after opening a phpdocblock and automatic * on every
" line
set formatoptions=qroct

" Use php syntax check when doing :make
set makeprg=php5\ -l\ %

" Use errorformat for parsing PHP error output
set errorformat=%m\ in\ %f\ on\ line\ %l

" Switch syntax highlighting on, if it was not
syntax on

" Map ; to "add ; to the end of the line, when missing"
noremap ; :s/\([^;]\)$/\1;/<cr>

" Map <ctrl>+p to single line mode documentation (in insert and command mode)
inoremap <C-P> :call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
" Map <ctrl>+p to multi line mode documentation (in visual mode)
vnoremap <C-P> :call PhpDocRange()<CR>

" Map <CTRL>-H to search phpm for the function name currently under the cursor (insert mode only)
inoremap <C-H> <ESC>:!phpm <C-R>=expand("<cword>")<CR><CR>

" Map <CTRL>-0 to alignment function
vnoremap <C-0> :call PhpAlign()<CR>

" Map <CTRL>-u to (un-)comment function
vnoremap <C-u> :call PhpUnComment()<CR>

" }}}

" {{{ Automatic close char mapping

" More common in PEAR coding standard
" CHANGED; commented version inserted with carriage return; new version does not
" inoremap  { {<CR>}<C-O>O
inoremap  { {}<LEFT>

" Maybe this way in other coding standards
" inoremap  { <CR>{<CR>}<C-O>O

inoremap [ []<LEFT>

" Standard mapping after PEAR coding standard
inoremap ( ()<LEFT>

" Maybe this way in other coding standards
" inoremap ( ( )<LEFT><LEFT> 

inoremap " ""<LEFT>
inoremap ' ''<LEFT>

" }}} Automatic close char mapping

" {{{ Wrap visual selections with chars

:vnoremap ( "zdi(<C-R>z)<ESC>
:vnoremap { "zdi{<C-R>z}<ESC>
:vnoremap [ "zdi[<C-R>z]<ESC>
:vnoremap ' "zdi'<C-R>z'<ESC>
" Removed in favor of register addressing
" :vnoremap " "zdi"<C-R>z"<ESC>

" }}} Wrap visual selections with chars

" {{{ Dictionary completion

" The completion dictionary is provided by Rasmus:
" http://lerdorf.com/funclist.txt
set dictionary-=/home/dotxp/funclist.txt dictionary+=/home/dotxp/funclist.txt
" Use the dictionary completion
set complete-=k complete+=k

" }}} Dictionary completion

" {{{ Autocompletion using the TAB key

" {{{ Alignment

func! PhpAlign() range
    let l:paste = &g:paste
    let &g:paste = 0

    let l:line        = a:firstline
    let l:endline     = a:lastline
    let l:maxlength = 0
    while l:line <= l:endline
		if getline (l:line) =~ '^\s*\/\/.*$'
			let l:line = l:line + 1
			continue
		endif
        let l:index = substitute (getline (l:line), '^\s*\(.\{-\}\)\s*=>\{0,1\}.*$', '\1', "") 
        let l:indexlength = strlen (l:index)
        let l:maxlength = l:indexlength > l:maxlength ? l:indexlength : l:maxlength
        let l:line = l:line + 1
    endwhile
    
	let l:line = a:firstline
	let l:format = "%s%-" . l:maxlength . "s %s %s"
    
	while l:line <= l:endline
		if getline (l:line) =~ '^\s*\/\/.*$'
			let l:line = l:line + 1
			continue
		endif
        let l:linestart = substitute (getline (l:line), '^\(\s*\).*', '\1', "")
        let l:linekey   = substitute (getline (l:line), '^\s*\(.\{-\}\) *=>\{0,1\}.*$', '\1', "")
        let l:linesep   = substitute (getline (l:line), '^\s*.* *\(=>\{0,1\}\).*$', '\1', "")
        let l:linevalue = substitute (getline (l:line), '^\s*.* *=>\{0,1\}\s*\(.*\)$', '\1', "")

        let l:newline = printf (l:format, l:linestart, l:linekey, l:linesep, l:linevalue)
        call setline (l:line, l:newline)
        let l:line = l:line + 1
    endwhile
    let &g:paste = l:paste
endfunc

" }}}   

" {{{ (Un-)comment

func! PhpUnComment() range
    let l:paste = &g:paste
    let &g:paste = 0

    let l:line        = a:firstline
    let l:endline     = a:lastline

	while l:line <= l:endline
		if getline (l:line) =~ '^\s*\/\/.*$'
			let l:newline = substitute (getline (l:line), '^\(\s*\)\/\/ \(.*\).*$', '\1\2', '')
		else
			let l:newline = substitute (getline (l:line), '^\(\s*\)\(.*\)$', '\1// \2', '')
		endif
		call setline (l:line, l:newline)
		let l:line = l:line + 1
	endwhile

    let &g:paste = l:paste
endfunc

" }}}
