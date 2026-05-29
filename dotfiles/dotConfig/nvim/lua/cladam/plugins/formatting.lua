return {
  "stevearc/conform.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "joechrisellis/lsp-format-modifications.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = { ["*"] = { "trim_whitespace" } },
    format_on_save = {
      lsp_fallback = false,
      async = false,
      timeout_ms = 1500,
    },
    disable_lsp_formatting = {},
  },
  config = function(_, opts)
    local conform = require("conform")

    opts.format_on_save = {
      timeout_ms = 1500,
      lsp_fallback = false,
    }

    conform.setup(opts)
    vim.keymap.set({ "n", "v" }, "<leader>fa", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1500,
      })
    end, { desc = "[F]ormat [A]pply" })
    require("cladam.utils").on_attach(function(client, buffer)
      vim.api.nvim_buf_create_user_command(buffer, "FormatModifications", function()
        local lsp_format_modifications = require("lsp-format-modifications")
        lsp_format_modifications.format_modifications(client, buffer)
      end, {})
    end)
  end,
}
-- vim: ts=2 sts=2 sw=2 et
