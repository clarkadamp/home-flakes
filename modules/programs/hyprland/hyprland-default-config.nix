{ self, lib, ... }:
{

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
      ];
      wayland.windowManager.hyprland =
        let
          inherit (self.factory.hyprland)
            on
            dimKeyBoardOnClass
            debugEventData
            ;
        in
        {
          # From https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
          settings = {
            on = lib.lists.flatten [
              (dimKeyBoardOnClass "vlc")
              (debugEventData "window.fullscreen")
            ];
          };
        };
    };
}
# vim: ts=2 sts=2 sw=2 et
