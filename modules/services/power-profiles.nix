{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [

    ];
  };
in
{
  flake.modules.nixos.powerProfiles =
    { pkgs, ... }:
    {
      services.power-profiles-daemon.enable = true;
    };

  flake.modules.darwin.powerProfiles =
    { pkgs, ... }:
    {
      inherit home-manager;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.modules.homeManager.powerProfiles =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
      ];
      programs = {
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
