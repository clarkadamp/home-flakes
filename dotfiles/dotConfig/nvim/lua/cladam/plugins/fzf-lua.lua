return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "echasnovski/mini.icons",
    "mfussenegger/nvim-dap",
    "nvim-treesitter/nvim-treesitter-context",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  config = function()
    require("fzf-lua").setup({
      hls = {
        border = "FzfLuaBufName",
        preview_border = "FzfLuaBufName",
      },
    })
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "[?] Find recently opened files",
    },
    {
      "<leader><space>",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "[ ] Find existing buffers",
    },
    {
      "<leader>sf",
      function()
        require("fzf-lua").files()
      end,
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      desc = "[S]earch LSP [S]ymbols",
    },
    {
      "<leader>sh",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "[S]earch [H]elp",
    },
    {
      "<leader>gf",
      function()
        require("fzf-lua").git_files()
      end,
      desc = "Search [G]it [F]iles",
    },
    {
      "<leader>sw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "[S]earch [D]iagnostics",
    },
    {
      "<leader>sr",
      function()
        require("fzf-lua").live_grep_resume()
      end,
      desc = "[S]earch [R]resume",
    },
  },
}
