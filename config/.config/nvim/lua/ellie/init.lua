require("ellie.remap")
require("ellie.packer")







-- setup must be called before loading



	-- nvim-tree setup
	-- desiable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin =1

	-- 24-bit color
vim.opt.termguicolors = true

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,

	},
	filters = {
		dotfiles = false,
	},
})

require("ellie.lsp")


require("ellie.theme")

