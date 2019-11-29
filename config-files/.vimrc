" vim: foldmethod=marker foldlevel=-1 nolist

set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
scriptencoding utf-8

" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'dense-analysis/ale'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --cs-completer --ts-completer --java-completer --clang-completer' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

Plug 'SirVer/ultisnips'
Plug 'chaoren/vim-wordmotion'

" Style
Plug 'joshdick/onedark.vim'
Plug 'ap/vim-css-color'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" javascript
Plug 'pangloss/vim-javascript'

" csharp
Plug 'OmniSharp/omnisharp-vim'

" typescript
Plug 'leafgarland/typescript-vim'

" markdown
Plug 'shime/vim-livedown'

" latex
Plug 'lervag/vimtex'
Plug 'mads10m/vim-template'
call plug#end()
" }}}
" Basic settings {{{
set number						" Shows line numbers

set hlsearch					" Highlight all searches
set incsearch					" Enable incremental searching

set splitbelow splitright		" New splits are below or to the right
autocmd VimResized * wincmd =	" Auto resize windows

set autoindent					" Turns indent (tabs) on
set noexpandtab					" Don't turn spaces into an tab
set tabstop=4					" How many columns a tab is made out of
set shiftwidth=4				" How many columns text will be indented when
" using indent operations (such as < or >)

set list						" Shows special characters in file
set listchars=tab:\|\ ,trail:·	" Sets tab and trailing characters
"set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

