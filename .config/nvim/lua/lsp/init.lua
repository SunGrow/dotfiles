local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require('lspconfig')
local lspcompletion = require('completion')

lsp_status.config({
	status_symbol = '',
	indicator_errors = 'e',
	indicator_warnings = 'w',
	indicator_info = 'i',
	indicator_hint = 'h',
	indicator_ok = '✔️',
	spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = true,
  	virtual_text = true,
  	signs = true,
  	update_in_insert = true
  }
)

require'lspconfig'.clangd.setup{
	cmd = { "clangd", "--background-index", "-j=8", "--header-insertion=never", "--cross-file-rename"};
	handlers = lsp_status.extensions.clangd.setup();
	init_options = {
    clangdFileStatus = true
	};
	on_attach = lsp_status.on_attach; 
	capabilities = lsp_status.capabilities;
};

require'lspconfig'.pyls.setup{
	on_attach = lsp_status.on_attach; 
	capabilities = lsp_status.capabilities;
}

require'lspconfig'.zls.setup{
	on_attach = lsp_status.on_attach; 
	capabilities = lsp_status.capabilities;
}


