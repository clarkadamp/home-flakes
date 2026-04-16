local U = require("cladam.utils")

local function find_perl()
  return require("cladam.utils").run_command("which perl").stdout
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "perl",
        -- "pod"
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        perlnavigator = {
          settings = {
            settings = {
              perlnavigator = {
                perlPath = find_perl(),
                enableWarnings = true,
                perltidyProfile = "",
                perlcriticProfile = "",
                perlcriticEnabled = true,
              },
            },
          },
        },
      },
      setup = {
        perlnavigator = function()
          local function setup_perlnavigator(client, _)
            if client.name ~= "perlnavigator" then
              return
            end
            local include_paths = {}
            client.config.settings =
              vim.tbl_deep_extend("force", client.config.settings, { perlnavigator = { includePaths = include_paths } })
          end
          U.on_attach(setup_perlnavigator)
        end,
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
