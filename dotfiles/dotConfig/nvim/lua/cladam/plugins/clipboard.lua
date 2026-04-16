local osc_52_support, _ = pcall(require, "vim.ui.clipboard.osc52")
if osc_52_support then
  return {}
end
return {
  {
    "ojroques/nvim-osc52",
    opts = {
      trim = true,
      tmux_passthrough = true,
    },
    config = function(_, opts)
      local osc52 = require("osc52")

      vim.notify_once("Setting up OSC52 support", vim.log.levels.DEBUG)
      osc52.setup(opts)

      local function copy(lines, _)
        osc52.copy(table.concat(lines, "\n"))
      end

      local function paste()
        return {
          vim.fn.split(vim.fn.getreg(""), "\n"),
          vim.fn.getregtype(""),
        }
      end
      vim.g.clipboard = {
        name = "osc52",
        copy = {
          ["+"] = copy,
          ["*"] = copy,
        },
        paste = {
          ["+"] = paste,
          ["*"] = paste,
        },
      }
    end,
  },
}
