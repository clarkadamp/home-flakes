{
  flake.homeModules.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.file = {
        ".config/git/hooks/post-commit" = {
          text = ''
            #!${pkgs.bash}/bin/bash
            set -o errexit
            set -o nounset
            set -o pipefail

            set-tracking-branch
          '';
          executable = true;
        };
      };

      home.packages = with pkgs; [
        (pkgs.writeShellApplication {
          name = "add-git-blame-ignore-revs-commit";
          runtimeInputs = [ ];
          text = builtins.readFile ./assets/add-git-blame-ignore-revs-commit;
        })
        (pkgs.writeShellApplication {
          name = "set-tracking-branch";
          runtimeInputs = [ ];
          text = builtins.readFile ./assets/set-tracking-branch;
        })
        nixpkgs-review
      ];

      programs = {
        git = {
          enable = true;
          settings = {
            user = {
              name = config.userProfile.username;
              email = config.userProfile.email;
            };
            alias = {
              dag = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
            };
            color = {
              ui = "auto";
            };
            core = {
              pager = "less -FMRiX";
              hooksPath = "${config.home.homeDirectory}/.config/git/hooks";
            };
            pull = {
              rebase = false;
            };
            push = {
              default = "simple";
            };
            rerere = {
              enabled = true;
            };
            rebase = {
              updateRefs = true;
            };
          };
          ignores = [
            # IntelliJ
            "*.iml"
            # Bemol generated
            ".env"
            ".vscode"
            "pyrightconfig.json"
            ".settings"
            ".classpath"
            ".solargraph.yml"
            ".project"
            ".factorypath"
            # Python
            ".venv"
            # Random stuff
            "*.unison.tmp"
            "build"
            ".byebug_history"
            ".attach*"
            "*.gron"
            "*.flat"
            "*.pcap"
            ".gkignore*"
          ];
          lfs.enable = true;
        };
        gh = {
          enable = true;
          settings = {
            git_protocol = "ssh";
          };
          gitCredentialHelper.enable = true;
        };
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
