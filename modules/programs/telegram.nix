{ self, lib, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      telegram
    ];
  };
in
{
  flake.modules.nixos.telegram = {
    inherit home-manager;
  };

  flake.modules.darwin.telegram = {
    inherit home-manager;
  };

  flake.modules.homeManager.telegram =
    { pkgs, ... }:
    let
      inherit (self.factory.hyprland)
        launchOrFocus
        mainMod
        on
        ;
      pkg = pkgs.telegram-desktop;
      exe = lib.getExe pkg;
      class = "org.telegram.desktop";
      name = "telegram";
      workspace = "name:${name}";
    in

    {
      home.packages = [ pkg ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          (launchOrFocus "${mainMod} + T" exe class workspace)
        ];
        on = [
          (on "hyprland.start" [
            exe
            { workspace = "${workspace} silent"; }
          ])
        ];
        window_rule = [
          {
            name = "${name}-workspace";
            match = {
              inherit class;
            };
            inherit workspace;
          }
        ];
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
