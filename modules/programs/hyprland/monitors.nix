{ self, ... }: {
  flake.modules.homeManager.hyprland = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      brightnessctl
    ];
    wayland.windowManager.hyprland =
      let
        inherit (self.factory.hyprland)
          bind''
          ;
      in
      {
        settings = {
          monitor = [
            {
              output = "eDP-1";
              mode = "1920x1200@60.03";
              position = "7920x2038";
              scale = "1.0";
            }
          ];
          bind = lib.lists.flatten [
            (bind'' "XF86MonBrightnessUp" "exec_cmd" "brightnessctl -e4 -n2 set 5%+" {
              locked = true;
              repeating = true;
            })
            (bind'' "XF86MonBrightnessDown" "exec_cmd" "brightnessctl -e4 -n2 set 5%-" {
              locked = true;
              repeating = true;
            })
          ];
        };
      };
  };
}
# vim: ts=2 sts=2 sw=2 et
