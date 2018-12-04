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



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" copy and paste to clibbord
vnoremap <C-c> "+y
map <C-v> "+p
inoremap <C-v> <C-r>+ 

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
	" set updatetime to a smaller value, which is the frequency that the
	" output PDF is updated
	Setl updatetime=1

	nnoremap <buffer> <Space><Space> /<++>/:<CR>ciw
	" compile latex
	" map <buffer> <F5> :! compile-latex expand('%:t')<CR> 
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
	" vim
	Plug 'scrooloose/nerdtree'
	Plug 'airblade/vim-gitgutter'
	Plug 'tpope/vim-surround'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'

	" javascript
	Plug 'pangloss/vim-javascript'

	" latex
	Plug 'xuhdev/vim-latex-live-preview'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Latex
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-latex-live-preview
let g:livepreview_previewer = 'evince'


