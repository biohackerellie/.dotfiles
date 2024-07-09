require("ellie.remap")
require("ellie.packer")

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
require("ellie.opts")
require("ellie.theme")
