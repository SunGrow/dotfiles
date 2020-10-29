
" - General - "

" Set leader key
let mapleader="\<Space>"

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au CursorHold * checktime
au FocusGained,BufEnter * checktime

" - Navigation - "

" Window navigation

map <leader>w <C-W>

" Buffer Control

noremap <leader>bb :buffers<cr>

" Is it possible to pass in the keystroke as a variable to the binding?
noremap <leader>bd :bd

noremap <leader>bl :bnext<cr>
noremap <leader>bh :bprevious<cr>

" File Navigation

noremap <leader>e :Ex<cr>

" - UI - "

" Turn off last search highlight

" Clear highlighting on escape in normal mode
nnoremap <esc><esc> :noh<return>

noremap <leader>c :noh<CR>

set so=4 " how many lines from edge before scrolling

" When search for capital letter, become case sensetive 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" - Fonts and Colors - "

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn all of the backups off
set nobackup
set nowb
set noswapfile

" - Text - "

" Formating
set softtabstop=4 shiftwidth=4 tabstop=4

" Highlight
syntax on

"" Plugin

" Autoinstall plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		\https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'neovim/nvim-lspconfig'
call plug#end()

"" Gruvbos theme
set background=dark
autocmd vimenter * colorscheme gruvbox


"" LSP
lua <<EOF
require'nvim_lsp'.clangd.setup{
	cmd = { "clangd", "--background-index", "-j=8" }
}
EOF

nnoremap <silent> gd         <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gD         <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>lr <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <silent> <leader>/  <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>



nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
