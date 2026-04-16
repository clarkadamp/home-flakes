return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
        "html",
        "javascript",
        "xml",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {},
        html = {},
        cssls = {},
        tailwindcss = {},
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.javascript = { "eslint_d" }
    end,
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, { "prettier" })
      end,
    },
    opts = function(_, opts)
      opts.formatters_by_ft.html = { "prettier" }
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.css = { "prettier" }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
