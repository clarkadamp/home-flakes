{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      pycharm
    ];
  };
in
{
  flake.modules.nixos.pycharm =
    { pkgs, ... }:
    {
      inherit home-manager;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.modules.darwin.pycharm =
    { pkgs, ... }:
    {
      inherit home-manager;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.modules.homeManager.pycharm =
    { pkgs, ... }:
    {
      home.packages = with pkgs.unfree; [
        jetbrains.pycharm
      ];
      programs = {
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
