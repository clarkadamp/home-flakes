return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "nix",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          nixpkgs = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
          },
          formatting = {
            command = { "nixfmt" },
          },
          options = {
            nixos = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.gw.options',
            },
            home_manager = {
              expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.gw.options.home-manager.users.type.getSubOptions []",
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.nix = { "treefmt", "trim_whitespace" }
      opts.formatters = {
        treefmt = {
          inherit = false,
          command = "treefmt",
          stdin = false,
          args = { "--quiet", "$FILENAME" },
        },
      }
    end,
  },
}
