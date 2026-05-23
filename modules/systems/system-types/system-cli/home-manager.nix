{ self, inputs, ... }:
let
  home-manager = {
    backupFileExtension = "bkp";
    useGlobalPkgs = true;
    # https://github.com/nix-community/home-manager/issues/6770
    useUserPackages = true;
    sharedModules = with self.modules.homeManager; [
      systemCli
    ];
  };
in
{
  flake.modules.nixos.systemCli = {
    inherit home-manager;
    imports = with inputs.home-manager; [
      nixosModules.home-manager
    ];
  };

  flake.modules.darwin.systemCli = {
    inherit home-manager;
    imports = with inputs.homeManager; [
      darwinModules.home-manager
    ];
  };

  flake.modules.homeManager.systemCli = {
    programs.home-manager.enable = true;
    imports = with self.modules.homeManager; [
      dotfilesRoot
    ];
  };

}
