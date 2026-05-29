{ self, inputs, ... }:
let
  home-manager = {
    backupFileExtension = "bkp";
    useGlobalPkgs = true;
    # https://github.com/nix-community/home-manager/issues/6770
    useUserPackages = true;
    sharedModules = with self.modules.homeManager; [
      homeManager
    ];
  };
in
{
  flake.modules.nixos.homeManager = {
    inherit home-manager;
    imports = with inputs.home-manager; [
      nixosModules.home-manager
    ];
  };

  flake.modules.darwin.homeManager = {
    inherit home-manager;
    imports = with inputs.home-manager; [
      darwinModules.home-manager
    ];
  };

  flake.modules.homeManager.homeManager = {
    programs.home-manager.enable = true;
    imports = with self.modules.homeManager; [
      dotfilesRoot
    ];
  };

}
