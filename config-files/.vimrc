""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
	Plug 'scrooloose/nerdtree'
	Plug 'w0rp/ale'
	Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --ts-completer --java-completer' }
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'airblade/vim-gitgutter'
	Plug 'tpope/vim-surround'
	"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug '~/.fzf'
	Plug 'junegunn/fzf.vim'

	Plug 'SirVer/ultisnips'

	" Style
	Plug 'joshdick/onedark.vim'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'

	" tmux
	Plug 'christoomey/vim-tmux-navigator'

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
" Searching
	set hlsearch
	set incsearch
	"autocmd InsertEnter * :let @/=""
	nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Change scroll
	map <F2> :call ScrollToggle()<cr>
	set scrolloff=5
	let s:mappingsScrolloff=1
	function! ScrollToggle()
		if s:mappingsScrolloff
			set scrolloff=5
		else
			set scrolloff=999
		endif

		let s:mappingsScrolloff = !s:mappingsScrolloff
	endfunction


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
" Fix indentation
	map <F7> mzgg=G`z
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
	\	'python': ['pylint', 'flake8'],
	\	'latex': ['chktex'],
	\}
	let g:ale_open_list = 1
	let g:ale_lint_on_save = 1
	let g:ale_echo_cursor = 0
" Youcompleteme
	let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
	let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
	let g:SuperTabDefaultCompletionType = '<C-n>'
" Ultisnips
	" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpForwardTrigger="<tab>"
	let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

	" If you want :UltiSnipsEdit to split your window.
	let g:UltiSnipsEditSplit="vertical"

	let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/my-snippets']
" Onedark
	highlight Folded ctermbg=242 ctermfg=White
	colorscheme onedark
" Airline
	let g:airline_theme = 'onedark'
	let g:lightline = {
	\ 'colorscheme': 'onedark',
	\ }
" FZF
	let g:fzf_action = {
  	\ 'ctrl-t': 'tab split',
  	\ 'ctrl-x': 'split',
  	\ 'ctrl-v': 'vsplit' }
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
