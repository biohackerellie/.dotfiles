local M = {
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "[b",         "<Cmd>BufferLineCyclePrev<CR>",   desc = "Prev buffer" },
      { "]b",         "<Cmd>BufferLineCycleNext<CR>",   desc = "Next buffer" },
      { "<leader>bp", "<Cmd>BufferLinePick<CR>",        desc = "Buffer pick" },
      { "<leader>bc", "<Cmd>BufferLinePickClose<CR>",   desc = "Pick close" },
      { "<leader>b[", "<Cmd>BufferLineMovePrev<CR>",    desc = "Move prev" },
      { "<leader>b]", "<Cmd>BufferLineMoveNext<CR>",    desc = "Move next" },
      { "<leader>bD", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close others" },
      { "<leader>bH", "<Cmd>BufferLineCloseLeft<CR>",   desc = "Close to the left" },
      { "<leader>bL", "<Cmd>BufferLineCloseRight<CR>",  desc = "Close to the right" },
    },
    opts = function()
      -- local ctp = require("catppuccin.groups.integrations.bufferline")
      local tkn = require("tokyonight.groups.bufferline")
      local colors = require("tokyonight.colors").setup()
      local transparent = require("ellie.config").transparent

      return {
        options = {
          indicator = { icon = "▍", style = "icon" },
          buffer_close_icon = "󰖭",
          modified_icon = "●",
          left_trunc_marker = " ",
          right_trunc_marker = " ",
          right_mouse_command = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, level)
            local icons = require("ellie.config").icons.diagnostics
            level = level:match("warn") and "warn" or level
            return icons[level] or ""
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              separator = transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "undotree",
              text = "Undotree",
              separator = transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
            {
              filetype = "dapui_scopes",
              text = "Debugger",
              separator = transparent,
              text_align = "center",
              highlight = "PanelHeading",
            },
          },
          move_wraps_at_ends = true,
          show_close_icon = false,
          separator_style = transparent and "thin" or "slope",
          show_buffer_close_icons = false,
          sort_by = "insert_after_current",
        },
        -- highlights = tkn.get(colors,{
        -- 	custom = {
        -- 		all = {
        -- 			buffer_selected = { fg = colors.lavender },
        -- 			error = { fg = colors.surface1 },
        -- 			error_diagnostic = { fg = colors.surface1 },
        -- 			warning = { fg = colors.surface1 },
        -- 			warning_diagnostic = { fg = colors.surface1 },
        -- 			info = { fg = colors.surface1 },
        -- 			info_diagnostic = { fg = colors.surface1 },
        -- 			hint = { fg = colors.surface1 },
        -- 			hint_diagnostic = { fg = colors.surface1 },
        -- 		},
        -- 	},
        -- }),
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    opts = function()
      local lualine = require("ellie.util").lualine
      local colors = require("tokyonight.colors").setup()
      local custom_theme = require("lualine.themes.tokyonight-moon")

      custom_theme.normal.c.bg = colors.bg
      return {

        options = {
          component_separators = "",
          section_separators = { left = "", right = "" },
          icons_enabled = true,
          theme = "auto",

          globalstatus = true,
          ignore_focus = {},
          always_divide_middle = false,
        },

        sections = {
          lualine_a = { lualine.components.mode },
          lualine_b = { lualine.components.branch },
          lualine_c = {
            lualine.components.diff,
            lualine.components.diagnostics,
          },
          lualine_x = {
            -- lualine.components.copilot,

            lualine.components.dap,
            lualine.components.lsp,
            lualine.components.treesitter,
            lualine.components.filetype,
            lualine.components.filesize,
            lualine.components.lazy,
          },
          lualine_y = { lualine.components.location },
          lualine_z = { lualine.components.clock },
        },
      }
    end,
  },

  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local builtin = require("statuscol.builtin")
      local sign_name = { "Dap*", "todo%-sign%-", "neotest_*" }

      return {
        bt_ignore = { "terminal", "nofile" },
        relculright = true,
        segments = {
          {
            sign = {
              name = sign_name,
              namespace = { "diagnostic/signs" },
              maxwidth = 1,
              auto = true,
            },
          },
          { text = { builtin.lnumfunc, " " } },
          { sign = { namespace = { "gitsign" }, maxwidth = 1, colwidth = 1, auto = true } },
          { text = { builtin.foldfunc, " " } },
        },
      }
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>nl", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end,     desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      {
        "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll down",
        mode = { "i", "n", "s" },
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll up",
        mode = { "i", "n", "s" },
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-notify",
        opts = {
          timeout = 3000,
          stages = "static",
          max_height = function()
            return math.floor(vim.o.lines * 0.7)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.7)
          end,
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
          end,
        },
      },
    },
    opts = {
      cmdline = {
        view = "cmdline_popup",
      },
      hover = {
        enabled = false,
        -- silent = true,
      },
      lsp = {
        documentation = {
          opts = {
            size = {
              max_height = 15,
              max_width = math.floor(vim.o.columns * 0.8),
            },
          },
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d+ fewer lines" },
              { find = "^Hunk %d+ of %d" },
              { find = "^No hunks" },
              { find = "^E486" },
              { find = "%d+ more lines" },
              { find = "%d+ lines yanked" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            any = {
              { event = "notify", max_height = 1 },
            },
          },
          view = "mini",
        },
        {
          opts = { skip = true },
          filter = {
            event = "msg_show",
            any = {
              { find = "search hit %w+, continuing at %w+" },
            },
          },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = require("ellie.config").transparent,
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[ message clear]])
      end
      require("noice").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
        tab_char = "┊",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = { "help", "neo-tree", "lazy", "mason" },
      },
    },
  },
  { "nvchad/volt", lazy = true },
  {
    "nvchad/menu",
    lazy = true,
    keys = {
      {
        "<C-t>",
        function()
          require("menu").open("default")
        end,
        desc = "Context Menu",
      },
      {
        "<RightMouse>",
        function()
          vim.cmd.exec('"normal! \\<RightMouse>"')

          local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
          require("menu").open(options, { mouse = true })
        end,
        desc = "Context Menu",
      },
    },
  },
}

return M
