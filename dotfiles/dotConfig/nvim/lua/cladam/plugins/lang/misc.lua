return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dot",
        "regex",
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
