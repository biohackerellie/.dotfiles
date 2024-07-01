require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = {"lua_ls", "rust_analyzer","gopls", "tsserver", "eslint", "prettier", "tailwindcss" }

}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.lua_ls.setup{}

require'lspconfig'.gopls.setup{}



