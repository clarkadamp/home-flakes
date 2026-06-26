{ self, ... }:
let
in
{
  flake.modules.nixos.networking = {
    home-manager = {
      sharedModules = with self.modules.homeManager; [
        networking
      ];
    };
    networking.networkmanager.enable = true;
    users.users.cladam = {
      extraGroups = [
        "networkmanager"
      ];
    };
  };

  flake.modules.homeManager.networking =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        networkmanagerapplet
      ];
    };
}
# vim: ts=2 sts=2 sw=2 et
