vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use { "catppuccin/nvim", as = "catppuccin" }


	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use('nvim-treesitter/nvim-treesitter-textobjects')
	use {
		'vimpostor/vim-tpipeline',
		config = function()
			vim.g.tpipeline_autoembed = 0
			vim.g.tpipeline_clearstl = 1
		end
	}
	use('nvim-treesitter/playground')

	use('m4xshen/autoclose.nvim')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons',
		},
	}
	use("JoosepAlviste/nvim-ts-context-commentstring")

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvimtree/nvim-web-devicons', opt = true }
	}

	use({
		"aserowy/tmux.nvim",
		config = function() return require("tmux").setup() end
	})

	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use('windwp/nvim-ts-autotag')
	use('github/copilot.vim')
	use('nvimtools/none-ls.nvim')
	use('williamboman/mason.nvim')
	use('hrsh7th/nvim-cmp')
	use('hrsh7th/cmp-buffer')
	use('hrsh7th/cmp-nvim-lsp')
	use('hrsh7th/cmp-path')
	use('hrsh7th/cmp-nvim-lua')
	use('jose-elias-alvarez/null-ls.nvim')
	use('MunifTanjim/prettier.nvim')
	use("folke/trouble.nvim")
	use('nvim-pack/nvim-spectre')
	use('neovim/nvim-lspconfig')
	use("j-hui/fidget.nvim")
	use('onsails/lspkind.nvim')
	use('nvim-lua/plenary.nvim')
	use('williamboman/mason-lspconfig.nvim')
	use("xiyaowong/nvim-transparent")

	use({
		'nosduco/remote-sshfs.nvim',
		requires = { 'nvim-telescope/telescope.nvim' }
	})
	use('romgrk/barbar.nvim')
end
)
