require'nvim_lsp'.clangd.setup{
	cmd = { "clangd", "--background-index", "-j=8" };
	on_attach = require'completion'.on_attach; 
};

require'nvim_lsp'.pyls.setup{
	on_attach = require'completion'.on_attach; 
};


