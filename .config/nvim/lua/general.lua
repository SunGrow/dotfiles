-- Basic settings
vim.o.encoding = "utf-8"
vim.o.backspace = "indent,eol,start" -- backspace works on every char in insert mode
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.o.history = 1000
vim.o.laststatus = 2
vim.g.mapleader = ' ' -- Set leader key
vim.o.so = 4 -- How many lines from edge before scrolling

-- Enable filetype plugins
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')
-- Set to auto read when a file is changed from the outside
vim.g.autoread = true 
vim.cmd('au CursorHold * checktime')
vim.cmd('au FocusGained,BufEnter * checktime')

vim.cmd[[
augroup LargeFile
        let g:large_file = 10485760

        " Set options:
        "   eventignore+=FileType (no syntax highlighting etc
        "   assumes FileType always on)
        "   noswapfile (save copy of file)
        "   bufhidden=unload (save memory when other file is viewed)
        "   buftype=nowritefile (is read-only)
        "   undolevels=-1 (no undo possible)
        au BufReadPre *
                \ let f=expand("<afile>") |
                \ if getfsize(f) > g:large_file |
                        \ set eventignore+=FileType |
                        \ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
                \ else |
                        \ set eventignore-=FileType |
                \ endif
augroup END
]]

vim.o.ignorecase = true -- Ignore case when searching
vim.o.smartcase = true -- When search for capital letter, become case sensetive
vim.o.hlsearch = true -- Highlight search results
vim.o.incsearch = true -- Makes search act like search in modern browsers
vim.g.lazyredraw = true -- Don't redraw while executing macros (good performance config)
vim.g.magic = true -- For regular expressions turn magic on
vim.g.showmatch = true -- Show matching brackets when text indicator is over them
-- No annoying sound on errors
vim.g.errorbells = false
vim.g.visualbell = false
vim.g.t_vb = ''
vim.g.tm=500
-- GUI
--vim.g.guioptions-=r
--vim.g.guioptions-=R
--vim.g.guioptions-=l
--vim.g.guioptions-=L


-- Mapping waiting time
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

-- Theme
vim.g.gruvbox_contrast_dark = 'normal'
vim.o.background = 'dark'
vim.cmd('colorscheme gruvbox')
vim.g.guifont = 'JetBrains Mono:h11'
vim.o.linespace = 4

local lsp_colors = require("lsp-colors")

lsp_colors.setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})

local lualine = require('lualine')

require('bufferline').setup{
  options = {
    view = "multiwindow",
    diagnostics = "nvim_diagnostic",
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
      {'diagnostics', sources={'nvim_diagnostic'}, condition=function() return vim.fn.winwidth(0) > 80 end}
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
      {'diagnostics', sources={'nvim_diagnostic'}, condition=function() return vim.fn.winwidth(0) > 80 end}
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  }
}


-- Formating
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.cmd('syntax on')


-- Latex
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'

-- Diagnostics

lspconfig = require('lspconfig')
lspinstall = require('nvim-lsp-installer')


lspfuzzy = require('lspfuzzy')
lspfuzzy.setup {}


treesitter = require('nvim-treesitter.configs')
treesitter.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = true,
  	virtual_text = true,
        signs = true,
  	update_in_insert = false
  }
)

trouble = require('trouble')
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

--- Unfiltered mess below

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

local LspOnAttach = function(client, bufnr)
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

local configs = require('lspconfig/configs')
local util = require('lspconfig/util')
local completion = require('cmp_nvim_lsp')

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = completion.update_capabilities(capabilities)
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    	on_attach = LspOnAttach,
	root_dir = util.root_pattern(".git") or vim.loop.os_homedir()
  }
end

lspinstall.on_server_ready(function(server)
    local opts = make_config()
    if server.name == "clangd" then
	opts.cmd = { "clangd", "--background-index", "-j=8", "--header-insertion=never", "--cross-file-rename"};
	opts.root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git") or vim.loop.os_homedir()
    end
    if server.name == "gdscript" then
    end
    if server.name == "zls" then
    end
    if server.name == "lua" then
      config.settings = lua_settings
    end
    server:setup(opts)
end)

saga = require('lspsaga')
saga.init_lsp_saga()

