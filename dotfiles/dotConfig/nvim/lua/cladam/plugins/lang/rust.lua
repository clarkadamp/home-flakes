return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust",
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    dependencies = {
      -- {
      --   "WhoIsSethDaniel/mason-tool-installer.nvim",
      --   opts = function(_, opts)
      --     vim.list_extend(opts.ensure_installed, {
      --       "codelldb",
      --     })
      --   end,
      -- },
    },
  },
}
