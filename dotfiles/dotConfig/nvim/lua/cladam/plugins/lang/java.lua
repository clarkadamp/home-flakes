return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "jdtls",
          })
        end,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "javadbg", "javatest" })
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.java = { "trim_whitespace" }
      -- Disable LSP formatting as it is too intrusive in our projects
      vim.list_extend(opts.disable_lsp_formatting, { "jdtls" })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 eo
