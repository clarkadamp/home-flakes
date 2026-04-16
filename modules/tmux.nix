{ inputs, ... }:
{
  flake.homeModules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      fix-ssh-agent = pkgs.writeShellApplication {
        name = "fix-ssh-agent";
        runtimeInputs = with pkgs; [ coreutils ];
        text = builtins.readFile ./assets/fix-ssh-agent;
        excludeShellChecks = [
          "SC2012" # ls -t is best
        ];
      };
    in
    {
      home.file = lib.mkIf pkgs.stdenv.isLinux {
        ".config/tmux/bin/start-tmux" = {
          # Provide a deterministic location to start-tmux
          text = ''
            #!${pkgs.bash}/bin/bash
            set -o errexit
            set -o nounset
            set -o pipefail

            start-tmux
          '';
          executable = true;
        };
      };

      home.packages = [
        (pkgs.writeShellApplication {
          name = "tmux-popup";
          runtimeInputs = with pkgs; [ tmux ];
          bashOptions = [
            "errexit"
            "pipefail"
          ];
          text = builtins.readFile ./assets/tmux-popup.sh;
        })
      ]
      ++ lib.optional pkgs.stdenv.isLinux (
        pkgs.writeShellApplication {
          name = "start-tmux";
          runtimeInputs = with pkgs; [
            tmux
            fix-ssh-agent
          ];
          bashOptions = [
            "errexit"
            "pipefail"
          ];
          text = builtins.readFile ./assets/start-tmux;
        }
      )
      ++ lib.optional pkgs.stdenv.isLinux fix-ssh-agent;

      home.sessionVariables.LANG = "en_US.UTF-8";

      programs.lazygit = {
        enable = true;
        settings = {
          customCommands = [
            {
              key = "I";
              commannd = "GIT_EDITOR=\"sed -i '1s/^/break \\n /'\" git rebase --interactive --autostash --keep-empty --empty=keep --no-autosquash {{.SelectedLocalBranch.Name}}";
              context = "localBranches";
            }
          ];
          git = {
            mainBranches = [
              "master"
              "main"
              "mainline"
            ];
          };
        };
      };
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        terminal = "tmux-256color";
        mouse = true;
        prefix = "C-s";
        resizeAmount = 5;
        keyMode = "vi";
        escapeTime = 10;
        focusEvents = true;

        shell = "${config.home.profileDirectory}/bin/zsh";

        plugins = [
          {
            plugin = inputs.tmux-sessionx.packages.${pkgs.stdenv.hostPlatform.system}.default;
            extraConfig = ''
              set -g @sessionx-bind 'o'
              set -g @sessionx-zoxide-mode 'on'
              set -g @sessionx-custom-paths "$HOME/workspaces/*/src/*,$HOME/workspaces/test/*/src/*,$HOME/workspaces/Cladam-settings/dotfiles/dotConfig/*,$HOME/.config/*"
              set -g @sessionx-custom-paths-subdirectories 'false'
              set -g @sessionx-filter-current 'false'
              set -g @sessionx-fzf-builtin-tmux 'off'
            '';
          }
        ];
        extraConfig = builtins.readFile ./assets/tmux.conf;
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
