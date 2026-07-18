{ self, ... }: {
  flake.modules.homeManager.hyprland = { pkgs, lib, ... }: {
    options = { };
    config = {
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
                output = "desc:AU Optronics 0x9EA9";
                mode = "1920x1200@60.03";
                position = "6000x2000";
                scale = "1.0";
              }
              {
                output = "desc:Dell Inc. DELL U3223QE 76B04P3";
                mode = "3840x2160@60.00";
                position = "2160x700";
                scale = "1.0";
              }
              {
                output = "desc:LG Electronics LG Ultra HD 0x00031176";
                mode = "3840x2160@60.00";
                position = "0x0";
                scale = "1.0";
                transform = 1;
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
  };
}
# vim: ts=2 sts=2 sw=2 et
