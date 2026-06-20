{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings = {
        monitor = [
          {
            output = "eDP-1";
            mode = "1920x1200@60.03";
            position = "7920x2038";
            scale = "1.0";
          }
        ];
      };
    };
  };
}
# vim: ts=2 sts=2 sw=2 et