set wildignore=.git/*
set wildignore+=*/node_modules/*

au BufWritePost *.c,*.cpp,*.h,*.py,*.cs,*.html,*.js,makefile,Makefile,*.tex silent! !ctags -R &
" Auto generate tags on save

"set wildmode=longest:list,full	" Enable autocomplete
set wildmode=longest:full,full	" Enable autocomplete

" Vim directory
silent execute '!mkdir -p ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo'
" Create dir for backup, swap and undo file
set backup
set backupdir=~/.vim/.backup//	" Backup directory

set swapfile
set directory=~/.vim/.swp//		" Swap directory

set undofile					" Save undo file after file closes
set undodir=~/.vim/.undo//		" Undo directory
set undolevels=1000				" How many undoes
set undoreload=10000			" Number of lines to save for undo
" }}}
" Shortcuts and mappings {{{
let mapleader=","				" Map leader
let maplocalleader="_"			" Map local leader

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Quick save
nnoremap <silent> <Leader>s :update<CR>
inoremap <silent> <Leader>s <Esc>:update<CR>i
vnoremap <silent> <Leader>s <Esc>:w<CR>

" Spell check
map <F6><F6> :setlocal spell!<CR>
map <F6>e :setlocal spell spelllang=en_us<CR>
map <F6>d :setlocal spell spelllang=da<CR>

" Copy and paste to clipboard
vnoremap <Leader>c "+y
map <Leader>v "+p
inoremap <Leader>v <C-r>+
vnoremap <Leader>x "+d

map <F7> mzgg=G`z:ALEFix<CR>	" Fix indentation, trailing lines and trim whitespace

cnoreabbrev qq quitall			" Adding quit all command

" For vimrc and vimscript
autocmd Filetype vim call MyVim()
function! MyVim()
	map <F5> :source ~/.vimrc<CR>
endfunction

" For latex files
autocmd Filetype tex call MyLatex()
function! MyLatex()
	map <C-m> :VimtexTocToggle<CR>
	map <F5> :VimtexCompile<CR>
	map <F3> :call ToggleFollowMode()<CR>
	map <C-m> <plug>(vimtex-toc-open)
	inoremap <expr> <cr> CheckIfList() ? '<cr>\item ' : '<cr>'
	inoremap <C-f> <C-o>:call NewInkscape(getline("."))<cr>
endfunction

function! CheckIfList()
	" This function test if curser is inside itemize or enumerate
	" https://vi.stackexchange.com/questions/15333/inserting-text-within-a-block-automaticaly-for-each-enter-button-pressing/15334

	" Test in itemize
	let [l:lnum, l:cnum] = searchpairpos('\\begin{itemize}', '',
				\  '\\end{itemize}', 'nbW')

	" Test in enumerate
	let [l:lnum, l:cnum] += searchpairpos('\\begin{enumerate}', '',
				\  '\\end{enumerate}', 'nbW')

	" Test in description
	let [l:lnum, l:cnum] += searchpairpos('\\begin{description}', '',
				\  '\\end{description}', 'nbW')

	"echom "NEWLINE"
	"echom l:lnum
	"echom l:cnum

	"if l:lnum > 0
	"	return "\n\\item "
	"endif
	"
	"return "\n"

	return l:lnum > 0
endfunction

" Toggle folow mode
let s:enabled = 1
function! ToggleFollowMode()
	if s:enabled
		autocmd CursorMoved *.tex :VimtexView
		autocmd CursorMovedI *.tex :VimtexView
		let s:enabled = 0
	else
		autocmd! CursorMoved *.tex
		autocmd! CursorMovedI *.tex
		let s:enabled = 1
	endif
endfunction

function! NewInkscape(line)
	if strlen(a:line) < 25
		let l:tmpPath = "~/Templates/inkscape/template.svg"
		let l:svgFile = substitute(a:line, '[ \t]', '-', "g") . ".svg"
		let l:copyPath = getcwd() . "/figures/" . l:svgFile

		echom l:tmpPath
		echom l:copyPath
		silent! execute "!cp" l:tmpPath l:copyPath
		redraw!

		silent! execute "!inkscape" l:copyPath . " &> /dev/null"
		redraw!

	else
		echom "test"
	endif
	"echom substitute(a:line, " ", "-", "")
endfunction

" Toggle follow mode
let s:enabled = 0
function! ToggleFollowMode()
	if s:enabled
		autocmd CursorMoved *.tex :VimtexView
		autocmd CursorMovedI *.tex :VimtexView
		let s:enabled = 0
	else
		autocmd CursorMoved *.tex
		autocmd CursorMovedI *.tex
		let s:enabled = 1
	endif
endfunction
"endfunction

"let w:window = system("tmux display-message -p '#S:#I'")
"let w:index = system("tmux display-message -p '#{pane_index}'")
"let w:te = substitute(w:window.".".w:index, '\n\+$', '', '')
"echo w:te
" }}}
" Plugin settings {{{
" Onedark {{{
colorscheme onedark
"highlight Folded ctermbg=242 ctermfg=White
" }}}
" NERDtree {{{
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
" }}}
" NERDtree git {{{
let g:NERDTreeIndicatorMapCustom = {
			\ "Modified"  : "✹",
			\ "Staged"    : "✚",
			\ "Untracked" : "✭",
			\ "Renamed"   : "➜",
			\ "Unmerged"  : "═",
			\ "Deleted"   : "✖",
			\ "Dirty"     : "✗",
			\ "Clean"     : "✔︎",
			\ 'Ignored'   : '☒',
			\ "Unknown"   : "?"
			\ }
let g:NERDTreeUpdateOnCursorHold = 0
let g:NERDTreeUpdateOnWrite      = 0
" }}}
" Ale {{{
"let g:ale_fixers = {
"			\	'*': ['remove_trailing_lines', 'trim_whitespace'],
"			\	'javascript': ['prettier'],
"			\	'cs': ['OmniSharp'],
"			\	'python': ['pylint', 'flake8'],
"			\	'latex': ['ChkTeX -n'],
"			\}
"let g:ale_linters = {
"			\	'javascript': ['eslint'],
"			\	'cs': ['OmniSharp'],
"			\	'python': ['pylint', 'flake8'],
"			\	'latex': ['ChkTeX -n'],
"			\}
let g:ale_linters = {
			\	'javascript': ['eslint'],
			\	'css': ['stylelint'],
			\	'scss': ['stylelint'],
			\	'python': ['flake8', 'pylint'],
			\	'cs': ['OmniSharp'],
			\	'c': ['clang'],
			\	'latex': ['chktex', 'lacheck'],
			\}
let g:ale_fixers = {
			\	'*': ['remove_trailing_lines', 'trim_whitespace'],
			\}
let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_close_preview_on_insert = 1
let g:ale_echo_cursor = 0					" Echos errors when cursor is near a warning/error
" Close error buffer when file is closed
autocmd QuitPre * if empty(&bt) | lclose | endif
" }}}
" Youcompleteme {{{
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:ycm_autoclose_preview_window_after_insertion = 1
" }}}
" Ultisnips {{{

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/my-snippets']
" }}}
" Airline {{{
let g:airline_theme = 'onedark'
let g:lightline = {
			\	 'colorscheme': 'onedark',
			\}
" }}}
" Fzf {{{
let g:fzf_action = {
			\	'ctrl-t': 'tab split',
			\	'ctrl-x': 'split',
			\	'ctrl-v': 'vsplit'
			\}

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" }}}
" Goyo and Limelight {{{
" Shortcuts
map <F4> :Goyo<CR>
inoremap <F4> <Esc>:Goyo<CR>a
" Settings
let g:goyo_width=80
let g:goyo_height='85%'
let g:goyo_linenr=1
" Goyo start
function! s:goyo_enter()
	if executable('tmux') && strlen($TMUX)
		silent !tmux set status off
		silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
	endif

	set noshowmode
	set noshowcmd
	set scrolloff=999
	" Remove comment for limelight
	"Limelight
endfunction
" Goyo leave
function! s:goyo_leave()
	if executable('tmux') && strlen($TMUX)
		silent !tmux set status on
		silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
	endif
	set showmode
	set showcmd
	set scrolloff=1
	" Remove comment for limelight
	"Limelight!
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
let g:limelight_priority = -1
" }}}
" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
" }}}
" vimtex {{{
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
" }}}
" vim-latex-live-preview {{{
"let g:livepreview_previewer = 'evince'
" set updatetime to a smaller value, which is the frequency that the
" output PDF is updated
"Setl updatetime=1
"let g:tex_flavor = "latex"
"let g:tex_flavor='latex'
"let g:livepreview_previewer = 'evince'
"let g:vimtex_quickfix_mode=0
"set conceallevel=3
"let g:tex_conceal='abdmg'
" }}}
" omnisharp-vim {{{
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_selector_ui = 'fzf'    " Use fzf.vim
" }}}
" }}}
