vim.api.nvim_create_augroup("SmithyAutoFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.smithy",
  group = "SmithyAutoFormatting",
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "smithy" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, {
            "smithy-language-server",
          })
        end,
      },
    },
    opts = {
      servers = {
        smithy_ls = {},
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
