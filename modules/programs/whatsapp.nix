{ self, lib, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      whatsapp
    ];
  };
in
{
  flake.modules.nixos.whatsapp = {
    inherit home-manager;
  };

  flake.modules.darwin.whatsapp = {
    inherit home-manager;
  };

  flake.modules.homeManager.whatsapp =
    { pkgs, ... }:
    let
      inherit (self.factory.hyprland)
        launchOrFocus
        mainMod
        on
        ;
      pkg = pkgs.whatsapp-electron;
      exe = lib.getExe pkg;
      class = "whatsapp-electron";
      name = "whatsapp";
      workspace = "name:${name}";
    in

    {
      home.packages = [ pkg ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          (launchOrFocus "${mainMod} + SHIFT + W" exe class workspace)
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
