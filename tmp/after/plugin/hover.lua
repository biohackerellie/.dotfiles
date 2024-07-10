local hover = require("hover")

hover.setup({
	init = function()
		require("hover.providers.lsp")
	end,
	preview_opts = {
		border = "single",
	},
	preview_window = false,
	mouse_providers = {
		"LSP",
	},
	mouse_delay = 500,
	auto_close = true,
})

vim.o.mousemoveevent = true
