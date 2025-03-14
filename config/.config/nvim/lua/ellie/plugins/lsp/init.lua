local M = {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local U = require("ellie.util").lsp
			require("ellie.plugins.lsp.diagnostic").setup()
			require("lspconfig.ui.windows").default_options.border = require("ellie.config").get_border()

			local on_attach = U.on_attach(function(client, buffer)
				require("ellie.plugins.lsp.keymaps").on_attach(client, buffer)
				require("ellie.plugins.lsp.codelens").on_attach(client, buffer)
				require("ellie.plugins.lsp.highlight").on_attach(client, buffer)
				if client.name == "svelte" then
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts", "*.svelte" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end,
					})
				end
				if vim.bo[buffer].filetype == "svelte" then
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts", "*.svelte" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end,
					})
				end
			end)

			local lsp_flags = {
				debounce_text_changes = 150,
			}
			-- servers
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
							disable = { "different-requires" },
						},
					},
				},
			})
			lspconfig.gdscript.setup({
				on_attach = on_attach,
				flags = lsp_flags,
				filetypes = { "gd", "gdscript", "gdscript3" },
			})
			-- lspconfig.rust_analyzer.setup({
			-- 	diagnostics = {
			-- 		refreshSupport = false,
			-- 	},
			-- 	procMacro = {
			-- 		enable = true,
			-- 	},
			-- })
			lspconfig.vtsls.setup({})
			lspconfig.gopls.setup({
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					env = {
						GOEXPERIMENT = "rangefunc",
					},
					formatting = {
						gofumpt = true,
					},
				},
			})
			lspconfig.svelte.setup({
				filetypes = { "svelte" },
				on_attach = on_attach,
			})
			lspconfig.jsonls.setup({})
			lspconfig.astro.setup({})
			lspconfig.biome.setup({
				root_dir = U.root_pattern("biome.json", "biome.jsonc"),
			})
			lspconfig.zls.setup({})
			lspconfig.cssls.setup({})
			lspconfig.tailwindcss.setup({
				settings = {
					experimental = {
						classRegex = {
							-- clsx, cn
							-- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/682#issuecomment-1364585313
							{ [[clsx\(([^)]*)\)]], [["([^"]*)"]] },
							{ [[cn\(([^)]*)\)]], [["([^"]*)"]] },
							-- Tailwind Variants
							-- https://www.tailwind-variants.org/docs/getting-started#intellisense-setup-optional
							{ [[tv\(([^)]*)\)]], [==[["'`]([^"'`]*).*?["'`]]==] },
						},
					},
				},
			})
		end,
	},
	{
		"yioneko/nvim-vtsls",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		dependencies = { "nvim-lspconfig" },
	},
}

return M
