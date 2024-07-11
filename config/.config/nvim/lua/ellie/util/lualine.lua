---@class ellie.util.lualine
local M = {}

local fn, api = vim.fn, vim.api
local palette = require("ellie.config").palette

local mode_map = {
	n = "(ᴗ _ ᴗ)",
	nt = "(ᴗ_ ᴗ。)",
	i = "(•̀ - •́ )",
	R = "( •̯́ ₃ •̯̀)",
	v = "(⊙ _ ⊙ )",
	V = "(⊙ _ ⊙ )",
	no = "Σ(°△°ꪱꪱꪱ)",
	["\22"] = "(⊙ _ ⊙ )",
	t = "(⌐■_■)",
	["!"] = "Σ(💩)",
	c = "(⊙_⊙)⊃━☆ﾟ.*",
	s = "SUB",
}
local copilot_colors = {
	[""] = palette.lavender,
	["Normal"] = palette.lavender,
	["Error"] = palette.red,
	["Warning"] = palette.yellow,
	["InProgress"] = palette.peach,
}

M.conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.o.columns > 100
	end,
	has_lsp_clients = function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		return #clients > 0
	end,
}

M.components = {
	mode = {
		"mode",
		fmt = function()
			return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
		end,
    
	},

	branch = {
		"branch",
		icon = { "", color = { fg = palette.pink, gui = "bold" } },
		color = { gui = "bold" },
	},

	filetype = {
		"filetype",
		icon_only = true,
    color = { bg = palette.surface0 },
	},

	filename = {
		"filename",
		file_status = false,
		color = { fg = palette.lavender, bg = palette.surface0 },
	},

	filesize = {
		"filesize",
		icon = "󰙴",
		color = { fg = palette.lavender, gui = "bold",bg = palette.surface0 },
		padding = { left = 1, right = 1 },
		cond = M.conditions.buffer_not_empty and M.conditions.hide_in_width,
	},

	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn", "info", "hint" },
		symbols = require("ellie.config").icons.diagnostics,
    color = { bg = palette.surface0 },
		cond = M.conditions.hide_in_width,
	},

	diff = {
		"diff",
		source = function()
			---@diagnostic disable-next-line: undefined-field
			local gitsigns = vim.b.gitsigns_status_dict
			if gitsigns then
				return {
					added = gitsigns.added,
					modified = gitsigns.changed,
					removed = gitsigns.removed,
				}
			end
		end,
		symbols = {
			added = " ",
			modified = " ",
			removed = " ",
		},
		color = { bg = palette.surface0 },
		cond = M.conditions.hide_in_width,
	},

	treesitter = {
		function()
			return ""
		end,
		color = function()
			local buf = api.nvim_get_current_buf()
			local ts = vim.treesitter.highlighter.active[buf]
			return {
				fg = ts and not vim.tbl_isempty(ts) and palette.green or palette.red,
			}
		end,
		cond = M.conditions.hide_in_width,
	},

	python_env = {
		function()
			if vim.bo.filetype == "python" then
				local venv = vim.env.VIRTUAL_ENV
				if venv then
					local venv_name = fn.fnamemodify(venv, ":t")
					return string.format("(%s)", venv_name)
				end
			end
			return ""
		end,
		-- icon = function()
		--   local devicons = require("nvim-web-devicons")
		--   local icon, color = devicons.get_icon_color_by_filetype("python")
		--   return { icon, color = { fg = color } }
		-- end,
		icon = { "󰌠", color = { fg = "#ffbc03" } },
		color = { fg = palette.lavender },
		cond = M.conditions.hide_in_width,
	},

	lsp = {
		function()
			local clients = {}
			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
			for _, client in pairs(buf_clients) do
				table.insert(clients, client.name)
			end

			return string.format("LSP(s):[%s]", table.concat(clients, " • "))
		end,
		icon = "",
		color = { fg = palette.mauve },
		cond = M.conditions.hide_in_width and M.conditions.has_lsp_clients,
	},

	dap = {
		function()
			return require("dap").status()
		end,
		icon = "",
		color = { fg = palette.yellow },
		cond = function()
			return package.loaded["dap"] and require("dap").status() ~= ""
		end,
	},

	lazy = {
		require("lazy.status").updates,
		color = { fg = palette.subtext0 },
		cond = require("lazy.status").has_updates,
	},

	location = {
		function()
			local line = fn.line(".")
			local lines = fn.line("$")
			local col = fn.virtcol(".")
			-- return string.format("%3d/%d:%-2d", line, lines, col)
			return string.format("%d/%d:%d", line, lines, col)
		end,
		icon = { "", color = { fg = palette.pink, gui = "bold" } },
		color = { gui = "bold" },
	},

	scrollbar = {
		function()
			local current_line = fn.line(".")
			local total_lines = fn.line("$")
			local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  " }
			local line_ratio = current_line / total_lines
			local index = math.ceil(line_ratio * #chars)
			return chars[index]
		end,
		color = { fg = palette.surface0 },
	},

	spaces = {
		function()
			if not api.nvim_get_option_value("expandtab", { buf = 0 }) then
				return "Tab:" .. api.nvim_get_option_value("tabstop", { buf = 0 })
			end
			local size = api.nvim_get_option_value("shiftwidth", { buf = 0 })
			if size == 0 then
				size = api.nvim_get_option_value("tabstop", { buf = 0 })
			end
			return "Spaces:" .. size
		end,
		padding = { left = 1, right = 1 },
		cond = M.conditions.hide_in_width,
		color = { fg = palette.sapphire },
	},

	clock = {
		function()
			return os.date("%R")
		end,
		icon = "",
	},

	copilot = {
		function()
			local icon = require("ellie.config").icons.kinds.Copilot
			local status = require("copilot.api").status.data
			return icon .. (status.message or "")
		end,
		cond = function()
			local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
			if not ok then
				return
			end
			return ok and #clients > 0
		end,
		color = function()
			if not package.loaded["copilot"] then
				return
			end
			local status = require("copilot.api").status.data
			return { fg = copilot_colors[status.status] or copilot_colors[""], bg = palette.surface0 }
		end,
	},
}

return M
