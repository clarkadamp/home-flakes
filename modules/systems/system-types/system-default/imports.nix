{ self, ... }:
{
  flake.modules.nixos.systemDefault = {
    imports = with self.modules.nixos; [
    ];
  };

  flake.modules.darwin.systemDefault = {
    imports = with self.modules.darwin; [
    ];
  };

  flake.modules.homeManager.systemDefault = {
    imports = with self.modules.homeManager; [
    ];
  };
}
