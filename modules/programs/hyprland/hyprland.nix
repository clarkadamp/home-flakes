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
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        bluez
        brightnessctl
        dunst
        hyprpolkitagent
        socat
        javaPackages.compiler.openjdk21
        (pkgs.python3Packages.buildPythonApplication {
          pname = "hyprland-events";
          version = "0.0.1";
          pyproject = false;
          propagatedBuildInputs = with pkgs; [
            (python3.withPackages (
              python-pkgs: with python-pkgs; [
                (pkgs.python3Packages.buildPythonPackage rec {
                  pname = "hyprland-py";
                  version = "master";
                  src = fetchFromGitHub {
                    owner = "clarkadamp";
                    repo = pname;
                    rev = version;
                    sha256 = "sha256-pJfUswcSNV5jVdOP9Ehdn+lPQIqjMYBbWAvxlcPOMhk=";
                  };
                  pyproject = true;
                  build-system = [
                    setuptools
                    wheel
                  ];
                })
              ]
            ))
          ];
          dependencies = [
            brightnessctl
          ];
          dontUnpack = true;
          installPhase = ''
            install -Dm755 "${./hyprland-events.py}" "$out/bin/hyprland-events"
          '';
        })

        (writeShellApplication {
          name = "start-or-focus";
          runtimeInputs = [
            jq
            hyprland
          ];
          text = builtins.readFile ./focus-or-start.sh;
        })
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        jq
        sof-firmware
        glib
        ghostty
        pkgs.unfree.google-chrome
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
        waybar = {
          enable = true;
        };
        wofi = {
          enable = true;
        };
      };
      services.hypridle.enable = true;
      wayland.windowManager.hyprland = {
        enable = true;
        # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
        package = null;
        portalPackage = null;
        xwayland.enable = true; # Xwayland can be disabled.
        settings = {
          source = [
            "${config.xdg.configHome}/hypr/hyprland-main.conf"
            "${config.xdg.configHome}/hypr/monitors.conf"
          ];
        };
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
    };
}
