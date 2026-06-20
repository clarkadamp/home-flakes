{ self, lib, ... }:
{
  flake.modules.nixos.chrome = {
    home-manager.sharedModules = with self.modules.homeManager; [
      chrome
    ];
  };

  flake.modules.homeManager.chrome =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.unfree.google-chrome
      ];
      wayland.windowManager.hyprland =
        let
          inherit (self.factory.hyprland)
            bind'
            launchOrFocus
            mainMod
            on
            dimKeyBoardOnClass
            ;
        in
        {
          settings = {
            bind = [
              (launchOrFocus "${mainMod} + 1" "google-chrome-stable" "google-chrome" 1)
              (bind' "${mainMod} + W" "exec_cmd" "google-chrome-stable")
            ];
            on = lib.lists.flatten [
              (on "hyprland.start" [
                "google-chrome-stable"
                { workspace = "1 silent"; }
              ])
              (dimKeyBoardOnClass "google-chrome")
            ];
          };
        };
    };
}
# vim: ts=2 sts=2 sw=2 et
