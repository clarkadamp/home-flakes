{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      zsh
    ];
  };
in
{
  flake.modules.nixos.zsh = {
    inherit home-manager;
    programs.zsh = {
      enable = true;
      shellAliases.hm-switch = "sudo nixos-rebuild switch --flake ~/system-flakes";
    };
  };

  flake.modules.darwin.zsh = {
    inherit home-manager;
  };

  flake.modules.homeManager.zsh =
    {
      config,
      lib,
      ...
    }:
    {
      home = {
        file = {
          ".p10k.zsh" = {
            text = builtins.readFile ./p10k.zsh;
          };
        };
        sessionPath = [
          "${config.home.homeDirectory}/bin"
          "${config.home.profileDirectory}/bin"
          "${config.home.homeDirectory}/.local/bin"
        ];
        sessionVariables = {
          #LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
          FZF_DEFAULT_COMMAND = "rg --files --hidden -g '!*.git*'";
        };
      };

      # Let Home Manager install and manage itself.
      programs.bash.enable = true;
      programs.bat.enable = true;
      programs.command-not-found.enable = true;
      programs.eza = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.ripgrep.enable = true;
      programs.zoxide = {
        enable = true;
        options = [
          "--cmd"
          "cd"
        ];
        enableZshIntegration = true;
      };
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        history = {
          expireDuplicatesFirst = true;
          ignoreDups = true;
          ignoreSpace = true; # ignore commands starting with a space
          save = 20000;
          size = 20000;
          share = true;
        };
        syntaxHighlighting = {
          enable = true;
        };
        initContent = lib.mkMerge [
          (lib.mkOrder 500 ''
            if [ -e ${config.home.profileDirectory}/etc/profile.d/nix.sh ]; then
              . ${config.home.profileDirectory}/etc/profile.d/nix.sh;
            fi

            if [ -e ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh ]; then
              . ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh;
            fi
          '')
          (lib.mkOrder 501 ''
            if [[ -o login  ]] && which uwsm 2>&1 > /dev/null; then
              if uwsm check may-start; then
                uwsm start default
              else
                echo "Unable to start window manager"
                uwsm check may-start -v
              fi
            fi
          '')
          (lib.mkOrder 502 (builtins.readFile ./zsh.p10k.cache.sh))
        ];
        shellAliases.ls = "eza";
        shellAliases.ll = "eza -la";
        shellAliases.tree = "eza --tree";
        shellAliases.cat = "bat";
        oh-my-zsh = {
          enable = true;
          plugins = [
            "aws"
            "git"
          ];
        };
        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
            {
              name = "romkatv/powerlevel10k";
              tags = [ "as:theme" ];
            }
          ];
        };
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
