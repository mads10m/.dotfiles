""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on
set number relativenumber

" tab
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" source .vimrc
map <F5> :source ~/.vimrc<CR>

" quick save
nnoremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <Esc>:update<CR>i
vnoremap <silent> <c-s> <Esc>:w<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"augroup filetypedetect
	"au! BufNewFile,BufRead *.tex <buffer> MyLatex()
"augroup END

autocmd Filetype tex call MyLatex()

" au! BufNewFile,BufRead *.tex <buffer> MyLatex()
" autocmd filetype tex nnoremap <Space><Space> /<++><CR>ciw
" autocmd FileType tex call MyLatex()
" call MyLatex()
function! MyLatex()
	nnoremap <buffer> <Space><Space> /<++>/:<CR>ciw
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
	" Declare the list of plugins.
	Plug 'scrooloose/nerdtree'
	Plug 'airblade/vim-gitgutter'
	"Plug 'vim-syntastic/syntastic'
	Plug 'tpope/vim-surround'
	Plug 'pangloss/vim-javascript'
	"Plug 'w0rp/ale'
	"Plug 'Valloric/YouCompleteMe'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" nerdtree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END

" syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0


function! s:goyo_enter()
	silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
	set noshowmode
	set noshowcmd
	set scrolloff=999
	Limelight
	" ...
endfunction

function! s:goyo_leave()
	silent !tmux set status on
	silent !tmux list-panes -F '\#F' | grep -q Z && tmux
	resize-pane -Z
	set showmode
	set showcmd
	set scrolloff=5
	Limelight!
	" ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
