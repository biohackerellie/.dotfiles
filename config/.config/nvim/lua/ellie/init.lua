require("ellie.remap")
require("ellie.packer")

-- setup must be called before loading

-- nvim-tree setup
-- desiable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set number
vim.opt.number = true
-- 24-bit color
vim.opt.termguicolors = true

-- set global clipboard
vim.opt.clipboard = "unnamedplus"
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

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
