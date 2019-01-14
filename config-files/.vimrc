""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
	Plug 'scrooloose/nerdtree'
	Plug 'w0rp/ale'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'airblade/vim-gitgutter'
	Plug 'tpope/vim-surround'

	" Style
	Plug 'joshdick/onedark.vim'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'

	" javascript
	Plug 'pangloss/vim-javascript'

	" markdown
	Plug 'shime/vim-livedown'

	" latex
	Plug 'mads10m/vim-template'
	Plug 'xuhdev/vim-latex-live-preview'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""
" My settings
""""""""""""""""""""""""""""""""""""""""""""""""""

" Basic settings
	set nocompatible
	filetype plugin indent on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Tabs
	set autoindent
	set noexpandtab
	set tabstop=4
	set shiftwidth=4
" Enable autocompletion
	set wildmode=longest,list,full
" New splits are below or to the right
	set splitbelow splitright
" Auto resize windows
	autocmd VimResized * wincmd =
" Folding
	set foldmethod=indent
	set foldnestmax=10
	set nofoldenable
	set foldlevel=2


""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts and mappings
""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
" Quick save
	nnoremap <silent> <C-s> :update<CR>
	inoremap <silent> <C-s> <Esc>:update<CR>i
	vnoremap <silent> <c-s> <Esc>:w<CR>
" Copy and paste to clipboard
	vnoremap <C-c> "+y
	map <C-v> "+p
	inoremap <C-v> <C-r>+
	vnoremap <C-x> "+d
" Spell check
	map <F6><F6> :setlocal spell!<CR>
	map <F6>e :setlocal spell spelllang=en_us<CR>
	map <F6>d :setlocal spell spelllang=da<CR>
" For vim files
	autocmd Filetype vim call MyVim()
	function! MyVim()
		map <F5> :source ~/.vimrc<CR>
	endfunction
" For latex files
	autocmd Filetype tex call MyLatex()
	function! MyLatex()
		"map <F7> :w<CR>:silent !compile-latex %<CR>
		" compile latex
		" map <buffer> <F5> :! compile-latex expand('%:t')<CR>
		" Snippets
		" List
		"inoremap ,pl \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
		"inoremap ,nl \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
		map <C-j> /<++><CR>cf>
		inoremap <C-j> <Esc>/<++><CR>cf>
		" Documentclass
		inoremap ,dc \documentclass[]{<++>}<Enter><++><Esc>?[]<CR>a
		" Usepackage
		inoremap ,up \usepackage{}<Enter><++><Esc>?{}<CR>a
		" Begin document
		inoremap ,bd \begin{document}<Enter><Enter><Enter><Enter>\end{document}<Esc>2ki
		
		inoremap ,chap \chapter{}<Enter><++><Esc>?{}<CR>a
		inoremap ,sec \section{}<Enter><++><Esc>?{}<CR>a
		inoremap ,ssec \subsection{}<Enter><++><Esc>?{}<CR>a
		inoremap ,sssec \subsubsection{}<Enter><++><Esc>?{}<CR>a

		inoremap ,ic \includegraphics[width=\textwidth]{}<Enter><++><Esc>?{}<CR>a

		inoremap ,be \begin{equation}<Enter>\end{equation}<Esc>O


	endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""

" Nerdtree
	map <C-n> :NERDTreeToggle<CR>
	let NERDTreeShowHidden=1
" Ale
	let g:ale_fixers = {
	\	'*': ['remove_trailing_lines', 'trim_whitespace'],
	\	'javascript': ['prettier', 'eslint'],
	\}
	let g:ale_open_list = 1
	let g:ale_lint_on_save = 1
	let g:ale_echo_cursor = 0
" Onedark
	colorscheme onedark
	highlight Folded ctermbg=242 ctermfg=White
" Airline
	let g:lightline = {
	\ 'colorscheme': 'onedark',
	\ }
" Goyo and Limelight
	" Shortcuts
	map <F4> :Goyo<CR>
	inoremap <F4> <Esc>:Goyo<CR>a
	" Settings
	let g:goyo_width=80
	let g:goyo_height='85%'
	let g:goyo_linenr=0
	" Goyo start
	function! s:goyo_enter()
		silent !tmux set status off
		silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
		" Changes folding color
		highlight Folded ctermbg=242 ctermfg=White
		set noshowmode
		set noshowcmd
		set scrolloff=999
		Limelight
	endfunction
	" Goyo leave
	function! s:goyo_leave()
		silent !tmux set status on
		silent !tmux list-panes -F '\#F' | grep -q Z && tmux
		" Changes folding color
		highlight Folded ctermbg=242 ctermfg=White
		resize-pane -Z
		set showmode
		set showcmd
		set scrolloff=5
		Limelight!
	endfunction
	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave()
	" Color name (:help gui-colors) or RGB color
	let g:limelight_conceal_guifg = 'DarkGray'
	let g:limelight_conceal_guifg = '#777777'
" vim-javascript
	let g:javascript_plugin_jsdoc = 1
	let g:javascript_plugin_flow = 1
" vim-latex-live-preview
	let g:livepreview_previewer = 'evince'
	" set updatetime to a smaller value, which is the frequency that the
	" output PDF is updated
	"Setl updatetime=1
	let g:tex_flavor = "latex"
