vim.cmd[[
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

" Tab navigation
nnoremap <leader>te <cmd>:tabe<cr>
nnoremap <leader>tf <cmd>:tabf %<cr>
nnoremap <leader>tn <cmd>:tabn<cr>
nnoremap <leader>tp <cmd>:tabp<cr>
nnoremap <leader>tc <cmd>:tabc<cr>
nnoremap <leader>to <cmd>:tabo<cr>
nnoremap <leader>tt <cmd>:tabe +term<cr>


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
"if has('win32') || has("win64") || has("win16")
"else
"	if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
"		silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"			\https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"		autocmd VimEnter * PlugInstall
"	endif
"endif

let g:polyglot_disabled = ['glsl']

"call plug#begin(stdpath('data') . '/plugged')
"" Visual
"Plug 'morhetz/gruvbox'
"Plug 'ap/vim-css-color'
"	" Tabs
"Plug 'akinsho/nvim-bufferline.lua'
"	" Line
"Plug 'hoob3rt/lualine.nvim'
"Plug 'kyazdani42/nvim-web-devicons'
"
"" Lsp Config
"Plug 'neovim/nvim-lspconfig'
"Plug 'williamboman/nvim-lsp-installer'
"Plug 'hrsh7th/cmp-nvim-lsp'
"
"Plug 'glepnir/lspsaga.nvim'
"Plug 'lervag/vimtex'
"Plug 'tikhomirov/vim-glsl'
"Plug 'sheerun/vim-polyglot'
"Plug 'ziglang/zig.vim'
"Plug 'f-person/git-blame.nvim'
"Plug 'folke/lsp-trouble.nvim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
"Plug 'ojroques/nvim-lspfuzzy'
"Plug 'folke/lsp-colors.nvim'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'mfussenegger/nvim-dap'
"call plug#end()

" Autoinstall packer
if has('win32') || has("win64") || has("win16")
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
else
	if empty(glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim'))
		git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
	endif
endif


" CoC
set signcolumn=number

" Buffer Control
nnoremap <silent>    <A-,> :BufferLineCyclePrev<CR>
nnoremap <silent>    <A-.> :BufferLineCycleNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> :BufferLineMovePrev<CR>
nnoremap <silent>    <A->> :BufferLineMoveNext<CR>
nnoremap <silent><leader>be :BufferLineSortByExtension<CR>
nnoremap <silent><leader>bd :BufferLineSortByDirectory<CR>
" Goto buffer in position...
nnoremap <silent><A-<num>> <cmd>:lua require"bufferline".go_to_buffer(num)<CR>
nnoremap <silent>    <A-c> :bd<CR>
nnoremap <silent>    <C-s> :BufferLinePick<CR>


"" GLSL
autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

" Autocompletion

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

set completeopt=menuone,noinsert,noselect
set completeopt-=preview

"set completeopt=menuone,noinsert,noselect,popuphidden
"set completepopup=highlight:Pmenu,border:off

" Server

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

nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
tnoremap <silent> <C-[><C-[> <C-\><C-n>

" Large files


]]

local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')
local saga = require('lspsaga')

local trouble = require('trouble')
local lualine = require('lualine')
local lsp_colors = require("lsp-colors")
local treesitter = require('nvim-treesitter.configs')
local lspfuzzy = require('lspfuzzy')

require('bufferline').setup{
  options = {
    view = "multiwindow",
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
          or (e == "warning" and " " or "" )
        s = s .. sym .. n 
      end
      return s
    end
  },
}

lspfuzzy.setup {}

treesitter.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

lsp_colors.setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = true,
  	virtual_text = true,
    signs = true,
  	update_in_insert = false
  }
)

lualine.setup{
  options = {
    theme = 'gruvbox',
    section_separators = {'', ''},
    component_separators = {'', ''}
  },
  extensions = { 'fzf' },
  sections = {
    lualine_a = {{'mode', format=function(mode_name) return mode_name:sub(1,1) end}, },
    lualine_b = {{'branch'}},
    lualine_c = {
      {'filename', condition=function() return vim.fn.winwidth(0) > 50 end},
      {'diagnostics', sources={'nvim_lsp'}, condition=function() return vim.fn.winwidth(0) > 80 end}
    },
    lualine_x = {{'encoding', 'fileformat', 'filetype'}},
    lualine_y = {{'diff'}},
    lualine_z = {{'location'}}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {'filename', condition=function() return vim.fn.winwidth(0) > 50 end},
      {'diagnostics', sources={'nvim_lsp'}, condition=function() return vim.fn.winwidth(0) > 80 end}
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  }
}

trouble.setup {
  signs = {
    -- icons / text used for a diagnostic
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "﫠"
  },
}

saga.init_lsp_saga()

local function preview_location_callback(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end

function RestartLSP()
  local clients = vim.lsp.get_active_clients() -- client that crashed
  local copy_of_config = clients[1].config
  vim.lsp.stop_client(clients)
  local new_client_id = vim.lsp.start_client(copy_of_config)
  vim.lsp.buf_attach_client(0, new_client_id)
end

function PeekDefinition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>dg', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gd', "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
  buf_set_keymap('n', '<leader>lr', "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)
  buf_set_keymap('n', '<leader>/', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', 'K', "<Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
  buf_set_keymap('n', '<C-f>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
  buf_set_keymap('n', '<C-b>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)
  buf_set_keymap('n', 'gr', "<cmd>LspTroubleToggle lsp_references<cr>", opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<C-k>', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
  
  buf_set_keymap('n', '<leader>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  
  buf_set_keymap('n', '<leader>ca', "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", opts)
  buf_set_keymap('n', '<leader>sl', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
  buf_set_keymap('n', '<leader>sh', "<cmd>lua vim.lsp.buf.document_highlight()<CR>", opts)
  buf_set_keymap('n', '<leader>lk', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
  buf_set_keymap('n', '<leader>lj', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)
  buf_set_keymap('n', '<leader>q',  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  buf_set_keymap('n', '<leader>xx', "<cmd>LspTroubleToggle<cr>", opts)
  buf_set_keymap('n', '<leader>xw', "<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>", opts)
  buf_set_keymap('n', '<leader>xd', "<cmd>LspTroubleToggle lsp_document_diagnostics<cr>", opts)
  buf_set_keymap('n', '<leader>xq', "<cmd>LspTroubleToggle quickfix<cr>", opts)
  buf_set_keymap('n', '<leader>xl', "<cmd>LspTroubleToggle loclist<cr>", opts)

  
  buf_set_keymap('n', '<leader>lc', '<cmd>lua restartLSP()<cr>', opts)
  
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead  cterm=bold ctermbg=130 guibg=#af5f00
      hi LspReferenceText  cterm=bold ctermbg=130 guibg=#af5f00
      hi LspReferenceWrite cterm=bold ctermbg=130 guibg=#af5f00
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

lspinstall.setup()

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()
  table.insert(servers, "clangd")
  table.insert(servers, "zls")

  for _, server in pairs(servers) do
    local config = make_config()
    if server == "clangd" then
      config.cmd = { "clangd", "--background-index", "-j=8", "--header-insertion=never", "--cross-file-rename"};
    end

    if server == "lua" then
      config.settings = lua_settings
    end

    local pid = vim.fn.getpid()
    if server == "csharp" then
      config.init_options = {"--languageserver" , "--hostPID", tostring(pid), "msbuild:enabled:true"}
    end

    lspconfig[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

--- Gruvbox theme
vim.cmd[[
 let g:gruvbox_contrast_dark = 'normal'
 colorscheme gruvbox
 set background=dark
 hi Normal guibg=NONE ctermbg=NONE
]]
