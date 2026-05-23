{ self, ... }:
{
  flake.modules.nixos.systemDesktop = {
    imports = with self.modules.nixos; [
      systemCli
      fonts
      hyprland
    ];
  };

  flake.modules.darwin.systemDesktop = {
    imports = with self.modules.darwin; [
      systemCli
    ];
  };

  flake.modules.homeManager.systemDesktop = {
    imports = with self.modules.homeManager; [
      systemCli
    ];
  };
}
