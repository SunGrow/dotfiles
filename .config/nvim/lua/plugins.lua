vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	-- Visual
	use 'morhetz/gruvbox'
	use 'ap/vim-css-color'
	use 'akinsho/nvim-bufferline.lua'
	use 'hoob3rt/lualine.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use 'folke/lsp-colors.nvim'
	-- LSP
	use 'neovim/nvim-lspconfig'
	-- Completion
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	-- Snippets
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	-- 
	use 'glepnir/lspsaga.nvim'
	use 'williamboman/nvim-lsp-installer'
	use 'folke/lsp-trouble.nvim'
	-- LatexPlugx
	use 'lervag/vimtex'
	use {'junegunn/fzf', run = function() vim.fn['fzf#install'](0) end }
	use 'junegunn/fzf.vim'
	use 'ojroques/nvim-lspfuzzy'
	use {'nvim-treesitter/nvim-treesitter'}
	use 'habamax/vim-godot'
	end)
