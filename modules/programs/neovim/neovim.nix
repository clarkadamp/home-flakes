{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      neovim
    ];
  };
in
{
  flake.modules.nixos.neovim = {
    inherit home-manager;
    imports = with self.modules.dawrin; [ homebrew ];
    homebrew = {
      brews = [
        "sqlite" # For neoclip
      ];
    };
  };

  flake.modules.darwin.neovim = {
    inherit home-manager;
  };
  flake.modules.homeManager.neovim =
    { config, pkgs, ... }:
    {
      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;

          # look into whether or not these are needed
          withPython3 = true;
          withRuby = false;

          extraPackages = with pkgs; [
            autoflake
            bat
            basedpyright
            bash-language-server
            black
            coreutils
            dockerfile-language-server
            eslint_d
            eza
            fd
            fzf
            glow
            go
            gron
            isort
            jq-lsp
            kotlin-language-server
            lua5_1
            luajitPackages.jsregexp
            luarocks
            lua-language-server
            mypy
            nil
            nixd
            nixfmt-tree
            nodejs
            python3
            python3Packages.debugpy
            python3Packages.flake8
            python3Packages.pip
            ripgrep
            ruby
            rubyPackages.solargraph
            shellcheck
            stylua
            tailwindcss-language-server
            taplo
            tree-sitter
            typescript-language-server
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
          text = builtins.readFile ./nvim-wrapper;
        })
        yarn
      ];
      xdg.configFile = self.factory.symlinkDotfiles {
        hmConfig = config;
        path = ../../../dotfiles/dotConfig/nvim;
        subFilesOnly = true;
      };
    };
}
