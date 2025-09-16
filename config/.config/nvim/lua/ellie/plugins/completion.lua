local has_words_before = function()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local M = {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      -- {
      -- 	"zbirenbaum/copilot-cmp",
      -- 	dependencies = "copilot.lua",
      -- 	opts = {},
      -- },
      {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
          fast_wrap = {},
        },
        config = function(_, opts)
          local autopairs = require("nvim-autopairs")
          local Rule = require("nvim-autopairs.rule")
          local cond = require("nvim-autopairs.conds")

          autopairs.setup(opts)
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
          autopairs.add_rules({
            Rule("<", ">", "rust"):with_pair(cond.before_regex("%a+")):with_move(function(args)
              return args.char == ">"
            end),
          })
        end,
      },
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        lazy = true,
        dependencies = "rafamadriz/friendly-snippets",
        keys = {
          {
            "<C-o>",
            function()
              if require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
              end
            end,
            mode = { "s", "i" },
            desc = "Select option",
          },
        },
        config = function(_, opts)
          require("ellie.config.others").luasnip(opts)
        end,
      },
    },
    config = function()
      local cmp, luasnip = require("cmp"), require("luasnip")
      local select = cmp.SelectBehavior.Select
      local border = require("ellie.config").get_border()
      cmp.setup({
        preselect = cmp.PreselectMode.None,
        experimental = { ghost_text = true },
        window = {
          completion = {
            border = border,
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
          documentation = {
            border = border,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          -- { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "npm",     keyword_length = 4 },
        }, {
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
            keyword_length = 2,
          },
        }),
        formatting = {
          expandable_indicator = false,
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local icons = require("ellie.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            -- if entry.source.name ~= "copilot" then
            -- 	local widths = { abbr = 27, menu = 35 }
            -- 	for key, value in pairs(widths) do
            -- 		if item[key] and vim.fn.strchars(item[key]) > value then
            -- 			item[key] = vim.fn.strcharpart(item[key], 0, value - 3) .. "..."
            -- 		end
            -- 	end
            -- end
            return item
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = select })
              -- elseif vim.snippet.active({ direction = 1 }) then
              --   vim.schedule(function()
              --     vim.snippet.jump(1)
              --   end)
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = select })
              -- elseif vim.snippet.active({ direction = -1 }) then
              --   vim.schedule(function()
              --     vim.snippet.jump(-1)
              --   end)
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
          ["<C-e>"] = { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          -- ["<C-c>"] = cmp.mapping.complete(),
          ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = select }), { "i", "c" }),
          ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = select }), { "i", "c" }),
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "cmdline" },
        },
      })
    end,
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").config({

        providers = {
          "hover.providers.lsp",
          "hover.providers.diagnostic",
        },
        preview_opts = {
          border = require("ellie.config").get_border(),
        },
        preview_window = false,
        title = true,
        mouse_providers = {
          "hover.providers.lsp",
        },
        mouse_delay = 500,
      })
    end,
  },
  -- {
  -- 	"zbirenbaum/copilot.lua",
  -- 	cmd = "Copilot",
  -- 	build = ":Copilot auth",
  -- 	opts = {
  -- 		suggestion = { enabled = false },
  -- 		panel = { enabled = false },
  -- 		filetypes = {
  -- 			markdown = true,
  -- 		},
  -- 	},
  -- },
}

return M
