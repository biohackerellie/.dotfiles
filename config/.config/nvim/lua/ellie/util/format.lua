local Util = require("ellie.util")
local levels = vim.log.levels

---@class ellie.util.format
local E = setmetatable({}, {
  __call = function(m, ...)
    return E.format(...)
  end,
})

---@class Formatter
---@field name string
---@field format fun(buf:number)

---@type Formatter
E.formatter = nil

---@param buf? number
function E.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function E.toggle(buf)
  if buf then
    ---@diagnostic disable-next-line: inject-field
    vim.b.autoformat = not E.enabled()
  else
    vim.g.autoformat = not E.enabled()
    ---@diagnostic disable-next-line: inject-field
    vim.b.autoformat = nil
  end
  E.info()
end

---@param buf? number
function E.info(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = E.enabled(buf)

  local msg = ("Format: %s [[ global:%s | buffer:%s ]]"):format(
    enabled and "enabled" or "disabled",
    gaf and "enabled" or "disabled",
    baf == nil and "inherit" or baf and "enabled" or "disabled"
  )
  local level = enabled and levels.INFO or levels.WARN

  vim.notify(msg, level)
end

---@param opts? {force?:boolean, buf?:number}
function E.format(opts)
  opts = opts or {}

  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or E.enabled(buf)) then
    return
  end

  xpcall(function()
    E.formatter.format(buf)
  end, function(err)
    -- local Esg = debug.traceback(err)
    vim.schedule(function()
      vim.notify("Code Format Error: " .. err, levels.ERROR)
    end)
  end)
end

function E.setup()
  Util.augroup("CodeFormat", {
    event = "BufWritePre",
    pattern = "*",
    command = function(args)
      E.format({ buf = args.buf })
    end,
    desc = "Code format",
  })

  vim.api.nvim_create_user_command("CodeFormat", function()
    E.format({ force = true })
  end, { desc = "Code format" })
end

return E