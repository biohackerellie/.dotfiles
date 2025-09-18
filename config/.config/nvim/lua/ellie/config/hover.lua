local M = {}

local function has_hover_provider()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr }) or {}
  for _, client in ipairs(clients) do
    local caps = client.server_capabilities or client.dynamic_capabilities or {}
    if caps and (caps.hoverProvider == true) then
      return true
    end
  end
  return false
end

local function hover_with_window()
  local border = require("ellie.config").get_border()
  vim.lsp.buf.hover({
    border = border,
    max_width = 120,
    max_height = 30,
    title = 'LSP Hover',
    title_pos = "center"
  })
end

-- Public function: hover with LSP fallback
function M.hover_or_fallback()
  if has_hover_provider() then
    hover_with_window()
  else
    vim.notify("Falling back to hover.nvim", vim.log.levels.INFO)
    local ok, err = pcall(require("hover").open)
    if not ok then
      vim.notify("hover.nvim failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

return M
