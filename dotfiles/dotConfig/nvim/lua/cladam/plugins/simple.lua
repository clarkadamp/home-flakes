return {
  -- simple plugins that require no configuration
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  {
    "eandrju/cellular-automaton.nvim",
    lazy = false,
    config = function()
      -- when everything goes wrong
      vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
