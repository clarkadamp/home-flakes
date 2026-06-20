{ self, lib, ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland =
      let
        inherit (self.factory.hyprland)
          bind
          bind'
          bind''
          mainMod
          onFunc
          ;
      in
      {
        settings = {
          define_submap = [
            (onFunc "resize" ''
              -- Arrow keys resize the window continuously when held down
              hl.bind("right", hl.dsp.window.resize({ x = "20", y = "0", relative = true }), { ["repeat"] = true })
              hl.bind("left",  hl.dsp.window.resize({ x = "-20", y = "0", relative = true }), { ["repeat"] = true })
              hl.bind("up",    hl.dsp.window.resize({ x = "0", y = "-20", relative = true }), { ["repeat"] = true })
              hl.bind("down",  hl.dsp.window.resize({ x = "0", y = "20", relative = true }), { ["repeat"] = true })

              -- Vim alternatives (h, j, k, l)
              hl.bind("l", hl.dsp.window.resize({ x = "20", y = "0", relative = true }), { ["repeat"] = true })
              hl.bind("h", hl.dsp.window.resize({ x = "-20", y = "0", relative = true }), { ["repeat"] = true })
              hl.bind("k", hl.dsp.window.resize({ x = "0", y = "-20", relative = true }), { ["repeat"] = true })
              hl.bind("j", hl.dsp.window.resize({ x = "0", y = "20", relative = true }), { ["repeat"] = true })

              -- Exit the submap and return to global binds
              hl.bind("Escape", hl.dsp.submap("reset"))
              hl.bind("Return", hl.dsp.submap("reset"))
            '')
          ];
          bind = lib.lists.flatten [
            (bind' "${mainMod} + Q" "exec_cmd" "ghostty")
            (bind' "${mainMod} + W" "exec_cmd" "google-chrome-stable")
            (bind' "CTRL + ALT + Q" "exec_cmd" "hyprlock")
            (bind "${mainMod} + C" "window.close")
            (bind' "${mainMod} + M" "exec_cmd"
              "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
            )
            (bind' "${mainMod} + E" "exec_cmd" "dolphin")
            (bind "${mainMod} + F" "window.fullscreen")
            (bind' "${mainMod} + V" "window.float" { action = "toggle"; })
            (bind "${mainMod} + P" "window.pseudo")
            (bind "${mainMod} + G" "group.toggle")
            (bind' "${mainMod} + J" "layout" "togglesplit") # dwindle only

            (bind' "${mainMod} + R" "submap" "resize")

            # Move focus with mainMod + arrow keys
            (bind' "${mainMod} + left" "focus" { direction = "left"; })
            (bind' "${mainMod} + right" "focus" { direction = "right"; })
            (bind' "${mainMod} + up" "focus" { direction = "up"; })
            (bind' "${mainMod} + down" "focus" { direction = "down"; })
            # Move focus with mainMod + arrow keys
            (bind' "${mainMod} + SHIFT + left" "window.move" { direction = "left"; })
            (bind' "${mainMod} + SHIFT + right" "window.move" { direction = "right"; })
            (bind' "${mainMod} + SHIFT + up" "window.move" { direction = "up"; })
            (bind' "${mainMod} + SHIFT + down" "window.move" { direction = "down"; })
            # Example special workspace (scratchpad)
            (bind' "${mainMod} + S" "workspace.toggle_special" "magic")
            (bind' "${mainMod} + SHIFT + S" "window.move" { workspace = "special:magic"; })

            # Scroll through existing workspaces with mainMod + scroll
            (bind' "${mainMod} + mouse_down" "focus" { workspace = "e+1"; })
            (bind' "${mainMod} + mouse_up" "focus" { workspace = "e-1"; })

            # Move/resize windows with mainMod + LMB/RMB and dragging
            (bind'' "${mainMod} + mouse:272" "window.drag" null { mouse = true; })
            (bind'' "${mainMod} + mouse:273" "window.resize" null { mouse = true; })

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
            (map (workspace: (bind' "${mainMod} + ${toString workspace}" "focus" { inherit workspace; })) (
              lib.lists.range 2 9
            ))
            (map (
              workspace: (bind' "${mainMod} + SHIFT + ${toString workspace}" "window.move" { inherit workspace; })
            ) (lib.lists.range 0 9))
          ];
        };
      };
  };
}
# vim: ts=2 sts=2 sw=2 et
