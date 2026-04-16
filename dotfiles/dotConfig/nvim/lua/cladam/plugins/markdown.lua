return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "markdown",
        "markdown_inline",
      })
    end,
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
      vim.g.mkdp_preview_options = {
        uml = {
          server = os.getenv("PLANTUML_URL"),
        },
      }
      local group = vim.api.nvim_create_augroup("markdown_autocommands", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function(_)
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>p",
            "<cmd>MarkdownPreviewToggle<cr>",
            { noremap = true, silent = true }
          )
        end,
        group = group,
      })
    end,
  },
}
