{ self, ... }:
{
  flake.modules.nixos.systemBasic = {
    imports = with self.modules.nixos; [
      nixpkgs
      systemEssential
    ];
  };

  flake.modules.darwin.systemBasic = {
    imports = with self.modules.darwin; [
      systemEssential
    ];
  };

  flake.modules.homeManager.systemBasic = {
    imports = with self.modules.homeManager; [
      systemEssential
    ];
  };

}
