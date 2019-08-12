" vim: foldmethod=marker foldlevel=-1

set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8

" Plugins {{{
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
	Plug 'ap/vim-css-color'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'

	" tmux
	Plug 'christoomey/vim-tmux-navigator'

	" javascript
	Plug 'pangloss/vim-javascript'

	" typescript
	Plug 'leafgarland/typescript-vim'

	" markdown
	Plug 'shime/vim-livedown'

	" latex
	Plug 'lervag/vimtex'
	Plug 'mads10m/vim-template'
	Plug 'xuhdev/vim-latex-live-preview'
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

map <F7> mzgg=G`z				" Fix indentation

cnoreabbrev qq quitall			" Adding quit all command

" For vim files {{{
autocmd Filetype vim call MyVim()
function! MyVim()
	" source .vimrc
	map <F5> :source ~/.vimrc<CR>
endfunction
" }}}
" }}}
" Plugin settings {{{
" Onedark {{{
colorscheme onedark
"highlight Folded ctermbg=242 ctermfg=White
" }}}
" Nerdtree {{{
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
" }}}
" Ale {{{
let g:ale_fixers = {
\	'*': ['remove_trailing_lines', 'trim_whitespace'],
\	'javascript': ['prettier', 'eslint'],
\	'python': ['pylint', 'flake8'],
\	'latex': ['chktex'],
\}

let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_echo_cursor = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 0
" }}}
" Youcompleteme {{{
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
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
" }}}
" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
" }}}
" vim-latex-live-preview {{{
let g:livepreview_previewer = 'evince'
" set updatetime to a smaller value, which is the frequency that the
" output PDF is updated
"Setl updatetime=1
let g:tex_flavor = "latex"
" }}}
let g:tex_flavor='latex'
let g:livepreview_previewer = 'evince'
let g:vimtex_quickfix_mode=0
set conceallevel=3
let g:tex_conceal='abdmg'
" }}}
