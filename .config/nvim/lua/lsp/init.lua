require'lspconfig'.clangd.setup{
	cmd = { "clangd", "--background-index", "-j=8", "--header-insertion=never", "--cross-file-rename"};
	on_attach = require'completion'.on_attach; 
};

require'lspconfig'.pyls.setup{
	on_attach = require'completion'.on_attach; 
}

require'lspconfig'.zls.setup{
	on_attach = require'completion'.on_attach; 
}


