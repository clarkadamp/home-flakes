vim.diagnostic.config({
  float = {
    source = true,
    border = "rounded",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.ERROR] = " ",
    },
    numhl = {
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    },
  },
})

return {
  "m-gail/diagnostic_manipulation.nvim",
  opts = {
    whitelist = {},
    blacklist = {},
  },
}
-- vim: ts=2 sts=2 sw=2 et
