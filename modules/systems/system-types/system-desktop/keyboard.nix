{ self, ... }: {

  flake.modules.nixos.keyboard = {
    home-manager.sharedModules = with self.modules.homeManager; [
      keyboard
    ];
  };
  flake.modules.homeManager.keyboard = { lib, pkgs, ... }: {
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
          bind = lib.lists.flatten [
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
          ];
        };
      };
  };
}
