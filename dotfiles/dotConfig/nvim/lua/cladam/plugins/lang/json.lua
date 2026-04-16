return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "jq",
        "json",
        "jsonc",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jqls = {},
        jsonls = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.json = { "prettier" }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
