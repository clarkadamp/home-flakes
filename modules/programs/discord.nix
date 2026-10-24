{ self, lib, ... }:
{
  flake.modules.nixos.discord = {
    home-manager = {
      sharedModules = with self.modules.homeManager; [
        discord
      ];
    };
  };

  flake.modules.homeManager.discord =
    { pkgs, ... }:
    let
      inherit (self.factory.hyprland)
        launchOrFocus
        mainMod
        on
        ;
      pkg = pkgs.unfree.discord;
      exe = lib.getExe pkg;
      class = "discord";
      name = "discord";
      workspace = "name:${name}";
    in

    {
      home.packages = [ pkg ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          (launchOrFocus "${mainMod} + D" exe class workspace)
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
