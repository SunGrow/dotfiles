" - General - "
"
set notimeout
set ttimeout

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
nnoremap <esc><esc> :noh<cr>

" Always show the status line
set laststatus=2

" Disable scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

set so=4 " how many lines from edge before scrolling

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" Ignore case when searching
set ignorecase

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
" Set gui font
set guifont=JetBrains\ Mono:h10.5 
set linespace=4

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
if has('win32') || has("win64") || has("win16")
else
	if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
		silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
			\https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall
	endif
endif

let g:polyglot_disabled = ['glsl']

call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'lervag/vimtex'
Plug 'tikhomirov/vim-glsl'
Plug 'sheerun/vim-polyglot'
Plug 'ziglang/zig.vim'
Plug 'ap/vim-css-color'
Plug 'f-person/git-blame.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-trouble.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'folke/lsp-colors.nvim'
call plug#end()



"" GLSL
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

"" LSP

" Autocompletion

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

set completeopt=menuone,noinsert,noselect

autocmd BufEnter * lua require'completion'.on_attach()

imap <silent> <c-p> <Plug>(completion_trigger)

" Server
lua require('lsp')

" Keybindings
set updatetime=1000

"" Python
nnoremap <silent> <leader>bc <cmd>:! python %<cr>

"" Text doc editing

" Doc Preview
nnoremap <silent> <leader>do <cmd>:silent !zathura '/tmp/preview_tmp.pdf'&<cr> 
" Groff/Troff
function! CompileGroff()
	:!preconv % | groff -Kutf8 -ms -Tpdf > /tmp/preview_tmp.pdf &
endfunction

autocmd BufWritePost *.ms :silent call CompileGroff()

" Markdown
function! CompileMarkdown()
	:!pandoc % -o /tmp/preview_tmp.pdf --pdf-engine=xelatex -V mainfont="DejaVu Serif" &
endfunction

autocmd BufWritePost *.md :silent call CompileMarkdown()

" Latex
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
nnoremap <silent> <leader>c <cmd>:VimtexCompile<cr>
nnoremap <silent> <leader>p <cmd>:VimtexView<cr>

" Blame
let g:gitblame_enabled = 0
let g:gitblame_message_template = '  < <summary> • <date> • <author>'
nnoremap <silent> <leader>B <cmd>GitBlameToggle<CR>

"" Gruvbos theme
