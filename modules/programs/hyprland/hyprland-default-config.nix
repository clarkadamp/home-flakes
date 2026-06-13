{ self, lib, ... }:
{
  flake.factory.hyprland = rec {
    toLua = lib.generators.toLua { };
    # `_args` renders attrsets as Lua multi-argument calls instead of tables.
    renderLuaArgs =
      value:
      if lib.isAttrs value && value ? _args then
        lib.concatMapStringsSep ", " toLua value._args
      else
        toLua value;
    luaAttrs = args: if args == null then "" else ((lib.generators.toLua { }) args);
    hlDsp = name: args: (lib.generators.mkLuaInline "hl.${name}(${luaAttrs args})");
    asArgs = args: { _args = args; };
    mkBind =
      {
        keys,
        dispatcher,
        flags ? null,
      }:
      asArgs (
        [
          keys
          dispatcher
        ]
        ++ lib.optional (flags != null) (lib.generators.mkLuaInline (luaAttrs flags))
      );
    bind =
      keys: dispatcher:
      (mkBind {
        inherit keys;
        dispatcher = (hlDsp "dsp.${dispatcher}" null);
      });
    bind' =
      keys: dispatcher: args:
      (mkBind {
        inherit keys;
        dispatcher = (hlDsp "dsp.${dispatcher}" args);
      });
    bind'' =
      keys: dispatcher: args: flags:
      (mkBind {
        inherit
          keys
          flags
          ;
        dispatcher = (hlDsp "dsp.${dispatcher}" args);
      });
    on =
      event: command:
      let
        ensureList = command: if builtins.isString command then [ command ] else command;
      in
      (onFunc event "hl.exec_cmd(${renderLuaArgs (asArgs (ensureList command))})");
    onFunc =
      event: content:
      asArgs [
        event
        (lib.generators.mkLuaInline "function(event)\n  ${content}\nend")
      ];
    dimKeyBoardOnClass =
      class:
      (onFunc "window.fullscreen" ''
        if event.class == "${class}" then
          if event.fullscreen > 0 then
            hl.dispatch(hl.dsp.exec_cmd("brightnessctl -s --device=tpacpi::kbd_backlight set 0"))
          else
            hl.dispatch(hl.dsp.exec_cmd("brightnessctl -r --device=tpacpi::kbd_backlight"))
          end
        end
      '');
    debugEventData =
      event:
      (onFunc event ''
        function dump(o)
          if type(o) == "table" then
            local s = "{ "
            for k, v in pairs(o) do
              local _k = k
              if type(_k) ~= "number" then
                _k = '"' .. _k .. '"'
              end
              s = s .. "[" .. _k .. "] = " .. dump(v) .. ","
            end
            return s .. "} "
          else
            return tostring(o)
          end
        end

        local file = io.open("/tmp/hyprland-events.log", "a")
        file:write("### ${event} \n")
        file:write(event.class .. tostring(event.fullscreen) .. "\n")
        file:close()
      '');
    launchOrFocus =
      keys: executable: class: workspace:
      (mkBind {
        inherit keys;
        dispatcher = (
          lib.generators.mkLuaInline ''
            function()
              for _, window in ipairs(hl.get_windows({ class = "${class}", workspace = ${toString workspace} })) do
                hl.dispatch(hl.dsp.focus({ workspace = window.workspace }))
                return
              end
              for _, window in ipairs(hl.get_windows({ class = "${class}" })) do
                hl.dispatch(hl.dsp.focus({ workspace = window.workspace }))
                return
              end
              hl.dispatch(hl.dsp.exec_cmd("${executable}", { workspace = ${toString workspace} }))
            end
          ''
        );
      });

  };

  flake.modules.nixos.hyprlandDefaultConfig = {
    home-manager.sharedModules = with self.modules.homeManager; [
      hyprlandDefaultConfig
    ];
  };

  flake.modules.homeManager.hyprlandDefaultConfig =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
      ];
      wayland.windowManager.hyprland =
        let
          inherit (self.factory.hyprland)
            asArgs
            bind
            bind'
            bind''
            on
            dimKeyBoardOnClass
            launchOrFocus
            ;
          mainMod = "SUPER";
          workspaces = lib.lists.range 0 9;
        in
        {
          # From https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
          settings = {
            on = lib.lists.flatten [
              (on "hyprland.start" "waybar")
              (on "hyprland.start" "nm-applet --indicator")
              (on "hyprland.start" "blueman-applet")
              (on "hyprland.start" [
                "ghostty"
                { workspace = "2 silent"; }
              ])
              (on "hyprland.start" [
                "google-chrome-stable"
                { workspace = "1 silent"; }
              ])
              (dimKeyBoardOnClass "vlc")
              (dimKeyBoardOnClass "google-chrome")
              # (debugEventData "window.fullscreen")
            ];
            bind = lib.lists.flatten [
              (launchOrFocus "${mainMod} + O" "obsidian" "obsidian" 8)
              (launchOrFocus "${mainMod} + Q" "ghostty" "com.mitchellh.ghostty" 2)
              (launchOrFocus "${mainMod} + W" "google-chrome-stable" "google-chrome" 1)
              (launchOrFocus "${mainMod} + SHIFT + W" "whatsapp-electron" "whatsapp-electron" 9)
              (launchOrFocus "${mainMod} + T" "Telegram" "org.telegram.desktop" 9)
              (launchOrFocus "${mainMod} + Y" "signal-desktop" "signal" 9)
              (bind' "CTRL + ALT + Q" "exec_cmd" "hyprlock")
              (bind "${mainMod} + C" "window.close")
              (bind' "${mainMod} + M" "exec_cmd"
                "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
              )
              (bind' "${mainMod} + E" "exec_cmd" "dolphin")
              (bind "${mainMod} + F" "window.fullscreen")
              (bind' "${mainMod} + V" "window.float" { action = "toggle"; })
              (bind' "${mainMod} + R" "exec_cmd" "rofi")
              (bind "${mainMod} + P" "window.pseudo")
              (bind' "${mainMod} + J" "layout" "togglesplit") # dwindle only

              (bind' "${mainMod} + R" "exec_cmd" "rofi")

              # Move focus with mainMod + arrow keys
              (bind' "${mainMod} + left" "focus" { direction = "left"; })
              (bind' "${mainMod} + right" "focus" { direction = "right"; })
              (bind' "${mainMod} + up" "focus" { direction = "up"; })
              (bind' "${mainMod} + down" "focus" { direction = "down"; })
              # Example special workspace (scratchpad)
              (bind' "${mainMod} + S" "workspace.toggle_special" "magic")
              (bind' "${mainMod} + SHIFT + S" "window.move" { workspace = "special:magic"; })

              # Scroll through existing workspaces with mainMod + scroll
              (bind' "${mainMod} + mouse_down" "focus" { workspace = "e+1"; })
              (bind' "${mainMod} + mouse_up" "focus" { workspace = "e-1"; })

              # Move/resize windows with mainMod + LMB/RMB and dragging
              (bind'' "${mainMod} + mouse:272" "window.drag" null { mouse = true; })
              (bind'' "${mainMod} + mouse:273" "window.resize" null { mouse = true; })

              (bind' "${mainMod} + Return" "exec_cmd" "rofi -show drun -theme ~/.config/rofi/launcher.rasi")

              # Laptop multimedia keys for volume and LCD brightness
              (bind'' "XF86AudioRaiseVolume" "exec_cmd" "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" {
                locked = true;
                repeating = true;
              })
              (bind'' "XF86AudioLowerVolume" "exec_cmd" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" {
                locked = true;
                repeating = true;
              })
              (bind'' "XF86AudioMute" "exec_cmd" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" {
                locked = true;
                repeating = true;
              })
              (bind'' "XF86AudioMicMute" "exec_cmd" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" {
                locked = true;
                repeating = true;
              })
              (bind'' "XF86MonBrightnessUp" "exec_cmd" "brightnessctl -e4 -n2 set 5%+" {
                locked = true;
                repeating = true;
              })
              (bind'' "XF86MonBrightnessDown" "exec_cmd" "brightnessctl -e4 -n2 set 5%-" {
                locked = true;
                repeating = true;
              })
              (bind'' "SHIFT + XF86MonBrightnessUp" "exec_cmd"
                "brightnessctl --device='tpacpi::kbd_backlight' set 1+"
                {
                  locked = true;
                  repeating = true;
                }
              )
              (bind'' "SHIFT + XF86MonBrightnessDown" "exec_cmd"
                "brightnessctl --device='tpacpi::kbd_backlight' set 1-"
                {
                  locked = true;
                  repeating = true;
                }
              )

              # Requires playerctl
              (bind'' "XF86AudioNext" "exec_cmd" "playerctl next" { locked = true; })
              (bind'' "XF86AudioPause" "exec_cmd" "playerctl play-pause" { locked = true; })
              (bind'' "XF86AudioPlay" "exec_cmd" "playerctl play-pause" { locked = true; })
              (bind'' "XF86AudioPrev" "exec_cmd" "playerctl previous" { locked = true; })
              (map (
                workspace: (bind' "${mainMod} + ${toString workspace}" "focus" { inherit workspace; })
              ) workspaces)
              (map (
                workspace: (bind' "${mainMod} + SHIFT + ${toString workspace}" "window.move" { inherit workspace; })
              ) workspaces)
            ];
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

              input = {
                kb_layout = "us";
                kb_variant = "";
                kb_model = "";
                kb_options = "caps:swapescape";
                kb_rules = "";

                follow_mouse = 1;

                sensitivity = 0; # -1.0 - 1.0; 0 means no modification.

                touchpad = {
                  natural_scroll = true;
                  clickfinger_behavior = 1;
                };
              };
            };
            gesture = [
              {
                fingers = 3;
                direction = "horizontal";
                action = "workspace";
              }
            ];
            # Example per-device config
            # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
            device = [
              {
                name = "epic-mouse-v1";
                sensitivity = -0.5;
              }
            ];
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
            monitor = [
              {
                output = "eDP-1";
                mode = "1920x1200@60.03";
                position = "7920x2038";
                scale = "1.0";
              }
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
            # See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
            # and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

            # Example window rules that are useful
            window_rule = [
              {
                # Ignore maximize requests from all apps. You'll probably like this.
                name = "suppress-maximize-events";
                match = {
                  class = ".*";
                };

                suppress_event = "maximize";
              }
              {
                # Fix some dragging issues with XWayland
                name = "fix-xwayland-drags";
                match = {
                  class = "^$";
                  title = "^$";
                  xwayland = true;
                  float = true;
                  fullscreen = false;
                  pin = false;
                };

                no_focus = true;
              }
            ];
          };
        };
    };
}
# vim: ts=2 sts=2 sw=2 et
