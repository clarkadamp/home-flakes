{ self, ... }:
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
    {
      home.packages = with pkgs.unfree; [
        discord
      ];
    };
}
# vim: ts=2 sts=2 sw=2 et
