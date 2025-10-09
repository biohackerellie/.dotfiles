local finder = require("ellie.util").finder

local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  -- stylua: ignore
  dependencies = {
    -- {
    -- 	"nvim-telescope/telescope-fzf-native.nvim",
    -- 	build = "make",
    -- 	config = function()
    -- 		-- require("ellie.util").on_load("telescope.nvim", function()
    -- 		require("telescope").load_extension("fzf")
    -- 		-- end)
    -- 	end,
    -- },
    "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim"
  },
  init = function()
    local builtin = require("telescope.builtin")
    local wk = require("which-key")
    wk.add({
      { "<leader>ff", builtin.find_files,  desc = "Find files" },
      { "<leader>fg", builtin.live_grep,   desc = "Grep (root dir)" },
      { "<leader>fw", builtin.grep_string, desc = "Find word" },
      { "<leader>fb", builtin.buffers,     desc = "List buffers" },
      { "<leader>fd", builtin.diagnostics, desc = "List diagnostics" },
    })
  end,
  opts = function()
    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = "󰈺 ",
        layout_config = {
          height = 0.9,
          width = 0.9,
          preview_cutoff = 120,
          horizontal = {
            preview_width = 0.6,
          },
          vertical = {
            preview_height = 0.7,
          },
        },
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<Esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-e>"] = layout_actions.toggle_preview,
          },
        },
      },
      vimgrep_arguments = {
        "rg",
        "-L",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      previewer = true,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
        },
        -- 	fzf = {
        -- 		fuzzy = true,
        -- 		override_generic_sorter = true,
        -- 		override_file_sorter = true,
        -- 		case_mode = "smart_case",
        -- 	},
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    -- for _, ext in ipairs(opts.extensions_list) do
    -- 	telescope.load_extension(ext)
    -- end
  end,
}

return M
