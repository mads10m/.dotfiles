" vim: foldmethod=marker foldlevel=-1 nolist

set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
scriptencoding utf-8

" Plugins {{{
call plug#begin('~/.vim/plugged')
" Navigation
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'christoomey/vim-tmux-navigator'

" Style
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'

" Functionality
Plug 'SirVer/ultisnips'
"Plug 'dense-analysis/ale'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --cs-completer --ts-completer --java-completer --clang-completer' }

" Editor
Plug 'chaoren/vim-wordmotion'

" Searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" look at
Plug 'tpope/vim-fugitive'
" Plug 'mbbill/undotree'

" Typescript
Plug 'leafgarland/typescript-vim'

" React
Plug 'maxmellon/vim-jsx-pretty'

" Latex
Plug 'lervag/vimtex'

call plug#end()
" }}}
" Basic settings {{{
set number						" Shows line numbers

set hlsearch					" Highlight all searches
set incsearch					" Highlight search while it is
								" being typed

set autoindent					" Turns indent (tabs) on
set noexpandtab					" Don't turn spaces into an tab
set tabstop=4					" How many columns a tab is
								" made out of
set shiftwidth=4				" How many columns text will be
								" indented when using indent
								" operations (such as < or >)

set hidden						"

set wildmode=longest:full,full	" Enable better autocomplete


set list
set listchars=tab:\ \ ,trail:·	" Show trailing whitespace

" Change tabs to spaces (2 spaces) in work directory
autocmd BufRead,BufNewFile ~/work/* setlocal expandtab tabstop=2 shiftwidth=2

set splitbelow splitright		" New splits are below or to
								" the right
autocmd VimResized * wincmd =	" Auto resize windows

set backspace=indent,eol,start	" Fix backspace button

let mapleader=","				" Map leader
let maplocalleader="_"			" Map local leader

set updatetime=100				" How many milliseconds before
								" the swap file will be
								" written to disk if nothing
								" is typed. (Used for updating
								" vim-gitgutter faster)

set colorcolumn=80				" Set 80 column limit

set wildignore=.git/*
set wildignore+=*/node_modules/*

" }}}
" Mappings {{{
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
noremap <F6><F6> :setlocal spell!<CR>
noremap <F6>e :setlocal spell spelllang=en_us<CR>
noremap <F6>d :setlocal spell spelllang=da<CR>

" Copy and paste to clipboard
vnoremap <Leader>c "+y
noremap <Leader>v "+p
inoremap <Leader>v <C-r>+
vnoremap <Leader>x "+d

" Adding quit all command
cnoreabbrev qq quitall

" Fix indentation, trailing lines and trim whitespace
noremap <F7> mzgg=G`z:YcmCompleter Format<CR>:ALEFix<CR>:ALEFix<CR>

" YCM
noremap <Leader>gt :YcmCompleter GoTo<CR>
noremap <Leader>gr :YcmCompleter GoToReferences<CR>
noremap <Leader>gd :YcmCompleter GetDoc<CR>
noremap <Leader>rr :YcmCompleter RefactorRename<Space>

" Buffers
nnoremap <Left> :bprevious<CR>
nnoremap <Leader>bn :bprevious<CR>
nnoremap <Right> :bnext<CR>
nnoremap <Leader>bp :bnext<CR>

nnoremap <Leader>bq :bp <BAR> bd #<CR>
nnoremap <Leader>bl :Buffers<CR>

"execute system('git rev-parse --is-inside-work-tree')
"if execute system('git rev-parse --is-inside-work-tree') =~ true
"	noremap <Leader>f :GFiles<CR>
"else
"	noremap <Leader>f :Files<CR>
"endif
" }}}
" Vim directory {{{
" Create dir for backup, swap and undo file
silent execute '!mkdir -p ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo'

set backup
set backupdir=~/.vim/.backup//		" Backup directory

set swapfile
set directory=~/.vim/.swp//			" Swap directory

set undofile						" Save undo file after file closes
set undodir=~/.vim/.undo//			" Undo directory
set undolevels=1000					" How many undoes
set undoreload=10000				" Number of lines to save for undo
" }}}
" language specific settings {{{
" Latex {{{
autocmd Filetype tex call MyLatex()
function! MyLatex()
	map <C-m> :VimtexTocToggle<CR>
	map <F5> :VimtexCompile<CR>
	map <F3> :call ToggleFollowMode()<CR>
	map <C-m> <plug>(vimtex-toc-open)
	"inoremap <expr> <cr> CheckIfList() ? '<cr>\item ' : '<cr>'
	"inoremap <C-f> <C-o>:call NewInkscape(getline("."))<cr>
endfunction
" }}}
" }}}
" Plugin settings {{{
" NERDtree {{{
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ["^node_modules$", ".git$"]
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
" Onedark {{{
colorscheme onedark
" }}}
" vim-airline {{{
"let g:airline#extensions#tabline#enabled = 1	" Enabel buffer details
"let g:airline#extensions#tabline#buffer_nr_show = 0
"let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#enabled = 1		" Enable enhanced tabline
let g:airline#extensions#tabline#formatter = 'default'
"let g:airline#extensions#tabline#tab_nr_type = 1	" Display tab number
"let g:airline#extensions#tabline#show_tab_nr = 1	" Display number of tabs
"let g:airline#extensions#tabline#buffer_nr_show = 0	" Display number of buffers in tab
" }}}
" ALE {{{
let g:ale_linters = {
			\	'javascript': ['eslint'],
			\	'typescript': ['tsserver'],
			\	'css': ['stylelint'],
			\	'scss': ['stylelint'],
			\	'python': ['flake8', 'pylint'],
			\	'cs': ['OmniSharp'],
			\	'c': ['clang'],
			\	'latex': ['chktex', 'lacheck'],
			\}
let g:ale_fixers = {
			\	'*': ['remove_trailing_lines', 'trim_whitespace'],
			\	'javascript': ['eslint'],
			\	'typescript': ['tsserver'],
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
" YouCompleteMe {{{
"let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_complete_in_comments = 1
"let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_use_ultisnips_completer = 1
" }}}
" Ultisnips {{{

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/my-snippets']
" }}}
" FZF {{{
" Where and how big the preview window is
let g:fzf_preview_window = 'right:50%'

" Mapping selecting mappings
"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)
"
"" Insert mode completion
"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-j> <plug>(fzf-complete-file-ag)
"imap <c-x><c-l> <plug>(fzf-complete-line)
"
"let g:fzf_action = {
"	\	'ctrl-t': 'tab split',
"	\	'ctrl-x': 'split',
"	\	'ctrl-v': 'vsplit'
"	\}

" }}}
" Vimtex {{{
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
" }}}
" }}}
