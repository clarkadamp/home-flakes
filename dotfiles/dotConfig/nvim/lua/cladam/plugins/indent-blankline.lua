return {
  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
    },
    main = "ibl",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      --char = "┊",
      --show_trailing_blankline_indent = false,
    },
    config = function()
      vim.opt.listchars = {
        eol = "↵",
        --space = "."
      }
      vim.opt.list = true
      require("ibl").setup({
        indent = {
          highlight = {
            "Comment",
            "RainbowCyan",
            "RainbowBlue",
            "RainbowGreen",
            "RainbowYellow",
            "RainbowOrange",
            "RainbowRed",
            "RainbowViolet",
          },
        },
        scope = { enabled = false },
      })
      vim.g.rainbow_delimiters = {
        highlight = {
          "RainbowCyan",
          "RainbowBlue",
          "RainbowGreen",
          "RainbowYellow",
          "RainbowOrange",
          "RainbowRed",
          "RainbowViolet",
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
