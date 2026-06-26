{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      signal
    ];
  };
in
{
  flake.modules.nixos.signal = {
    inherit home-manager;
  };

  flake.modules.homeManager.signal =
    { pkgs, lib, ... }:
    let
      inherit (self.factory.hyprland)
        launchOrFocus
        mainMod
        on
        ;
      pkg = pkgs.signal-desktop;
      exe = lib.getExe pkg;
      class = "signal";
      name = "signal";
      workspace = "name:${name}";
    in

    {
      home.packages = [ pkg ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          (launchOrFocus "${mainMod} + Y" exe class workspace)
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
