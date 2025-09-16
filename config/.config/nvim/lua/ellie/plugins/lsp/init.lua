local M = {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			require("ellie.plugins.lsp.diagnostic").setup()
			require("lspconfig.ui.windows").default_options.border = require("ellie.config").get_border()

			local on_attach = function(_client, _buffer)
				-- require("ellie.plugins.lsp.keymaps").on_attach(buffer)
				-- require("ellie.plugins.lsp.codelens").on_attach(client, buffer)
				-- require("ellie.plugins.lsp.highlight").on_attach(client, buffer)
			end

			-- require("typescript-tools").setup({
			-- 	on_attach = on_attach,
			-- })

			-- servers
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
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
				capabilities,
				flags = lsp_flags,
				cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
				filetypes = { "gd", "gdscript", "gdscript3" },
			})
			lspconfig.rust_analyzer.setup({
				diagnostics = {
					refreshSupport = false,
				},
				procMacro = {
					enable = true,
				},
			})
			lspconfig.vtsls.setup({})
			lspconfig.vimls.setup({
				on_attach = on_attach,
			})
			lspconfig.gopls.setup({
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					env = {
						GOEXPERIMENT = "rangefunc",
						GOFLAGS = "-tags=postgres",
					},
					formatting = {
						gofumpt = true,
					},
				},
			})
			lspconfig.templ.setup({
				on_attach = on_attach,
			})
			lspconfig.svelte.setup({
				filetypes = { "svelte" },
				on_attach = on_attach,
			})
			lspconfig.jsonls.setup({
				on_attach = on_attach,
			})
			lspconfig.astro.setup({})
			lspconfig.biome.setup({
				on_attach = on_attach,
			})

			lspconfig.zls.setup({})
			lspconfig.cssls.setup({})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				filetypes = {
					-- html
					"aspnetcorerazor",
					"astro",
					"astro-markdown",
					"blade",
					"clojure",
					"django-html",
					"htmldjango",
					"edge",
					"eelixir", -- vim ft
					"elixir",
					"ejs",
					"erb",
					"eruby", -- vim ft
					"gohtml",
					"gohtmltmpl",
					"haml",
					"handlebars",
					"hbs",
					"html",
					"htmlangular",
					"html-eex",
					"heex",
					"jade",
					"leaf",
					"liquid",
					"markdown",
					"mdx",
					"mustache",
					"njk",
					"nunjucks",
					"php",
					"razor",
					"slim",
					"twig",
					-- css
					"css",
					"less",
					"postcss",
					"sass",
					"scss",
					"stylus",
					"sugarss",
					-- js
					"javascript",
					"javascriptreact",
					"reason",
					"rescript",
					"typescript",
					"typescriptreact",
					-- mixed
					"vue",
					"svelte",
					"templ",
				},
				settings = {

					validate = true,
					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidScreen = "error",
						invalidVariant = "error",
						invalidConfigPath = "error",
						invalidTailwindDirective = "error",
						recommendedVariantOrder = "warning",
					},
					classAttributes = {
						"class",
						"className",
						"class:list",
						"classList",
						"ngClass",
					},
					includeLanguages = {
						eelixir = "html-eex",
						eruby = "erb",
						templ = "html",
						htmlangular = "html",
					},
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			})
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {},
	-- },
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
	{ "habamax/vim-godot", event = "BufEnter *.gd" },
}

return M
