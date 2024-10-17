---@class MvimConfig: MvimOptions
local M = {}

---@class MvimOptions
local defaults = {
	transparent = true,
  -- stylua: ignore
  icons = {
    diagnostics = {
      error = " ",
      warn  = " ",
      info  = " ",
      hint  = " ",
    },
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Color         = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Keyword       = " ",
      Method        = " ",
      Module        = " ",
      Namespace     = " ",
      Null          = "󰟢 ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = " ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = " ",
      Copilot       = " ",
    },
  },
	banner = [[
         .-') _     ('-.                      (`-.              _   .-')      
        ( OO ) )  _(  OO)                   _(OO  )_           ( '.( OO )_    
    ,--./ ,--,'  (,------.  .-'),-----. ,--(_/   ,. \  ,-.-')   ,--.   ,--.)  
    |   \ |  |\   |  .---' ( OO'  .-.  '\   \   /(__/  |  |OO)  |   `.'   |   
    |    \|  | )  |  |     /   |  | |  | \   \ /   /   |  |  \  |         |   
    |  .     |/  (|  '--.  \_) |  |\|  |  \   '   /,   |  |(_/  |  |'.'|  |   
    |  |\    |    |  .--'    \ |  | |  |   \     /__) ,|  |_.'  |  |   |  |   
    |  | \   |    |  `---.    `'  '-'  '    \   /    (_|  |     |  |   |  |   
    `--'  `--'    `------'      `-----'      `-'       `--'     `--'   `--'   
  ]],
	---@class CtpColor
	palette = {},
}

function M.bootstrap()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.uv.fs_stat(lazypath) then
		local output = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--single-branch",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
		if vim.api.nvim_get_vvar("shell_error") ~= 0 then
			vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" .. output)
		end
	end
	vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

	require("lazy").setup({
		spec = "ellie.plugins",
		defaults = { lazy = true },
		install = { colorscheme = { "catppuccin" } },
		change_detection = { notify = false },
		checker = { enabled = true },

		rocks = { enabled = false },
		dev = {
		    path = "~/.local/share/nvim/nix",
		    fallback = false
		}
		ui = {
			backdrop = M.transparent and 100 or 60,
			border = M.get_border(),
			icons = {
				loaded = "󰽢",
				not_loaded = "󰏝",
				plugin = "",
			},
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"tohtml",
					"getscript",
					"getscriptPlugin",
					"gzip",
					"logipat",
					"netrw",
					"netrwPlugin",
					"netrwSettings",
					"netrwFileHandlers",
					"matchit",
					"tar",
					"tarPlugin",
					"rrhelper",
					"spellfile_plugin",
					"vimball",
					"vimballPlugin",
					"zip",
					"zipPlugin",
					"tutor",
					"rplugin",
					"syntax",
					"synmenu",
					"optwin",
					"compiler",
					"bugreport",
				},
			},
		},
	})
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
	local function _load(mod)
		local U = require("lazy.core.util")

		U.try(function()
			require(mod)
		end, {
			msg = "Failed loading " .. mod,
			on_error = function(msg)
				local info = require("lazy.core.cache").find(mod)
				if info == nil or (type(info) == "table" and #info == 0) then
					return
				end
				U.error(msg)
			end,
		})
	end

	_load("ellie.config." .. name)

	if vim.bo.filetype == "lazy" then
		vim.cmd([[do VimResized]])
	end
end

M.did_init = false
function M.init()
	if not M.did_init then
		M.did_init = true

		M.load("options")
	end
end

function M.setup()
	M.bootstrap()

	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
	end
	require("ellie.util").augroup("Mvim", {
		pattern = "VeryLazy",
		event = "User",
		command = function()
			if lazy_autocmds then
				M.load("autocmds")
			end
			M.load("keymaps")

			require("ellie.util").format.setup()
		end,
	})
end

function M.get_border()
	local border = M.transparent and "rounded" or "none"
	return border
end

---@param palette CtpColors<string> | CtpColor
function M.filling_pigments(palette)
	M.palette = palette
end

---@type MvimOptions
local options

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end

		---@cast options MvimConfig
		return options[key]
	end,
})

return M
