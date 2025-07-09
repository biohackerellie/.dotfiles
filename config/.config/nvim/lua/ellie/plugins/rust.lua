-- local border = require("ellie.config").get_border()

local M = {
	-- {
	-- 	"mrcjkb/rustaceanvim",
	-- 	version = "^5",
	-- 	lazy = false,
	-- 	init = function()
	-- 		vim.g.rustaceanvim = {
	-- 			tools = {
	-- 				float_win_config = {
	-- 					border = border,
	-- 					auto_focus = true, -- or your preferred settings
	-- 					open_split = "horizontal",
	-- 				},
	-- 				hover_actions = {
	-- 					replace_builtin_hover = true,
	-- 					-- any other hover options…
	-- 				},
	-- 				-- other tool options…
	-- 			},
	-- 			server = {
	-- 				on_attach = function(client, buffer)
	-- 					require("ellie.plugins.lsp.keymaps").on_attach(client, buffer)
	-- 					require("ellie.plugins.lsp.codelens").on_attach(client, buffer)
	-- 					require("ellie.plugins.lsp.highlight").on_attach(client, buffer)
	-- 				end,
	-- 				default_settings = {
	-- 					["rust-analyzer"] = {},
	-- 				},
	-- 			},
	-- 			dap = {},
	-- 		}
	-- 	end,
	-- },
}

return M
