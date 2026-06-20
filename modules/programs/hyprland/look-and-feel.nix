{ self, ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland =
      let
        inherit (self.factory.hyprland)
          asArgs
          ;
      in
      {
        # From https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
        settings = {
          config = {
            general = {
              gaps_in = 2;
              gaps_out = 2;

              border_size = 1;

              col = {
                active_border = {
                  colors = [
                    "rgba(33ccffee)"
                    "rgba(00ff99ee)"
                  ];
                  angle = 45;
                };
                inactive_border = "rgba(595959aa)";
              };

              # Set to true to enable resizing windows by clicking and dragging on borders and gaps
              resize_on_border = false;

              # Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
              allow_tearing = false;

              layout = "dwindle";
            };

            decoration = {
              rounding = 2;
              rounding_power = 2;

              # Change transparency of focused and unfocused windows
              active_opacity = 1.0;
              inactive_opacity = 1.0;

              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };

              blur = {
                enabled = true;
                size = 3;
                passes = 1;
                vibrancy = 0.1696;
              };
            };

            animations = {
              enabled = true;
            };
            # See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
            dwindle = {
              preserve_split = true; # You probably want this
            };
            # See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more

            master = {
              new_status = "master";
            };

            # See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more

            scrolling = {
              fullscreen_on_one_column = true;
            };

            misc = {
              force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
              disable_splash_rendering = true;
            };
          };

          curve = map asArgs [
            # Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
            [
              "easeOutQuint"
              {
                type = "bezier";
                points = [
                  [
                    0.23
                    1
                  ]
                  [
                    0.32
                    1
                  ]
                ];
              }
            ]
            [
              "easeInOutCubic"
              {
                type = "bezier";
                points = [
                  [
                    0.65
                    0.05
                  ]
                  [
                    0.36
                    1
                  ]
                ];
              }
            ]
            [
              "linear"
              {
                type = "bezier";
                points = [
                  [
                    0
                    0
                  ]
                  [
                    1
                    1
                  ]
                ];
              }
            ]
            [
              "almostLinear"
              {
                type = "bezier";
                points = [
                  [
                    0.5
                    0.5
                  ]
                  [
                    0.75
                    1
                  ]
                ];
              }
            ]
            [
              "quick"
              {
                type = "bezier";
                points = [
                  [
                    0.15
                    0
                  ]
                  [
                    0.1
                    1
                  ]
                ];
              }
            ]
            # Default springs
            [
              "easy"
              {
                type = "spring";
                mass = 1;
                stiffness = 71.2633;
                dampening = 15.8273644;
              }
            ]
          ];
          animation = [
            {
              leaf = "global";
              enabled = true;
              speed = 10;
              bezier = "default";
            }
            {
              leaf = "border";
              enabled = true;
              speed = 5.39;
              bezier = "easeOutQuint";
            }
            {
              leaf = "windows";
              enabled = true;
              speed = 4.79;
              spring = "easy";
            }
            {
              leaf = "windowsIn";
              enabled = true;
              speed = 4.1;
              spring = "easy";
              style = "popin 87%";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 1.49;
              bezier = "linear";
              style = "popin 87%";
            }
            {
              leaf = "fadeIn";
              enabled = true;
              speed = 1.73;
              bezier = "almostLinear";
            }
            {
              leaf = "fadeOut";
              enabled = true;
              speed = 1.46;
              bezier = "almostLinear";
            }
            {
              leaf = "fade";
              enabled = true;
              speed = 3.03;
              bezier = "quick";
            }
            {
              leaf = "layers";
              enabled = true;
              speed = 3.81;
              bezier = "easeOutQuint";
            }
            {
              leaf = "layersIn";
              enabled = true;
              speed = 4;
              bezier = "easeOutQuint";
              style = "fade";
            }
            {
              leaf = "layersOut";
              enabled = true;
              speed = 1.5;
              bezier = "linear";
              style = "fade";
            }
            {
              leaf = "fadeLayersIn";
              enabled = true;
              speed = 1.79;
              bezier = "almostLinear";
            }
            {
              leaf = "fadeLayersOut";
              enabled = true;
              speed = 1.39;
              bezier = "almostLinear";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 1.94;
              bezier = "almostLinear";
              style = "fade";
            }
            {
              leaf = "workspacesIn";
              enabled = true;
              speed = 1.21;
              bezier = "almostLinear";
              style = "fade";
            }
            {
              leaf = "workspacesOut";
              enabled = true;
              speed = 1.94;
              bezier = "almostLinear";
              style = "fade";
            }
            {
              leaf = "zoomFactor";
              enabled = true;
              speed = 7;
              bezier = "quick";
            }
          ];
        };
      };
  };
}
# vim: ts=2 sts=2 sw=2 et
