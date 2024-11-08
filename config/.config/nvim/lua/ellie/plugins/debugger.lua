local M = {
	"mfussenegger/nvim-dap",
  -- stylua: ignore
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      },
      opts = {
        icons = {
          expanded = "",
          collapsed = "",
          current_frame = "",
        },
        layouts = {
          {
            elements = {
              "scopes",
              "stacks",
              "watches",
              "breakpoints",
            },
            size = 0.3,
            position = "right",
          },
          {
            elements = { "repl" },
            size = 0.24,
            position = "bottom",
          },
        },
        floating = {
          border = require("ellie.config").get_border(),
        },
      },
      config = function(_, opts)
        -- setup listener
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup(opts)

        dap.listeners.after.event_initialized["dapui_config"] = function()
          local breakpoints = require("dap.breakpoints").get()
          local args = vim.tbl_isempty(breakpoints) and {} or { layout = 2 }
          dapui.open(args)
        end
        dap.listeners.before.event_stopped["dapui_config"] = function(_, body)
          if body.reason == "breakpoint" then
            dapui.open({})
          end
        end
        -- dap.listeners.before.event_terminated["dapui_config"] = function()
        --   dapui.close({})
        -- end
        -- dap.listeners.before.event_exited["dapui_config"] = function()
        --   dapui.close({})
        -- end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true },
    },
  },
	init = function()
		vim.fn.sign_define("DapStopped", { text = "󰋇 ", texthl = "DapStopped", numhl = "DapStopped" })
		vim.fn.sign_define("DapBreakpoint", { text = "󰄛 ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
	end,
	config = function()
		-- load launch.json file
		require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. "/.vscode/launch.json")

		local dap = require("dap")
		-- setup adapter
		dap.adapters.python = {
			type = "executable",
			command = "python",
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
		}
    dap.adapters.godot = {
          type = "server",
          host = "127.0.0.1",
          port = 6007,
        }

    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true
      }
    }

		dap.adapters.go = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:" .. "${port}" },
			},
			options = {
				initialize_timeout_sec = 10,
			},
		}

		-- https://github.com/rcarriga/nvim-dap-ui/issues/248
		require("ellie.util").augroup("DapReplOptions", {
			event = "BufWinEnter",
			pattern = { "\\[dap-repl\\]", "DAP *" },
			command = vim.schedule_wrap(function(args)
				local win = vim.fn.bufwinid(args.buf)
				vim.api.nvim_set_option_value("wrap", true, { win = win })
			end),
		})
	end,
}

return M
