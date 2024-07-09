---@class ellie.util
---@field format ellie.util.format
---@field lsp ellie.util.lsp
---@field exporter ellie.util.exporter
---@field toggle ellie.util.toggle
---@field finder ellie.util.finder
---@field augroup ellie.util.augroup
---@field lualine ellie.util.lualine
---@field terminal ellie.util.terminal
local E = {}

setmetatable(E, {
  __index = function(t, k)
    t[k] = require("ellie.util." .. k)
    return t[k]
  end,
})

---Check if the plugin exists
---@param plugin string plugin name
---@return boolean
function E.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---Get the specified plugin opts
---@param name string plugin name
---@return table plugin_opts
function E.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param fn fun()
function E.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---Execute code when a plugin loads
---@param name string plugin name
---@param fn fun(name: string)
function E.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(args)
        if args.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

return E