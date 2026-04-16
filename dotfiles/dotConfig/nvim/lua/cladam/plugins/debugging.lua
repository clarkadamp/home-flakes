return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local dap = require("dap")

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })

      vim.fn.sign_define("DapBreakpoint", {
        text = "🔴",
        texthl = "DapBreakpointSymbol",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
      })
      vim.fn.sign_define("DapStopped", {
        text = "🔴",
        texthl = "DapStoppedSymbol",
        linehl = "DapStoppedLine",
        numhl = "DpBreakpoint",
      })

      local dap_configurations = require("dap.ext.vscode").getconfigs()
      table.insert(dap_configurations, {
          name = "Debug Attach (5050)",
          type = "java",
          request = "attach",
          hostName = "127.0.0.1",
          port = 5050,
        })
      for _, configuration in ipairs(dap_configurations) do
        local config_type = configuration["type"]
        if dap.configurations[config_type] == nil then
          dap.configurations[config_type] = {}
        end
        table.insert(dap.configurations[config_type], configuration)
      end
    end,
  },
  {
    -- Installs the debug adapters for you
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      autoatic_setup = true,
      handlers = {},
      ensure_installed = {},
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })
      -- if you want to see what is coming in to these functions:
      -- dap.listeners.before.event_*["my-thing"] = function(session, body)
      --   print('Session initialized', vim.inspect(session), vim.inspect(body))
      -- end
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    config = function(_, opts)
      require("persistent-breakpoints").setup(opts)
      local pb_api = require("persistent-breakpoints.api")
      vim.keymap.set("n", "<leader>b", pb_api.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set(
        "n",
        "<leader>B",
        pb_api.set_conditional_breakpoint,
        { desc = "Debug: Set Conditional Breakpoint" }
      )
      vim.keymap.set("n", "<leader>cb", pb_api.clear_all_breakpoints, { desc = "Debug: [c]lear [b]reakpoints" })
    end,
  },
  {
    "rcarriga/cmp-dap",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
