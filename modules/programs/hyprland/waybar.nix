{ self, lib, ... }:
{

  flake.modules.homeManager.waybar =
    { config, ... }:
    {
      programs = {
        waybar = {
          enable = true;
        };
      };
      wayland.windowManager.hyprland =
        let
          inherit (self.factory.hyprland)
            on
            ;
        in
        {
          settings = {
            on = lib.lists.flatten [
              (on "hyprland.start" "waybar")
            ];
          };
        };
      xdg.configFile = self.factory.symlinkDotfiles {
        hmConfig = config;
        path = ../../../dotfiles/dotConfig/waybar;
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
