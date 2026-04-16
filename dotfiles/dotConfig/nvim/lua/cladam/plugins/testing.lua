return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
  },
  opts = {
    adapters = {},
  },
  config = function(_, opts)
    local neotest = require("neotest")
    neotest.setup(opts)

    vim.keymap.set("n", "<leader>tr", function()
      neotest.run.run({ strategy = "dap" })
    end, { desc = "[T]est [R]un" })
    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "[T]est [F]ile" })
    vim.keymap.set("n", "<leader>tv", function()
      vim.cmd([[Neotest summary]])
    end, { desc = "[T]est [V]iew" })
  end,
}
