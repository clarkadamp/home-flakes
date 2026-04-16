function SetColors()
  -- python
  vim.api.nvim_set_hl(0, "@keyword.import.python", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@constant.python", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "@lsp.type.namespace.python", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.method.definition.python", { link = "RainbowMagenta" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.parameter.definition.python", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "@variable.parameter.python", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "@lsp.type.namespace.python", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@boolean.python", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@boolean.python", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@constructor.python", { link = "RainbowYellow" })
  vim.api.nvim_set_hl(0, "@constant.builtin.python", { link = "RainbowYellow" })
  vim.api.nvim_set_hl(0, "@function.builtin.python", { link = "RainbowYellow" })
  vim.api.nvim_set_hl(0, "@include.python", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@method.call.python", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@operator.python", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@parameter.python", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "@punctuation.bracket.python", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@type.builtin.python", { link = "RainbowYellow" })
  vim.api.nvim_set_hl(0, "@type.python", { link = "Normal" })

  -- java
  vim.api.nvim_set_hl(0, "@lsp.typemod.annotation.public.java", { link = "RainbowYellow" })
  vim.api.nvim_set_hl(0, "@operator.java", { link = "RainbowYellow" })
  vim.api.nvim_set_hl(0, "@include.java", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@method.call.java", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@lsp.type.class.java", { link = "RainbowBlue" })
  vim.api.nvim_set_hl(0, "@lsp.type.modifier.java", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@lsp.type.method.java", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@type.builtin.java", { link = "RainbowGreen" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.method.declaration.java", { link = "RainbowMagenta" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.property.static.java", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.property.private.java", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.interface.public.java", { link = "RainbowBlue" })
  vim.api.nvim_set_hl(0, "@lsp.typemod.method.public.java", { link = "Normal" })
  vim.api.nvim_set_hl(0, "@lsp.type.namespace.java", { link = "RainbowBlue" })
  vim.api.nvim_set_hl(0, "@lsp.type.enum.java", { link = "RainbowBlue" })

  -- nvim-cmp
  vim.api.nvim_set_hl(0, "CmpItemAbbr", { link = "Folded" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { link = "RainbowMagenta" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "RainbowViolet" })
  vim.api.nvim_set_hl(0, "CmpItemKind", { link = "RainbowBlue" })
  vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "Folded" })
end

SetColors()

return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(hl, c)
          hl.RainbowRed = {
            fg = c.red,
          }
          hl.RainbowOrange = {
            fg = c.orange,
          }
          hl.RainbowYellow = {
            fg = c.yellow,
          }
          hl.RainbowGreen = {
            fg = c.green,
          }
          hl.RainbowCyan = {
            fg = c.cyan,
          }
          hl.RainbowBlue = {
            fg = c.blue,
          }
          hl.RainbowMagenta = {
            fg = c.magenta,
          }
          hl.RainbowViolet = {
            fg = c.violet,
          }
          hl.TelescopeBorder = {
            fg = c.fg,
          }
          hl.TelescopePromptNormal = {
            fg = c.fg,
          }
          hl.TelescopePromptBorder = {
            fg = c.fg,
          }
          hl.TelescopePromptTitle = {
            fg = c.fg,
          }
          hl.TelescopePreviewTitle = {
            fg = c.fg,
          }
          hl.TelescopeResultsTitle = {
            fg = c.fg,
          }
        end,
      })
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          hsl_color = {
            pattern = "hsl%(%d+,? %d+,? %d+%)",
            group = function(_, match)
              local utils = require("solarized-osaka.hsl")
              local h, s, l = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
              h, s, l = tonumber(h), tonumber(s), tonumber(l)
              local hex_color = utils.hslToHex(h, s, l)
              return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
            end,
          },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
