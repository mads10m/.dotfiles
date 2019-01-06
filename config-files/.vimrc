""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8

" line number
set number relativenumber

" sets normal line number when not activ window
"augroup numbertoggle
	"autocmd!
	"autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	"autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END

" tab
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

" Enable autocompletion:
set wildmode=longest,list,full

set splitbelow splitright

" Auto resice windows
autocmd VimResized * wincmd =

" my filetype file
"if exists("did_load_filetypes")
    "finish
"endif
"augroup filetypedetect
    "au! BufRead,BufNewFile *.hjs setfiletype html
"augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fix indentation
map <F7> mzgg=G`z

" copy and paste to clibbord
vnoremap <C-c> "+y
map <C-v> "+p
inoremap <C-v> <C-r>+
vnoremap <C-x> "+d

" quick save
nnoremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <Esc>:update<CR>i
vnoremap <silent> <c-s> <Esc>:w<CR>

" spell check
map <F6><F6> :setlocal spell!<CR>
map <F6>e :setlocal spell spelllang=en_us<CR>
map <F6>d :setlocal spell spelllang=da<CR>

" For vim files
autocmd Filetype vim call MyVim()
function! MyVim()
	" source .vimrc
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
	inoremap ,pl \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
	inoremap ,nl \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
endfunction

map <C-j> /<++><CR>cf>
inoremap <C-j> <Esc>/<++><CR>cf>

inoremap " ""<++><Esc>?"<CR>i
inoremap ' ''<++><Esc>?'<CR>i
inoremap ( ()<++><Esc>?)<CR>i
inoremap [ []<++><Esc>?]<CR>i
inoremap { {}<++><Esc>?}<CR>i
inoremap < <><++><Esc>?><CR>i

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
	" vim
	Plug 'scrooloose/nerdtree'
	Plug 'w0rp/ale'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'airblade/vim-gitgutter'
	Plug 'tpope/vim-surround'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'
	Plug 'joshdick/onedark.viM'

	" javascript
	Plug 'pangloss/vim-javascript'
	
	" markdown
	Plug 'shime/vim-livedown'

	" latex
	Plug 'xuhdev/vim-latex-live-preview'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Ale
let g:ale_fixers = {
\	'*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\} 

let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_echo_cursor = 0

" Onedark
colorscheme onedark

" Airline
let g:lightline = {
\ 'colorscheme': 'onedark',
\ }


" Goyo and Limelight
map <F4> :Goyo<CR>
inoremap <F4> <Esc>:Goyo<CR>a

let g:goyo_width=80
let g:goyo_height='85%'
let g:goyo_linenr=0

function! s:goyo_enter()
	silent !tmux set status off
	silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
	set noshowmode
	set noshowcmd
	set scrolloff=999
	Limelight
endfunction

function! s:goyo_leave()
	silent !tmux set status on
	silent !tmux list-panes -F '\#F' | grep -q Z && tmux
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

" Onedark colorschee
"g:onedark_termcolors
"let g:onedark_termcolors=256
"colorscheme onedark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Latex
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-latex-live-preview
let g:livepreview_previewer = 'evince'
" set updatetime to a smaller value, which is the frequency that the
" output PDF is updated
"Setl updatetime=1


