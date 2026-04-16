return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate " },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-d>"] = actions.delete_buffer,
              ["<C-v>"] = actions.file_vsplit,
              ["<tab>"] = actions.toggle_selection,
            },
          },
          file_ignore_patterns = {
            "^build",
            "^.bemol",
            "^repo",
            "^env",
            "node_modules",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("neoclip")
      telescope.load_extension("ui-select")
      telescope.load_extension("dap")

      -- telescope.load_extension("repo")

      local telescope_builtin = require("telescope.builtin")
      -- See `:help telescope.builtin`
      vim.keymap.set("n", "<leader>?", telescope_builtin.oldfiles, { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader><space>", telescope_builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>gf", telescope_builtin.git_files, { desc = "Search [G]it [F]iles" })
      vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", telescope_builtin.resume, { desc = "[S]earch [R]resume" })
    end,
  },
  -- {
  --   "cljoly/telescope-repo.nvim",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      { "kkharji/sqlite.lua", module = "sqlite" },
    },
    config = function()
      require("neoclip").setup({
        enable_persistent_history = true,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
