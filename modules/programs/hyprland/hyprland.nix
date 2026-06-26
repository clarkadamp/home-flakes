{ self, ... }:
{
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    imports = [
      self.inputs.noctalia-greeter.nixosModules.default
    ];
    home-manager = {
      sharedModules = with self.modules.homeManager; [
        hyprland
      ];
    };
    programs.hyprlock.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    programs.noctalia-greeter = {
      enable = true;
      package = self.inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings.cursor = {
        theme = "BreezeX-RosePine-Linux";
        size = 24;
        package = pkgs.rose-pine-cursor;
      };
    };
  };

  flake.modules.homeManager.hyprland =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.packages = with pkgs; [
        dunst
        hyprpolkitagent
        socat
        wget
        jq
        glib
        rose-pine-hyprcursor
        hyprcursor
        pkgs.unfree.plexamp
        evtest
        nix-diff
      ];
      services = {
        dunst.enable = true;
        gnome-keyring = {
          enable = true;
          components = [
            "pkcs11"
            "secrets"
            "ssh"
          ];
        };
      };
      programs.hyprlock.enable = true;
      services.hypridle.enable = true;
      wayland.windowManager.hyprland = {
        enable = true;
        # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
        # package = null;
        configType = "lua";
        portalPackage = null;
        xwayland.enable = true; # Xwayland can be disabled.
      };
      xdg.configFile =
        (self.factory.symlinkDotfiles {
          hmConfig = config;
          path = ../../../dotfiles/dotConfig/rofi;
        })
        // (self.factory.symlinkDotfiles {
          hmConfig = config;
          path = ../../../dotfiles/dotConfig/hypr;
          subFilesOnly = true;
        });

      programs.zsh = {
        initContent = lib.mkOrder 501 ''
          if [[ -o login  ]] && which uwsm 2>&1 > /dev/null; then
            if uwsm check may-start; then
              uwsm start default
            else
              echo "Unable to start window manager"
              uwsm check may-start -v
            fi
          fi
        '';
      };
    };
}
