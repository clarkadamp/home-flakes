{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      # From https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
      settings = {
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
          {
            name = "bitwarden-extention";
            match = {
              class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default";
            };
            float = true;
          }
        ];
      };
    };
  };
}
# vim: ts=2 sts=2 sw=2 et
