
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.6',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { "catppuccin/nvim", as = "catppuccin" } 


  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use{
	  'vimpostor/vim-tpipeline',
	config = function()
		vim.g.tpipeline_autoembed = 0
		vim.g.tpipeline_clearstl = 1
	end
  }
  use('nvim-treesitter/playground')
  use('neovim/nvim-lspconfig')
  use('m4xshen/autoclose.nvim')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use{
	  'nvim-tree/nvim-tree.lua',
	  requires = {
		  'nvim-tree/nvim-web-devicons',
	  },
  }

  use{
	  'nvim-lualine/lualine.nvim',
	  requires = { 'nvimtree/nvim-web-devicons', opt = true}
  }

  use({
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!:).
	run = "make install_jsregexp"
})
  use({
    "aserowy/tmux.nvim",
    config = function() return require("tmux").setup() end
})
  use('windwp/nvim-ts-autotag')
  use('github/copilot.vim')
  use('nvimtools/none-ls.nvim')
  use('williamboman/mason.nvim')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-buffer')
  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')
  use('hrsh7th/cmp-nvim-lsp')
  use('onsails/lspkind.nvim')
  use('nvim-lua/plenary.nvim')
  use('williamboman/mason-lspconfig.nvim')
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'
  }
  use("xiyaowong/nvim-transparent")
  use {
  "pmizio/typescript-tools.nvim",
  requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
	  require("typescript-tools").setup {}
	end,
}
end)
