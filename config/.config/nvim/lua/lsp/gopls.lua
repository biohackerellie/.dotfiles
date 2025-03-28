---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		env = {
			GOEXPERIMENT = "rangefunc",
		},
		formatting = {
			gofumpt = true,
		},
	},
	root_markers = { "go.mod", "go.sum", ".git" },
}
