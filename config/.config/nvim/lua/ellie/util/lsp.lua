local Util = require("ellie.util")
local validate = vim.validate
local nvim_eleven = vim.fn.has("nvim-0.11") == 1
---@class ellie.util.lsp
local M = {}

---Setup lsp autocmds
---@param func fun(client: vim.lsp.Client, buffer: number)
---@param name? string
function M.on_attach(func, name)
	Util.augroup("LspOnAttach", {
		event = "LspAttach",
		command = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and (not name or client.name == name) then
				func(client, buffer)
			end
		end,
		desc = "Setup the language server autocommands",
	})
end

---This function allows reading a per project `settings.josn` file
---in the `.vim` directory of the project
---@param client vim.lsp.Client lsp client
---@return boolean
function M.common_on_init(client)
	local settings = string.format(vim.fn.getcwd() .. "/.vscode/settings.json")
	if vim.fn.filereadable(settings) == 0 then
		return true
	end

	local ok, json = pcall(vim.fn.readfile, settings)
	if not ok then
		vim.notify_once("LSP init: read file `settings.json` failed", vim.log.levels.ERROR)
		return true
	end

	local status, overrides = pcall(vim.json.decode, table.concat(json, "\n"))
	if not status then
		vim.notify_once("LSP init: unmarshall `settings.json` file failed", vim.log.levels.ERROR)
		return true
	end

	for name, config in pairs(overrides or {}) do
		if name == client.name then
			client.config = vim.tbl_deep_extend("force", client.config, config)
			client.notify("workspace/didChangeConfiguration")

			vim.schedule(function()
				local path = vim.fn.fnamemodify(settings, ":~:.")
				local msg = "loaded local settings for " .. client.name .. " from " .. path
				vim.notify_once(msg, vim.log.levels.INFO)
			end)
		end
	end
	return true
end
function M.tbl_flatten(t)
	--- @diagnostic disable-next-line:deprecated
	return nvim_eleven and vim.iter(t):flatten(math.huge):totable() or vim.tbl_flatten(t)
end

function M.search_ancestors(startpath, func)
	if nvim_eleven then
		validate("func", func, "function")
	end
	if func(startpath) then
		return startpath
	end
	local guard = 100
	for path in vim.fs.parents(startpath) do
		-- Prevent infinite recursion if our algorithm breaks
		guard = guard - 1
		if guard == 0 then
			return
		end

		if func(path) then
			return path
		end
	end
end

function M.strip_archive_subpath(path)
	-- Matches regex from zip.vim / tar.vim
	path = vim.fn.substitute(path, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
	path = vim.fn.substitute(path, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
	return path
end
local function escape_wildcards(path)
	return path:gsub("([%[%]%?%*])", "\\%1")
end
function M.root_pattern(...)
	local patterns = M.tbl_flatten({ ... })
	return function(startpath)
		startpath = M.strip_archive_subpath(startpath)
		for _, pattern in ipairs(patterns) do
			local match = M.search_ancestors(startpath, function(path)
				for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, "/"), true, true)) do
					if vim.loop.fs_stat(p) then
						return path
					end
				end
			end)

			if match ~= nil then
				return match
			end
		end
	end
end

return M
