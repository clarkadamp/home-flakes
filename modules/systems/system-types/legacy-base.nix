{ self, ... }:
{
  flake.modules.nixos.base = {
    imports = with self.modules.nixos; [
    ];
  };

  flake.modules.darwin.base = {
    imports = with self.modules.darwin; [
    ];
  };
}
