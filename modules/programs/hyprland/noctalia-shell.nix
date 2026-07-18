{
  self,
  lib,
  ...
}:
{
  flake.modules.nixos.noctaliaShell = {
    home-manager.sharedModules = with self.modules.homeManager; [
      noctaliaShell
    ];
    services.upower.enable = true;
    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
  };
  flake.modules.homeManager.noctaliaShell =
    { pkgs, ... }:
    let
      noctalia = self.inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      noctaliaExe = lib.getExe noctalia;
    in
    {
      imports = [
        self.inputs.noctalia.homeModules.default
      ];
      home.packages = [
        noctalia
      ];
      programs.noctalia =
        let
          themeName = "Solarized";
        in
        {
          enable = true;
          settings = {
            bar = {
              default = {
                start = [ "session" ];
                center = [ ];
                end = [
                  "caffeine"
                  "group:g1"
                  "tray"
                  "clipboard"
                  "notifications"
                  "battery"
                  "brightness"
                  "volume"
                  "bluetooth"
                  "network"
                  "clock"
                  "control-center"
                ];
                margin_edge = 0;
                margin_ends = 0;
                radius = 5;
                thickness = 20;
                capsule_group = [
                  {
                    fill = "surface_variant";
                    id = "g1";
                    members = [
                      "temp"
                      "cpu"
                      "ram"
                    ];
                    opacity = 1.0;
                    padding = 6.0;
                  }
                ];

              };
            };
            keybinds = {
              cancel = [ "Escape" ];
              down = [ "Down" ];
              left = [ "Left" ];
              right = [ "Right" ];
              up = [ "Up" ];
              validate = [ "Return" ];
            };
            location = {
              auto_locate = true;
            };
            theme = {
              custom_palette = themeName;
              source = "custom";
            };
            widget = {
              tray = {
                drawer = true;
                drawer_columns = 5;
              };
            };
          };
          customPalettes = {
            ${themeName} = {
              "dark" = {
                "mPrimary" = "#268bd2";
                "mOnPrimary" = "#002b36";
                "mSecondary" = "#859900";
                "mOnSecondary" = "#002b36";
                "mTertiary" = "#d33682";
                "mOnTertiary" = "#002b36";
                "mError" = "#dc322f";
                "mOnError" = "#002b36";
                "mSurface" = "#002b36";
                "mOnSurface" = "#839496";
                "mSurfaceVariant" = "#073642";
                "mOnSurfaceVariant" = "#657b83";
                "mOutline" = "#0c5c70";
                "mShadow" = "#002b36";
                "mHover" = "#cb4b16";
                "mOnHover" = "#002b36";
                "terminal" = {
                  "foreground" = "#839496";
                  "background" = "#002b36";
                  "selectionFg" = "#93a1a1";
                  "selectionBg" = "#073642";
                  "cursorText" = "#073642";
                  "cursor" = "#839496";
                  "normal" = {
                    "black" = "#073642";
                    "red" = "#dc322f";
                    "green" = "#859900";
                    "yellow" = "#b58900";
                    "blue" = "#268bd2";
                    "magenta" = "#d33682";
                    "cyan" = "#2aa198";
                    "white" = "#eee8d5";
                  };
                  "bright" = {
                    "black" = "#335e69";
                    "red" = "#cb4b16";
                    "green" = "#586e75";
                    "yellow" = "#657b83";
                    "blue" = "#839496";
                    "magenta" = "#6c71c4";
                    "cyan" = "#93a1a1";
                    "white" = "#fdf6e3";
                  };
                };
              };
              "light" = {
                "mPrimary" = "#b58900";
                "mOnPrimary" = "#fdf6e3";
                "mSecondary" = "#d33682";
                "mOnSecondary" = "#fdf6e3";
                "mTertiary" = "#cb4b16";
                "mOnTertiary" = "#fdf6e3";
                "mError" = "#dc322f";
                "mOnError" = "#fdf6e3";
                "mSurface" = "#fdf6e3";
                "mOnSurface" = "#657b83";
                "mSurfaceVariant" = "#eee8d5";
                "mOnSurfaceVariant" = "#839496";
                "mOutline" = "#dfd4b1";
                "mShadow" = "#eee8d5";
                "mHover" = "#cb4b16";
                "mOnHover" = "#fdf6e3";
                "terminal" = {
                  "foreground" = "#657b83";
                  "background" = "#fdf6e3";
                  "selectionFg" = "#586e75";
                  "selectionBg" = "#eee8d5";
                  "cursorText" = "#eee8d5";
                  "cursor" = "#657b83";
                  "normal" = {
                    "black" = "#073642";
                    "red" = "#dc322f";
                    "green" = "#859900";
                    "yellow" = "#b58900";
                    "blue" = "#268bd2";
                    "magenta" = "#d33682";
                    "cyan" = "#2aa198";
                    "white" = "#bbb5a2";
                  };
                  "bright" = {
                    "black" = "#002b36";
                    "red" = "#cb4b16";
                    "green" = "#586e75";
                    "yellow" = "#657b83";
                    "blue" = "#839496";
                    "magenta" = "#6c71c4";
                    "cyan" = "#93a1a1";
                    "white" = "#fdf6e3";
                  };
                };
              };
            };
          };
        };
      wayland.windowManager.hyprland =
        let
          inherit (self.factory.hyprland)
            bind'
            mainMod
            on
            ;
        in
        {
          settings = {
            on = lib.lists.flatten [
              (on "hyprland.start" noctaliaExe)
            ];
            bind = [
              (bind' "${mainMod} + Return" "exec_cmd" "${noctaliaExe} msg panel-toggle launcher")
            ];
            layer_rule = [
              {
                name = "noctalia";
                match = {
                  namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
                };
                no_anim = true;
                ignore_alpha = 0.5;
                blur = true;
                blur_popups = true;
              }
            ];
            window_rule = [
              {
                name = "noctalia-settings";
                match = {
                  class = "dev.noctalia.Noctalia.Settings";
                };
                float = true;
                pin = true;
                size = [
                  "(monitor_w*0.8)"
                  "(monitor_h*0.8)"
                ];
              }

            ];
          };
        };
      # xdg.configFile = self.factory.symlinkDotfiles {
      #   hmConfig = config;
      #   path = ../../../dotfiles/dotConfig/noctalia;
      # };
    };
}
# vim: ts=2 sts=2 sw=2 et
