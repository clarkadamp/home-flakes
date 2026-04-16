return {
  "mfussenegger/nvim-lint",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  opts = {
    linters_by_ft = {},
    setup = {},
  },
  config = function(_, opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft

    for linter_name, callback in pairs(opts.setup) do
      callback(lint.linters[linter_name])
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>al", function()
      lint.try_lint()
    end, { desc = "[L]inting [A]pply" })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
