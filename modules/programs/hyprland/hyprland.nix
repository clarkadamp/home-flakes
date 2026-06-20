{ self, ... }:
{
  flake.modules.nixos.hyprland = {
    home-manager = {
      sharedModules = with self.modules.homeManager; [
        hyprland
      ];
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
      imports = with self.modules.homeManager; [
        noctaliaShell
      ];
      home.packages = with pkgs; [
        bluez
        brightnessctl
        dunst
        hyprpolkitagent
        socat
        javaPackages.compiler.openjdk21
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        jq
        sof-firmware
        glib
        rose-pine-hyprcursor
        hyprcursor
        hyprpicker
        telegram-desktop
        signal-desktop
        pkgs.unfree.spotify
        whatsapp-electron
        pkgs.unfree.discord
        pkgs.unfree.plexamp
        # beersmith
        system-config-printer
        networkmanagerapplet
        systemctl-tui
        evtest
        rofi
        nix-diff
        wtype
        wev
      ];
      home.sessionVariables = {
        "JDTLS_JAVA_HOME" = "${pkgs.javaPackages.compiler.openjdk21}";
      };
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
      programs = {
        wofi = {
          enable = true;
        };
      };
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
          path = ../../../dotfiles/dotConfig/waybar;
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
