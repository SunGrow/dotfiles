local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require('lspconfig')
local lspcompletion = require('completion')

lsp_status.config({
	status_symbol = '',
	indicator_errors = 'E:',
	indicator_warnings = 'W:',
	indicator_info = 'i',
	indicator_hint = 'h',
	indicator_ok = '✔️',
	spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
})

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	lspcompletion.on_attach()
	lsp_status.on_attach(_)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = true,
  	virtual_text = true,
  	signs = true,
  	update_in_insert = true
  }
)

lspconfig.clangd.setup{
	cmd = { "clangd", "--background-index", "-j=8", "--header-insertion=never", "--cross-file-rename"};
	handlers = lsp_status.extensions.clangd.setup();
	init_options = {
    clangdFileStatus = true
	};
	on_attach = on_attach; 
	capabilities = lsp_status.capabilities;
};

lspconfig.pyls.setup{
	on_attach = on_attach; 
	capabilities = lsp_status.capabilities;
}

lspconfig.zls.setup{
	on_attach = on_attach; 
	capabilities = lsp_status.capabilities;
}


