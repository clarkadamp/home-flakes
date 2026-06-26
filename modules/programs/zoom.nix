{ self, ... }: {
  flake.modules.nixos.zoom = { pkgs, ... }: {
    home-manager.sharedModules = with self.modules.homeManager; [
      zoom
    ];
    programs.zoom-us = {
      enable = true;
      package = pkgs.unfree.zoom-us;
    };
  };

  flake.modules.homeManager.zoom =
    { pkgs, lib, ... }:
    let
      inherit (self.factory.hyprland)
        launchOrFocus
        mainMod
        ;
      pkg = pkgs.unfree.zoom-us;
      exe = lib.getExe pkg;
      class = "zoom";
      name = "zoom";
      workspace = "name:${name}";
    in

    {
      home.packages = [ pkg ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          (launchOrFocus "${mainMod} + Z" exe class workspace)
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
