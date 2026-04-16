{ self, ... }:
{
  flake.homeModules.base =
    { config, pkgs, ... }:
    {
      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;

          extraPackages = with pkgs; [
            autoflake
            bat
            basedpyright
            # bash-language-server
            black
            coreutils
            # dockerfile-language-server-nodejs
            # eslint_d
            eza
            fd
            fzf
            glow
            go
            gron
            isort
            # jq-lsp
            # kotlin-language-server
            lua5_1
            luajitPackages.jsregexp
            luarocks
            lua-language-server
            mypy
            nil
            nixd
            nixfmt-tree
            nodejs
            # perlnavigator
            python3
            python3Packages.debugpy
            python3Packages.flake8
            python3Packages.pip
            ripgrep
            # ruby
            # rubyPackages.solargraph
            stylua
            # tailwindcss-language-server
            # taplo
            tree-sitter
            # typescript-language-server
            unzip
            vscode-extensions.vadimcn.vscode-lldb
            vscode-langservers-extracted
            yaml-language-server
          ];
        };
        zsh = {
          shellAliases = {
            vi = "nvim-wrapper";
            vim = "nvim-wrapper";
            nvim = "nvim-wrapper";
          };
        };
      };

      home.packages = with pkgs; [
        (pkgs.writeShellApplication {
          name = "nvim-wrapper";
          runtimeInputs = with pkgs; [
            bat
            fzf
          ];
          bashOptions = [
            "errexit"
            "pipefail"
          ];
          text = builtins.readFile ./assets/nvim-wrapper;
        })
        yarn
      ];
      xdg.configFile = self.lib.symlinkDotfiles {
        hmConfig = config;
        path = ../../dotfiles/dotConfig/nvim;
        subFilesOnly = true;
      };
    };
}
