{ self, ... }:
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
    {
      home.packages = with pkgs.unfree; [
        spotify
      ];
    };
}
# vim: ts=2 sts=2 sw=2 et
