{ self, lib, ... }:
{
  flake.modules.nixos.spotify = {
    home-manager = {
      sharedModules = with self.modules.homeManager; [
        spotify
      ];
    };
    networking.firewall.allowedTCPPorts = [
      57621
    ];
  };

  flake.modules.homeManager.spotify =
    { pkgs, ... }:
    let
      inherit (self.factory.hyprland)
        launchOrFocus
        mainMod
        on
        ;
      pkg = pkgs.unfree.spotify;
      exe = lib.getExe pkg;
      class = "spotify";
      name = "spotify";
      workspace = "name:${name}";
    in

    {
      home.packages = [ pkg ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          (launchOrFocus "${mainMod} + S" exe class workspace)
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
