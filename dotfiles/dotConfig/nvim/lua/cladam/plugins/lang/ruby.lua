return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ruby",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.solargraph = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.ruby = { "trim_whitespace" }
      -- Disable LSP formatting as it is too intrusive in our projects
      vim.list_extend(opts.disable_lsp_formatting, { "solargraph" })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
