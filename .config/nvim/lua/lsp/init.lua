local lspconfig = require('lspconfig')
local lspcompletion = require('completion')

local trouble = require('trouble')
local lualine = require('lualine')
local lsp_colors = require("lsp-colors")
lsp_colors.setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})


lualine.setup{
  options = {theme = 'gruvbox'},
  extensions = { 'fzf' },
  sections = {
    lualine_a = {{'mode', format=function(mode_name) return mode_name:sub(1,1) end}, },
    lualine_b = {{'branch'}},
    lualine_c = {
      {'filename', condition=function() return vim.fn.winwidth(0) > 80 end},
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
      {'filename', condition=function() return vim.fn.winwidth(0) > 80 end},
      {'diagnostics', sources={'nvim_lsp'}, condition=function() return vim.fn.winwidth(0) > 80 end}
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  }
}

trouble.setup {
}

local function preview_location_callback(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end

function restartLSP()
  clients = vim.lsp.get_active_clients() -- client that crashed
  copy_of_config = clients[1].config
  vim.lsp.stop_client(clients)
  
  new_client_id = vim.lsp.start_client(copy_of_config)
  vim.lsp.buf_attach_client(0, new_client_id)
end

function PeekDefinition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  lspcompletion.on_attach()
  
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>dg', '<Cmd>lua PeekDefinition()<CR>', opts)
  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>/', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
---  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  
  buf_set_keymap('n', '<leader>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>sl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
  buf_set_keymap('n', '<leader>lk', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>lj', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  buf_set_keymap('n', '<leader>xx', '<cmd>LspTroubleToggle<cr>', opts)
  buf_set_keymap('n', '<leader>xw', '<cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>', opts)
  buf_set_keymap('n', '<leader>xd', '<cmd>LspTroubleToggle lsp_document_diagnostics<cr>', opts)
  buf_set_keymap('n', '<leader>xq', '<cmd>LspTroubleToggle quickfix<cr>', opts)
  buf_set_keymap('n', '<leader>xl', '<cmd>LspTroubleToggle loclist<cr>', opts)
  buf_set_keymap('n', 'gr', '<cmd>LspTroubleToggle lsp_references<cr>', opts)

  
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = true,
  	virtual_text = true,
    signs = function(bufnr, client_id)
      local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
      -- No buffer local variable set, so just enable by default
      if not ok then
        return true
      end

      return result
    end,
  	update_in_insert = true
  }
)

lspconfig.clangd.setup{
  cmd = { "clangd", "--background-index", "-j=8", "--header-insertion=never", "--cross-file-rename"};
  on_attach = on_attach; 
};

lspconfig.pyls.setup{
  on_attach = on_attach; 
}

lspconfig.zls.setup{
  on_attach = on_attach; 
}

--- Gruvbox theme
vim.cmd[[
 let g:gruvbox_contrast_dark = 'normal'
 colorscheme gruvbox
 set background=dark
 hi Normal guibg=NONE ctermbg=NONE
]]
