{ self, ... }:
{
  flake.modules.nixos.systemEssential = {
    imports = with self.modules.nixos; [
      systemDefault
    ];
  };

  flake.modules.darwin.systemEssential = {
    imports = with self.modules.darwin; [
      systemDefault
    ];
  };

  flake.modules.homeManager.systemEssential = {
    imports = with self.modules.homeManager; [
      systemDefault
    ];
  };
}
